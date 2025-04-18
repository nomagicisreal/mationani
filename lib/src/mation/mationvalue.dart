///
///
/// this file contains:
///
/// [_Mationvalue]
/// [Mationvalue]
///
/// [Between]
///   --[BetweenSpline2D]
///   --[BetweenPath]
///   |   --[BetweenPathOffset]
///   |   --[BetweenPathVector3D]
///   |   --[_BetweenPathConcurrent]
///   |       --[BetweenPathPolygon]
///   |
///
///
/// [Amplitude]
///
/// [BetweenInterval]
/// [BetweenConcurrent]
///
/// extensions:
/// [MationvalueDoubleExtension]
/// [BetweenOffsetExtension]
///
///
///
part of '../../mationani.dart';

///
/// [_Mationvalue], [Mationvalue]
///
class _Mationvalue<T> extends Animation<T>
    with AnimationWithParentMixin<double> {
  _Mationvalue(this.parent, this.animatable);

  @override
  final Animation<double> parent;

  final Mationvalue<T> animatable;

  @override
  T get value => animatable.evaluate(parent);
}

///
/// [onLerp], [curve],
/// [transform], [evaluate], [animate],
///
sealed class Mationvalue<T> extends Animatable<T> {
  final Lerper<T> onLerp;
  final CurveFR? curve;

  const Mationvalue({required this.onLerp, this.curve});

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _Mationvalue(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );
}

///
/// [begin], [end],
/// [Between.constant], [Between.of], [Between.sequence], [Between.sequenceFromGenerator], ...
/// [reverse], [follow], [followOperate], ..., [toString]
///
class Between<T> extends Mationvalue<T> {
  final T begin;
  final T end;

  Between(this.begin, this.end, {super.curve})
      : super(onLerp: lerperFrom(begin, end));

  const Between.constant(
    this.begin,
    this.end, {
    required super.onLerp,
    required super.curve,
  });

  Between.of(T value)
      : begin = value,
        end = value,
        super(onLerp: DoubleExtension.lerperOf(value));

  Between.sequence({
    BetweenInterval weight = BetweenInterval.linear,
    super.curve,
    required List<T> steps,
  })  : begin = steps.first,
        end = steps.last,
        super(
          onLerp: BetweenInterval._link(
            totalStep: steps.length,
            step: (i) => steps[i],
            interval: (i) => weight,
          ),
        );

  Between.sequenceFromGenerator({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    super.curve,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  })  : begin = step(0),
        end = step(totalStep - 1),
        super(
          onLerp: BetweenInterval._link(
            totalStep: totalStep,
            step: step,
            interval: interval,
            sequencer: sequencer,
          ),
        );

