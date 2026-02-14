part of '../mationani.dart';

///
/// .
///     --[Deviate]
///     |   | [_DeviateDouble], [_DeviateOffset]
///     |
/// * [Matalue] * [_AnimationMatalue]
///     |
///     --[Between]
///         | [_BetweenConstant]
///         | [_BetweenDouble], [_BetweenDoubleDouble], [_BetweenDoubleDoubleDouble]
///         | [_BetweenSize], [_BetweenRect], [_BetweenColor]
///         | [_BetweenEdgeInsets], [_BetweenRelativeRect], [_BetweenAlignmentGeometry]
///         | [_BetweenDecoration], [_BetweenBoxDecoration], [_BetweenShapeDecoration]
///         | [_BetweenBoxBorder], [_BetweenShapeBorder], [_BetweenOutlinedBorder]
///         |
///         --[BetweenSpline2D]
///         --[BetweenPath]
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

typedef BiCurve = (Curve, Curve);

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
        // Deviate<double>() => Deviate(
        //     around: round.around * _radian_angle360,
        //     amplitude: round.amplitude * _radian_angle360,
        //     curve: round.curve,
        //   ),
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

class _BetweenConstant<T> extends Between<T> {
  const _BetweenConstant(T value, [BiCurve? curve])
      : super._(value, value, curve);

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
        b2 = begin.$1,
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

///
///
///
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
abstract class BetweenDepend<L> extends Between<L> {
  final L Function(double) onLerp;

  BetweenDepend({required this.onLerp, BiCurve? curve})
      : super._(onLerp(0), onLerp(1), curve);

  @override
  L transform(double t) => onLerp(t);
}

///
/// static methods:
/// [BetweenSpline2D.lerpArcOval], ...
/// [BetweenSpline2D.lerpBezierQuadratic], ...
/// [BetweenSpline2D.lerpBezierCubic], ...
/// [BetweenSpline2D.lerpCatmullRom], ...
///
class BetweenSpline2D extends BetweenDepend<Offset> {
  BetweenSpline2D({required super.onLerp, super.curve});

  ///
  ///
  ///
  static Offset Function(double value) lerpArcOval({
    required Offset origin,
    required Between<double> direction,
    required Between<double> radius,
  }) {
    final dOf = direction.transform;
    final rOf = radius.transform;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Offset Function(double value) lerpArcCircle({
    required Offset origin,
    required double radius,
    required Between<double> direction,
  }) =>
      lerpArcOval(
        origin: origin,
        direction: direction,
        radius: Between.of(radius),
      );

  static Offset Function(double value) lerpArcCircleSemi({
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

  ///
  ///
  ///
  static Offset Function(double value) lerpBezierQuadratic({
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

  static Offset Function(double value) lerpBezierQuadraticSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      lerpBezierQuadratic(
        begin: begin,
        end: end,
        controlPoint: (begin, end)._centerPerpendicularOf(dPerpendicular),
      );

  /// bezier cubic
  static Offset Function(double value) lerpBezierCubic({
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

  static Offset Function(double value) lerpBezierCubicSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return lerpBezierCubic(begin: begin, end: end, c1: s.$1, c2: s.$2);
  }

  ///
  ///
  ///
  static Offset Function(double value) lerpCatmullRom({
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

  static Offset Function(double value) lerpCatmullRomSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return lerpCatmullRom(
      controlPoints: [begin, end, s.$1, s.$2],
      tension: tension,
      startHandle: startHandle,
      endHandle: endHandle,
    );
  }
}

///
///
///
class BetweenPath<T> extends BetweenDepend<Path Function(Size size)> {
  final Path Function(Size size) Function(T value) onAnimate;

  BetweenPath.fixed({
    required super.onLerp,
    required this.onAnimate,
    super.curve,
  }) : super();

  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super(onLerp: _animateOf(onAnimate, between.transform));

  static Path Function(Size size) Function(double value) _animateOf<T>(
    Path Function(Size size) Function(T value) onAnimate,
    T Function(double value) onLerp,
  ) =>
      (t) => onAnimate(onLerp(t));

  static Rect _full(Size size) => Offset.zero & size;

  static Path Function(Size size) Function(ShapeBorder border)
      onAnimateShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    Rect Function(Size size) sizingRect = _full,
  }) {
    final shaping = outerPath
        ? (ShapeBorder shape) => (size) => shape.getOuterPath(
              sizingRect(size),
              textDirection: textDirection,
            )
        : (ShapeBorder shape) => (size) => shape.getInnerPath(
              sizingRect(size),
              textDirection: textDirection,
            );
    return (shape) => shaping(shape);
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

class _DeviateDouble extends Deviate<double> {
  const _DeviateDouble(super.around, super.amplitude, super.curve) : super._();

  @override
  double transform(double t) =>
      around + amplitude * math.sin(Deviate.rRound * t);
}

class _DeviateOffset extends Deviate<Offset> {
  const _DeviateOffset(super.around, super.amplitude, super.curve) : super._();

  @override
  Offset transform(double t) =>
      around + amplitude * math.sin(Deviate.rRound * t);
}
