///
///
/// this file contains:
///
/// [SizingPath], [SizingOffset], ...
/// [FSizingPath]
/// [FSizingRect]
/// [FSizingOffset]
///
///
/// [PaintFrom], [PaintingPath], [Painter]
/// [FPaintFrom]
/// [FPaintingPath]
/// [FPainter]
///
///
/// [RectBuilder]
/// [FRectBuilder]
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
///
/// sizing, painting
///
///
typedef Sizing = Size Function(Size size);
typedef SizingDouble = double Function(Size size);
typedef SizingOffset = Offset Function(Size size);
typedef SizingRect = Rect Function(Size size);
typedef SizingPath = Path Function(Size size);
typedef SizingPathFrom<T> = SizingPath Function(T value);
typedef SizingOffsetIterable = Iterable<Offset> Function(Size size);
typedef SizingOffsetList = List<Offset> Function(Size size);
typedef SizingCubicOffsetIterable = Iterable<CubicOffset> Function(Size size);

///
/// instance methods
/// [combine]
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
extension FSizingPath on SizingPath {
  SizingPath combine(
    SizingPath another, {
    PathOperation operation = PathOperation.union,
  }) =>
      (size) => Path.combine(operation, this(size), another(size));

  static SizingPath of(Path value) => (_) => value;

  static SizingPath combineAll(
    Iterable<SizingPath> iterable, {
    PathOperation operation = PathOperation.union,
  }) =>
      iterable.reduce((a, b) => a.combine(b, operation: operation));

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
    SizingCubicOffsetIterable points,
    double scale, {
    Companion<CubicOffset, Size>? adjust,
  }) {
    final Mapper<Iterable<CubicOffset>> scaled = scale == 1
        ? FMapper.keep
        : (corners) => corners.map((cubics) => cubics * scale);

    Path from(Iterable<CubicOffset> offsets) => scaled(offsets).foldWithIndex(
          Path(),
          (index, path, points) => path
            ..moveOrLineToPoint(points.a, index == 0)
            ..cubicToPoint(points.b, points.c, points.d),
        )..close();

    return adjust == null
        ? (size) => from(points(size))
        : (size) => from(points(size).map((points) => adjust(points, size)));
  }

  static SizingPath polygonCubic(
    Iterable<CubicOffset> cornersCubic, {
    double scale = 1,
    Companion<CubicOffset, Size>? adjust,
  }) =>
      _polygonCubic((_) => cornersCubic, scale, adjust: adjust);

  static SizingPath polygonCubicFromSize(
    SizingCubicOffsetIterable cornersCubic, {
    double scale = 1,
    Companion<CubicOffset, Size>? adjust,
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
/// painting
///
///
///
///
///
typedef PaintFrom = Paint Function(Canvas canvas, Size size);
typedef PaintingPath = void Function(Canvas canvas, Paint paint, Path path);
typedef Painter = Painting Function(SizingPath sizingPath);

// paint from
extension FPaintFrom on PaintFrom {
  static PaintFrom of(Paint paint) => (_, __) => paint;

  static Paint whiteFill(Canvas canvas, Size size) => VPaintFill.white;

  static Paint redFill(Canvas canvas, Size size) => VPaintFill.red;
}

// painting path
extension FPaintingPath on PaintingPath {
  static void draw(Canvas canvas, Paint paint, Path path) =>
      canvas.drawPath(path, paint);
}

// painter
extension FPainter on Painter {
  static Painter of(
    PaintFrom paintFrom, {
    PaintingPath paintingPath = FPaintingPath.draw,
  }) =>
      (sizingPath) => Painting.rePaintWhenUpdate(
            paintingPath: paintingPath,
            sizingPath: sizingPath,
            paintFrom: paintFrom,
          );
}

///
///
/// rect builder
///
///
///
typedef RectBuilder = Rect Function(BuildContext context);

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


