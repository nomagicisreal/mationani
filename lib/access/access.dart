// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of mationani;

///
/// this file contains:
///
/// [NumExtension], [DoubleExtension], [IntExtension]
///
/// [PathExtension], [PathOperationExtension]
/// [FSizingPath], [FSizingRectingPath], [FSizingRRectingPath]
/// [FCanvasProcessor]
/// [VPaintFill], [VPaintFillBlur], [VPaintStroke], [KMaskFilter], [FPaintFromCanvasSize]
/// [FClipping], [FClipping], ...
/// [FCustomPaint], [FPainting], [FMationPainter]
///
///
/// [KMapperNone]
/// [KMapper], [FMapper], [FMapperDouble], [FMapperOffsetIterable]
/// [KMapperCubicPointsPermutation], [FCompanionOffsetIterable]
///
///
///

extension NumExtension on num {
  num get square => math.pow(this, 2);
}

extension DoubleExtension on double {
  static final double infinity2_31 = DoubleExtension.proximateInfinityOf(2.31);
  static final double infinity3_2 = DoubleExtension.proximateInfinityOf(3.2);
  static const double sqrt2 = math.sqrt2;
  static const double sqrt3 = 1.7320508075688772;
  static const double sqrt5 = 2.23606797749979;
  static const double sqrt6 = 2.44948974278317;
  static const double sqrt7 = 2.6457513110645907;
  static const double sqrt8 = 2.8284271247461903;
  static const double sqrt10 = 3.1622776601683795;
  static const double sqrt1_2 = math.sqrt1_2;
  static const double sqrt1_3 = 0.5773502691896257;
  static const double sqrt1_5 = 0.4472135954999579;
  static const double sqrt1_6 = 0.408248290463863;
  static const double sqrt1_7 = 0.3779644730092272;
  static const double sqrt1_8 = 0.3535533905932738;
  static const double sqrt1_10 = 0.31622776601683794;

  Radius get toCircularRadius => Radius.circular(this);

  bool get isNearlyInt => (ceil() - this) <= 0.01;

  ///
  /// infinity usages
  ///

  static double proximateInfinityOf(double precision) =>
      1.0 / math.pow(0.1, precision);

  static double proximateNegativeInfinityOf(double precision) =>
      -1.0 / math.pow(0.1, precision);

  double filterInfinity(double precision) => switch (this) {
        double.infinity => proximateInfinityOf(precision),
        double.negativeInfinity => proximateNegativeInfinityOf(precision),
        _ => this,
      };
}

extension IntExtension on int {
  int get accumulate {
    assert(!isNegative && this != 0, 'invalid accumulate integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator += i;
    }
    return accelerator;
  }

  int get factorial {
    assert(!isNegative && this != 0, 'invalid factorial integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator *= i;
    }
    return accelerator;
  }

  bool isSmallerOrEqualTo(int value) => this == value || this < value;

  bool isLessOneOrEqualTo(int value) => this == value || this + 1 == value;

  bool isHigherOrEqualTo(int value) => this == value || this > value;

  bool isHigherOneOrEqualTo(int value) => this == value || this == value + 1;

  static List<int> accumulationTo(int end, {int start = 0}) {
    final list = <int>[];
    for (int i = start; i <= end; i++) {
      list.add(i.accumulate);
    }
    return list;
  }
}

///
///
///
///
/// path, canvas, paint, clipper, painter
///
///
///
///
///
///

extension PathExtension on Path {
  ///
  ///
  ///
  /// move, line, arc
  ///
  ///
  /// see https://www.youtube.com/watch?v=aVwxzDHniEw for explanation of cubic bezier
  ///
  ///
  void moveToPoint(Offset point) => moveTo(point.dx, point.dy);

  void lineToPoint(Offset point) => lineTo(point.dx, point.dy);

  void moveOrLineToPoint(Offset point, bool shouldMove) =>
      shouldMove ? moveToPoint(point) : lineTo(point.dx, point.dy);

  void lineFromAToB(Offset a, Offset b) => this
    ..moveToPoint(a)
    ..lineToPoint(b);

  void lineFromAToAll(Offset a, Iterable<Offset> points) => points.fold<Path>(
        this..moveToPoint(a),
        (path, point) => path..lineToPoint(point),
      );

  void arcFromStartToEnd(
    Offset arcStart,
    Offset arcEnd, {
    Radius radius = Radius.zero,
    bool clockwise = true,
    double rotation = 0.0,
    bool largeArc = false,
  }) =>
      this
        ..moveToPoint(arcStart)
        ..arcToPoint(
          arcEnd,
          radius: radius,
          clockwise: clockwise,
          rotation: rotation,
          largeArc: largeArc,
        );

