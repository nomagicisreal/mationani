part of '../mationani.dart';

///
/// this file contains:
/// for special typedef:
/// [FSizingPath]
/// [FSizingRect]
/// [FSizingOffset]
/// [FSizingPaintFromCanvas]
///
/// [FRectBuilder]
///
/// [FOnLerpSpline2D], [FOnAnimatePath]
///
/// [FPredicatorNum]
///
/// [FMapper], [FMapperDouble], [FMapperBoxConstraints]
/// [FGenerator], [FGeneratorOffset], [FGeneratorRadius]
/// [FTranslator]
///
/// for values:
/// [FRadian], [FRadianCoordinate]
///
/// [FStream]
///
/// [FBoxShadow]
/// [FBorderSide], [FBorderBox], [FBorderOutlined], [FBorderInput]
/// [FDecorationBox], [FDecorationShape], [FDecorationInput]
///
///
///
///
///
///
///

///
/// instance methods
/// [difference], [intersect], [union], [xor], [reverseDifference]
///
///
/// static methods:
/// [of], [combineAll]
/// [lineTo], ..., [bezierQuadratic], [bezierCubic], ...
///
/// [rect], ...
/// [rRect], ...
/// [oval], ..., [circle]
/// [polygon], ...
/// [shapeBorder]
///
/// [pie], [pieOfLeftRight], ...
/// [finger], [crayon], [trapeziumSymmetry]
/// ...
///
///
///
///
extension FSizingPath on SizingPath {
  SizingPath difference(SizingPath another) =>
      PathOperation.difference._combine(this, another);

  SizingPath intersect(SizingPath another) =>
      PathOperation.intersect._combine(this, another);

  SizingPath union(SizingPath another) =>
      PathOperation.union._combine(this, another);

  SizingPath xor(SizingPath another) =>
      PathOperation.xor._combine(this, another);

  SizingPath reverseDifference(SizingPath another) =>
      PathOperation.reverseDifference._combine(this, another);

  static SizingPath of(Path value) => (_) => value;

  static SizingPath combineAll(
    PathOperation operation,
    Iterable<SizingPath> iterable,
  ) =>
      operation._combineAll(iterable);

  ///
  ///
  /// line
  ///
  ///
  static SizingPath lineTo(Offset point) => (_) => Path()..lineToPoint(point);

  static SizingPath connect(Offset a, Offset b) =>
      (size) => Path()..lineFromAToB(a, b);

  static SizingPath connectAll({
    Offset begin = Offset.zero,
    required Iterable<Offset> points,
    PathFillType pathFillType = PathFillType.nonZero,
  }) =>
      (size) => Path()
        ..lineFromAToAll(begin, points)
        ..fillType = pathFillType;

  static SizingPath lineToFromSize(SizingOffset point) =>
      (size) => Path()..lineToPoint(point(size));

  static SizingPath connectFromSize(
    SizingOffset a,
    SizingOffset b,
  ) =>
      (size) => Path()..lineFromAToB(a(size), b(size));

  static SizingPath connectAllFromSize({
    SizingOffset begin = FSizingOffset.zero,
    required SizingOffsetIterable points,
    PathFillType pathFillType = PathFillType.nonZero,
  }) =>
      (size) => Path()
        ..lineFromAToAll(begin(size), points(size))
        ..fillType = pathFillType;

  static SizingPath bezierQuadratic(
    Offset controlPoint,
    Offset end, {
    Offset begin = Offset.zero,
  }) =>
      begin == Offset.zero
          ? (size) => Path()..quadraticBezierToPoint(controlPoint, end)
          : (size) => Path()
            ..moveToPoint(begin)
            ..quadraticBezierToPoint(controlPoint, end);

  static SizingPath bezierCubic(
    Offset c1,
    Offset c2,
    Offset end, {
    Offset begin = Offset.zero,
  }) =>
      begin == Offset.zero
          ? (size) => Path()..cubicToPoint(c1, c2, end)
          : (size) => Path()
            ..moveToPoint(begin)
            ..cubicToPoint(c1, c2, end);

  ///
  /// rect
  ///
  static SizingPath get rectFullSize =>
      (size) => Path()..addRect(Offset.zero & size);

