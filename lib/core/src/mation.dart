part of '../mationani.dart';

///
/// .
///    --[Manable]      --[_Manion]
///    --[Mamable]      --[Mamion]
/// * [Matable]     * [Mation]
///    |
///    --[_MatableSolo]
///    |   --[_MatableBuilder]
///    |
///    --[_MatableNest]
///
/// [_MamablePerformMixin]
/// [_MamablePerformNestMixin]
/// [_ManablePerformMixin]
/// [_ManablePerformAllMixin]
/// [_ManablePerformEachMixin]
/// [_ManablePerformRespectivelyMixin]
///
///
///
///
///
abstract base class Mation<A extends Matable, C> {
  ///
  /// [matable] consume [Mamable] or [Manable] for now
  ///
  final A matable;
  final C child;

  // factory cannot construct typed generic, so it's not possible to integrate subclasses into Mation for now
  // static methods as constructor is not referenced well in android studio.
  const Mation({required this.matable, required this.child});

  Widget plan(Animation<double> parent, CurveFR? curve);

  @override
  String toString() => 'Mation($matable)';
}

///
/// [Mamion] responsible for animation on a child widget. ([SizedBox], [Container], [Scaffold], ...)
///
final class Mamion extends Mation<Mamable, Widget> {
  const Mamion({required Mamable mamable, required super.child})
      : super(matable: mamable);

  @override
  Widget plan(Animation<double> parent, CurveFR? curve) => switch (matable) {
        // all transition widgets themself in flutter are listenable
        MamableTransition() => matable._perform(parent, curve, child),
        _ => ListenableBuilder(
            listenable: parent,
            builder: (_, __) => matable._perform(parent, curve, child),
          ),
      };
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
///                           [MamableClipper] <  <  <  <  <  [_MamableSizingPath]
///                                      v                               ^
/// [Mamion.matable] < [Mation.matable] v     [_MamablePerformMixin._perform] mixin on [_MatableSolo]
///                                      v              ^                ^                     ^
///                  [Mationani.mation]  v              ^                ^     [_MatableDriverMixin._drive]
///                                      v              ^    [_MatableBuilderMixin._builder]   ^
///      [_MationaniState.planForChild]  v              ^                ^                     ^
///                                      v   [Mamable._perform] + [Mamable._drive] + [Mamable._builder]
///                                      v              ^
///          [Mation.plan] > [Mamion.plan] required [Matable._perform]
///
abstract final class Matable {
  // ignore: unused_element
  Object _perform(Animation<double> parent, CurveFR? curve, Object builder);
}

abstract final class Mamable implements Matable {
  @override
  Widget _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant Widget child,
  );
}

abstract final class Manable implements Matable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  );
}

abstract final class _ManableParent implements Manable {
  Mamable get mamableParent;
}

///
///
///
abstract final class _MatableSolo<T> implements Matable {
  final Matalue<T> value;

  final AnimationBuilder _builder;

  const _MatableSolo(this.value, this._builder);

  Animation _drive(Animation<double> parent, CurveFR? curve) =>
      curve.mapNotNullOr(
        (curve) => value.animate(CurvedAnimation(
            parent: parent, curve: curve.forward, reverseCurve: curve.reverse)),
        () => value.animate(parent),
      );
}

abstract final class _MatableNest<A extends Matable> implements Matable {
  final Iterable<A> ables;

  const _MatableNest(this.ables);

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

  @override
  String toString() => _MatableNest.stringOf(this);
}

///
///
///
final class MamableSolo<T> extends _MatableSolo<T> implements Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      _builder(_drive(parent, curve), child);

  const MamableSolo(super.value, super._builder);
}

final class ManableSolo<T> extends _MatableSolo<T> implements Manable {
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

  const ManableSolo(super.value, super._builder);
}

///
///
///
final class MamableSet<A extends MamableSolo> extends _MatableNest<A>
    implements Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      ables.fold(
        child,
        (child, able) => able._builder(able._drive(parent, curve), child),
      );

  const MamableSet(super.ables);
}

abstract final class ManableSet extends _MatableNest<_MatableSolo> {
  const ManableSet(super.ables);

  const factory ManableSet.all(Iterable<_MatableSolo> ables) = _MNA;

  const factory ManableSet.each(Iterable<_MatableSolo> ables) = _MNE;
}

final class _MNA extends ManableSet implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.mapToList(
        (child) => ables.fold(
          child,
          (child, able) => able._builder(able._drive(parent, curve), child),
        ),
      );

  const _MNA(super.ables);
}

final class _MNE extends ManableSet implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.foldWith(
        ables,
        [],
        (output, child, able) => output
          ..add(
            able._builder(able._drive(parent, curve), child),
          ),
      );

  const _MNE(super.ables);
}

///
///
///
final class ManableRespectively extends _MatableNest<_MatableNest<_MatableSolo>>
    implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.foldWith(
        ables,
        [],
        (output, child, nest) => output
          ..add(
            nest.ables.fold(
              child,
              (child, able) => able._builder(able._drive(parent, curve), child),
            ),
          ),
      );

  const ManableRespectively(Iterable<MamableSet> super.children);

  const factory ManableRespectively.andParent({
    required Mamable parent,
    required Iterable<MamableSet> children,
  }) = _MNRParent;
}

final class _MNRParent extends ManableRespectively implements _ManableParent {
  @override
  final Mamable mamableParent;

  const _MNRParent({
    required Mamable parent,
    required Iterable<MamableSet> children,
  })  : mamableParent = parent,
        super(children);
}