  void quadraticBezierToPoint(Offset controlPoint, Offset endPoint) =>
      quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void quadraticBezierToRelativePoint(Offset controlPoint, Offset endPoint) =>
      relativeQuadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToPoint(
    Offset controlPoint1,
    Offset controlPoint2,
    Offset endPoint,
  ) =>
      cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToRelativePoint(
    Offset controlPoint1,
    Offset controlPoint2,
    Offset endPoint,
  ) =>
      relativeCubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  /// [points] should be treated as [controlPointA, controlPointB, endPoint]
  void cubicToPointsList(List<Offset> points) =>
      cubicToPoint(points[0], points[1], points[2]);

  ///
  ///
  ///
  /// shape
  ///
  ///
  ///
  void addOvalFromCircle(Offset center, double radius) =>
      addOval(Rect.fromCircle(center: center, radius: radius));

  void addRectFromPoints(Offset a, Offset b) => addRect(Rect.fromPoints(a, b));

  void addRectFromCenter(Offset center, double width, double height) =>
      addRect(Rect.fromCenter(center: center, width: width, height: height));

  void addRectFromLTWH(double left, double top, double width, double height) =>
      addRect(Rect.fromLTWH(left, top, width, height));

}

extension PathOperationExtension on PathOperation {
  SizingPath combining(
    SizingPath a,
    SizingPath b,
  ) =>
      (size) => Path.combine(this, a(size), b(size));

  SizingPath combiningAll(
    Iterable<SizingPath> iterable,
  ) =>
      iterable.reduce((p, pNext) => combining(p, pNext));
}

///
///
/// instance methods
/// [difference], [intersect], [union], [xor], [reverseDifference]
///
///
/// static methods:
///
/// [lineTo], [connect], [connectAll] ; [lineToFromSize], [connectFromSize], [connectAllFromSize]
/// [bezierQuadratic], [bezierCubic]
///
/// [rect], [rRect],
/// [oval], [ovalFromCenterSize], [circle]
/// [polygon], [polygonCubic], [polygonCubicFromSize]
///
///
/// [shapeBorder]
/// [pieSizingOf], [pieSizing]
/// [penpointFlat]
/// [trapeziumSymmetry]
/// ...
///
///
///
///
///
extension FSizingPath on SizingPath {
  static SizingPath of(Path value) => (_) => value;

  SizingPath difference(SizingPath another) => (size) =>
      Path.combine(PathOperation.difference, this(size), another(size));

  SizingPath intersect(SizingPath another) => (size) =>
      Path.combine(PathOperation.intersect, this(size), another(size));

  SizingPath union(SizingPath another) =>
      (size) => Path.combine(PathOperation.union, this(size), another(size));

  SizingPath xor(SizingPath another) =>
      (size) => Path.combine(PathOperation.xor, this(size), another(size));

  SizingPath reverseDifference(SizingPath another) => (size) => Path.combine(
        PathOperation.reverseDifference,
        this(size),
        another(size),
      );

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
  ///
  /// shape
  ///
  ///
  static SizingPath rect(Rect rect) => (size) => Path()..addRect(rect);

  static SizingPath get addRectFullSize =>
      (size) => Path()..addRect(Offset.zero & size);

  static SizingPath rRect(RRect rRect) => (size) => Path()..addRRect(rRect);

  static SizingPath oval(Rect rect) => (size) => Path()..addOval(rect);

  static SizingPath ovalFromCenterSize(
    Offset center,
    Size size,
  ) =>
      oval(RectExtension.fromCenterSize(center, size));

  static SizingPath circle(Offset center, double radius) =>
      oval(RectExtension.fromCircle(center, radius));

  ///
  ///
  /// polygon
  ///
  /// see [RegularPolygon.cornersOf] to create corners
  ///
  ///
  static SizingPath polygon(List<Offset> corners) =>
      (size) => Path()..addPolygon(corners, false);

  ///
  /// [cornersCubic] should be the cubic points related to polygon corners in clockwise or counterclockwise sequence
  /// every element list of [cornersCubic] will be treated as [beginPoint, controlPointA, controlPointB, endPoint]
  ///
  /// see [RRegularPolygon.cubicPoints] and its subclasses for [cornersCubic] creation
  ///
  ///
  static Path _polygonCubic(
    Iterable<Iterable<Offset>> points,
    Mapper<Iterable<Offset>> scaling,
  ) =>
      points
          .map((points) => scaling(points).toList(growable: false))
          .foldWithIndex(
            Path(),
            (path, points, index) => path
              ..moveOrLineToPoint(points[0], index == 0)
              ..cubicToPointsList(points.sublist(1)),
          )..close();