  static SizingPath rect(Rect rect) => (size) => Path()..addRect(rect);

  static SizingPath rectFromZeroToSize(Size size) =>
      (_) => Path()..addRect(Offset.zero & size);

  static SizingPath rectFromZeroToOffset(Offset offset) =>
      (size) => Path()..addRect(Rect.fromPoints(Offset.zero, offset));

  ///
  /// rRect
  ///
  static SizingPath rRect(RRect rRect) => (size) => Path()..addRRect(rRect);

  ///
  /// oval
  ///
  static SizingPath oval(Rect rect) => (size) => Path()..addOval(rect);

  static SizingPath ovalFromCenterSize(Offset center, Size size) =>
      oval(RectExtension.fromCenterSize(center, size));

  static SizingPath circle(Offset center, double radius) =>
      oval(RectExtension.fromCircle(center, radius));

  ///
  /// polygon
  ///
  /// [polygon], [polygonFromSize]
  /// [polygonCubic], [polygonCubicFromSize]
  ///
  /// 1. see [RegularPolygon.cornersOf] to create corners of regular polygon
  /// 2. [polygonCubic.cornersCubic] should be the cubic points related to polygon corners in clockwise or counterclockwise sequence
  /// every element list of [cornersCubic] will be treated as [beginPoint, controlPointA, controlPointB, endPoint]
  /// see [RRegularPolygon.cubicPoints] and its subclasses for creating [cornersCubic]
  ///
  ///
  static SizingPath polygon(List<Offset> corners) =>
      (size) => Path()..addPolygon(corners, false);

  static SizingPath polygonFromSize(SizingOffsetList corners) =>
      (size) => Path()..addPolygon(corners(size), false);

  static SizingPath _polygonCubic(
    Iterable<Iterable<Offset>> points,
    double scale, {
    Companion<Iterable<Offset>, Size>? adjust,
  }) {
    final scaling = IterableOffsetExtension.scalingMapper(scale);

    Path from(Iterable<Iterable<Offset>> offsets) => offsets
        .map((points) => scaling(points).toList(growable: false))
        .foldWithIndex(
          Path(),
          (path, points, index) => path
            ..moveOrLineToPoint(points[0], index == 0)
            ..cubicToPointsList(points.sublist(1)),
        )..close();

    return adjust == null
        ? (size) => from(points)
        : (size) => from(points.map((points) => adjust(points, size)));
  }

  static SizingPath polygonCubic(
    Iterable<List<Offset>> cornersCubic, {
    double scale = 1,
  }) =>
      _polygonCubic(cornersCubic, scale);

  static SizingPath polygonCubicFromSize(
    Iterable<List<Offset>> cornersCubic, {
    double scale = 1,
    Companion<Iterable<Offset>, Size> adjust =
        IterableOffsetExtension.adjustCenterCompanion,
  }) =>
      _polygonCubic(cornersCubic, scale, adjust: adjust);

  ///
  /// shape border
  ///
  static SizingPath _shapeBorderOuter(
    ShapeBorder shape,
    SizingRect sizingRect,
    TextDirection? textDirection,
  ) =>
      (size) => shape.getOuterPath(
            sizingRect(size),
            textDirection: textDirection,
          );

  static SizingPath _shapeBorderInner(
    ShapeBorder shape,
    SizingRect sizingRect,
    TextDirection? textDirection,
  ) =>
      (size) => shape.getInnerPath(
            sizingRect(size),
            textDirection: textDirection,
          );

  static SizingPath shapeBorder(
    ShapeBorder shape, {
    TextDirection? textDirection,
    bool outerPath = true,
    SizingRect sizingRect = FSizingRect.full,
  }) =>
      outerPath
          ? _shapeBorderOuter(shape, sizingRect, textDirection)
          : _shapeBorderInner(shape, sizingRect, textDirection);

  ///
  /// [pie]
  /// [pieFromCenterDirectionRadius]
  /// [pieFromSize]
  /// [pieOfLeftRight]
  ///
  static SizingPath pie(
    Offset arcStart,
    Offset arcEnd, {
    bool clockwise = true,
  }) {
    final radius = arcEnd.distanceHalfTo(arcStart).toCircularRadius;
    return (size) => Path()
      ..arcFromStartToEnd(arcStart, arcEnd,
          radius: radius, clockwise: clockwise)
      ..close();
  }

