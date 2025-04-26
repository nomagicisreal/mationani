part of '../mationani.dart';

///
///
/// implementation for `matalue.dart`
/// * [_ShapeDecoration]
///
/// implementation for `animation.dart`
/// * [_AnimationControllerExtension]
/// * [_AnimationStyleExtension]
///
/// implementation for `matable.dart`
/// * [AnimationBuilder]
/// * [_MatableDriver], and more ...
///
///
///

///
///
///
extension _ShapeDecoration on ShapeDecoration {
  bool get isRounded =>
      shape is CircleBorder || shape is RoundedRectangleBorder;
}

///
///
///
extension _AnimationControllerExtension on AnimationController {
  void addStatusListenerIfNotNull(AnimationStatusListener? statusListener) {
    if (statusListener != null) addStatusListener(statusListener);
  }

  void addListenerIfNotNull(VoidCallback? listener) {
    if (listener != null) addListener(listener);
  }

  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void updateDurationIfNew(Mationani oldWidget, Mationani widget) {
    final style = widget.ani.style;
    final styleOld = oldWidget.ani.style;
    if (styleOld?.duration != style?.duration) duration = style?.duration;
    if (styleOld?.reverseDuration != style?.reverseDuration) {
      reverseDuration = style?.reverseDuration;
    }
  }
}

///
///
///
extension _AnimationStyleExtension on AnimationStyle? {
  bool isCurveEqualTo(AnimationStyle? another) {
    final style = this;
    if (style == null) return another == null;
    if (another == null) return false;
    return style.curve == another.curve &&
        style.reverseCurve == another.reverseCurve;
  }
}

///
///
///
abstract final class _MatableDriver<T> {
  final Matalue<T> value;

  ///
  /// there is an error if typed generic for [_builder] and [_drive] for multiple driver instance.
  ///
  /// for example, ([Animation]<[Offset]>, [Widget]) => [SlideTransition],
  /// which is not the subtype of ([Animation]<dynamic>, [Widget]) => [SlideTransition].
  /// its a class designed ta be use many times in a widget build,
  /// not a class intended ta be type safe for each single creation in [MamableSingle]
  ///
  final AnimationBuilder _builder;

  const _MatableDriver(this.value, this._builder);

  Animation _drive(Animation<double> parent, CurveFR? curve) {
    if (curve == null) return value.animate(parent);
    return value.animate(CurvedAnimation(
      parent: parent,
      curve: curve.forward,
      reverseCurve: curve.reverse,
    ));
  }
}

abstract final class _ManableParent {
  Mamable get parent;
}

///
///
///
final class _ManableSetSync extends ManableSet {
  final MamableSet matable;

  const _ManableSetSync(this.matable);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      List.of(
        children.map(
          (child) => matable.ables.fold(
            child,
            (child, able) => able._builder(able._drive(parent, curve), child),
          ),
        ),
        growable: false,
      );
}

final class _ManableSetEach extends ManableSet {
  final Iterable<MamableSingle> each;

  const _ManableSetEach(this.each);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.foldWith(
        each,
        [],
        (output, child, solo) => output
          ..add(
            solo._builder(solo._drive(parent, curve), child),
          ),
      );
}

///
///
///
final class _ManableSetRespectively extends ManableSet {
  final Iterable<MamableSet> children;

  const _ManableSetRespectively(this.children);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.foldWith(
        this.children,
        [],
        (output, child, matable) => output
          ..add(
            matable.ables.fold(
              child,
              (c, able) => able._builder(able._drive(parent, curve), c),
            ),
          ),
      );
}

final class _ManableSetSelected extends ManableSet {
  final Map<int, MamableSet> selected;

  const _ManableSetSelected(this.selected);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) =>
      children.iterator.mapToListByIndex(
        (child, i) {
          final select = selected[i];
          if (select == null) return child;
          return select.ables.fold(
            child,
            (widget, able) => able._builder(able._drive(parent, curve), widget),
          );
        },
      );
}

///
///
///
final class _ManableParentSyncAlso<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  Mamable get parent => MamableSingle(value, _builder);

  const _ManableParentSyncAlso(super.value, super.builder);
}

final class _ManableParentSyncAnd<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSyncAnd({
    required Matalue<T> value,
    required AnimationBuilder builder,
    required Mamable mamable,
  })  : parent = mamable,
        super(value, builder);
}

//
final class _ManableParentSetSync extends _ManableSetSync
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSetSync({required this.parent, required MamableSet model})
      : super(model);

  const _ManableParentSetSync.also(super.matable) : parent = matable;
}

//
final class _ManableParentSetEach extends _ManableSetEach
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSetEach(
      {required this.parent, required Iterable<MamableSingle> each})
      : super(each);
}

//
final class _ManableParentRespectively extends _ManableSetRespectively
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentRespectively({
    required this.parent,
    required Iterable<MamableSet> children,
  }) : super(children);
}

final class _ManableParentSelected extends _ManableSetSelected
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSelected({
    required this.parent,
    required Map<int, MamableSet> selected,
  }) : super(selected);
}
