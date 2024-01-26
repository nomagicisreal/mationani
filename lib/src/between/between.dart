///
///
/// this file contains:
/// [Between]
///   --[BetweenSpline2D]
///   --[BetweenPath]
///   |   [BetweenPathOffset]
///   |   [BetweenPathVector3D]
///   |   * [_BetweenPathConcurrent]
///   |   [BetweenPathPolygon]
///   ...
///
///
///
/// [BetweenInterval]
/// [BetweenConcurrent]
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
/// [Between] is my implementation for [Tween.animate],
/// which aims to have an easier way to enable beautiful animation for [_MationAnimatable] in [Mationani]
///
/// [Between.constant]
/// [Between.of]
/// [Between.sequenceFromGenerator], ...
///
/// [begin], [end], [onLerp], [curve],
/// [transform], [evaluate], [animate], [toString]
///
/// [reverse]
/// [follow], [followPlus], ...
///
class Between<T> extends Animatable<T> {
  ///
  /// constructors
  ///
  Between(this.begin, this.end, {OnLerp<T>? onLerp, this.curve})
      : onLerp = onLerp ?? _of(begin, end);

  const Between.constant(this.begin, this.end, this.onLerp, this.curve);

  Between.of(T value)
      : begin = value,
        end = value,
        curve = null,
        onLerp = _constant(value);

  Between.sequence({
    required List<T> steps,
    this.curve,
  })  : begin = steps.first,
        end = steps.last,
        onLerp = BetweenInterval._linking(
          totalStep: steps.length,
          step: (i) => steps[i],
          interval: (i) => const BetweenInterval(1),
        );