  static SizingPath pieFromSize({
    required SizingOffset arcStart,
    required SizingOffset arcEnd,
    bool clockwise = true,
  }) =>
      (size) {
        final start = arcStart(size);
        final end = arcEnd(size);
        return Path()
          ..moveToPoint(start)
          ..arcToPoint(
            end,
            radius: end.distanceHalfTo(start).toCircularRadius,
            clockwise: clockwise,
          )
          ..close();
      };

  static SizingPath pieOfLeftRight(bool isRight) => isRight
      ? FSizingPath.pieFromSize(
          arcStart: (size) => Offset.zero,
          arcEnd: (size) => size.bottomLeft(Offset.zero),
          clockwise: true,
        )
      : FSizingPath.pieFromSize(
          arcStart: (size) => size.topRight(Offset.zero),
          arcEnd: (size) => size.bottomRight(Offset.zero),
          clockwise: false,
        );

  static SizingPath pieFromCenterDirectionRadius(
    Offset arcCenter,
    double dStart,
    double dEnd,
    double r, {
    bool clockwise = true,
  }) {
    final arcStart = arcCenter.direct(dStart, r);
    final arcEnd = arcCenter.direct(dEnd, r);
    return (size) => Path()
      ..moveToPoint(arcStart)
      ..arcToPoint(arcEnd, radius: r.toCircularRadius, clockwise: clockwise)
      ..close();
  }

  ///
  /// finger
  ///
  ///  ( )
  /// (   )  <---- [tip]
  /// |   |
  /// |   |
  /// |   |
  /// -----  <----[root]
  ///
  static SizingPath finger({
    required Offset rootA,
    required double width,
    required double length,
    required double direction,
    bool clockwise = true,
  }) {
    final tipA = rootA.direct(direction, length);
    final rootB = rootA.direct(
      direction + KRadian.angle_90 * (clockwise ? 1 : -1),
      width,
    );
    final tipB = rootB.direct(direction, length);
    final radius = (width / 2).toCircularRadius;
    return (size) => Path()
      ..moveToPoint(rootA)
      ..lineToPoint(tipA)
      ..arcToPoint(tipB, radius: radius, clockwise: clockwise)
      ..lineToPoint(rootB)
      ..close();
  }

  /// crayon
  ///
  /// -----
  /// |   |
  /// |   |   <----[bodyLength]
  /// |   |
  /// \   /
  ///  ---   <---- [tipWidth]
  ///
  static SizingPath crayon({
    required SizingDouble tipWidth,
    required SizingDouble bodyLength,
  }) =>
      (size) {
        final width = size.width;
        final height = size.height;
        final flatLength = tipWidth(size);
        final penBody = bodyLength(size);

        return Path()
          ..lineTo(width, 0.0)
          ..lineTo(width, penBody)
          ..lineTo((width + flatLength) / 2, height)
          ..lineTo((width - flatLength) / 2, height)
          ..lineTo(0.0, penBody)
          ..lineTo(0.0, 0.0)
          ..close();
      };

  static SizingPath trapeziumSymmetry({
    required SizingOffset topLeftMargin,
    required Mapper<Size> body,
    required SizingDouble bodyShortest,
    Direction2DIn4 shortestSide = Direction2DIn4.top,
  }) =>
      (size) {
        // final origin = topLeftMargin(size);
        // final bodySize = body(size);
        throw UnimplementedError();
      };
}

extension FSizingRect on SizingRect {
  static Rect full(Size size) => Offset.zero & size;

  static SizingRect fullFrom(Offset origin) => (size) => origin & size;
}

extension FSizingOffset on SizingOffset {
  static SizingOffset of(Offset value) => (_) => value;

  static Offset zero(Size size) => Offset.zero;

  static Offset topLeft(Size size) => size.topLeft(Offset.zero);

  static Offset topCenter(Size size) => size.topCenter(Offset.zero);

  static Offset topRight(Size size) => size.topRight(Offset.zero);

  static Offset centerLeft(Size size) => size.centerLeft(Offset.zero);

  static Offset center(Size size) => size.center(Offset.zero);

