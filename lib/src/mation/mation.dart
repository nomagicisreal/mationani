part of '../../mationani.dart';

///
///
/// [Ani] and [Mation] helps us to create animation for [Mationani].
/// [Ani] implement how [AnimationController] can be used in [_MationaniState].
/// while [Mation] implement how [Animation] can be triggered by [Ani] in [_MationaniState].
///   1. [Mationability] plan for build
///       |--[Mamionability.planFor]
///       \--[Manionability.planForParent], [Manionability.planForChildren]
///   2. mation planning widget builder
///     - [Mamion.planning]
///     - [Manion.planning]
///   3. TODO: explain mation ani flow
///

///
/// [Mation]
///   --[Mamion] (responsible for animation(s) on a child widget ([SizedBox], [Container], ...))
///   --[Manion] (responsible for animation(s) on a parent widget with children ([Stack], [Column], ...))
///
/// [Mationability]
///   --[Mamionability]
///   --[Manionability]
///
/// [_Mationable], [_MationableIterable]
///
/// [_MationAnimatable]
///   [_MationAnimatableSingle], [_MationAnimatableIterable], [_MationAnimatableNest]
///
/// [_MationPlanable]
///   [_MationPlanableSingle], [_MationPlanableIterable], [_MationPlanableNest]
///
/// [_MamionSingle], [_MamionMulti] (trigger 1 child by 1|multi animation)
/// [_ManionChildren], [_ManionChildrenParent] (trigger children by [Mamion] for each child)
///
/// typedefs:
/// [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
/// [AnimationBuilder]
/// [MationBuilder]
/// [MationMultiGenerator]
/// [MationSequencer]
///

///
/// All the class that implements [Mationability] calls 'have mationability'
/// similar to [Mation], [Mamion], [Manion],
///
/// [Mamionability] requires subclasses to implement [Mamionability.planFor].
/// [Manionability] requires subclasses to implement [Manionability.planForParent], [Manionability.planForChildren]
/// the implementation will be invoked by [Mation.planning].
///

///
/// All the class that implements [_Mationable] called 'mationable'
///
/// Why not directly implements [Mamionability] ? instead of using [_Mationable] ?
///   When a visual effect isn't unique enough, to prevent ambiguous, it's better not to be [Mamion.ability].
///   For example, [MationTransformDelegate] is an implementation for [Transform] animation,
///   which has no [Mamionability] but is [_Mationable], and in [MationTransformDelegate],
///   [MationTransformDelegate.rotation] is similar to [MamionTransition.rotate].
///   if both of [MationTransformDelegate] and [MamionTransition] have [Mamionability],
///   we will hesitate to assign [Mamion.ability] because there are two similar way to do that.
///   [_Mationable] aims to prevent duplicate visual effect, provide more diversity on animation.
///

///
///
/// there are two core functionality on animation practice for mationable object:
///   1. animate (the function translating [Animation]<[double]> to useful value. Similar to [Tween.animate])
///   2. plan (the function or getter that returns a [WidgetBuilder])
/// [_MationAnimatable], [_MationPlanable] require subclass to care about them.
///
/// Why not writing abstraction all in [_Mationable] ? Why [_MationAnimatable] and [_MationPlanable] ?
///   Because there are kinds of 'animate' or 'plan', there are several combination for them to each other.
///   For example, it's possible for an [Animation] that is returned by an 'animate' function
///   couple with [AnimationBuilder] or [Iterable]<[AnimatedBuilder]> that is returned by a 'plan' function;
///   providing that there are two abstract function ('animate', 'plan') must be defined in superclass or interface,
///   and both of them have unspecified return type, generic type or [Object] type,
///   we must overwrite both of them to have clear type for concrete implementation; we can achieve that by
///     1. Having 1 level inheritance by the subclasses that directly inherit to 'animate' and 'plan' with:
///       - overwrite 'animate' to return [Animation], overwrite 'plan' to return [AnimatedBuilder]
///       - overwrite 'animate' to return [Animation], overwrite 'plan' to return [Iterable]<[AnimatedBuilder]>
///       - overwrite 'animate' to return [Iterable]<[Animation]>, overwrite 'plan' to return [AnimatedBuilder]
///       - ...
///     2. Having 2 level inheritance:
///       - the first level subclasses inherit one of 'animate' or 'plan'
///       - the second level subclasses inherit another. (it's hard to name the second level due to the diversity.)
///     3. Makes the interface holding 'animate' and 'plan' to return generic, and let them return generic type.
///     4. Separate 'animate' and 'plan' into two sealed class.
///   the option 4 seems to work efficiently for now,
///   because the dart mixin provides high flexibility for diverse implementation with the keyword 'with'.
///
/// Why not declaring the generic type for [Animation] and [AnimationBuilder] ?
///   because 'dynamic generic' is not the subtype of 'typed generic', [Iterable] can't cast to [Iterable]<[String]>,
///   there is an error when 'dynamic generic' passed to 'typed generic' even if it is okay to do that. for example,
///     - [MamionTransition.rotate] required [double] as animation value
///     - [MamionTransition.slide] required [Offset] as animation value
///   after initializing [MamionTransition.rotate] and [MamionTransition.slide] for [MamionMulti],
///   [MamionTransition.animate] and [MamionTransition.plan] called by [MamionMulti.animate] and [MamionMulti.plan]
///   respectively as dynamic [Animation] and dynamic [AnimatedBuilder].
///   it's okay to finish animations without error,
///   but typed return type for [MamionTransition.animate] or [MamionTransition.plan] cause error.
///   With the same methodology, it's better to defining [Animation] and [AnimatedBuilder] as dynamic.
///   Type safety must be checked before initializing the concrete instance, like [MamionTransition] does.
///
///
///

