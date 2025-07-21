part of '../mationani.dart';

///
///
/// implementation for this file
/// * [_ListWidget]
///
/// implementation for `matalue.dart`
/// * [_ShapeDecoration]
/// * [_ListOffset]
///
/// implementation for `animation.dart`
/// * [_AnimationController]
/// * [_AnimationStyleExtension]
///
/// implementation for `matable.dart`
/// * [_Clipping]
/// * [_Painting]
/// * [_MatableDriver], and more ...
///
///
///

///
///
///
extension _ListWidget on List<Widget> {
  List<Widget> _attachList<T>(
    List<T> animations,
    Widget Function(Widget child, T value) companion,
  ) {
    if (length != animations.length) {
      throw StateError(
        'size(${animations.length}) not equal to children size($length)',
      );
    }
    var children = <Widget>[];
    for (var i = 0; i < length; i++) {
      children.add(companion(this[i], animations[i]));
    }
    return children;
  }

  List<Widget> _attachMap<T>(
    Map<int, T> selected,
    Widget Function(Widget child, T value) companion,
  ) {
    final list = <Widget>[];
    for (var i = 0; i < length; i++) {
      final animation = selected[i];
      list.add(animation == null ? this[i] : companion(this[i], animation));
    }
    return list;
  }
}

///
///
///
extension _ShapeDecoration on ShapeDecoration {
  bool get isRounded =>
      shape is CircleBorder || shape is RoundedRectangleBorder;
}

extension _OffsetOffset on (Offset, Offset) {
  Offset _centerPerpendicularOf([double distance = 1]) =>
      this.$1 * 0.5 +
      this.$2 * 0.5 +
      Offset.fromDirection(
        (this.$2 - this.$1).direction + Matalue._radian_angle90,
        distance,
      );

  (Offset, Offset) _symmetryInsert(double dPerpendicular, dParallel) {
    final v = this.$2 - this.$1;
    final vUnit = v / v.distance;
    final u = _centerPerpendicularOf(dPerpendicular);
    return (u - vUnit * dParallel, u + vUnit * dParallel);
  }
}

///
///
///
extension _AnimationController on AnimationController {
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
class _Clipping extends CustomClipper<Path> {
  final Path Function(Size size) sizingPath;

  @override
  Path getClip(Size size) => sizingPath(size);

  @override
  bool shouldReclip(_Clipping oldClipper) =>
      sizingPath != oldClipper.sizingPath;

  const _Clipping(this.sizingPath);
}

class _Painting extends CustomPainter {
  final bool Function(_Painting oldP, _Painting p) shouldRePaint;
  final Path Function(Size size) sizingPath;
  final Paint Function(Canvas canvas, Size size) paintFrom;
  final void Function(Canvas canvas, Paint paint, Path path) paintingPath;

  ///
  ///
  ///
  @override
  void paint(Canvas canvas, Size size) {
    final path = sizingPath(size);
    final paint = paintFrom(canvas, size);
    paintingPath(canvas, paint, path);
  }

  @override
  bool shouldRepaint(_Painting oldDelegate) => shouldRePaint(oldDelegate, this);

  static bool _rePaintWhenUpdate(_Painting oldP, _Painting p) => true;

  ///
  ///
  ///
  const _Painting({
    required this.paintingPath,
    required this.sizingPath,
    required this.paintFrom,
  }) : shouldRePaint = _rePaintWhenUpdate;
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

  Animation _drive(Animation<double> parent, (Curve, Curve)? curve) {
    if (curve == null) return value.animate(parent);
    return value.animate(CurvedAnimation(
      parent: parent,
      curve: curve.$1,
      reverseCurve: curve.$2,
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
    (Curve, Curve)? curve,
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
  final List<MamableSingle> each;

  const _ManableSetEach(this.each);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    (Curve, Curve)? curve,
    covariant List<Widget> children,
  ) =>
      children._attachList(
        each,
        (child, solo) => solo._builder(solo._drive(parent, curve), child),
      );
}

///
///
///
final class _ManableSetRespectively extends ManableSet {
  final List<MamableSet> children;

  const _ManableSetRespectively(this.children);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    (Curve, Curve)? curve,
    covariant List<Widget> children,
  ) =>
      children._attachList(
        this.children,
        (child, animation) => animation.ables.fold(
          child,
          (child, able) => able._builder(able._drive(parent, curve), child),
        ),
      );
}

final class _ManableSetSelected extends ManableSet {
  final Map<int, MamableSet> selected;

  const _ManableSetSelected(this.selected);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    (Curve, Curve)? curve,
    covariant List<Widget> children,
  ) =>
      children._attachMap(
        selected,
        (child, animation) => animation.ables.fold(
          child,
          (c, able) => able._builder(able._drive(parent, curve), c),
        ),
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
      {required this.parent, required List<MamableSingle> each})
      : super(each);
}

//
final class _ManableParentRespectively extends _ManableSetRespectively
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentRespectively({
    required this.parent,
    required List<MamableSet> children,
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
