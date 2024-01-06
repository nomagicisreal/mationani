// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of '../mationani.dart';

///
///
/// this file contains:
/// [PathExtension]
///
/// [FSizingPath]
/// [FSizingRect]
/// [FSizingOffset]
///
/// [FSizingPaintFromCanvas]
/// [VPaintFill]
/// [VPaintFillBlur]
/// [VPaintStroke]
/// [KMaskFilter]
///
/// [FOnLerpSpline2D]
/// [FOnAnimateMatrix4]
/// [FOnAnimatePath]
///
///

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

///
///
///
///
/// canvas, paint
///
///
///
///

extension FSizingPaintFromCanvas on SizingPaintFromCanvas {
  static SizingPaintFromCanvas of(Paint paint) => (_, __) => paint;

  static const SizingPaintFromCanvas whiteFill = _whiteFill;
  static const SizingPaintFromCanvas redFill = _redFill;

  static Paint _whiteFill(Canvas canvas, Size size) => VPaintFill.white;

  static Paint _redFill(Canvas canvas, Size size) => VPaintFill.red;
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

extension FOnAnimateMatrix4 on OnAnimateMatrix4 {
  static Matrix4 _scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4.scaledCoordinate(value);

  static Matrix4 _translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective..translateCoordinate(value);

  static Matrix4 _rotating(Matrix4 matrix4, Coordinate value) => matrix4
    ..setRotation((Matrix4.identity()..rotateCoordinate(value)).getRotation());

  ///
  /// with mapper
  ///
  static OnAnimateMatrix4 scaleMapping(Mapper<Coordinate> mapper) =>
          (matrix4, value) => matrix4.scaledCoordinate(mapper(value));

  static OnAnimateMatrix4 translateMapping(Mapper<Coordinate> mapper) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateCoordinate(mapper(value));

  static OnAnimateMatrix4 rotateMapping(Mapper<Coordinate> mapper) =>
          (matrix4, value) => matrix4
        ..setRotation((Matrix4.identity()..rotateCoordinate(mapper(value)))
            .getRotation());

  ///
  /// with fixed value
  ///
  static OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
          (matrix4, value) => matrix4.scaledCoordinate(value + fixed);

  static OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateCoordinate(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
          (matrix4, value) => matrix4
        ..setRotation((Matrix4.identity()..rotateCoordinate(fixed + value))
            .getRotation());
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
