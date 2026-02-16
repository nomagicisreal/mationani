part of '../mationani.dart';

///
/// .
///     --[Deviate]
///     |   --[_DeviateDouble], [_DeviateOffset]
///     |
/// * [Matalue] * [_AnimationMatalue] * [Animation]
///     |
///     --[Between]
///         --[_BetweenConstant]
///         --[_BetweenDouble], [_BetweenDoubleDouble], [_BetweenDoubleDoubleDouble]
///         --[_BetweenSize], [_BetweenRect], [_BetweenColor]
///         --[_BetweenEdgeInsets], [_BetweenRelativeRect], [_BetweenAlignmentGeometry]
///         --[_BetweenDecoration], [_BetweenBoxDecoration], [_BetweenShapeDecoration]
///         --[_BetweenBoxBorder], [_BetweenShapeBorder], [_BetweenOutlinedBorder]
///         |
///         --[BetweenDepend]
///
///

///
///
///
class _AnimationMatalue<T> extends Animation<T>
    with AnimationWithParentMixin<double> {
  _AnimationMatalue(this.parent, this.animatable);

  @override
  final Animation<double> parent;

  final Matalue<T> animatable;

  @override
  T get value => animatable.evaluate(parent);
}

abstract class Matalue<T> extends Animatable<T> {
  final BiCurve? curve;

  const Matalue(this.curve);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _AnimationMatalue(
        CurvedAnimation(
          parent: parent,
          curve: curve?.$1 ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.$2 ?? Curves.fastOutSlowIn,
        ),
        this,
      );

  static const double _radian_angle360 = math.pi * 2;
  static const double _radian_angle90 = math.pi / 2;

  ///
  ///
  ///
  static Matalue<double> doubleRadianFromRound(Animatable<double> round) =>
      switch (round) {
        Between<double>() => Between(
            begin: round.begin * _radian_angle360,
            end: round.end * _radian_angle360,
            curve: round.curve,
          ),
        Deviate<double>() => Deviate(
            around: round.around * _radian_angle360,
            amplitude: round.amplitude * _radian_angle360,
            curve: round.curve,
          ),
        Animatable<double>() => throw UnimplementedError(),
      };
}

///
///
///
abstract class Between<T> extends Matalue<T> {
  final T begin;
  final T end;

  const Between._(this.begin, this.end, super.curve);

  const factory Between.of(T value, [BiCurve? curve]) = _BetweenConstant;

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  ///
  ///
  factory Between({required T begin, required T end, BiCurve? curve}) =>
      switch (begin) {
        double _ => _BetweenDouble(begin, end as double, curve),
        (double, double) _ =>
          _BetweenDoubleDouble(begin, end as (double, double), curve),
        (double, double, double) _ => _BetweenDoubleDoubleDouble(
            begin, end as (double, double, double), curve),

        ///
        ///
        ///
        Path Function(Size size) _ =>
          throw StateError('Plz use BetweenPath instead'),
        Offset _ => _BetweenOffset(begin, end as Offset, curve),
        Size _ => _BetweenSize(begin, end as Size, curve),
        Rect _ => _BetweenRect(begin, end as Rect, curve),
        Color _ => _BetweenColor(begin, end as Color, curve),
        EdgeInsets _ => _BetweenEdgeInsets(begin, end as EdgeInsets, curve),
        RelativeRect _ =>
          _BetweenRelativeRect(begin, end as RelativeRect, curve),
        AlignmentGeometry _ =>
          _BetweenAlignmentGeometry(begin, end as AlignmentGeometry, curve),
        Decoration _ => switch (begin) {
            BoxDecoration _ => begin.shape == (end as BoxDecoration).shape
                ? _BetweenBoxDecoration(begin, end, curve)
                : throw _errorUnimplement(begin, end),
            ShapeDecoration _ => switch (end) {
                ShapeDecoration _ => begin.shape == end.shape
                    ? _BetweenShapeDecoration(begin, end, curve)
                    : begin.isRounded && end.isRounded
                        ? _BetweenDecoration(begin, end, curve)
                        : throw _errorUnimplement(begin, end),
                _ => throw _errorUnimplement(begin.shape, end!),
              },
            _ => throw _errorUnimplement(begin, end!),
          },
        ShapeBorder _ => switch (begin) {
            BoxBorder _ => _BetweenBoxBorder(begin, end as BoxBorder, curve),
            InputBorder _ =>
              _BetweenShapeBorder(begin, end as InputBorder, curve),
            OutlinedBorder _ =>
              _BetweenOutlinedBorder(begin, end as OutlinedBorder, curve),
            _ => throw _errorUnimplement(begin, end!),
          },
        _ => throw _errorUnimplement(begin, end),
      } as Between<T>;

  static Error _errorUnimplement(Object? begin, Object? end) =>
      UnimplementedError('no implementation for lerp($begin, $end)');
}

///
///
/// [BetweenDepend.offsetArcOval], ...
/// [BetweenDepend.offsetBezierQuadratic], ...
/// [BetweenDepend.offsetBezierCubic], ...
/// [BetweenDepend.offsetCatmullRom], ...
///
class BetweenDepend<L> extends Between<L> {
  final L Function(double) onLerp;

  BetweenDepend(this.onLerp, {BiCurve? curve})
      : super._(onLerp(0), onLerp(1), curve);

  @override
  L transform(double t) => onLerp(t);