  Between.outAndBack({
    required this.begin,
    required T target,
    super.curve = CurveFR.linear,
    double ratio = 1.0,
    Curve curveOut = Curves.fastOutSlowIn,
    Curve curveBack = Curves.fastOutSlowIn,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  })  : end = begin,
        super(
          onLerp: BetweenInterval._link(
            totalStep: 3,
            step: (i) => i == 1 ? target : begin,
            interval: (i) => i == 0
                ? BetweenInterval(ratio, curve: curveOut)
                : BetweenInterval(1 / ratio, curve: curveBack),
            sequencer: sequencer,
          ),
        );

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  /// properties
  ///
  Between<T> get reverse => Between.constant(
        end,
        begin,
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> follow(T next) => Between.constant(
        end,
        next,
        onLerp: onLerp,
        curve: curve,
      );
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
    required super.onLerp,
    super.curve,
  }) : super.constant(onLerp(0), onLerp(1));

  static Lerper<Offset> lerpArcOval(
    Offset origin,
    Between<double> direction,
    Between<double> radius,
  ) {
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Lerper<Offset> lerpArcCircle(
    Offset origin,
    double radius,
    Between<double> direction,
  ) =>
      lerpArcOval(origin, direction, Between.of(radius));

  static Lerper<Offset> lerpArcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return DoubleExtension.lerperOf(a);
    }

    final center = a.middleTo(b);
    final radianBegin = a.direction - center.direction;
    final r = clockwise ? Radian.angle_180 : -Radian.angle_180;
    final radius = (a - b).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  ///
  /// bezier quadratic
  ///
  static Lerper<Offset> lerpBezierQuadratic(
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

  static Lerper<Offset> lerpBezierQuadraticSymmetry(
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
  static Lerper<Offset> lerpBezierCubic(
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

  static Lerper<Offset> lerpBezierCubicSymmetry(
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
  static Lerper<Offset> lerpCatmullRom(
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

  static Lerper<Offset> lerpCatmullRomSymmetry(
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
    required super.onLerp,
    super.curve,
  }) : super.constant();

  ///
  /// because [end] is called before [onLerp]. no matter [end] is set to
  /// "onAnimate(1, between.end)", "onAnimate(0, between.end)" or "onAnimate(1, between.begin)",
  /// it causes ambiguous [onLerp] for the child of [BetweenPath]
  ///
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super.constant(
          onAnimate(0, between.begin),
          onAnimate(0, between.begin),
          onLerp: animateOf(onAnimate, between.onLerp),
        );

  static Lerper<SizingPath> animateOf<T>(
    OnAnimatePath<T> onAnimate,
    Lerper<T> onLerp,
  ) =>
      (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> animateShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) {
    final shaping = outerPath
        ? (s) => FSizingPath.shapeBorderOuter(s, sizingRect, textDirection)
        : (s) => FSizingPath.shapeBorderInner(s, sizingRect, textDirection);
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
    Offset topOf(Offset p) => p.direct(direction - Radian.angle_90, r);
    Offset bottomOf(Offset p) => p.direct(direction + Radian.angle_90, r);
    final oTop = topOf(o);
    final oBottom = bottomOf(o);

    final radius = Radius.circular(r);
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

  // 'width' means stoke width
  BetweenPathOffset.line(
    super.between,
    double width, {
    super.curve,
    StrokeCap strokeCap = StrokeCap.round,
  })  : assert(strokeCap == StrokeCap.round),
        super(onAnimate: animateStadiumLine(between, width));

  // 'width' means stoke width
  factory BetweenPathOffset.linePoly(
    double width, {
    required List<Offset> nodes,
    CurveFR? curve,
  }) {
    final length = nodes.length;
    final intervals = List.generate(length, (index) => (index + 1) / length);
    final between = Between.sequence(steps: nodes, curve: curve);

    int i = 0;
    double bound = intervals[i];
    OnAnimatePath<Offset> lining(Offset a, Offset b) =>
        animateStadium(a, b.direction - a.direction, width);
    OnAnimatePath<Offset> drawing = lining(nodes[0], nodes[1]);
    SizingPath draw = FSizingPath.circle(nodes[0], width);

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
class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
  _BetweenPathConcurrent(BetweenConcurrent<T, SizingPath> concurrent)
      : super._(
          concurrent.begins,
          concurrent.ends,
          onLerp: concurrent.onLerps,
          onAnimate: concurrent.onAnimate,
        );

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
//           Vector3D(Point3.zero, radiusOrbit.begin),
//           Vector3D(KRadianPoint3.angleZ_360, radiusOrbit.end),
//         ),
//         onAnimate: (t, vector) => FSizingPath.combineAll(
//           Iterable.generate(
//             circleCount,
//             (i) => (size) => Path()
//               ..addOval(
//                 Rect.fromCircle(
//                   center: planetGenerator(vector, i).toPoint3,
//                   radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
//                 ),
//               ),
//           ),
//         ),
//       );
}

//
class BetweenPathPolygon extends _BetweenPathConcurrent<double> {
  BetweenPathPolygon.regularCubicOnEdge({
    required RRegularPolygonCubicOnEdge polygon,
    Between<double>? scale,
    Between<double>? edgeVectorTimes,
    Mapper<RRegularPolygonCubicOnEdge, Between<double>>? cornerRadius,
    CurveFR? curve,
  }) : super(
          BetweenConcurrent(
            betweens: [
              cornerRadius?.call(polygon) ?? Between.of(0.0),
              edgeVectorTimes ?? Between.of(0.0),
              scale ?? Between.of(1.0),
            ],
            onAnimate: (t, values) => FSizingPath.polygonCubic(
              polygon.cubicPointsFrom(values[0], values[1]),
              scale: values[2],
              adjust: polygon.cornerAdjust,
            ),
            curve: curve,
          ),
        );
}

enum AmplitudeStyle {
  sin,
  cos,
  tan;
}

//
class Amplitude<T> extends Mationvalue<T> {
  final T from;
  final T value;
  final int times;
  final AmplitudeStyle style;

  const Amplitude.constant(
    this.from,
    this.value,
    this.times, {
    required this.style,
    required super.onLerp,
    super.curve,
  });

  Amplitude(
    this.from,
    this.value,
    this.times, {
    required this.style,
    super.curve,
  }) : super(onLerp: () {
          final transform = Between(from, value).transform;
          final curved = switch (style) {
            AmplitudeStyle.sin => Curving.sinPeriodOf(times),
            AmplitudeStyle.cos ||
            AmplitudeStyle.tan =>
              throw UnimplementedError(),
          }
              .transformInternal;

          return (t) => transform(curved(t));
        }());
}

///
///
///
/// [BetweenInterval], [BetweenConcurrent]
///
///
///

///
/// See Also:
///   * [AniSequence], which is similar
///   * [AniSequenceInterval], which is similar
///

//
class BetweenInterval {
  final double weight;
  final Curve curve;

  Lerper<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = lerperFrom<T>(a, b);
    return (t) => onLerp(curving(t));
  }

  const BetweenInterval(this.weight, {this.curve = Curves.linear});

  ///
  ///
  ///
  static const BetweenInterval linear = BetweenInterval(1);

  ///
  ///
  /// the index 0 of [interval] is between index 0 and 1 of [step]
  /// the index 1 of [interval] is between index 1 and 2 of [step], and so on.
  ///
  ///
  static Lerper<T> _link<T>({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  }) {
    final seq = sequencer ?? _sequencer<T>;
    var i = -1;
    return TweenSequence(
      step.linkToListTill(
        totalStep,
        interval,
        (previous, next, interval) => TweenSequenceItem<T>(
          tween: seq(previous, next, interval.lerp(previous, next))(++i),
          weight: interval.weight,
        ),
      ),
    ).transform;
  }

  static Mapper<int, Between<T>> _sequencer<T>(
    T previous,
    T next,
    Lerper<T> onLerp,
  ) =>
      (_) => Between.constant(
            previous,
            next,
            onLerp: onLerp,
            curve: null,
          );
}

class BetweenConcurrent<T, S> {
  final S begins;
  final S ends;
  final Lerper<S> onLerps;
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
    final onLerps = <Lerper<T>>[];
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

///
/// extensions
///
extension MationvalueDoubleExtension on Mationvalue<double> {
  static Mationvalue<double> toRadianFrom(Mationvalue<double> round) =>
      switch (round) {
        Between<double>() => Between(
            Radian.fromRound(round.begin),
            Radian.fromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            Radian.fromRound(round.from),
            Radian.fromRound(round.value),
            round.times,
            style: round.style,
            curve: round.curve,
          ),
      };
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => end.direction - begin.direction;
}