///
/// Normally, flutter animation requires correct animation value put into correct consumer widget, for example:
///   - [ScaleTransition] requires animated double value, [Tween]<[double]>
///   - [FadeTransition] requires animated double value, [Tween]<[double]>, and must between 0.0 to 1.0
///   - [SlideTransition] requires animated offset value, [Tween]<[Offset]>
///   - [Transform] requires animated [Matrix4]
/// With [Mationability] as an ancestor interface,
/// there are many implementations for specific animation type,
/// including flutter built-in animation (transition, transform) or even clipping, painting, ...
///
/// In short,
/// the development of [Mationability] focus on implementing exist animation or future animation in flutter,
/// and explore the capability of animation type, not limited to the built-in flutter animation widget.
///
///

///
/// [Mation], [Mamion], [Manion]
///
sealed class Mation<M extends Mationability> {
  final M ability;

  const Mation({required this.ability});

  @override
  String toString() => 'Mation($ability)';

  WidgetBuilder planning(Animation<double> animation);
}

class Mamion<M extends Mamionability> extends Mation<M> {
  final WidgetBuilder builder;

  const Mamion({
    required super.ability,
    required this.builder,
  });

  @override
  WidgetBuilder planning(Animation<double> animation) {
    final ability = this.ability;
    final build = ability.planFor(animation, builder);
    return switch (ability) {
      MamionTransition() => build,
      _ => (_) => AnimatedBuilder(
            animation: animation,
            builder: (context, __) => build(context),
          ),
    };
  }
}

class Manion<M extends Manionability> extends Mation<M> {
  final WidgetParentBuilder builder;

  const Manion({
    required super.ability,
    required this.builder,
  });

  @override
  WidgetBuilder planning(Animation<double> animation) => ability
      .planForParent(animation, this.builder)
      .builderFrom(ability.planForChildren(animation));
}

///
/// [Mationability], [Mamionability], [Manionability]
///
abstract interface class Mationability implements _Mationable {}

abstract interface class Mamionability implements Mationability {
  WidgetBuilder planFor(Animation<double> animation, WidgetBuilder builder);
}

abstract interface class Manionability<M extends Mamionability>
    implements Mationability {
  WidgetParentBuilder planForParent(
    Animation<double> animation,
    WidgetParentBuilder parent,
  );

  List<WidgetBuilder> planForChildren(Animation<double> animation);
}

///
/// [_Mationable], [_MationableIterable]
///
abstract interface class _Mationable {
  const _Mationable();
}

abstract interface class _MationableIterable<M extends _Mationable>
    implements _Mationable {
  final Iterable<M> ables;

  const _MationableIterable(this.ables);

  static bool isFlat(Iterable<_Mationable> ables) =>
      ables.every((m) => m is! _MationableIterable);

  static int lengthFlatted(_Mationable ables) => switch (ables) {
        _MationableIterable() => ables.ables.iterator.induct(
            lengthFlatted,
            IntExtension.reducePlus,
          ),
        _Mationable() => 1,
      };

  static String stringOf(_MationableIterable ables) =>
      'Mations(${lengthFlatted(ables)}):'
      ' ${ables.ables.fold(
        '',
        (value, element) =>
            '$value \n|-${isFlat(ables.ables) ? '-' : ''}$element',
      )}';
}

///
///
/// [_MationAnimatable], [_MationPlanable]
///
///
sealed class _MationAnimatable implements _Mationable {
  const _MationAnimatable();

  Object animate(Animation<double> parent);