  Between.sequenceFromGenerator({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    this.curve,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : begin = step(0),
        end = step(totalStep - 1),
        onLerp = BetweenInterval._linking(
          totalStep: totalStep,
          step: step,
          interval: interval,
          sequencer: sequencer,
        );

  Between.outAndBack({
    required this.begin,
    required T target,
    this.curve = KCurveFR.linear,
    double ratio = 1.0,
    Curve curveOut = Curves.fastOutSlowIn,
    Curve curveBack = Curves.fastOutSlowIn,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : end = begin,
        onLerp = BetweenInterval._linking(
          totalStep: 3,
          step: (i) => i == 1 ? target : begin,
          interval: (i) => i == 0
              ? BetweenInterval(ratio, curve: curveOut)
              : BetweenInterval(1 / ratio, curve: curveBack),
          sequencer: sequencer,
        );

  final T begin;
  final T end;
  final OnLerp<T> onLerp;
  final CurveFR? curve;

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _BetweenAnimation(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  /// properties
  /// - [reverse]
  /// - [follow]
  /// - [followPlus]
  /// - [followMinus]
  /// - [followMultiply]
  /// - [followDivide]
  ///
  ///

  Between<T> get reverse => Between(
        end,
        begin,
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> follow(T next) => Between(
        end,
        next,
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followPlus(T next) => Between(
        end,
        Operator.plus.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followMinus(T next) => Between(
        end,
        Operator.minus.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followMultiply(T next) => Between(
        end,
        Operator.multiply.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followDivide(T next) => Between(
        end,
        Operator.divide.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  ///
  ///
  /// lerp
  ///
  ///

  static OnLerp<T> _constant<T>(T value) => (_) => value;

  ///
  ///
  /// See Also
  ///   * [Decoration]
  ///   * [FSizingPath.shapeBorder]
  ///
  ///
  static OnLerp<T> _of<T>(T a, T b) => switch (a) {
        Size _ => (t) => Size.lerp(a, b as Size, t)!,
        Rect _ => (t) => Rect.lerp(a, b as Rect, t)!,
        Color _ => (t) => Color.lerp(a, b as Color, t)!,
        Vector3D _ => (t) => Vector3D.lerp(a, b as Vector3D, t),
        EdgeInsets _ => (t) => EdgeInsets.lerp(a, b as EdgeInsets?, t)!,
        Decoration _ => switch (a) {
            BoxDecoration _ => b is BoxDecoration && a.shape == b.shape
                ? (t) => BoxDecoration.lerp(a, b, t)!
                : throw UnimplementedError(
                    'BoxShape should not be interpolated'),
            ShapeDecoration _ => switch (b) {
                ShapeDecoration _ => a.shape == b.shape
                    ? (t) => ShapeDecoration.lerp(a, b, t)!
                    : switch (a.shape) {
                        CircleBorder _ || RoundedRectangleBorder _ => switch (
                              b.shape) {
                            CircleBorder _ || RoundedRectangleBorder _ => (t) =>
                                Decoration.lerp(a, b, t)!,
                            _ => throw UnimplementedError(
                                "'$a shouldn't be interpolated to $b'",
                              ),
                          },
                        _ => throw UnimplementedError(
                            "'$a shouldn't be interpolated to $b'",
                          ),
                      },
                _ => throw UnimplementedError(),
              },
            _ => throw UnimplementedError(),
          },
        ShapeBorder _ => switch (a) {
            BoxBorder _ => switch (b) {
                BoxBorder _ => (t) => BoxBorder.lerp(a, b, t)!,
                _ => throw UnimplementedError(),
              },
            InputBorder _ => switch (b) {
                InputBorder _ => (t) => ShapeBorder.lerp(a, b, t)!,
                _ => throw UnimplementedError(),
              },
            OutlinedBorder _ => switch (b) {
                OutlinedBorder _ => (t) => OutlinedBorder.lerp(a, b, t)!,
                _ => throw UnimplementedError(),
              },
            _ => throw UnimplementedError(),
          },
        RelativeRect _ => (t) => RelativeRect.lerp(a, b as RelativeRect?, t)!,
        AlignmentGeometry _ => (t) =>
            AlignmentGeometry.lerp(a, b as AlignmentGeometry?, t)!,
        SizingPath _ => throw ArgumentError(
            'using BetweenPath constructor instead of Between<SizingPath>',
          ),
        _ => Tween<T>(begin: a, end: b).transform,
      } as OnLerp<T>;
}

///
/// [BetweenSpline2D.lerpArcOval]
/// [BetweenSpline2D.lerpArcCircleSemi]
/// [BetweenSpline2D.lerpBezierQuadratic]
/// [BetweenSpline2D.lerpBezierQuadraticSymmetry]
/// [BetweenSpline2D.lerpBezierCubic]
/// [BetweenSpline2D.lerpBezierCubicSymmetry]
/// [BetweenSpline2D.lerpCatmullRom]
/// [BetweenSpline2D.lerpCatmullRomSymmetry]
///
class BetweenSpline2D extends Between<Offset> {
  BetweenSpline2D({
    required OnLerp<Offset> super.onLerp,
    super.curve,
  }) : super(onLerp(0), onLerp(1));

  static OnLerp<Offset> lerpArcOval(
    Offset origin,
    Between<double> direction,
    Between<double> radius,
  ) {
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static OnLerp<Offset> lerpArcCircle(
    Offset origin,
    double radius,
    Between<double> direction,
  ) =>
      lerpArcOval(origin, direction, Between.of(radius));

  static OnLerp<Offset> lerpArcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return Between._constant(a);
    }

    final center = a.middleWith(b);
    final radianBegin = center.directionTo(a);
    final r = clockwise ? KRadian.angle_180 : -KRadian.angle_180;
    final radius = (a - b).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  ///
  /// bezier quadratic
  ///
  static OnLerp<Offset> lerpBezierQuadratic(
    Offset begin,
    Offset end,
    Offset controlPoint,
  ) {
    final vector1 = controlPoint - begin;
    final vector2 = end - controlPoint;
    return (t) => OffsetExtension.parallelOffsetOf(
          begin + vector1 * t,
          controlPoint + vector2 * t,
          t,
        );
  }

  static OnLerp<Offset> lerpBezierQuadraticSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      lerpBezierQuadratic(
        begin,
        end,
        OffsetExtension.perpendicularOffsetUnitFromCenterOf(
          begin,
          end,
          dPerpendicular,
        ),
      );

  /// bezier cubic
  static OnLerp<Offset> lerpBezierCubic(
    Offset begin,
    Offset end, {
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

  static OnLerp<Offset> lerpBezierCubicSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return lerpBezierCubic(begin, end, c1: list[1], c2: list[2]);
  }

  ///
  /// catmullRom
  ///
  static OnLerp<Offset> lerpCatmullRom(
    List<Offset> controlPoints, {
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

  static OnLerp<Offset> lerpCatmullRomSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      lerpCatmullRom(
        [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

///
///
/// between path
///
class BetweenPath<T> extends Between<SizingPath> {
  final OnAnimatePath<T> onAnimate;

  BetweenPath._(
    super.begin,
    super.end, {
    required this.onAnimate,
    super.onLerp,
    super.curve,
  });

  ///
  /// because [end] is called before [onLerp]. no matter [end] is set to
  /// "onAnimate(1, between.end)", "onAnimate(0, between.end)" or "onAnimate(1, between.begin)",
  /// it causes ambiguous [onLerp] for the child of [BetweenPath]
  ///
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super(
          onAnimate(0, between.begin),
          onAnimate(0, between.begin),
          onLerp: animateOf(onAnimate, between.onLerp),
        );

  static OnLerp<SizingPath> animateOf<T>(
    OnAnimatePath<T> onAnimate,
    OnLerp<T> onLerp,
  ) =>
      (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> animateShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) {
    final shaping = outerPath
        ? (s) => FSizingPath._shapeBorderOuter(s, sizingRect, textDirection)
        : (s) => FSizingPath._shapeBorderInner(s, sizingRect, textDirection);
    return (t, shape) => shaping(shape);
  }
}

///
/// [animateStadium], [animateStadiumLine]
///
/// [BetweenPathOffset.line]
/// [BetweenPathOffset.linePoly]
/// [BetweenPathOffset.linePolyFromGenerator]
///
///
class BetweenPathOffset extends BetweenPath<Offset> {
  BetweenPathOffset._(
    super.between, {
    required super.onAnimate,
    super.curve,
  });

  static OnAnimatePath<Offset> animateStadium(
      Offset o, double direction, double r) {
    Offset topOf(Offset p) => p.direct(direction - KRadian.angle_90, r);
    Offset bottomOf(Offset p) => p.direct(direction + KRadian.angle_90, r);
    final oTop = topOf(o);
    final oBottom = bottomOf(o);

    final radius = r.toCircularRadius;
    return (t, current) => (size) => Path()
      ..arcFromStartToEnd(oBottom, oTop, radius: radius)
      ..lineToPoint(topOf(current))
      ..arcToPoint(bottomOf(current), radius: radius)
      ..lineToPoint(oBottom);
  }

  static OnAnimatePath<Offset> animateStadiumLine(
          Between<Offset> between, double w) =>
      animateStadium(between.begin, between.direction, w);

  ///
  /// constructor, factories
  ///
  BetweenPathOffset.line(
    super.between,
    double width, {
    super.curve,
    StrokeCap strokeCap = StrokeCap.round,
  })  : assert(strokeCap == StrokeCap.round),
        super(onAnimate: animateStadiumLine(between, width));

  factory BetweenPathOffset.linePoly(
    double r, {
    required List<Offset> nodes,
    CurveFR? curve,
  }) {
    final length = nodes.length;
    final intervals = List.generate(length, (index) => (index + 1) / length);
    final between = Between.sequence(steps: nodes, curve: curve);

    int i = 0;
    double bound = intervals[i];
    OnAnimatePath<Offset> lining(Offset a, Offset b) =>
        animateStadium(a, a.directionTo(b), r);
    OnAnimatePath<Offset> drawing = lining(nodes[0], nodes[1]);
    SizingPath draw = FSizingPath.circle(nodes[0], r);

    return BetweenPathOffset._(
      between,
      onAnimate: (t, current) {
        if (t > bound) {
          i++;
          bound = intervals[i];
          drawing = i == length - 1 ? drawing : lining(nodes[i], nodes[i + 1]);
        }
        draw = draw.combine(drawing(t, current));
        return draw;
      },
      curve: curve,
    );
  }

  factory BetweenPathOffset.linePolyFromGenerator(
    double width, {
    required int totalStep,
    required Generator<Offset> step,
    required Generator<BetweenInterval> interval,
    CurveFR? curve,
  }) {
    // final offset = Between.sequenceFromGenerator(
    //   totalStep: totalStep,
    //   step: step,
    //   interval: interval,
    //   curve: curve,
    // );
    throw UnimplementedError();
  }
}

//
class BetweenPathVector3D extends BetweenPath<Vector3D> {
  BetweenPathVector3D(
    super.between, {
    required super.onAnimate,
    super.curve,
  });

// BetweenPathVector3D.progressingCircles({
//   double initialCircleRadius = 5.0,
//   double circleRadiusFactor = 0.1,
//   required AniUpdateIfNotAnimating setting,
//   required Paint paint,
//   required Between<double> radiusOrbit,
//   required int circleCount,
//   required Companion<Vector3D, int> planetGenerator,
// }) : this(
//         Between<Vector3D>(
//           Vector3D(Coordinate.zero, radiusOrbit.begin),
//           Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end),
//         ),
//         onAnimate: (t, vector) => FSizingPath.combineAll(
//           Iterable.generate(
//             circleCount,
//             (i) => (size) => Path()
//               ..addOval(
//                 Rect.fromCircle(
//                   center: planetGenerator(vector, i).toCoordinate,
//                   radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
//                 ),
//               ),
//           ),
//         ),
//       );
}

//
class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
  _BetweenPathConcurrent(BetweenConcurrent<T, SizingPath> concurrent)
      : super._(
          concurrent.begins,
          concurrent.ends,
          onLerp: concurrent.onLerps,
          onAnimate: concurrent.onAnimate,
        );
}

//
class BetweenPathPolygon extends _BetweenPathConcurrent<double> {
  BetweenPathPolygon.regularCubicOnEdge({
    required RRegularPolygonCubicOnEdge polygon,
    Between<double>? scale,
    Between<double>? edgeVectorTimes,
    Translator<RRegularPolygonCubicOnEdge, Between<double>>? cornerRadius,
    CurveFR? curve,
  }) : super(
          BetweenConcurrent(
            betweens: [
              cornerRadius?.call(polygon) ?? FBetween.doubleKZero,
              edgeVectorTimes ?? FBetween.doubleKZero,
              scale ?? FBetween.doubleKOne,
            ],
            onAnimate: (t, values) => FSizingPath.polygonCubic(
              polygon.cubicPointsOf(values[0], values[1]),
              scale: values[2],
              adjust: polygon.cornerAdjust,
            ),
            curve: curve,
          ),
        );
}

///
///
///
///
///
/// See Also:
///   [AniSequenceInterval], which is similar
///
class BetweenInterval {
  final double weight;
  final Curve curve;

  const BetweenInterval(this.weight, {this.curve = Curves.fastOutSlowIn});

  OnLerp<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = Between._of<T>(a, b);
    return (t) => onLerp(curving(t));
  }

  ///
  ///
  /// the index 0 of [interval] is between index 0 and 1 of [step]
  /// the index 1 of [interval] is between index 1 and 2 of [step], and so on.
  ///
  ///
  static OnLerp<T> _linking<T>({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  }) {
    final seq = sequencer ?? _sequencer<T>;
    return TweenSequence(
        ListExtension.linking<TweenSequenceItem<T>, T, BetweenInterval>(
      totalStep: totalStep,
      step: step,
      interval: interval,
      sequencer: (previous, next, interval) => (index) => TweenSequenceItem(
            tween: seq(previous, next, interval.lerp(previous, next))(index),
            weight: interval.weight,
          ),
    )).transform;
  }

  static Translator<int, Between<T>> _sequencer<T>(
    T previous,
    T next,
    OnLerp<T> onLerp,
  ) =>
      (_) => Between(
            previous,
            next,
            onLerp: onLerp,
          );
}

class BetweenConcurrent<T, S> {
  final S begins;
  final S ends;
  final OnLerp<S> onLerps;
  final OnAnimate<List<T>, S> onAnimate;

  const BetweenConcurrent._({
    required this.begins,
    required this.ends,
    required this.onLerps,
    required this.onAnimate,
  });

  factory BetweenConcurrent({
    required List<Between<T>> betweens,
    required OnAnimate<List<T>, S> onAnimate,
    CurveFR? curve,
  }) {
    final begins = <T>[];
    final ends = <T>[];
    final onLerps = <OnLerp<T>>[];
    for (var tween in betweens) {
      begins.add(tween.begin);
      ends.add(tween.end);
      onLerps.add(tween.onLerp);
    }

    return BetweenConcurrent._(
      begins: onAnimate(0, begins),
      ends: onAnimate(0, ends),
      onLerps: (t) {
        final values = <T>[];
        for (var onLerp in onLerps) {
          values.add(onLerp(t));
        }
        return onAnimate(t, values);
      },
      onAnimate: onAnimate,
    );
  }
}
