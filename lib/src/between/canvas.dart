///
///
/// this file contains:
///
/// [SizingPath], [SizingOffset], ..., ...
/// [FSizingPath]
/// [FSizingRect]
/// [FSizingOffset]
///
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
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
/// [FOnLerpSpline2D], [FOnAnimatePath], [FOnAnimateMatrix4]
/// [_FOnLerp]
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
typedef SizingOffsetIterableIterable = Iterable<Iterable<Offset>> Function(
  Size size,
);

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
    SizingOffsetIterableIterable points,
    double scale, {
    Companion<Iterable<Offset>, Size>? adjust,
  }) {
    final scaling = IterableOffsetExtension.scalingMapper(scale);

    Path from(Iterable<Iterable<Offset>> offsets) => offsets
        .map((points) => scaling(points).toList(growable: false))
        .foldWithIndex(
          Path(),
          (index, path, points) => path
            ..moveOrLineToPoint(points[0], index == 0)
            ..cubicToPointsList(points.sublist(1)),
        )..close();

    return adjust == null
        ? (size) => from(points(size))
        : (size) => from(points(size).map((points) => adjust(points, size)));
  }

  static SizingPath polygonCubic(
    Iterable<List<Offset>> cornersCubic, {
    double scale = 1,
    Companion<Iterable<Offset>, Size>? adjust,
  }) =>
      _polygonCubic((_) => cornersCubic, scale, adjust: adjust);

  static SizingPath polygonCubicFromSize(
    SizingOffsetIterableIterable cornersCubic, {
    double scale = 1,
    Companion<Iterable<Offset>, Size>? adjust,
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


///
/// on (the type that may process in every tick)
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Coordinate>;

///
///
///
///
///
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
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static OnLerp<Offset> arcCircle(
    Offset origin,
    double radius,
    Between<double> direction,
  ) =>
      FOnLerpSpline2D.arcOval(origin, direction, Between.of(radius));

  static OnLerp<Offset> arcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return _FOnLerp._constant(a);
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
///
///
///
/// private extensions
///
///
///
///
///
extension _FOnLerp on OnLerp {
  static OnLerp<T> _constant<T>(T value) => (_) => value;

  static OnLerp<T> _of<T>(T a, T b) => switch (a) {
        Size _ => _size(a, b as Size),
        Rect _ => _rect(a, b as Rect),
        Color _ => _color(a, b as Color),
        Vector3D _ => _vector(a, b as Vector3D),
        EdgeInsets _ => _edgeInsets(a, b as EdgeInsets),
        Decoration _ => _decoration(a, b as Decoration),
        ShapeBorder _ => _shapeBorder(a, b as ShapeBorder),
        RelativeRect _ => _relativeRect(a, b as RelativeRect),
        AlignmentGeometry _ => _alignmentGeometry(a, b as AlignmentGeometry),
        SizingPath _ => throw ArgumentError(
            'using BetweenPath constructor instead of Between<SizingPath>',
          ),
        _ => Tween<T>(begin: a, end: b).transform,
      } as OnLerp<T>;

  static OnLerp<Size> _size(Size a, Size b) => (t) => Size.lerp(a, b, t)!;

  static OnLerp<Rect> _rect(Rect a, Rect b) => (t) => Rect.lerp(a, b, t)!;

  static OnLerp<Color> _color(Color a, Color b) => (t) => Color.lerp(a, b, t)!;

  static OnLerp<Vector3D> _vector(Vector3D a, Vector3D b) =>
      (t) => Vector3D.lerp(a, b, t);

  static OnLerp<EdgeInsets> _edgeInsets(EdgeInsets a, EdgeInsets b) =>
      (t) => EdgeInsets.lerp(a, b, t)!;

  static OnLerp<RelativeRect> _relativeRect(RelativeRect a, RelativeRect b) =>
      (t) => RelativeRect.lerp(a, b, t)!;

  static OnLerp<AlignmentGeometry> _alignmentGeometry(
    AlignmentGeometry a,
    AlignmentGeometry b,
  ) =>
      (t) => AlignmentGeometry.lerp(a, b, t)!;

  ///
  ///
  /// See Also
  ///   * [FSizingPath.shapeBorder]
  ///
  ///
  static OnLerp<ShapeBorder> _shapeBorder(ShapeBorder a, ShapeBorder b) =>
      switch (a) {
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
      };

  static OnLerp<Decoration> _decoration(Decoration a, Decoration b) =>
      switch (a) {
        BoxDecoration _ => b is BoxDecoration && a.shape == b.shape
            ? (t) => BoxDecoration.lerp(a, b, t)!
            : throw UnimplementedError('BoxShape should not be interpolated'),
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
      };
}

///
///
///
/// instance methods:
/// [getPerspective]
/// [setPerspective], [setDistance]
/// [copyPerspective], [identityPerspective]
///
/// [_translate], [_rotate], [_scaled]
///
/// static methods:
/// [translating], [rotating], [scaling]
/// [mapTranslating], [mapRotating], [mapScaling]
/// [fixedTranslating], [fixedRotating], [fixedScaling]
///
///
extension FOnAnimateMatrix4 on Matrix4 {
  double getPerspective() => entry(3, 2);

  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  Matrix4 get identityPerspective => Matrix4.identity()..copyPerspective(this);

  void _translate(Coordinate coordinate) =>
      translate(coordinate.dx, coordinate.dy, coordinate.dz);

  void _rotate(Coordinate coordinate) => this
    ..rotateX(coordinate.dx)
    ..rotateY(coordinate.dy)
    ..rotateZ(coordinate.dz);

  Matrix4 _scaled(Coordinate coordinate) => scaled(
        coordinate.dx,
        coordinate.dy,
        coordinate.dz,
      );

  ///
  ///
  /// statics
  ///
  ///
  static Matrix4 translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective.._translate(value);

  static Matrix4 rotating(Matrix4 matrix4, Coordinate value) =>
      matrix4..setRotation((Matrix4.identity().._rotate(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4._scaled(value);

// with mapper
  static OnAnimateMatrix4 mapTranslating(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        .._translate(mapper(value));

  static OnAnimateMatrix4 mapRotating(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity().._rotate(mapper(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4._scaled(mapper(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        .._translate(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity().._rotate(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
      (matrix4, value) => matrix4._scaled(value + fixed);
}


