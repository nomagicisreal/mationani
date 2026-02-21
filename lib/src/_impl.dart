part of '../mationani.dart';

///
///
/// implementation for this file
/// + [_ListWidget]
///
/// implementation for `matalue.dart`
/// k [_radian360], ...
/// + [_E]
/// + [_ShapeDecoration]
/// + [_OffsetOffset]
/// --[_BetweenConstant], ...
/// --[_DeviateDouble], ...
/// --[_CurveSegment]
///
/// implementation for `animation.dart`
/// k [_durationDefault]
/// + [_AnimationController]
/// + [_ListExtension]
///
/// implementation for `matable.dart`
/// --[Clipper], [_ClipperAdjust]
/// --[Painter], [_PainterAdjust]
/// [_MatableDriver]
/// --[_ManableSetSync], ...
/// [_ManableParent], ...
///
///
///
///

///
///
///
extension _ListWidget on List<Widget> {
  List<Widget> _attachList<T>(
    List<T> animations,
    Widget Function(Widget, T) companion,
  ) {
    if (length != animations.length) {
      throw StateError(
        '${animations.length} ≠ $length (animations.length ≠ children.length)',
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
    Widget Function(Widget, T) companion,
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
const double _radian360 = math.pi * 2;
const double _radian90 = math.pi / 2;

extension _E on Offset {
  static void _draw(Canvas canvas, Paint paint, Path path) =>
      canvas.drawPath(path, paint);

  static double _doublePlus(double a, double b) => a + b;

  static Rect _rectFull(Size size) => Offset.zero & size;

  static double _gen1(int i) => 1;

  static BiCurve _genLinear(int i) => (Curves.linear, Curves.linear);

  static Animatable<T> _between<T>(T begin, T end, BiCurve? curve) =>
      Between(begin, end, curve);

  static CubicOffset _rpcSwitch_1342(CubicOffset cubic) =>
      (cubic.$1, cubic.$3, cubic.$4, cubic.$2);

  ///
  ///
  ///
  Offset _parallelOffsetOf(Offset q, double t) => this + (q - this) * t;

  Offset _parallelOffsetUnitOf(Offset q, double t) {
    final offset = q - this;
    return this + offset / offset.distance * t;
  }
}

extension _ShapeDecoration on ShapeDecoration {
  bool get isRounded =>
      shape is CircleBorder || shape is RoundedRectangleBorder;
}

extension _OffsetOffset on (Offset, Offset) {
  Offset _centerPerpendicularOf([double distance = 1]) =>
      this.$1 * 0.5 +
      this.$2 * 0.5 +
      Offset.fromDirection(
        (this.$2 - this.$1).direction + _radian90,
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
class _BetweenConstant<T> extends Between<T> {
  const _BetweenConstant(T matalue, [BiCurve? curve])
      : super._(matalue, matalue, curve);

  @override
  T transform(double t) => begin;
}

class _BetweenDouble extends Between<double> {
  const _BetweenDouble(super.begin, super.end, super.curve) : super._();

  @override
  double transform(double t) => begin * (1.0 - t) + end * t;
}

class _BetweenDoubleDouble extends Between<(double, double)> {
  const _BetweenDoubleDouble(super.begin, super.end, super.curve) : super._();

  @override
  (double, double) transform(double t) {
    final begin = this.begin,
        end = this.end,
        b1 = begin.$1,
        b2 = begin.$2,
        e1 = end.$1,
        e2 = end.$2;
    return (b1 * (1.0 - t) + e1 * t, b2 * (1.0 - t) + e2 * t);
  }
}

class _BetweenDoubleDoubleDouble extends Between<(double, double, double)> {
  const _BetweenDoubleDoubleDouble(super.begin, super.end, super.curve)
      : super._();

  @override
  (double, double, double) transform(double t) {
    final begin = this.begin,
        end = this.end,
        b1 = begin.$1,
        b2 = begin.$2,
        b3 = begin.$3,
        e1 = end.$1,
        e2 = end.$2,
        e3 = end.$3;
    return (
      b1 * (1.0 - t) + e1 * t,
      b2 * (1.0 - t) + e2 * t,
      b3 * (1.0 - t) + e3 * t
    );
  }
}

class _BetweenDoubleDoubleDoubleDouble
    extends Between<(double, double, double, double)> {
  const _BetweenDoubleDoubleDoubleDouble(super.begin, super.end, super.curve)
      : super._();

  @override
  (double, double, double, double) transform(double t) {
    final begin = this.begin,
        end = this.end,
        b1 = begin.$1,
        b2 = begin.$2,
        b3 = begin.$3,
        b4 = begin.$4,
        e1 = end.$1,
        e2 = end.$2,
        e3 = end.$3,
        e4 = end.$4;
    return (
      b1 * (1.0 - t) + e1 * t,
      b2 * (1.0 - t) + e2 * t,
      b3 * (1.0 - t) + e3 * t,
      b4 * (1.0 - t) + e4 * t
    );
  }
}

class _BetweenOffset extends Between<Offset> {
  const _BetweenOffset(super.begin, super.end, super.curve) : super._();

  @override
  Offset transform(double t) => Offset.lerp(begin, end, t)!;
}

class _BetweenSize extends Between<Size> {
  const _BetweenSize(super.begin, super.end, super.curve) : super._();

  @override
  Size transform(double t) => Size.lerp(begin, end, t)!;
}

class _BetweenRect extends Between<Rect> {
  const _BetweenRect(super.begin, super.end, super.curve) : super._();

  @override
  Rect transform(double t) => Rect.lerp(begin, end, t)!;
}

class _BetweenColor extends Between<Color> {
  const _BetweenColor(super.begin, super.end, super.curve) : super._();

  @override
  Color transform(double t) => Color.lerp(begin, end, t)!;
}

class _BetweenEdgeInsets extends Between<EdgeInsets> {
  const _BetweenEdgeInsets(super.begin, super.end, super.curve) : super._();

  @override
  EdgeInsets transform(double t) => EdgeInsets.lerp(begin, end, t)!;
}

class _BetweenRelativeRect extends Between<RelativeRect> {
  const _BetweenRelativeRect(super.begin, super.end, super.curve) : super._();

  @override
  RelativeRect transform(double t) => RelativeRect.lerp(begin, end, t)!;
}

class _BetweenAlignmentGeometry extends Between<AlignmentGeometry> {
  const _BetweenAlignmentGeometry(super.begin, super.end, super.curve)
      : super._();

  @override
  AlignmentGeometry transform(double t) =>
      AlignmentGeometry.lerp(begin, end, t)!;
}

class _BetweenDecoration extends Between<Decoration> {
  const _BetweenDecoration(super.begin, super.end, super.curve) : super._();

  @override
  Decoration transform(double t) => Decoration.lerp(begin, end, t)!;
}

class _BetweenBoxDecoration extends Between<BoxDecoration> {
  const _BetweenBoxDecoration(super.begin, super.end, super.curve) : super._();

  @override
  BoxDecoration transform(double t) => BoxDecoration.lerp(begin, end, t)!;
}

class _BetweenShapeDecoration extends Between<ShapeDecoration> {
  const _BetweenShapeDecoration(super.begin, super.end, super.curve)
      : super._();

  @override
  ShapeDecoration transform(double t) => ShapeDecoration.lerp(begin, end, t)!;
}

class _BetweenBoxBorder extends Between<BoxBorder> {
  const _BetweenBoxBorder(super.begin, super.end, super.curve) : super._();

  @override
  BoxBorder transform(double t) => BoxBorder.lerp(begin, end, t)!;
}

class _BetweenShapeBorder extends Between<ShapeBorder> {
  const _BetweenShapeBorder(super.begin, super.end, super.curve) : super._();

  @override
  ShapeBorder transform(double t) => ShapeBorder.lerp(begin, end, t)!;
}

class _BetweenOutlinedBorder extends Between<OutlinedBorder> {
  const _BetweenOutlinedBorder(super.begin, super.end, super.curve) : super._();

  @override
  OutlinedBorder transform(double t) => OutlinedBorder.lerp(begin, end, t)!;
}

///
///
///
class _DeviateDouble extends Deviate<double> {
  const _DeviateDouble(super.around, super.amplitude, super.curve) : super._();

  @override
  double transform(double t) => around + amplitude * math.sin(_radian360 * t);
}

class _DeviateOffset extends Deviate<Offset> {
  const _DeviateOffset(super.around, super.amplitude, super.curve) : super._();

  @override
  Offset transform(double t) => around + amplitude * math.sin(_radian360 * t);
}

final class _CurveSegment extends Curve {
  final double Function(double) origin;
  final double begin;
  final double end;

  const _CurveSegment(this.origin, this.begin, this.end)
      : assert(begin >= 0 && end <= 1);

  @override
  double transformInternal(double t) => origin(begin * (1 - t) + end * t);

  static BiCurve apply(BiCurve curve, double begin, double end) => (
        _CurveSegment(curve.$1.transform, begin, end),
        _CurveSegment(curve.$2.transform, begin, end),
      );
}

///
///
///
const Duration _durationDefault = Duration(milliseconds: 500);

extension _AnimationController on AnimationController {
  ///
  ///
  ///
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void updateDurationIfNew(Mationani oldWidget, Mationani widget) {
    final duration = widget.duration,
        durationOld = oldWidget.duration,
        df = duration.$1,
        dr = duration.$2;
    if (durationOld.$1 != df) this.duration = df;
    if (durationOld.$2 != dr) reverseDuration = dr;
  }

  void forwardAt(Duration duration, [double? from]) => this
    ..duration = duration
    ..forward(from: from);

  void reverseAt(Duration duration, [double? from]) => this
    ..reverseDuration = duration
    ..reverse(from: from);
}

///
///
///
extension _ListExtension<T> on List<T> {
  bool isIdentical(List<T> another) {
    final length = this.length;
    if (length != another.length) return false;
    for (var i = 0; i < length; i++) {
      if (this[i] != another[i]) return false;
    }
    return true;
  }
}

///
///
///
class _Clipper extends CustomClipper<Path> {
  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(_Clipper oldClipper) => path != oldClipper.path;

  const _Clipper(this.path);
}

class _ClipperAdjust extends CustomClipper<Path> {
  final Path Function(Size size) adjust;

  @override
  Path getClip(Size size) => adjust(size);

  @override
  bool shouldReclip(_ClipperAdjust oldClipper) => adjust != oldClipper.adjust;

  const _ClipperAdjust(this.adjust);
}

///
///
///
class _Painter extends CustomPainter {
  final Paint pen;
  final Path path;
  final void Function(Canvas, Paint, Path) painting;

  @override
  void paint(Canvas canvas, Size size) {
    painting(canvas, pen, path);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => true;

  const _Painter({
    required this.painting,
    required this.path,
    required this.pen,
  });
}

class _PainterAdjust extends CustomPainter {
  final Paint pen;
  final Path Function(Size) adjust;
  final void Function(Canvas, Paint, Path) painting;

  @override
  void paint(Canvas canvas, Size size) {
    final path = adjust(size);
    painting(canvas, pen, path);
  }

  @override
  bool shouldRepaint(_PainterAdjust oldDelegate) => true;

  const _PainterAdjust({
    required this.painting,
    required this.adjust,
    required this.pen,
  });
}

///
///
///
abstract final class _MatableDriver<T> {
  final Matalue<T>? matalue;

  ///
  /// there is an error if typed generic for [_builder] and [_drive] for multiple driver instance.
  ///
  /// for example, ([Animation]<[Offset]>, [Widget]) => [SlideTransition],
  /// which is not the subtype of ([Animation]<dynamic>, [Widget]) => [SlideTransition].
  /// its a class designed ta be use many times in a widget build,
  /// not a class intended ta be type safe for each single creation in [MamableSingle]
  ///
  final AnimationBuilder _builder;

  const _MatableDriver(this.matalue, this._builder);

  Animation _drive(Animation<double> parent) {
    final matalue = this.matalue;
    return matalue == null ? parent : matalue.animate(parent);
  }
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
    covariant List<Widget> children,
  ) =>
      List.of(
        children.map(
          (child) => matable.ables.fold(
            child,
            (child, able) => able._builder(able._drive(parent), child),
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
    covariant List<Widget> children,
  ) =>
      children._attachList(
        each,
        (child, solo) => solo._builder(solo._drive(parent), child),
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
    covariant List<Widget> children,
  ) =>
      children._attachList(
        this.children,
        (child, animation) => animation.ables.fold(
          child,
          (child, able) => able._builder(able._drive(parent), child),
        ),
      );
}

final class _ManableSetSelected extends ManableSet {
  final Map<int, MamableSet> selected;

  const _ManableSetSelected(this.selected);

  @override
  List<Widget> _perform(
    Animation<double> parent,
    covariant List<Widget> children,
  ) =>
      children._attachMap(
        selected,
        (child, animation) => animation.ables.fold(
          child,
          (c, able) => able._builder(able._drive(parent), c),
        ),
      );
}

///
///
///
abstract final class _ManableParent {
  Mamable get parent;
}

final class _ManableParentSyncAlso<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  Mamable get parent => MamableSingle(matalue, _builder);

  const _ManableParentSyncAlso(super.matalue, super.builder);
}

final class _ManableParentSyncAnd<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSyncAnd({
    required Matalue<T> matalue,
    required AnimationBuilder builder,
    required Mamable mamable,
  })  : parent = mamable,
        super(matalue, builder);
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
