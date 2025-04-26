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
  final Lerper<T> onLerp;
  final CurveFR? curve;

  const Matalue({required this.onLerp, this.curve});

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _AnimationMatalue(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );

  ///
  ///
  ///
  static Matalue<double> doubleToRadian(Animatable<double> round) =>
      switch (round) {
        Between<double>() => Between(
            begin: Radian.fromRound(round.begin),
            end: Radian.fromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            from: Radian.fromRound(round.from),
            value: Radian.fromRound(round.value),
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
  static Lerper<T> lerperOf<T>(T begin, T end) => switch (begin) {
        double _ => DoubleExtension.lerp(begin, end as double),
        Point3 _ => Point3.lerp(begin, end as Point3),
        Point2 _ => Point2.lerp(begin, end as Point2),
        SizingPath _ => throw StateError('Plz use BetweenPath instead'),

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
      } as Lerper<T>;

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
  final int times;
  final Curving curving;

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
              curve: CurveFR.linear,
            ).transform;
            final curved = curving.transformInternal;
            return (t) => transform(curved(t));
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
  static Lerper<Offset> lerpArcOval({
    required Offset origin,
    required Between<double> direction,
    required Between<double> radius,
  }) {
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Lerper<Offset> lerpArcCircle({
    required Offset origin,
    required double radius,
    required Between<double> direction,
  }) =>
      lerpArcOval(
        origin: origin,
        direction: direction,
        radius: Between.of(radius),
      );

  static Lerper<Offset> lerpArcCircleSemi({
    required Offset begin,
    required Offset end,
    required bool clockwise,
  }) {
    if (begin == end) return (_) => begin;

    final center = begin.middleTo(end);
    final radianBegin = begin.direction - center.direction;
    final r = clockwise ? Radian.angle_180 : -Radian.angle_180;
    final radius = (begin - end).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  ///
  ///
  ///
  static Lerper<Offset> lerpBezierQuadratic({
    required Offset begin,
    required Offset end,
    required Offset controlPoint,
  }) {
    final vector1 = controlPoint - begin;
    final vector2 = end - controlPoint;
    return (t) => OffsetExtension.parallelOffsetOf(
          begin + vector1 * t,
          controlPoint + vector2 * t,
          t,
        );
  }

  static Lerper<Offset> lerpBezierQuadraticSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      lerpBezierQuadratic(
        begin: begin,
        end: end,
        controlPoint: OffsetExtension.perpendicularOffsetUnitFromCenterOf(
          begin,
          end,
          dPerpendicular,
        ),
      );

  /// bezier cubic
  static Lerper<Offset> lerpBezierCubic({
    required Offset begin,
    required Offset end,
    required Offset c1,
    required Offset c2,
  }) {
    final vector1 = c1 - begin;
    final vector2 = c2 - c1;
    final vector3 = end - c2;
    return (t) {
      final middle = c1 + vector2 * t;
      return OffsetExtension.parallelOffsetOf(
        OffsetExtension.parallelOffsetOf(begin + vector1 * t, middle, t),
        OffsetExtension.parallelOffsetOf(middle, c2 + vector3 * t, t),
        t,
      );
    };
  }

  static Lerper<Offset> lerpBezierCubicSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return lerpBezierCubic(begin: begin, end: end, c1: list[1], c2: list[2]);
  }

  ///
  ///
  ///
  static Lerper<Offset> lerpCatmullRom({
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

  static Lerper<Offset> lerpCatmullRomSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      lerpCatmullRom(
        controlPoints: [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

///
///
///
class BetweenPath<T> extends Between<SizingPath> {
  final Mapper<T, SizingPath> onAnimate;

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

  static Lerper<SizingPath> _animateOf<T>(
    Mapper<T, SizingPath> onAnimate,
    Lerper<T> onLerp,
  ) =>
      (t) => onAnimate(onLerp(t));

  static Mapper<ShapeBorder, SizingPath> onAnimateShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) {
    final shaping = outerPath
        ? (s) => FSizingPath.shapeBorderOuter(s, sizingRect, textDirection)
        : (s) => FSizingPath.shapeBorderInner(s, sizingRect, textDirection);
    return (shape) => shaping(shape);
  }
}