  static Iterable<Animation> Function(_Mationable able) animating(
    Animation<double> animation,
  ) =>
      (able) => switch (able) {
            _MationAnimatable() => switch (able) {
                _MationAnimatableSingle() => [able.animate(animation)],
                _MationAnimatableIterable() => able.animate(animation),
                _MationAnimatableNest() =>
                  able.animate(animation).iterator.foldNested(),
              },
            _Mationable() => throw UnimplementedError(able.toString()),
          };
}

//
sealed class _MationPlanable implements _Mationable {
  const _MationPlanable();

  Object get plan;

  static Iterable<AnimationBuilder> planning(_Mationable able) =>
      switch (able) {
        _MationPlanable() => switch (able) {
            _MationPlanableSingle() => [able.plan],
            _MationPlanableIterable() => able.plan,
            _MationPlanableNest() => able.plan.iterator.foldNested(),
          },
        _Mationable() => throw UnimplementedError(able.toString()),
      };
}

///
/// [_MationAnimatableSingle], [_MationAnimatableIterable], [_MationAnimatableNest]
/// [_MationPlanableSingle], [_MationPlanableIterable], [_MationPlanableNest]
///
mixin _MationAnimatableSingle<T> implements _MationAnimatable {
  Mationvalue<T> get value;

  @override
  Animation animate(Animation<double> animation) => value.animate(animation);
}

mixin _MationAnimatableIterable
    implements _MationAnimatable, _MationableIterable<_MationAnimatableSingle> {
  @override
  Iterable<Animation> animate(Animation<double> animation) =>
      ables.map((able) => able.animate(animation));
}

mixin _MationAnimatableNest<M extends _Mationable>
    implements _MationAnimatable, _MationableIterable<M> {
  @override
  Iterable<Iterable<Animation>> animate(Animation<double> animation) =>
      ables.map(_MationAnimatable.animating(animation));
}

//
mixin _MationPlanableSingle implements _MationPlanable {
  @override
  AnimationBuilder get plan;
}

mixin _MationPlanableIterable
    implements _MationPlanable, _MationableIterable<_MationPlanableSingle> {
  @override
  Iterable<AnimationBuilder> get plan => ables.map((able) => able.plan);
}

mixin _MationPlanableNest<M extends _Mationable>
    implements _MationPlanable, _MationableIterable<M> {
  @override
  Iterable<Iterable<AnimationBuilder>> get plan =>
      ables.map(_MationPlanable.planning);
}

///
/// [_MamionSingle], [_MamionMulti]
///
abstract class _MamionSingle<T>
    with _MationAnimatableSingle<T>, _MationPlanableSingle {
  @override
  final Mationvalue<T> value;
  @override
  final AnimationBuilder plan;

  const _MamionSingle(this.value, this.plan);
}

abstract class _MamionMulti<M extends _Mationable>
    with _MationAnimatableNest<M>, _MationPlanableNest<M>
    implements Mamionability {
  @override
  final Iterable<M> ables;

  const _MamionMulti(this.ables);

  @override
  WidgetBuilder planFor(Animation<double> animation, WidgetBuilder builder) {
    final evaluations2D = animate(animation);
    final plans2D = plan;
    return (context) => plans2D.foldWith2D(
          evaluations2D,
          builder(context),
          (child, build, animation) => build(animation, child),
        );
  }

  @override
  String toString() => _MationableIterable.stringOf(this);
}

///
/// [_ManionChildren], [_ManionChildrenParent],
///
abstract class _ManionChildren<M extends Mamionability>
    implements _Mationable, Manionability<M> {
  final Iterable<Mamion<M>> children;

  _ManionChildren({required this.children});

  @override
  WidgetParentBuilder planForParent(
    Animation<double> animation,
    WidgetParentBuilder parent,
  ) =>
      parent;

  @override
  List<WidgetBuilder> planForChildren(Animation<double> animation) =>
      children.iterator.fold(
        [],
        (list, mamion) => list..add(mamion.planning(animation)),
      );
}

abstract class _ManionChildrenParent<M extends Mamionability>
    extends _ManionChildren<M> {
  final M parent;

  _ManionChildrenParent({
    required this.parent,
    required super.children,
  });

  @override
  WidgetParentBuilder planForParent(
    Animation<double> animation,
    WidgetParentBuilder parent,
  ) {
    final planFor = this.parent.planFor;
    return (context, children) => planFor(
          animation,
          (context) => parent(context, children),
        )(context);
  }
}

///
///
///
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Point3>;
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

///
///
///
typedef MationBuilder<M extends Mamionability> = Widget Function(
  BuildContext context,
  M mation,
);
typedef MationSequencer<T>
    = Sequencer<AniSequenceStep, AniSequenceInterval, Mamionability>;
