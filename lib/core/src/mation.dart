part of '../mationani.dart';

///
/// .
///                       --[_MatableNest]        --[_MatableBuilderPlaneMixin]------
///                       --[_MatableDriverMixin]        --[_MatableBuilderSetMixin]--
///                       |                       --[_MatableBuilderMixin]     |
///    --[_Mamion]    --[Mamable]                 |                                |
/// * [Mation]     * [Matable]----------------------[_MatableNest]-------------|
///    --[_Manion]    --[Manable]                 |                                |
///                       |                       --[_MatableDriverSoloMixin]      |
///                       --[_ManableChildren]    --[_MatableDriverSetMixin]---
///                       --[_ManableParent]      --[_MatableDriverPlaneMixin]-------
///
///
///
abstract base class Mation<A extends Matable, C> {
  ///
  /// [matable] consume [Mamable] or [Manable] for now
  ///
  final A matable;
  final C child;

  // factory cannot construct typed generic
  const Mation({required this.matable, required this.child});

  Widget plan(Animation<double> parent, CurveFR? curve);

  @override
  String toString() => 'Mation($matable)';
}

///
/// [_Mamion] responsible for animation on a child widget. ([SizedBox], [Container], [Scaffold], ...)
///
final class _Mamion extends Mation<Mamable, Widget> {
  const _Mamion({required Mamable mamable, required super.child})
      : super(matable: mamable);

  @override
  Widget plan(Animation<double> parent, CurveFR? curve) {
    final matable = this.matable;
    final child = matable._perform(parent, curve, this.child);
    return switch (matable) {
      // transition widgets in flutter are [AnimatedWidget]
      MamableTransition() => child,
      _ => ListenableBuilder(
          listenable: parent,
          builder: (_, __) => child,
        ),
    };
  }
}

///
/// [_Manion] responsible for animation on a parent widget with 'children'. ([Stack], [Column], ...)
/// notice that the 'parent' of [Parenting] is different from 'parent' argument in [Mation.plan],
/// the former means the 'widget parent' be like [Stack] or [Column]
/// the latter means the 'animation parent', [AnimationController], same as the 'parent' in [Animatable.animate]
///
final class _Manion extends Mation<Manable, Parenting> {
  final List<Widget> grandChildren;

  const _Manion({
    required Manable manable,
    required super.child,
    required this.grandChildren,
  }) : super(matable: manable);

  @override
  Widget plan(Animation<double> parent, CurveFR? curve) {
    final matable = this.matable;
    final children = matable._perform(parent, curve, grandChildren);
    return matable is _ManableParent
        ? matable.mamableParent._perform(parent, curve, child(children))
        : child(children);
  }
}

///
/// In tradition, there are many ways to create animation in flutter; to name just a few,
///   - [ScaleTransition] requires animatable double, [Tween]<[double]>
///   - [SlideTransition] requires animatable offset, [Tween]<[Offset]>
///   - [ClipPath] requires [Path] instance and additional [CustomClipper], [ListenableBuilder] to trigger animation
///   - [Transform] requires [Matrix4] instance modification be in [State.setState] to trigger complex animation
/// With the concept of [Matable],
/// [Mationani] is the only widget, no more [AnimatedWidget], or [Transform], which is not even an [AnimatedWidget].
/// [Matalue] is the only animatable, similar to [Tween] but only for [Matable] implementation.
/// [Matable], the capability for [Mationani.mation] to 'animate' [Matalue] and to 'build' widget.
///
/// below is an approximate flow illustrating how a concrete [Matable] object, [MamableClipper], works through.
/// .
///                        [MamableClipper] <  <  <  <  <  <  <  [_MamableSizingPath]
///                                     v                                   ^
/// [_Mamion.matable] < [Mation.matable] v     [_MatableDriverMixin] mixin 'drive' and 'build' to [_MatableDriverMixin._perform]
///                                     v                ^                  ^                     ^
///                  [Mationani.mation] v                ^                  ^    [_MatableBuilderMixin._builder]
///                                     v                ^    [_MatableDriverSoloMixin._drive] ^
///    [_MationaniState.planForChild] v                ^                  ^                     ^
///                                     v     [Mamable._perform] + [Mamable._drive] + [Mamable._builder]
///                                     v                ^
///          [Mation.plan] > [_Mamion.plan] required [Matable._perform]
///
abstract interface class Matable {
  const Matable();

  // ignore: unused_element
  Object _drive(Animation<double> parent, CurveFR? curve);

  ///
  /// notice that [_builder] is different from [Mation.child]
  /// - [Mation.child] consumes widget builder developer what to animate, or the builder consumed in [_perform]
  /// - [_builder] is the animated version of [Mation.child]
  ///
  // ignore: unused_element
  Object get _builder;

  ///
  /// [_drive] and [_builder] are the internal function to enable [_perform]
  /// see also [_MatableDriverMixin._perform], [_MatableNest._perform], ...
  ///
  // ignore: unused_element
  Object _perform(Animation<double> parent, CurveFR? curve, Object builder);
}

abstract interface class Mamable implements Matable {
  const Mamable();