  static Offset centerRight(Size size) => size.centerRight(Offset.zero);

  static Offset bottomLeft(Size size) => size.bottomLeft(Offset.zero);

  static Offset bottomCenter(Size size) => size.bottomCenter(Offset.zero);

  static Offset bottomRight(Size size) => size.bottomRight(Offset.zero);
}

extension FSizingPaintFromCanvas on SizingPaintFromCanvas {
  static SizingPaintFromCanvas of(Paint paint) => (_, __) => paint;

  static Paint whiteFill(Canvas canvas, Size size) => VPaintFill.white;

  static Paint redFill(Canvas canvas, Size size) => VPaintFill.red;
}

extension FRectBuilder on RectBuilder {
  static RectBuilder get zero => (context) => Rect.zero;

  ///
  /// rect
  ///
  static RectBuilder get rectZeroToFull =>
      (context) => Offset.zero & context.mediaSize;

  static RectBuilder rectZeroToSize(Sizing sizing) =>
      (context) => Offset.zero & sizing(context.mediaSize);

  static RectBuilder rectOffsetToSize(
    SizingOffset positioning,
    Sizing sizing,
  ) =>
      (context) {
        final size = context.mediaSize;
        return positioning(size) & sizing(size);
      };

  ///
  /// circle
  ///
  static RectBuilder get circleZeroToFull => (context) =>
      RectExtension.fromCircle(Offset.zero, context.mediaSize.diagonal);

  static RectBuilder circleZeroToRadius(SizingDouble sizing) =>
      (context) => RectExtension.fromCircle(
            Offset.zero,
            sizing(context.mediaSize),
          );

  static RectBuilder circleOffsetToSize(
    SizingOffset positioning,
    SizingDouble sizing,
  ) =>
      (context) {
        final size = context.mediaSize;
        return RectExtension.fromCircle(positioning(size), sizing(size));
      };

  ///
  /// oval
  ///
  static RectBuilder get ovalZeroToFull =>
      (context) => RectExtension.fromCenterSize(Offset.zero, context.mediaSize);

  static RectBuilder ovalZeroToSize(Sizing sizing) =>
      (context) => RectExtension.fromCenterSize(
            Offset.zero,
            sizing(context.mediaSize),
          );

  static RectBuilder ovalOffsetToSize(
    SizingOffset positioning,
    Sizing sizing,
  ) =>
      (context) {
        final size = context.mediaSize;
        return RectExtension.fromCenterSize(positioning(size), sizing(size));
      };
}