  /// arc
  static Offset Function(double value) offsetArcOval({
    required Offset origin,
    required Between<double> direction,
    required Between<double> radius,
  }) {
    final dOf = direction.transform;
    final rOf = radius.transform;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Offset Function(double value) offsetArcCircle({
    required Offset origin,
    required double radius,
    required Between<double> direction,
  }) =>
      offsetArcOval(
        origin: origin,
        direction: direction,
        radius: Between.of(radius),
      );

  static Offset Function(double value) offsetArcCircleSemi({
    required Offset begin,
    required Offset end,
    required bool clockwise,
  }) {
    if (begin == end) return (_) => begin;

    final center = begin * 0.5 + end * 0.5;
    final radianBegin = begin.direction - center.direction;
    final r = math.pi * (clockwise ? 1 : -1);
    final radius = (begin - end).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  /// bezier quadratic
  static Offset Function(double value) offsetBezierQuadratic({
    required Offset begin,
    required Offset end,
    required Offset controlPoint,
  }) {
    final vector1 = controlPoint - begin;
    final vector2 = end - controlPoint;
    return (t) {
      final a1 = begin + vector1 * t;
      final b1 = controlPoint + vector2 * t;
      return a1 + (b1 - a1) * t;
    };
  }

  static Offset Function(double value) offsetBezierQuadraticSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      offsetBezierQuadratic(
        begin: begin,
        end: end,
        controlPoint: (begin, end)._centerPerpendicularOf(dPerpendicular),
      );

  /// bezier cubic
  static Offset Function(double value) offsetBezierCubic({
    required Offset begin,
    required Offset end,
    required Offset c1,
    required Offset c2,
  }) {
    final vector1 = c1 - begin;
    final vector2 = c2 - c1;
    final vector3 = end - c2;
    return (t) {
      final o = c1 + vector2 * t;
      final a1 = begin + vector1 * t;
      final a2 = a1 + (o - a1) * t;
      final b1 = c2 + vector3 * t;
      final b2 = o + (b1 - o) * t;
      return a2 + (b2 - a2) * t;
    };
  }

  static Offset Function(double value) offsetBezierCubicSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return offsetBezierCubic(begin: begin, end: end, c1: s.$1, c2: s.$2);
  }

  /// catmull rom
  static Offset Function(double value) offsetCatmullRom({
    required List<Offset> controlPoints,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      CatmullRomSpline.precompute(
        controlPoints,
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      ).transform;

  static Offset Function(double value) offsetCatmullRomSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return offsetCatmullRom(
      controlPoints: [begin, end, s.$1, s.$2],
      tension: tension,
      startHandle: startHandle,
      endHandle: endHandle,
    );
  }

  ///
  ///
  ///
  static Rect _full(Size size) => Offset.zero & size;

  static Path Function(Size) Function(ShapeBorder) pathAdjustShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    Rect Function(Size size) sizingRect = _full,
  }) =>
      outerPath
          ? (shape) => (size) => shape.getOuterPath(
                sizingRect(size),
                textDirection: textDirection,
              )
          : (shape) => (size) => shape.getInnerPath(
                sizingRect(size),
                textDirection: textDirection,
              );
}

///
/// [_line]
/// [BetweenPath.line]
/// [BetweenPath.linePoly]
///
///
class BetweenPath extends BetweenDepend<Path> {
  BetweenPath(super.onLerp, {super.curve});

  BetweenPath.line(
    Offset begin,
    Offset end,
    double strokeWidth, {
    super.curve,
    StrokeCap strokeCap = StrokeCap.round,
  })  : assert(strokeCap != StrokeCap.square),
        super(_line(begin, end, strokeWidth, strokeCap));

  ///
  ///
  ///
  static const double _r90 = math.pi / 2;

  static Path Function(double) _line(
    Offset begin,
    Offset end,
    double width,
    StrokeCap cap,
  ) {
    final direction = math.atan2(end.dy - begin.dy, end.dx - begin.dx),
        dTop = direction - _r90,
        dBottom = direction + _r90,
        radius = Radius.circular(width),
        pTop = begin + Offset.fromDirection(dTop, width),
        pBottom = begin + Offset.fromDirection(dBottom, width),
        lerpTop = Between(
          begin: pTop,
          end: end + Offset.fromDirection(dTop, width),
        ).transform,
        lerpBottom = Between(
          begin: pBottom,
          end: end + Offset.fromDirection(dBottom, width),
        ).transform;

    // StrokeCap.round
    if (cap == StrokeCap.round) {
      final clockwise = direction.abs() < _r90,
          beginPath = Path()
            ..moveTo(pBottom.dx, pBottom.dy)
            ..arcToPoint(pTop, radius: radius, clockwise: clockwise);
      return (t) {
        final tTop = lerpTop(t);
        return Path.from(beginPath)
          ..lineTo(tTop.dx, tTop.dy)
          ..arcToPoint(lerpBottom(t), radius: radius, clockwise: clockwise)
          ..close();
      };
    }

    // StrokeCap.butt
    final beginPath = Path()
      ..moveTo(pBottom.dx, pBottom.dy)
      ..lineTo(pTop.dx, pTop.dy);
    return (t) {
      final tTop = lerpTop(t), tBottom = lerpBottom(t);
      return Path.from(beginPath)
        ..lineTo(tTop.dx, tTop.dy)
        ..lineTo(tBottom.dx, tBottom.dy)
        ..close();
    };
  }
}

///
///
///
abstract class Deviate<T> extends Matalue<T> {
  final T around;
  final T amplitude;

  const Deviate._(this.around, this.amplitude, super.curve);

  factory Deviate({required T around, required T amplitude, BiCurve? curve}) =>
      switch (around) {
        double _ => _DeviateDouble(around, amplitude as double, curve),
        Offset _ => _DeviateOffset(around, amplitude as Offset, curve),
        _ => throw UnimplementedError('$around, $amplitude, $curve'),
      } as Deviate<T>;

  static const double rRound = math.pi * 2;
}
