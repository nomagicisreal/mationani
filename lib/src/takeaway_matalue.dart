part of '../api.dart';

///
///
/// * [BetweenPathOffset]
///
/// * [BetweenConcurrent]
///
/// * [BetweenOffsetExtension]
///
/// * [FMatalue]
///
///

///
/// [animateStadium], [animateStadiumLine]
///
/// [BetweenPathOffset.line]
/// [BetweenPathOffset.linePoly]
/// [BetweenPathOffset.linePolyFromGenerator]
///
///
class BetweenPathOffset extends BetweenPath<Offset> {
  BetweenPathOffset._(super.between, {
    required super.onAnimate,
    super.curve,
  });

  static OnAnimatePath<Offset> animateStadium(Offset o, double direction,
      double r) {
    Offset topOf(Offset p) => p.direct(direction - Radian.angle_90, r);
    Offset bottomOf(Offset p) => p.direct(direction + Radian.angle_90, r);
    final oTop = topOf(o);
    final oBottom = bottomOf(o);

    final radius = Radius.circular(r);
    return (t, current) =>
        (size) =>
    Path()
      ..arcFromStartToEnd(oBottom, oTop, radius: radius)
      ..lineToPoint(topOf(current))
      ..arcToPoint(bottomOf(current), radius: radius)
      ..lineToPoint(oBottom);
  }

  static OnAnimatePath<Offset> animateStadiumLine(Between<Offset> between,
      double w) =>
      animateStadium(between.begin, between.direction, w);

  ///
  /// constructor, factories
  ///

  // 'width' means stoke width
  BetweenPathOffset.line(super.between,
      double width, {
        super.curve,
        StrokeCap strokeCap = StrokeCap.round,
      })
      : assert(strokeCap == StrokeCap.round),
        super(onAnimate: animateStadiumLine(between, width));

