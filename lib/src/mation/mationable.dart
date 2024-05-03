///
///
/// this file contains:
/// [_Mationable]
///   [_MationableIterable]
///
/// [_MationAnimatable]
///   [_MationAnimatableSingle]
///   [_MationAnimatableIterable]
///   [_MationAnimatableMulti]
///
/// [_MationPlanable]
///   [_MationPlanableSingle]
///   [_MationPlanableIterable]
///   [_MationPlanableMulti]
///
///
/// [_MationableBetween]
///
/// [_MationMulti]
/// [_ManionChildren]
///   [_ManionParentChildren]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
///
///
/// [_Mationable], [_MationableIterable]
///
///
///

///
/// All the class that implements [_Mationable] called 'mationable'
///
/// Why not directly implements [Mamionability] ? instead of using [_Mationable] ?
///   When a visual effect isn't unique enough, to prevent ambiguous, it's better not to be [Mamion.ability].
///   For example, [MationTransformDelegate] is an implementation for [Transform] animation,
///   which has no [Mamionability] but is [_Mationable], and in [MationTransformDelegate],
///   [MationTransformDelegate.rotation] is similar to [MationTransition.rotate].
///   if both of [MationTransformDelegate] and [MamionTransition] have [Mamionability],
///   we will hesitate to assign [Mamion.ability] because there are two similar way to do that.
///   [_Mationable] aims to prevent duplicate visual effect, provide more diversity on animation.
///

//
abstract interface class _Mationable {
  const _Mationable();
}

//
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
///
/// [_MationAnimatable], [_MationPlanable]
///
///
///

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
///     - [MationTransition.rotate] required [double] as animation value
///     - [MationTransition.slide] required [Offset] as animation value
///   after initializing [MationTransition.rotate] and [MationTransition.slide] for [MamionMulti],
///   [MamionTransition.animate] and [MamionTransition.plan] called by [MamionMulti.animate] and [MamionMulti.plan]
///   respectively as dynamic [Animation] and dynamic [AnimatedBuilder].
///   it's okay to finish animations without error,
///   but typed return type for [MamionTransition.animate] or [MamionTransition.plan] cause error.
///   With the same methodology, it's better to defining [Animation] and [AnimatedBuilder] as dynamic.
///   Type safety must be checked before initializing the concrete instance, like [MamionTransition] does.
///
///
///

//
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
                _MationAnimatableMulti() =>
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
            _MationPlanableMulti() => able.plan.iterator.foldNested(),
          },
        _Mationable() => throw UnimplementedError(able.toString()),
      };
}

///
///
///
/// [_MationAnimatableSingle], [_MationAnimatableIterable], [_MationAnimatableMulti]
/// [_MationPlanableSingle], [_MationPlanableIterable], [_MationPlanableMulti]
///
///
///

// animatable single
mixin _MationAnimatableSingle<T> implements _MationAnimatable {
  Mationvalue<T> get value;

  @override
  Animation animate(Animation<double> animation) => value.animate(animation);
}

// animatable iterable
mixin _MationAnimatableIterable
    implements _MationAnimatable, _MationableIterable<_MationAnimatableSingle> {
  @override
  Iterable<Animation> animate(Animation<double> animation) =>
      ables.map((able) => able.animate(animation));
}

// animatable multi
mixin _MationAnimatableMulti<M extends _Mationable>
    implements _MationAnimatable, _MationableIterable<M> {
  @override
  Iterable<Iterable<Animation>> animate(Animation<double> animation) =>
      ables.map(_MationAnimatable.animating(animation));
}

// planable single
mixin _MationPlanableSingle implements _MationPlanable {
  @override
  AnimationBuilder get plan;
}

// planable iterable
mixin _MationPlanableIterable
    implements _MationPlanable, _MationableIterable<_MationPlanableSingle> {
  @override
  Iterable<AnimationBuilder> get plan => ables.map((able) => able.plan);
}

// planable multi
mixin _MationPlanableMulti<M extends _Mationable>
    implements _MationPlanable, _MationableIterable<M> {
  @override
  Iterable<Iterable<AnimationBuilder>> get plan =>
      ables.map(_MationPlanable.planning);
}

///
///
///
///
///
/// the classes belows
/// are the combination of mixin that implements [_MationAnimatable], [_MationPlanable], [_Mationable]
///
///
///
///
///

///
///
///
/// [_MationableBetween]
///
///
///

///
/// all the subclass of [_MationableBetween] only triggers only 1 animation with only 1 [Between].
/// Despite of 1 [Between], it has also a wide range of diversity of animation.
/// for example [Between.sequence] can sequence lots of values into an animation.
///
abstract class _MationableBetween<T>
    with _MationAnimatableSingle<T>, _MationPlanableSingle {
  @override
  final Mationvalue<T> value;
  @override
  final AnimationBuilder plan;

  const _MationableBetween(this.value, this.plan);
}

///
///
///
/// [_MationMulti]
///
///
///

//
abstract class _MationMulti<M extends _Mationable>
    with _MationAnimatableMulti<M>, _MationPlanableMulti<M>
    implements Mamionability {
  @override
  final Iterable<M> ables;

  const _MationMulti(this.ables);

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
///
///
/// [_ManionChildren], [_ManionParentChildren],
///
///
///

//
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

abstract class _ManionParentChildren<M extends Mamionability>
    extends _ManionChildren<M> {
  final M parent;

  _ManionParentChildren({
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