  Widget _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant Widget child,
  );
}

abstract interface class Manable implements Matable {
  const Manable();

  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  );
}

abstract interface class _ManableParent implements Manable {
  const _ManableParent();

  Mamable get mamableParent;
}

///
///
///
base mixin _MatableBuilderMixin on Matable {
  @override
  AnimationBuilder get _builder;
}

base mixin _MatableDriverMixin<T> on Matable {
  Matalue<T> get value;

  @override
  Animation _drive(Animation<double> parent, CurveFR? curve) =>
      curve.mapNotNullOr(
        (curve) => value.animate(CurvedAnimation(
            parent: parent, curve: curve.forward, reverseCurve: curve.reverse)),
        () => value.animate(parent),
      );
}

abstract base class _MatableSolo<T> extends Matable
    with _MatableDriverMixin<T>, _MatableBuilderMixin {
  @override
  final Matalue<T> value;

  const _MatableSolo(this.value);
}

///
///
///
abstract interface class _MatableNest<A extends Matable> extends Matable {
  Iterable<A> get ables;

  @override
  String toString() => _MatableNest.stringOf(this);

  const _MatableNest();

  ///
  ///
  ///
  static bool isFlat(Iterable<Matable> ables) =>
      ables.every((able) => able is! _MatableNest);

  static int lengthFlatted(Matable ables) => switch (ables) {
        _MatableNest() => ables.ables.iterator.induct(
            lengthFlatted,
            IntExtension.reducePlus,
          ),
        Matable() => 1,
      };

  static String stringOf(_MatableNest<Matable> iterable) =>
      'Mations(${lengthFlatted(iterable)}):${iterable.ables.fold<StringBuffer>(
        StringBuffer(),
        isFlat(iterable.ables)
            ? (buffer, able) => buffer..write('\n|-$able')
            : (buffer, able) => buffer..write('\n|$able'),
      )}';
}

///
///
///
base mixin _MatableBuilderSetMixin<B extends _MatableBuilderMixin>
    on _MatableNest<B> {
  @override
  Iterable<AnimationBuilder> get _builder => ables.map((able) => able._builder);
}

base mixin _MatableDriverSetMixin<D extends _MatableDriverMixin>
    on _MatableNest<D> {
  @override
  Iterable<Animation> _drive(Animation<double> parent, CurveFR? curve) =>
      ables.map((able) => able._drive(parent, curve));
}

abstract base class _MatableSet<M extends _MatableSolo> extends _MatableNest<M>
    with _MatableBuilderSetMixin<M>, _MatableDriverSetMixin<M> {
  @override
  final Iterable<M> ables;

  const _MatableSet(this.ables);
}

///
///
///
base mixin _MatableBuilderPlaneMixin<M extends _MatableSet> on _MatableNest<M> {
  @override
  Iterable<Iterable<AnimationBuilder>> get _builder =>
      ables.map((able) => able._builder);
}

base mixin _MatableDriverPlaneMixin<M extends _MatableSet> on _MatableNest<M> {
  @override
  Iterable<Iterable<Animation>> _drive(
    Animation<double> parent,
    CurveFR? curve,
  ) =>
      ables.map((able) => able._drive(parent, curve));
}

abstract base class _MatablePlane<M extends _MatableSet> extends _MatableNest<M>
    with _MatableBuilderPlaneMixin<M>, _MatableDriverPlaneMixin<M> {
  @override
  final Iterable<M> ables;

  const _MatablePlane(this.ables);
}

///
///
///
base mixin _PerformMamableSoloMixin<T> on _MatableSolo<T> implements Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      _builder(_drive(parent, curve), child);
}

base mixin _PerformMamableSetMixin<A extends _MatableSolo> on _MatableSet<A>
    implements _MatableDriverSetMixin<A>, _MatableBuilderSetMixin<A>, Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      _builder.foldWith(
        _drive(parent, curve),
        child,
        (child, builder, animation) => builder(animation, child),
      );
}

///
///
///
// ignore: unused_element
base mixin _PerformManableSoloMixin<T> on _MatableSolo<T> implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) {
    final animation = _drive(parent, curve);
    final builder = _builder;
    return children.mapToList((child) => builder(animation, child));
  }
}

// ignore: unused_element
base mixin _PerformManableSetApplyAllMixin<A extends _MatableSolo>
    on _MatableNest<A>
    implements _MatableDriverSetMixin<A>, _MatableBuilderSetMixin<A>, Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) {
    final builders = _builder;
    return children.mapToList(
      (child) => builders.fold(
        child,
        (child, builder) => builder(parent, child),
      ),
    );
  }
}

base mixin _PerformManablePlaneMappingMixin<A extends _MatableSet>
    on _MatableNest<A>
    implements
        _MatableDriverPlaneMixin<A>,
        _MatableBuilderPlaneMixin<A>,
        Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) {
    final builders = _builder.toList(growable: false);
    final animations = _drive(parent, curve).toList(growable: false);
    return children.iterator.mapToListByIndex(
      (child, i) => builders[i].foldWith(
        animations[i],
        child,
        (child, builder, animation) => builder(animation, child),
      ),
    );
  }
}