  // 'width' means stoke width
  factory BetweenPathOffset.linePoly(double width, {
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

  factory BetweenPathOffset.linePolyFromGenerator(double width, {
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



// class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
//   BetweenPathVector3D.progressingCircles({
//     double initialCircleRadius = 5.0,
//     double circleRadiusFactor = 0.1,
//     required AniUpdateIfNotAnimating setting,
//     required Paint paint,
//     required Between<double> radiusOrbit,
//     required int circleCount,
//     required Companion<Vector3D, int> planetGenerator,
//   }) : this(
//     Between<Vector3D>(
//       Vector3D(Point3.zero, radiusOrbit.begin),
//       Vector3D(KRadianPoint3.angleZ_360, radiusOrbit.end),
//     ),
//     onAnimate: (t, vector) =>
//         FSizingPath.combineAll(
//           Iterable.generate(
//             circleCount,
//                 (i) =>
//                 (size) =>
//             Path()
//               ..addOval(
//                 Rect.fromCircle(
//                   center: planetGenerator(vector, i).toPoint3,
//                   radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
//                 ),
//               ),
//           ),
//         ),
//   );
// }
//
// class BetweenPathPolygon extends _BetweenPathConcurrent<double> {
//   BetweenPathPolygon.regularCubicOnEdge({
//     required RRegularPolygonCubicOnEdge polygon,
//     Between<double>? scale,
//     Between<double>? edgeVectorTimes,
//     Mapper<RRegularPolygonCubicOnEdge, Between<double>>? cornerRadius,
//     CurveFR? curve,
//   }) : super(
//     BetweenConcurrent(
//       betweens: [
//         cornerRadius?.call(polygon) ?? Between.of(0.0),
//         edgeVectorTimes ?? Between.of(0.0),
//         scale ?? Between.of(1.0),
//       ],
//       onAnimate: (t, values) =>
//           FSizingPath.polygonCubic(
//             polygon.cubicPointsFrom(values[0], values[1]),
//             scale: values[2],
//             adjust: polygon.cornerAdjust,
//           ),
//       curve: curve,
//     ),
//   );
// }

///
///
///
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
///
///
extension BetweenOffsetExtension on Between<Offset> {
  double get direction => end.direction - begin.direction;
}

///
/// [between_double_0From], ...
/// [between_offset_0From], ...
/// [between_point3_0From], ...
/// [between_radian3_0From], ...
///
/// [amplitude_double_0From], ...
/// [amplitude_offset_0From], ...
/// [amplitude_point3_0From], ...
/// [amplitude_radian3_0From], ...
///
abstract final class FMatalue {
  ///
  ///
  ///
  static Between<double> between_double_0From(double begin, {CurveFR? curve}) =>
      Between(begin, 0, curve: curve);

  static Between<double> between_double_0To(double end, {CurveFR? curve}) =>
      Between(0, end, curve: curve);

  static Between<double> between_double_1From(double begin, {CurveFR? curve}) =>
      Between(begin, 1, curve: curve);

  static Between<double> between_double_1To(double end, {CurveFR? curve}) =>
      Between(1, end, curve: curve);

  ///
  ///
  ///
  static Between<Offset> between_offset_0From(Offset begin, {CurveFR? curve}) =>
      Between(begin, Offset.zero, curve: curve);

  static Between<Offset> offset_0To(Offset end, {CurveFR? curve}) =>
      Between(Offset.zero, end, curve: curve);

  static Between<Offset> between_offset_ofDirection(double direction,
      double begin, double end,
      {CurveFR? curve}) =>
      Between(
        Offset.fromDirection(direction, begin),
        Offset.fromDirection(direction, end),
        curve: curve,
      );

  static Between<Offset> between_offset_ofDirection0From(double direction,
      double begin, {
        CurveFR? curve,
      }) =>
      between_offset_ofDirection(direction, begin, 0, curve: curve);

  static Between<Offset> between_offset_ofDirection0To(double direction,
      double end, {
        CurveFR? curve,
      }) =>
      between_offset_ofDirection(direction, 0, end, curve: curve);

  ///
  ///
  ///
  static Between<Point3> between_point3_0From(Point3 begin, {CurveFR? curve}) =>
      Between<Point3>(begin, Point3.zero, curve: curve);

  static Between<Point3> between_point3_0To(Point3 end, {CurveFR? curve}) =>
      Between<Point3>(Point3.zero, end, curve: curve);

  ///
  ///
  ///
  static Between<Radian3> between_radian3_0From(Radian3 begin, {
    CurveFR? curve,
  }) =>
      Between<Radian3>(begin, Radian3.zero, curve: curve);

  static Between<Radian3> between_radian3_0To(Radian3 end, {CurveFR? curve}) =>
      Between<Radian3>(Radian3.zero, end, curve: curve);

  ///
  ///
  ///
  static Amplitude<double> amplitude_sin_double_0From(double begin,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(begin, 0.0, times, curving: Curving.sinPeriodOf(times));

  static Amplitude<double> amplitude_sin_double_0To(double end,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(0, end, times, curving: Curving.sinPeriodOf(times));

  static Amplitude<double> amplitude_sin_double_1To(double end,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(1, end, times, curving: Curving.sinPeriodOf(times));

  ///
  ///
  ///
  static Amplitude<Offset> amplitude_sin_offset_0From(Offset begin,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(begin, Offset.zero, times, curving: Curving.sinPeriodOf(times));

  static Amplitude<Offset> amplitude_sin_offset_0To(Offset end,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(Offset.zero, end, times, curving: Curving.sinPeriodOf(times));

  ///
  ///
  ///
  static Amplitude<Point3> amplitude_sin_point3_0From(Point3 begin,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(begin, Point3.zero, times, curving: Curving.sinPeriodOf(times));

  static Amplitude<Point3> amplitude_sin_point3_0To(Point3 end,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(Point3.zero, end, times, curving: Curving.sinPeriodOf(times));

  ///
  ///
  ///
  static Amplitude<Radian3> amplitude_sin_radian3_0From(Radian3 begin,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(
        begin,
        Radian3.zero,
        times,
        curving: Curving.sinPeriodOf(times),
      );

  static Amplitude<Radian3> amplitude_sin_radian3_0To(Radian3 end,
      int times, {
        CurveFR? curve,
      }) =>
      Amplitude(Radian3.zero, end, times, curving: Curving.sinPeriodOf(times));
}