///
///
/// [FOnLerpSpline2D.arcOval]
/// [FOnLerpSpline2D.arcCircleSemi]
/// [FOnLerpSpline2D.bezierQuadratic]
/// [FOnLerpSpline2D.bezierQuadraticSymmetry]
/// [FOnLerpSpline2D.bezierCubic]
/// [FOnLerpSpline2D.bezierCubicSymmetry]
/// [FOnLerpSpline2D.catmullRom]
/// [FOnLerpSpline2D.catmullRomSymmetry]
///
/// See Also:
///   * [BetweenSpline2D]
///
///
extension FOnLerpSpline2D on OnLerp<Offset> {
  static OnLerp<Offset> arcOval(
    Offset origin,
    Between<double> direction,
    Between<double> radius,
  ) {
    final dOf = direction._onLerp;
    final rOf = radius._onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static OnLerp<Offset> arcCircle(
    Offset origin,
    double radius,
    Between<double> direction,
  ) =>
      FOnLerpSpline2D.arcOval(origin, direction, Between.constant(radius));

  static OnLerp<Offset> arcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return _FOnLerp.constant(a);
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
  static OnLerp<Offset> bezierQuadratic(
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

  static OnLerp<Offset> bezierQuadraticSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      bezierQuadratic(
        begin,
        end,
        OffsetExtension.perpendicularOffsetUnitFromCenterOf(
          begin,
          end,
          dPerpendicular,
        ),
      );

  /// bezier cubic
  static OnLerp<Offset> bezierCubic(
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

  static OnLerp<Offset> bezierCubicSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return bezierCubic(begin, end, c1: list[1], c2: list[2]);
  }

  ///
  /// catmullRom
  ///
  static OnLerp<Offset> catmullRom(
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

  static OnLerp<Offset> catmullRomSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      catmullRom(
        [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

extension FOnAnimatePath on OnAnimatePath {
  static OnAnimatePath<Offset> stadium(Offset o, double direction, double r) {
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

  static OnAnimatePath<Offset> lineStadium(Between<Offset> between, double w) =>
      stadium(between.begin, between.direction, w);

  static OnLerp<SizingPath> of<T>(
    OnAnimatePath<T> onAnimate,
    OnLerp<T> onLerp,
  ) =>
      (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> shapeBorder({
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
///
/// predicator
///
///

extension FPredicatorNum on Predicator<num> {
  static bool isALess(num a, num b) => a < b;

  static bool isALarger(num a, num b) => a > b;

  static bool isEntryKeyLess<T>(MapEntry<num, T> a, MapEntry<num, T> b) =>
      a.key < b.key;

  static bool isEntryKeyLarger<T>(MapEntry<num, T> a, MapEntry<num, T> b) =>
      a.key > b.key;
}

extension FPredicatorCombiner on Combiner {
  static bool alwaysTrue<T>(T a, T? b) => true;

  static bool alwaysFalse<T>(T a, T? b) => false;

  static bool equal(bool a, bool? b) => a == b;

  static bool unequal(bool a, bool? b) => a != b;

  static bool intEqual(int a, int? b) => a == b;

  static bool intBigger(int a, int? b) => b != null && a > b;

  static bool intSmaller(int a, int? b) => b != null && a < b;
}

extension FPredicatorTernaryCombiner on Combiner {
  static bool? alwaysTrue<T>(T a, T? b) => true;

  static bool? alwaysFalse<T>(T a, T? b) => false;

  static bool? alwaysNull<T>(T a, T? b) => null;

  static bool? intEqualOrSmallerOrBigger(int? a, int? b) =>
      b == null || a == null
          ? null
          : switch (a - b) {
              0 => true,
              < 0 => false,
              _ => null,
            };
}

///
///
/// mapper
///
///

extension FMapper on Mapper {
  static T keep<T>(T value) => value;

  static Offset offset(Offset v) => v;

  static Iterable<Offset> ofOffsetIterable(Iterable<Offset> v) => v;

  static Coordinate ofCoordinate(Coordinate v) => v;

  static Size ofSize(Size v) => v;

  static Curve ofCurve(Curve v) => v;

  static Curve ofCurveFlipped(Curve v) => v.flipped;
}

extension FMapperDouble on Mapper<double> {
  static double of(double v) => v;

  static double zero(double value) => 0;

  static double keep(double value) => value;

  ///
  /// operate
  ///
  static Mapper<double> plus(double value) => (v) => v + value;

  static Mapper<double> minus(double value) => (v) => v - value;

  static Mapper<double> multiply(double value) => (v) => v * value;

  static Mapper<double> divide(double value) => (v) => v / value;

  static Mapper<double> operate(Operator operator, double value) =>
      operator.doubleCompanion(value);

  ///
  /// sin
  ///
  static Mapper<double> sinFromFactor(double timeFactor, double factor) =>
      (value) => math.sin(timeFactor * value) * factor;

  // return "times of period" of (0 ~ 1 ~ 0 ~ -1 ~ 0)
  static Mapper<double> sinFromPeriod(double times) {
    final tween = Tween(
      begin: 0.0,
      end: switch (times) {
        double.infinity || double.negativeInfinity => throw UnimplementedError(
            'instead of times infinity, pls use [Ani] to repeat animation',
          ),
        _ => KRadian.angle_360 * times,
      },
    );
    return (value) => math.sin(tween.transform(value));
  }
}

extension FMapperBoxConstraints on BoxConstraints {
  static BoxConstraints loosen(BoxConstraints constraints) =>
      constraints.loosen();
}

///
///
///
///
///
/// generator
///
///
///
///
///

extension FGenerator on Generator {
  static Generator<T> fill<T>(T value) => (i) => value;
}

extension FGeneratorOffset on Generator<Offset> {
  static Generator<Offset> withValue(
    double value,
    Offset Function(int index, double value) generator,
  ) =>
      (index) => generator(index, value);

  static Generator<Offset> leftRightLeftRight(
    double dX,
    double dY, {
    required Offset topLeft,
    required Offset Function(int line, double dX, double dY) left,
    required Offset Function(int line, double dX, double dY) right,
  }) =>
      (i) {
        final indexLine = i ~/ 2;
        return topLeft +
            (i % 2 == 0 ? left(indexLine, dX, dY) : right(indexLine, dX, dY));
      };

  static Generator<Offset> grouping2({
    required double dX,
    required double dY,
    required int modulusX,
    required int modulusY,
    required double constantX,
    required double constantY,
    required double group2ConstantX,
    required double group2ConstantY,
    required int group2ThresholdX,
    required int group2ThresholdY,
  }) =>
      (index) => Offset(
            constantX +
                (index % modulusX) * dX +
                (index > group2ThresholdX ? group2ConstantX : 0),
            constantY +
                (index % modulusY) * dY +
                (index > group2ThresholdY ? group2ConstantY : 0),
          );

  static Generator<Offset> topBottomStyle1(double group2ConstantY) => grouping2(
        dX: 78,
        dY: 12,
        modulusX: 6,
        modulusY: 24,
        constantX: -25,
        constantY: -60,
        group2ConstantX: 0,
        group2ConstantY: group2ConstantY,
        group2ThresholdX: 0,
        group2ThresholdY: 11,
      );
}

///
/// radius
///
extension FGeneratorRadius on List<Radius> {
  static List<Radius> circular(int n, double radius) =>
      List.generate(n, (index) => Radius.circular(radius));
}

///
/// translator
///
extension FTranslator on Translator {
  static Translator<int, bool> oddOrEvenCheckerAs(int value) =>
      value.isOdd ? (v) => v.isOdd : (v) => v.isEven;

  static Translator<int, bool> oddOrEvenCheckerOpposite(int value) =>
      value.isOdd ? (v) => v.isEven : (v) => v.isOdd;
}

///
///
///
///
///
///
///
/// for values
///
///
///
///
///
///
///
///

extension FRadian on double {
  static double modulus1Round(double radian) => radian % KRadian.angle_360;

  static double angleOf(double radian) => radian / KRadian.angle_1;

  static double radianOf(double angle) => angle * KRadian.angle_1;

  static double complementaryOf(double radian) {
    assert(radian >= 0 && radian <= KRadian.angle_90);
    return radianOf(90 - angleOf(radian));
  }

  static double supplementaryOf(double radian) {
    assert(radian >= 0 && radian <= KRadian.angle_180);
    return radianOf(180 - angleOf(radian));
  }

  static double restrictWithinAngle180_180N(double radian) {
    final r = radian % 360;
    return r >= KRadian.angle_180 ? r - KRadian.angle_360 : r;
  }

  ///
  /// if
  ///
  static bool ifWithinAngle90_90N(double radian) =>
      radian.abs() < KRadian.angle_90;

  static bool ifOverAngle90_90N(double radian) =>
      radian.abs() > KRadian.angle_90;

  static bool ifWithinAngle0_180(double radian) =>
      radian > 0 && radian < KRadian.angle_180;

  static bool ifWithinAngle0_180N(double radian) =>
      radian > -KRadian.angle_180 && radian < 0;

  static bool ifOnRight(double radian) =>
      ifWithinAngle90_90N(modulus1Round(radian));

  static bool ifOnLeft(double radian) =>
      ifOverAngle90_90N(modulus1Round(radian));

  static bool ifOnTop(
    double radian, {
    bool isInMathDiscussion = false,
  }) {
    final r = modulus1Round(radian);
    return isInMathDiscussion ? ifWithinAngle0_180(r) : ifWithinAngle0_180N(r);
  }

  static bool ifOnBottom(
    double radian, {
    bool isInMathDiscussion = false,
  }) {
    final r = modulus1Round(radian);
    return isInMathDiscussion ? ifWithinAngle0_180N(r) : ifWithinAngle0_180(r);
  }
}

extension FRadianCoordinate on Coordinate {
  static Coordinate complementaryOf(Coordinate radian) => Coordinate(
        FRadian.complementaryOf(radian.dx),
        FRadian.complementaryOf(radian.dy),
        FRadian.complementaryOf(radian.dz),
      );

  static Coordinate supplementaryOf(Coordinate radian) => Coordinate(
        FRadian.supplementaryOf(radian.dx),
        FRadian.supplementaryOf(radian.dy),
        FRadian.supplementaryOf(radian.dz),
      );

  static Coordinate restrictInAngle180Of(Coordinate radian) => Coordinate(
        FRadian.restrictWithinAngle180_180N(radian.dx),
        FRadian.restrictWithinAngle180_180N(radian.dy),
        FRadian.restrictWithinAngle180_180N(radian.dz),
      );
}

///
///
///
///
/// stream
///
///
///
///

extension FStream on Stream {
  static Stream<T> generateFromIterable<T>(
    int count, {
    Generator<T>? generator,
  }) =>
      Stream.fromIterable(Iterable.generate(count, generator));

  static Stream<int> intOf({
    int start = 1,
    int end = 10,
    Duration interval = KDuration.second1,
    bool startWithDelay = true,
  }) async* {
    Future<int> yielding(int value) async =>
        Future.delayed(interval).then((_) => value);

    Future<void> delay() async =>
        startWithDelay ? Future.delayed(interval) : null;

    if (end >= start) {
      await delay();
      for (var value = start; value <= end; value++) {
        yield await yielding(value);
      }
    } else {
      await delay();
      for (var value = start; value >= end; value--) {
        yield await yielding(value);
      }
    }
  }
}

///
///
/// [FBoxShadow]
///   [FBoxShadow.blurNormal]
///   [FBoxShadow.blurSolid]
///   [FBoxShadow.blurOuter]
///   [FBoxShadow.blurInner]
///
///
extension FBoxShadow on BoxShadow {
  static BoxShadow blurNormal({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.normal,
      );

  static BoxShadow blurSolid({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.solid,
      );

  static BoxShadow blurOuter({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.outer,
      );

  static BoxShadow blurInner({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.inner,
      );
}

///
///
///
///
///
/// [FBorderSide]
///   [FBorderSide.solidInside]
///   [FBorderSide.solidCenter]
///   [FBorderSide.solidOutside]
///
///
/// [FBorderBox]
///   [FBorderBox.sideSolidCenter]
///
/// [FBorderOutlined]
///   [FBorderOutlined.star]
///   [FBorderOutlined.linear]
///   [FBorderOutlined.stadium]
///   [FBorderOutlined.beveledRectangle]
///   [FBorderOutlined.roundedRectangle]
///   [FBorderOutlined.continuousRectangle]
///   [FBorderOutlined.circle]
///   [FBorderOutlined.oval]
///
/// [FBorderInput]
///   [FBorderInput.outline]
///   [FBorderInput.outlineSolidInside]
///   [FBorderInput.underline]
///
/// see https://api.flutter.dev/flutter/painting/ShapeBorder-class.html for more detail about [ShapeBorder]
///
///
///
///
///
///

// border side
extension FBorderSide on BorderSide {
  static BorderSide solidInside({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignInside,
      );

  static BorderSide solidCenter({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );

  static BorderSide solidOutside({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignOutside,
      );
}

// box border
extension FBorderBox on BoxBorder {
  static BoxBorder sideSolidCenter({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      Border.fromBorderSide(
        FBorderSide.solidCenter(color: color, width: width),
      );
}

// outlined border
extension FBorderOutlined on OutlinedBorder {
  static StarBorder star({
    required BorderSide side,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) =>
      StarBorder(
        side: side,
        points: points,
        innerRadiusRatio: innerRadiusRatio,
        pointRounding: pointRounding,
        valleyRounding: valleyRounding,
        rotation: rotation,
        squash: squash,
      );

  static LinearBorder linear({
    required BorderSide side,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) =>
      LinearBorder(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      );

  static StadiumBorder stadium(BorderSide side) => StadiumBorder(side: side);

  static BeveledRectangleBorder beveledRectangle({
    required BorderSide side,
    BorderRadius borderRadius = BorderRadius.zero,
  }) =>
      BeveledRectangleBorder(
        side: side,
        borderRadius: borderRadius,
      );

  static RoundedRectangleBorder roundedRectangle({
    required BorderSide side,
    BorderRadius borderRadius = BorderRadius.zero,
  }) =>
      RoundedRectangleBorder(
        side: side,
        borderRadius: borderRadius,
      );

  static ContinuousRectangleBorder continuousRectangle({
    required BorderSide side,
    BorderRadius borderRadius = BorderRadius.zero,
  }) =>
      ContinuousRectangleBorder(side: side, borderRadius: borderRadius);

  static CircleBorder circle({
    required BorderSide side,
    double eccentricity = 0.0,
  }) =>
      CircleBorder(side: side, eccentricity: eccentricity);

  static CircleBorder oval({
    required BorderSide side,
    double eccentricity = 1.0,
  }) =>
      OvalBorder(side: side, eccentricity: eccentricity);
}

// input border
extension FBorderInput on InputBorder {
  static OutlineInputBorder outline({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = KBorderRadius.allCircular_4,
    double gapPadding = 4.0,
  }) =>
      OutlineInputBorder(
        borderSide: borderSide,
        borderRadius: borderRadius,
        gapPadding: gapPadding,
      );

  static OutlineInputBorder outlineSolidInside({
    Color color = Colors.blueGrey,
    double width = 1.5,
    BorderRadius borderRadius = KBorderRadius.allCircular_4,
    double gapPadding = 4.0,
  }) =>
      OutlineInputBorder(
        borderSide: FBorderSide.solidInside(
          color: color,
          width: width,
        ),
        borderRadius: borderRadius,
        gapPadding: gapPadding,
      );

  static UnderlineInputBorder underline({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = KBorderRadius.top_4,
  }) =>
      UnderlineInputBorder(
        borderSide: borderSide,
        borderRadius: borderRadius,
      );
}

///
///
///
///
///
///
///
///
///
/// [FDecorationBox]
///   [FDecorationBox.rectangle]
///   [FDecorationBox.circle]
///
/// [FDecorationShape]
///   [FDecorationShape.stadiumBorder]
///   [FDecorationShape.outlineInputBorder]
///
/// [FDecorationInput]
///   [FDecorationInput.rowLabelIconText]
///   [FDecorationInput.style1]
///
///
///
///
///
///
///
///

// box decoration
extension FDecorationBox on BoxDecoration {
  static BoxDecoration rectangle(
          {Color? color,
          DecorationImage? image,
          Border? border,
          BorderRadiusGeometry? borderRadius,
          List<BoxShadow>? boxShadow,
          BlendMode? backgroundBlendMode}) =>
      BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        backgroundBlendMode: backgroundBlendMode,
        shape: BoxShape.rectangle,
      );

  static BoxDecoration circle({
    Color? color,
    DecorationImage? image,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    BlendMode? backgroundBlendMode,
  }) =>
      BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        backgroundBlendMode: backgroundBlendMode,
        shape: BoxShape.circle,
      );
}

// shape decoration
extension FDecorationShape on ShapeDecoration {
  static ShapeDecoration stadiumBorder({
    required BorderSide side,
    Color? color,
    DecorationImage? image,
    List<BoxShadow>? shadows,
    Gradient? gradient,
  }) =>
      ShapeDecoration(
        shape: StadiumBorder(side: side),
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      );

  static ShapeDecoration outlineInputBorder({
    required BorderSide side,
    Color? color,
    DecorationImage? image,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = KBorderRadius.allCircular_4,
    double gapPadding = 4.0,
  }) =>
      ShapeDecoration(
        shape: OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
        ),
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      );
}

// input decoration
extension FDecorationInput on InputDecoration {
  static InputDecoration rowLabelIconText({
    InputBorder? border,
    required Icon icon,
    required Text text,
  }) =>
      InputDecoration(
        alignLabelWithHint: true,
        border: border,
        contentPadding: switch (border) {
          null => EdgeInsets.zero,
          _ => throw UnimplementedError(),
        },
        label: Row(children: [icon, text]),
      );

  static InputDecoration style1({
    required InputBorder enabledBorder,
  }) =>
      InputDecoration(
        labelStyle: TextStyle(color: Colors.blueGrey),
        enabledBorder: enabledBorder,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
      );
}