  static SizingPath polygonCubic(
    Iterable<List<Offset>> cornersCubic, {
    double scale = 1,
  }) {
    final scaling = FMapperOffsetIterable.scaling(scale);
    return (size) => _polygonCubic(cornersCubic, scaling);
  }

  static SizingPath polygonCubicFromSize(
    Iterable<List<Offset>> cornersCubic, {
    double scale = 1,
    Companion<Iterable<Offset>, Size> adjust =
        FCompanionOffsetIterable.adjustSizeCenter,
  }) {
    final scaling = FMapperOffsetIterable.scaling(scale);
    return (size) => _polygonCubic(
          cornersCubic.map((points) => adjust(points, size)),
          scaling,
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
  static SizingPath shapeBorder(
    ShapeBorder shape, {
    TextDirection? textDirection,
    bool isOuterPath = true,
  }) =>
      isOuterPath
          ? (size) => shape.getOuterPath(
                Offset.zero & size,
                textDirection: textDirection,
              )
          : (size) => shape.getInnerPath(
                Offset.zero & size,
                textDirection: textDirection,
              );

  ///
  ///
  /// [pie]
  /// [pieFromCenterDirectionRadius]
  /// [pieSizing]
  /// [pieSizingOf]
  ///
  ///
  ///
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

  static SizingPath pieSizing({
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

  static SizingPath pieSizingOf(bool isRight) => isRight
      ? FSizingPath.pieSizing(
          arcStart: (size) => Offset.zero,
          arcEnd: (size) => size.bottomLeft(Offset.zero),
          clockwise: true,
        )
      : FSizingPath.pieSizing(
          arcStart: (size) => size.topRight(Offset.zero),
          arcEnd: (size) => size.bottomRight(Offset.zero),
          clockwise: false,
        );

  ///
  /// finger
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

  /// pencil
  ///
  /// -----
  /// |   |
  /// |   |   <----[penBodyLength]
  /// |   |
  /// \   /
  ///  ---   <---- [flatWidth]
  ///
  ///
  static SizingPath penpointFlat({
    required SizingDouble flatWidth,
    required SizingDouble penBodyLength,
  }) =>
      (size) {
        final width = size.width;
        final height = size.height;
        final flatLength = flatWidth(size);
        final penBody = penBodyLength(size);

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
        final origin = topLeftMargin(size);
        final bodySize = body(size);
        throw UnimplementedError();
      };
}

extension FSizingRect on SizingRect {
  static Rect full(Size size) => Offset.zero & size;

  static SizingRect fullTranslate(Offset origin) => (size) => origin & size;
}

extension FSizingRectingPath on SizingRectingPath {
  static const SizingRectingPath addOval = _addOval;
  static const SizingRectingPath addRect = _addRect;

  static Path _addOval(Rect rect, Size size) => FSizingPath.oval(rect)(size);

  static Path _addRect(Rect rect, Size size) => FSizingPath.rect(rect)(size);
}

extension FSizingRRectingPath on SizingRRectingPath {
  static const SizingRRectingPath addRRect = _addRRect;

  static Path _addRRect(RRect rect, Size size) => FSizingPath.rRect(rect)(size);
}

///
///
///
///
/// canvas, paint
///
///
///
///

extension FCanvasProcessor on CanvasProcessor {
  static const drawPathWithPaint = _drawPathWithPaint;

  static void _drawPathWithPaint(Canvas canvas, Paint paint, Path path) =>
      canvas.drawPath(path, paint);
}

extension VPaintFill on Paint {
  static Paint get _fill => Paint()..style = PaintingStyle.fill;

  static Paint get black => _fill..color = Colors.black;

  static Paint get white => _fill..color = Colors.white;

  static Paint get red => _fill..color = Colors.red;

  static Paint get orange => _fill..color = Colors.orange;

  static Paint get yellow => _fill..color = Colors.yellow;

  static Paint get green => _fill..color = Colors.green;

  static Paint get blue => _fill..color = Colors.blue;

  static Paint get blueAccent => _fill..color = Colors.blueAccent;

  static Paint get purple => _fill..color = Colors.purple;
}

extension VPaintFillBlur on Paint {
  static Paint get white_normal_05 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_05;

  static Paint get white_normal_1 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_1;

  static Paint get white_normal_2 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_2;

  static Paint get white_normal_3 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_3;

  static Paint get white_normal_4 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_4;

  static Paint get white_normal_5 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_5;

  static Paint get white_normal_6 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_6;

  static Paint get white_normal_7 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_7;

  static Paint get white_normal_8 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_8;

  static Paint get white_normal_9 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_9;

  static Paint get white_normal_10 =>
      VPaintFill.white..maskFilter = KMaskFilter.normal_10;
}

extension FPaintFill on Paint {
  static Paint of(Color color) => VPaintFill._fill..color = color;
}

extension VPaintStroke on Paint {
  static Paint get _stroke => Paint()..style = PaintingStyle.stroke;

  /// stroke

  static Paint get _stroke_1 => _stroke..strokeWidth = 1;

  static Paint get _stroke_2 => _stroke..strokeWidth = 2;

  static Paint get _stroke_3 => _stroke..strokeWidth = 3;

  static Paint get _stroke_4 => _stroke..strokeWidth = 4;

  static Paint get _stroke_5 => _stroke..strokeWidth = 5;

  /// cap

  static Paint get _stroke_1_capRound => _stroke_1..strokeCap = StrokeCap.round;

  static Paint get _stroke_1_capSquare =>
      _stroke_1..strokeCap = StrokeCap.square;

  static Paint get _stroke_1_capButt => _stroke_1..strokeCap = StrokeCap.butt;

  static Paint get _stroke_2_capRound => _stroke_2..strokeCap = StrokeCap.round;

  static Paint get _stroke_2_capSquare =>
      _stroke_2..strokeCap = StrokeCap.square;

  static Paint get _stroke_2_capButt => _stroke_2..strokeCap = StrokeCap.butt;

  static Paint get _stroke_3_capRound => _stroke_3..strokeCap = StrokeCap.round;

  static Paint get _stroke_3_capSquare =>
      _stroke_3..strokeCap = StrokeCap.square;

  static Paint get _stroke_3_capButt => _stroke_3..strokeCap = StrokeCap.butt;

  static Paint get _stroke_4_capRound => _stroke_4..strokeCap = StrokeCap.round;

  static Paint get _stroke_4_capSquare =>
      _stroke_4..strokeCap = StrokeCap.square;

  static Paint get _stroke_4_capButt => _stroke_4..strokeCap = StrokeCap.butt;

  static Paint get _stroke_5_capRound => _stroke_5..strokeCap = StrokeCap.round;

  static Paint get _stroke_5_capSquare =>
      _stroke_5..strokeCap = StrokeCap.square;

  static Paint get _stroke_5_capButt => _stroke_5..strokeCap = StrokeCap.butt;

  /// color_strokeWidth_cap

  // 1
  static Paint get black_1_capRound => _stroke_1_capRound..color = Colors.black;

  static Paint get black_1_capSquare =>
      _stroke_1_capSquare..color = Colors.black;

  static Paint get black_1_capButt => _stroke_1_capButt..color = Colors.black;

  static Paint get white_1_capRound => _stroke_1_capRound..color = Colors.white;

  static Paint get white_1_capSquare =>
      _stroke_1_capSquare..color = Colors.white;

  static Paint get white_1_capButt => _stroke_1_capButt..color = Colors.white;

  static Paint get red_1_capRound => _stroke_1_capRound..color = Colors.red;

  static Paint get red_1_capSquare => _stroke_1_capSquare..color = Colors.red;

  static Paint get red_1_capButt => _stroke_1_capButt..color = Colors.red;

  static Paint get orange_1_capRound =>
      _stroke_1_capRound..color = Colors.orange;

  static Paint get orange_1_capSquare =>
      _stroke_1_capSquare..color = Colors.orange;

  static Paint get orange_1_capButt => _stroke_1_capButt..color = Colors.orange;

  static Paint get yellow_1_capRound =>
      _stroke_1_capRound..color = Colors.yellow;

  static Paint get yellow_1_capSquare =>
      _stroke_1_capSquare..color = Colors.yellow;

  static Paint get yellow_1_capButt => _stroke_1_capButt..color = Colors.yellow;

  static Paint get green_1_capRound => _stroke_1_capRound..color = Colors.green;

  static Paint get green_1_capSquare =>
      _stroke_1_capSquare..color = Colors.green;

  static Paint get green_1_capButt => _stroke_1_capButt..color = Colors.green;

  static Paint get blue_1_capRound => _stroke_1_capRound..color = Colors.blue;

  static Paint get blue_1_capSquare => _stroke_1_capSquare..color = Colors.blue;

  static Paint get blue_1_capButt => _stroke_1_capButt..color = Colors.blue;

  static Paint get blueAccent_1_capRound =>
      _stroke_1_capRound..color = Colors.blueAccent;

  static Paint get blueAccent_1_capSquare =>
      _stroke_1_capSquare..color = Colors.blueAccent;

  static Paint get blueAccent_1_capButt =>
      _stroke_1_capButt..color = Colors.blueAccent;

  static Paint get purple_1_capRound =>
      _stroke_1_capRound..color = Colors.purple;

  static Paint get purple_1_capSquare =>
      _stroke_1_capSquare..color = Colors.purple;

  static Paint get purple_1_capButt => _stroke_1_capButt..color = Colors.purple;

  // 2
  static Paint get black_2_capRound => _stroke_2_capRound..color = Colors.black;

  static Paint get black_2_capSquare =>
      _stroke_2_capSquare..color = Colors.black;

  static Paint get black_2_capButt => _stroke_2_capButt..color = Colors.black;

  static Paint get white_2_capRound => _stroke_2_capRound..color = Colors.white;

  static Paint get white_2_capSquare =>
      _stroke_2_capSquare..color = Colors.white;

  static Paint get white_2_capButt => _stroke_2_capButt..color = Colors.white;

  static Paint get red_2_capRound => _stroke_2_capRound..color = Colors.red;

  static Paint get red_2_capSquare => _stroke_2_capSquare..color = Colors.red;

  static Paint get red_2_capButt => _stroke_2_capButt..color = Colors.red;

  static Paint get orange_2_capRound =>
      _stroke_2_capRound..color = Colors.orange;

  static Paint get orange_2_capSquare =>
      _stroke_2_capSquare..color = Colors.orange;

  static Paint get orange_2_capButt => _stroke_2_capButt..color = Colors.orange;

  static Paint get yellow_2_capRound =>
      _stroke_2_capRound..color = Colors.yellow;

  static Paint get yellow_2_capSquare =>
      _stroke_2_capSquare..color = Colors.yellow;

  static Paint get yellow_2_capButt => _stroke_2_capButt..color = Colors.yellow;

  static Paint get green_2_capRound => _stroke_2_capRound..color = Colors.green;

  static Paint get green_2_capSquare =>
      _stroke_2_capSquare..color = Colors.green;

  static Paint get green_2_capButt => _stroke_2_capButt..color = Colors.green;

  static Paint get blue_2_capRound => _stroke_2_capRound..color = Colors.blue;

  static Paint get blue_2_capSquare => _stroke_2_capSquare..color = Colors.blue;

  static Paint get blue_2_capButt => _stroke_2_capButt..color = Colors.blue;

  static Paint get blueAccent_2_capRound =>
      _stroke_2_capRound..color = Colors.blueAccent;

  static Paint get blueAccent_2_capSquare =>
      _stroke_2_capSquare..color = Colors.blueAccent;

  static Paint get blueAccent_2_capButt =>
      _stroke_2_capButt..color = Colors.blueAccent;

  static Paint get purple_2_capRound =>
      _stroke_2_capRound..color = Colors.purple;

  static Paint get purple_2_capSquare =>
      _stroke_2_capSquare..color = Colors.purple;

  static Paint get purple_2_capButt => _stroke_2_capButt..color = Colors.purple;

  // 3
  static Paint get black_3_capRound => _stroke_3_capRound..color = Colors.black;

  static Paint get black_3_capSquare =>
      _stroke_3_capSquare..color = Colors.black;

  static Paint get black_3_capButt => _stroke_3_capButt..color = Colors.black;

  static Paint get white_3_capRound => _stroke_3_capRound..color = Colors.white;

  static Paint get white_3_capSquare =>
      _stroke_3_capSquare..color = Colors.white;

  static Paint get white_3_capButt => _stroke_3_capButt..color = Colors.white;

  static Paint get red_3_capRound => _stroke_3_capRound..color = Colors.red;

  static Paint get red_3_capSquare => _stroke_3_capSquare..color = Colors.red;

  static Paint get red_3_capButt => _stroke_3_capButt..color = Colors.red;

  static Paint get orange_3_capRound =>
      _stroke_3_capRound..color = Colors.orange;

  static Paint get orange_3_capSquare =>
      _stroke_3_capSquare..color = Colors.orange;

  static Paint get orange_3_capButt => _stroke_3_capButt..color = Colors.orange;

  static Paint get yellow_3_capRound =>
      _stroke_3_capRound..color = Colors.yellow;

  static Paint get yellow_3_capSquare =>
      _stroke_3_capSquare..color = Colors.yellow;

  static Paint get yellow_3_capButt => _stroke_3_capButt..color = Colors.yellow;

  static Paint get green_3_capRound => _stroke_3_capRound..color = Colors.green;

  static Paint get green_3_capSquare =>
      _stroke_3_capSquare..color = Colors.green;

  static Paint get green_3_capButt => _stroke_3_capButt..color = Colors.green;

  static Paint get blue_3_capRound => _stroke_3_capRound..color = Colors.blue;

  static Paint get blue_3_capSquare => _stroke_3_capSquare..color = Colors.blue;

  static Paint get blue_3_capButt => _stroke_3_capButt..color = Colors.blue;

  static Paint get blueAccent_3_capRound =>
      _stroke_3_capRound..color = Colors.blueAccent;

  static Paint get blueAccent_3_capSquare =>
      _stroke_3_capSquare..color = Colors.blueAccent;

  static Paint get blueAccent_3_capButt =>
      _stroke_3_capButt..color = Colors.blueAccent;

  static Paint get purple_3_capRound =>
      _stroke_3_capRound..color = Colors.purple;

  static Paint get purple_3_capSquare =>
      _stroke_3_capSquare..color = Colors.purple;

  static Paint get purple_3_capButt => _stroke_3_capButt..color = Colors.purple;

  // 4
  static Paint get black_4_capRound => _stroke_4_capRound..color = Colors.black;

  static Paint get black_4_capSquare =>
      _stroke_4_capSquare..color = Colors.black;

  static Paint get black_4_capButt => _stroke_4_capButt..color = Colors.black;

  static Paint get white_4_capRound => _stroke_4_capRound..color = Colors.white;

  static Paint get white_4_capSquare =>
      _stroke_4_capSquare..color = Colors.white;

  static Paint get white_4_capButt => _stroke_4_capButt..color = Colors.white;

  static Paint get red_4_capRound => _stroke_4_capRound..color = Colors.red;

  static Paint get red_4_capSquare => _stroke_4_capSquare..color = Colors.red;

  static Paint get red_4_capButt => _stroke_4_capButt..color = Colors.red;

  static Paint get orange_4_capRound =>
      _stroke_4_capRound..color = Colors.orange;

  static Paint get orange_4_capSquare =>
      _stroke_4_capSquare..color = Colors.orange;

  static Paint get orange_4_capButt => _stroke_4_capButt..color = Colors.orange;

  static Paint get yellow_4_capRound =>
      _stroke_4_capRound..color = Colors.yellow;

  static Paint get yellow_4_capSquare =>
      _stroke_4_capSquare..color = Colors.yellow;

  static Paint get yellow_4_capButt => _stroke_4_capButt..color = Colors.yellow;

  static Paint get green_4_capRound => _stroke_4_capRound..color = Colors.green;

  static Paint get green_4_capSquare =>
      _stroke_4_capSquare..color = Colors.green;

  static Paint get green_4_capButt => _stroke_4_capButt..color = Colors.green;

  static Paint get blue_4_capRound => _stroke_4_capRound..color = Colors.blue;

  static Paint get blue_4_capSquare => _stroke_4_capSquare..color = Colors.blue;

  static Paint get blue_4_capButt => _stroke_4_capButt..color = Colors.blue;

  static Paint get blueAccent_4_capRound =>
      _stroke_4_capRound..color = Colors.blueAccent;

  static Paint get blueAccent_4_capSquare =>
      _stroke_4_capSquare..color = Colors.blueAccent;

  static Paint get blueAccent_4_capButt =>
      _stroke_4_capButt..color = Colors.blueAccent;

  static Paint get purple_4_capRound =>
      _stroke_4_capRound..color = Colors.purple;

  static Paint get purple_4_capSquare =>
      _stroke_4_capSquare..color = Colors.purple;

  static Paint get purple_4_capButt => _stroke_4_capButt..color = Colors.purple;

  // 5
  static Paint get black_5_capRound => _stroke_5_capRound..color = Colors.black;

  static Paint get black_5_capSquare =>
      _stroke_5_capSquare..color = Colors.black;

  static Paint get black_5_capButt => _stroke_5_capButt..color = Colors.black;

  static Paint get white_5_capRound => _stroke_5_capRound..color = Colors.white;

  static Paint get white_5_capSquare =>
      _stroke_5_capSquare..color = Colors.white;

  static Paint get white_5_capButt => _stroke_5_capButt..color = Colors.white;

  static Paint get red_5_capRound => _stroke_5_capRound..color = Colors.red;

  static Paint get red_5_capSquare => _stroke_5_capSquare..color = Colors.red;

  static Paint get red_5_capButt => _stroke_5_capButt..color = Colors.red;

  static Paint get orange_5_capRound =>
      _stroke_5_capRound..color = Colors.orange;

  static Paint get orange_5_capSquare =>
      _stroke_5_capSquare..color = Colors.orange;

  static Paint get orange_5_capButt => _stroke_5_capButt..color = Colors.orange;

  static Paint get yellow_5_capRound =>
      _stroke_5_capRound..color = Colors.yellow;

  static Paint get yellow_5_capSquare =>
      _stroke_5_capSquare..color = Colors.yellow;

  static Paint get yellow_5_capButt => _stroke_5_capButt..color = Colors.yellow;

  static Paint get green_5_capRound => _stroke_5_capRound..color = Colors.green;

  static Paint get green_5_capSquare =>
      _stroke_5_capSquare..color = Colors.green;

  static Paint get green_5_capButt => _stroke_5_capButt..color = Colors.green;

  static Paint get blue_5_capRound => _stroke_5_capRound..color = Colors.blue;

  static Paint get blue_5_capSquare => _stroke_5_capSquare..color = Colors.blue;

  static Paint get blue_5_capButt => _stroke_5_capButt..color = Colors.blue;

  static Paint get blueAccent_5_capRound =>
      _stroke_5_capRound..color = Colors.blueAccent;

  static Paint get blueAccent_5_capSquare =>
      _stroke_5_capSquare..color = Colors.blueAccent;

  static Paint get blueAccent_5_capButt =>
      _stroke_5_capButt..color = Colors.blueAccent;

  static Paint get purple_5_capRound =>
      _stroke_5_capRound..color = Colors.purple;

  static Paint get purple_5_capSquare =>
      _stroke_5_capSquare..color = Colors.purple;

  static Paint get purple_5_capButt => _stroke_5_capButt..color = Colors.purple;

  /// eraser
  static Paint get _eraser => _stroke..color = Colors.transparent;

  static Paint get _eraser_clear => _eraser..blendMode = BlendMode.clear;

  static Paint get eraser_1 => _eraser_clear..strokeWidth = 1;

  static Paint get eraser_2 => _eraser_clear..strokeWidth = 2;

  static Paint get eraser_3 => _eraser_clear..strokeWidth = 3;

  static Paint get eraser_4 => _eraser_clear..strokeWidth = 4;

  static Paint get eraser_5 => _eraser_clear..strokeWidth = 5;

  static Paint get eraser_10 => _eraser_clear..strokeWidth = 10;
}

extension KMaskFilter on Paint {
  /// normal
  static const MaskFilter normal_05 = MaskFilter.blur(BlurStyle.normal, 0.5);
  static const MaskFilter normal_1 = MaskFilter.blur(BlurStyle.normal, 1);
  static const MaskFilter normal_2 = MaskFilter.blur(BlurStyle.normal, 2);
  static const MaskFilter normal_3 = MaskFilter.blur(BlurStyle.normal, 3);
  static const MaskFilter normal_4 = MaskFilter.blur(BlurStyle.normal, 4);
  static const MaskFilter normal_5 = MaskFilter.blur(BlurStyle.normal, 5);
  static const MaskFilter normal_6 = MaskFilter.blur(BlurStyle.normal, 6);
  static const MaskFilter normal_7 = MaskFilter.blur(BlurStyle.normal, 7);
  static const MaskFilter normal_8 = MaskFilter.blur(BlurStyle.normal, 8);
  static const MaskFilter normal_9 = MaskFilter.blur(BlurStyle.normal, 9);
  static const MaskFilter normal_10 = MaskFilter.blur(BlurStyle.normal, 10);

  /// solid
  static const MaskFilter solid_05 = MaskFilter.blur(BlurStyle.solid, 0.5);
}

extension FPaintFromCanvasSize on SizingPaintFromCanvas {
  static SizingPaintFromCanvas of(Paint paint) => (_, __) => paint;

  static const SizingPaintFromCanvas whiteFill = _whiteFill;
  static const SizingPaintFromCanvas redFill = _redFill;

  static Paint _whiteFill(Canvas canvas, Size size) => VPaintFill.white;

  static Paint _redFill(Canvas canvas, Size size) => VPaintFill.red;
}

///
///
///
/// clipper
///
///
///

extension FClipPath on CustomPaint {
  static ClipPath rectFromZeroToSize({
    Clip clipBehavior = Clip.antiAlias,
    required Size size,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: FClipping.rectOf(Offset.zero & size),
        child: child,
      );

  static ClipPath reClipNeverOf({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath pathFromSize,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(pathFromSize),
        child: child,
      );

  static ClipPath decoratedPolygon(
    Decoration decoration,
    RRegularPolygon polygon, {
    DecorationPosition position = DecorationPosition.background,
    Widget? child,
  }) =>
      ClipPath(
        clipper: FClipping.polygonCubicCornerFromSize(polygon),
        child: DecoratedBox(
          decoration: decoration,
          position: position,
          child: child,
        ),
      );
}

extension FClipping on Clipping {
  static Clipping rectOf(Rect rect) =>
      Clipping.reclipNever((size) => Path()..addRect(rect));

  static Clipping rectFromZeroTo(Size size) => rectOf(Offset.zero & size);

  static Clipping rectFromZeroToOffset(Offset corner) =>
      rectOf(Rect.fromPoints(Offset.zero, corner));

  static Clipping polygonCubicCornerFromSize(RRegularPolygon polygon) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubicFromSize(polygon.cubicPoints),
      );
}

///
///
/// painter
///
///

extension FCustomPaint on CustomPaint {
  static CustomPaint polygonCanvasSizeToPaint(
    RRegularPolygon polygon,
    SizingPaintFromCanvas paintFromCanvasSize, {
    Widget? child,
  }) =>
      CustomPaint(
        painter: FPainting.polygonCubicCorner(paintFromCanvasSize, polygon),
        child: child,
      );
}

extension FPainting on Painting {
  static Painting polygonCubicCorner(
    SizingPaintFromCanvas paintFromCanvasSize,
    RRegularPolygon polygon,
  ) =>
      Painting.rePaintNever(
        paintFromCanvasSize: paintFromCanvasSize,
        pathFromSize: FSizingPath.polygonCubic(polygon.cubicPoints),
      );
}

extension FMationPainter on MationPainter {
  static MationPainter progressingCircles({
    double initialCircleRadius = 5.0,
    double circleRadiusFactor = 0.1,
    required Ani setting,
    required Paint paint,
    required Tween<double> radiusOrbit,
    required int circleCount,
    required Companion<Vector3D, int> planetGenerator,
  }) =>
      MationPainter.drawPathTweenWithPaint(
        sizingPaintingFromCanvas: (_, __) => paint,
        BetweenPath(
          Between<Vector3D>(
            begin: Vector3D(Coordinate.zero, radiusOrbit.begin!),
            end: Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end!),
          ),
          onAnimate: (t, vector) => PathOperation.union.combiningAll(
            Iterable.generate(
              circleCount,
              (i) => (size) => Path()
                ..addOval(
                  Rect.fromCircle(
                    center: planetGenerator(vector, i).toCoordinate,
                    radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
                  ),
                ),
            ),
          ),
        ),
      );
}

///
///
/// mapper
///
///

extension KMapperNone on Mapper<double> {
  static double ofDouble(double t) => t;

  static Offset offset(Offset t) => t;

  static Iterable<Offset> ofOffsetIterable(Iterable<Offset> t) => t;

  static Coordinate ofCoordinate(Coordinate t) => t;

  static Size ofSize(Size size) => size;
}

extension KMapper on Mapper<Curve> {
  static const Mapper<Curve> curveFlipped = _flipped;

  static Curve _flipped(Curve curve) => curve.flipped;
}

extension FMapper on Mapper {
  static T keep<T>(T value) => value;
}

extension FMapperDouble on Mapper<double> {
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

extension KMapperCubicPointsPermutation on Mapper<Map<Offset, List<Offset>>> {
  static const Mapper<Map<Offset, List<Offset>>> p0231 = _0231;
  static const Mapper<Map<Offset, List<Offset>>> p1230 = _1230;

  static Map<Offset, List<Offset>> _0231(Map<Offset, List<Offset>> points) =>
      points.map(
        (points, cubicPoints) => MapEntry(
          points,
          KOffsetPermutation4.p0231(cubicPoints),
        ),
      );

  static Map<Offset, List<Offset>> _1230(Map<Offset, List<Offset>> points) =>
      points.map(
        (points, cubicPoints) => MapEntry(
          points,
          KOffsetPermutation4.p1230(cubicPoints),
        ),
      );

  static Mapper<Map<Offset, List<Offset>>> of(Mapper<List<Offset>> mapper) =>
      (points) => points
          .map((points, cubicPoints) => MapEntry(points, mapper(cubicPoints)));
}

extension FMapperOffsetIterable on Mapper<Iterable<Offset>> {
  static Mapper<Iterable<Offset>> scaling(double scale) => scale == 1
      ? KMapperNone.ofOffsetIterable
      : (points) => points.scaling(scale);
}

extension FCompanionOffsetIterable on Companion<Iterable<Offset>, Size> {
  static Iterable<Offset> adjustSizeCenter(
          Iterable<Offset> points, Size size) =>
      points.adjustCenterFor(size);
}
