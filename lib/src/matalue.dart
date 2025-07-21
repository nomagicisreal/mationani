part of '../mationani.dart';

///
/// .
///     --[Amplitude]
///     |
/// * [Matalue] * [_AnimationMatalue]
///     |
///     --[Between]
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

sealed class Matalue<T> extends Animatable<T> {
  final T Function(double value) onLerp;
  final (Curve, Curve)? curve;

  const Matalue({required this.onLerp, this.curve});

  @override
  T transform(double t) => onLerp(t);

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
        Amplitude<double>() => Amplitude(
            from: round.from * _radian_angle360,
            value: round.value * _radian_angle360,
            times: round.times,
            curving: round.curving,
            curve: round.curve,
          ),
        Animatable<double>() => throw UnimplementedError(),
      };
}

///
/// [begin], [end],
/// [Between.constant], [Between.of], [Between.sequence], [Between.sequenceFromGenerator], ...
/// [reverse], [follow], [followOperate], ..., [toString]
///
class Between<T> extends Matalue<T> {
  final T begin;
  final T end;

  Between({required this.begin, required this.end, super.curve})
      : super(onLerp: lerperOf(begin, end));

  const Between.constant({
    required this.begin,
    required this.end,
    required super.onLerp,
    required super.curve,
  });

  Between.of(T value)
      : begin = value,
        end = value,
        super(onLerp: (_) => value);

  ///
  ///
  ///
  @override
  String toString() => 'Between($begin, $end, $curve)';

  Between<T> get reverse =>
      Between.constant(begin: end, end: begin, onLerp: onLerp, curve: curve);

  Between<T> follow(T next) =>
      Between.constant(begin: end, end: next, onLerp: onLerp, curve: curve);

  ///
  ///
  ///
  static T Function(double value) lerperOf<T>(T begin, T end) =>
      switch (begin) {
        double _ => () {
            end as double;
            return (t) => begin * (1.0 - t) + end * t;
          }(),
        (double, double) _ => () {
            end as (double, double);
            final p1 = begin.$1;
            final p2 = begin.$1;
            final q1 = end.$1;
            final q2 = end.$2;
            return (t) => (p1 * (1.0 - t) + q1 * t, p2 * (1.0 - t) + q2 * t);
          }(),
        (double, double, double) _ => () {
            end as (double, double, double);
            final p1 = begin.$1;
            final p2 = begin.$1;
            final p3 = begin.$3;
            final q1 = end.$1;
            final q2 = end.$2;
            final q3 = end.$3;
            return (t) => (
                  p1 * (1.0 - t) + q1 * t,
                  p2 * (1.0 - t) + q2 * t,
                  p3 * (1.0 - t) + q3 * t
                );
          }(),
        Path Function(Size size) _ =>
          throw StateError('Plz use BetweenPath instead'),

        ///
        ///
        ///
        Size _ => (t) => Size.lerp(begin, end as Size, t)!,
        Rect _ => (t) => Rect.lerp(begin, end as Rect, t)!,
        Color _ => (t) => Color.lerp(begin, end as Color, t)!,
        EdgeInsets _ => (t) => EdgeInsets.lerp(begin, end as EdgeInsets?, t)!,
        RelativeRect _ => (t) =>
            RelativeRect.lerp(begin, end as RelativeRect?, t)!,
        AlignmentGeometry _ => (t) =>
            AlignmentGeometry.lerp(begin, end as AlignmentGeometry?, t)!,
        Decoration _ => switch (begin) {
            BoxDecoration _ => begin.shape == (end as BoxDecoration).shape
                ? (t) => BoxDecoration.lerp(begin, end, t)!
                : _errorUnimplement_lerp(begin, end),
            ShapeDecoration _ => switch (end) {
                ShapeDecoration _ => begin.shape == end.shape
                    ? (t) => ShapeDecoration.lerp(begin, end, t)!
                    : begin.isRounded && end.isRounded
                        ? (t) => Decoration.lerp(begin, end, t)!
                        : _errorUnimplement_lerp(begin, end),
                _ => _errorUnimplement_lerp(begin.shape, end!),
              },
            _ => _errorUnimplement_lerp(begin, end!),
          },
        ShapeBorder _ => switch (begin) {
            BoxBorder _ => (t) => BoxBorder.lerp(begin, end as BoxBorder, t)!,
            InputBorder _ => (t) =>
                ShapeBorder.lerp(begin, end as InputBorder, t)!,
            OutlinedBorder _ => (t) =>
                OutlinedBorder.lerp(begin, end as OutlinedBorder, t)!,
            _ => _errorUnimplement_lerp(begin, end!),
          },
        _ => Tween<T>(begin: begin, end: end).transform,
      } as T Function(double value);

  static void _errorUnimplement_lerp(Object begin, Object end) =>
      throw UnimplementedError(
        'do you know how to define the lerper from $begin to $end ?',
      );
}

///
///
///
class Amplitude<T> extends Matalue<T> {
  final T from;
  final T value;
  final double times;
  final double Function(double value) curving;

  const Amplitude.constant({
    required this.from,
    required this.value,
    required this.times,
    required this.curving,
    required super.onLerp,
    super.curve,
  });

  Amplitude({
    required this.from,
    required this.value,
    required this.times,
    required this.curving,
    super.curve,
  }) : super(
          onLerp: () {
            final transform = Between(
              begin: from,
              end: value,
              curve: (Curves.linear, Curves.linear),
            ).transform;
            return (t) => transform(curving(t));
          }(),
        );
}

///
/// static methods:
/// [BetweenSpline2D.lerpArcOval], ...
/// [BetweenSpline2D.lerpBezierQuadratic], ...
/// [BetweenSpline2D.lerpBezierCubic], ...
/// [BetweenSpline2D.lerpCatmullRom], ...
///
class BetweenSpline2D extends Between<Offset> {
  BetweenSpline2D({
    required super.onLerp,
    super.curve,
  }) : super.constant(begin: onLerp(0), end: onLerp(1));

  ///
  ///
  ///
  static Offset Function(double value) lerpArcOval({
    required Offset origin,
    required Between<double> direction,
    required Between<double> radius,
  }) {
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
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
class BetweenPath<T> extends Between<Path Function(Size size)> {
  final Path Function(Size size) Function(T value) onAnimate;

  const BetweenPath.constant({
    required super.begin,
    required super.end,
    required this.onAnimate,
    required super.onLerp,
    super.curve,
  }) : super.constant();

  // notice that if between.begin == between.end, the animation won't be triggered
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super.constant(
          begin: onAnimate(between.begin),
          end: onAnimate(between.end),
          onLerp: _animateOf(onAnimate, between.onLerp),
        );

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
