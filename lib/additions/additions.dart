// ignore_for_file: constant_identifier_names
part of '../mationani.dart';

///
/// this file contains:
///
/// [DurationFR], [CurveFR]
/// [Clipping], [Painting]
///
/// [Operator]
/// [Direction]
///   [Direction2DIn4]
///   [Direction2DIn8]
///   [Direction3DIn6]
///   [Direction3DIn14]
///   [Direction3DIn22]
/// [Coordinate]
///   * [_CoordinateBase]
/// [Vector3D]
/// [Curving]
/// [RegularPolygon]
///   [RRegularPolygon]
///     [RRegularPolygonCubicOnEdge]
///       [RsRegularPolygon]
///       ...
///
/// [IconAction]
///
/// private usages:
/// [_IconActionListExtension]
/// [_AnimationsBuilder], [_AnimationControllerExtension]
/// [_FOnLerp], [_FOnAnimateMatrix4]
/// [_Matrix4Extension]
/// [_PathOperationExtension]
///
///
///
///
///

class DurationFR {
  final Duration forward;
  final Duration reverse;

  const DurationFR(this.forward, this.reverse);

  const DurationFR.constant(Duration duration)
      : forward = duration,
        reverse = duration;

  static const DurationFR zero = DurationFR.constant(Duration.zero);

  DurationFR operator ~/(int value) =>
      DurationFR(forward ~/ value, reverse ~/ value);

  DurationFR operator +(Duration value) =>
      DurationFR(forward + value, reverse + value);

  DurationFR operator -(Duration value) =>
      DurationFR(forward - value, reverse - value);

  @override
  int get hashCode => Object.hash(forward, reverse);

  @override
  bool operator ==(covariant DurationFR other) => hashCode == other.hashCode;

  @override
  String toString() => 'DurationFR(forward: $forward, reverse:$reverse)';
}

class CurveFR {
  final Curve forward;
  final Curve reverse;

  const CurveFR(this.forward, this.reverse);

  const CurveFR.symmetry(Curve curve)
      : forward = curve,
        reverse = curve;

  CurveFR.intervalFlip(double begin, double end, CurveFR curve)
      : forward = Interval(begin, end, curve: curve.forward),
        reverse = Interval(begin, end, curve: curve.reverse);

  CurveFR interval(double begin, double end) => CurveFR(
        Interval(begin, end, curve: forward),
        Interval(begin, end, curve: reverse),
      );

  CurveFR get flipped => CurveFR(reverse, forward);
}

///
///
/// [_shouldReClip]
/// [sizingPath]
///
/// [Clipping.reclipWhenUpdate]
/// [Clipping.reclipNever]
///
/// [Clipping.rectOf]
/// [Clipping.rectFromZeroTo]
/// [Clipping.rectFromZeroToOffset]
/// [Clipping.polygonCubicCornerFromSize]
///
///
///
class Clipping extends CustomClipper<Path> {
  final SizingPath sizingPath;
  final Combiner<Clipping, bool> _shouldReClip;

  @override
  Path getClip(Size size) => sizingPath(size);

  @override
  bool shouldReclip(Clipping oldClipper) => _shouldReClip(oldClipper, this);

  static bool _reclipWhenUpdate(Clipping oldC, Clipping c) => true;

  static bool _reclipNever(Clipping oldC, Clipping c) => false;

  const Clipping.reclipWhenUpdate(this.sizingPath)
      : _shouldReClip = _reclipWhenUpdate;

  const Clipping.reclipNever(this.sizingPath) : _shouldReClip = _reclipNever;

  ///
  ///
  /// factories
  ///
  ///

  factory Clipping.rectOf(Rect rect) =>
      Clipping.reclipNever(FSizingPath.rect(rect));

  factory Clipping.rectFromZeroTo(Size size) =>
      Clipping.rectOf(Offset.zero & size);

  factory Clipping.rectFromZeroToOffset(Offset corner) =>
      Clipping.rectOf(Rect.fromPoints(Offset.zero, corner));

  factory Clipping.polygonCubicCornerFromSize(RRegularPolygon polygon) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubicFromSize(polygon.cubicPoints),
      );
}

///
/// [_shouldRePaint]
/// [sizingPaintFromCanvas]
/// [sizingPath]
/// [paintingPath]
///
/// [draw]
///
/// [Painting.rePaintWhenUpdate]
/// [Painting.rePaintNever]
///
///
///
///
class Painting extends CustomPainter {
  final Combiner<Painting, bool> _shouldRePaint;
  final SizingPaintFromCanvas sizingPaintFromCanvas;
  final SizingPath sizingPath;
  final PaintingPath paintingPath;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = sizingPaintFromCanvas(canvas, size);
    final path = sizingPath(size);
    paintingPath(canvas, paint, path);
  }

  @override
  bool shouldRepaint(Painting oldDelegate) => _shouldRePaint(oldDelegate, this);

  ///
  /// paint with path
  ///
  static void draw(Canvas canvas, Paint paint, Path path) =>
      canvas.drawPath(path, paint);

  static bool _rePaintWhenUpdate(Painting oldP, Painting p) => true;

  static bool _rePaintNever(Painting oldP, Painting p) => false;

  const Painting.rePaintWhenUpdate({
    this.paintingPath = draw,
    required this.sizingPath,
    required this.sizingPaintFromCanvas,
  }) : _shouldRePaint = _rePaintWhenUpdate;

  const Painting.rePaintNever({
    this.paintingPath = draw,
    required this.sizingPaintFromCanvas,
    required this.sizingPath,
  }) : _shouldRePaint = _rePaintNever;

  ///
  ///
  /// factories
  ///
  ///
  factory Painting.polygonCubicCorner(
    SizingPaintFromCanvas paintFromCanvasSize,
    RRegularPolygon polygon,
  ) =>
      Painting.rePaintNever(
        sizingPaintFromCanvas: paintFromCanvasSize,
        sizingPath: FSizingPath.polygonCubic(polygon.cubicPoints),
      );
}

enum Operator {
  plus,
  minus,
  multiply,
  divide,
  modulus,
  ;

  @override
  String toString() => switch (this) {
        Operator.plus => '+',
        Operator.minus => '-',
        Operator.multiply => '*',
        Operator.divide => '/',
        Operator.modulus => '%',
      };

  String get latex => switch (this) {
        Operator.plus => r'+',
        Operator.minus => r'-',
        Operator.multiply => r'\times',
        Operator.divide => r'\div',
        Operator.modulus => throw UnimplementedError(),
      };

  ///
  /// latex operation
  ///
  String latexOperationOf(String a, String b) => "$a $latex $b";

  String latexOperationOfDouble(double a, double b, {int fix = 0}) =>
      "${a.toStringAsFixed(fix)} "
      "$latex "
      "${b.toStringAsFixed(fix)}";

  ///
  /// operate value
  ///
  double operateDouble(double a, double b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        Operator.multiply => a * b,
        Operator.divide => a / b,
        Operator.modulus => a % b,
      };

  static double operateDoubleAll(
    double value,
    Iterable<(Operator, double)> operations,
  ) =>
      operations.fold(
        value,
        (a, opertion) => switch (opertion.$1) {
          Operator.plus => a + opertion.$2,
          Operator.minus => a - opertion.$2,
          Operator.multiply => a * opertion.$2,
          Operator.divide => a / opertion.$2,
          Operator.modulus => a % opertion.$2,
        },
      );

  Duration operateDuration(Duration a, Duration b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        _ => throw UnimplementedError(),
      };

  DurationFR operateDurationFR(DurationFR a, DurationFR b) => switch (this) {
        Operator.plus =>
          DurationFR(a.forward + b.forward, a.reverse + b.reverse),
        Operator.minus =>
          DurationFR(a.forward - b.forward, a.reverse - b.reverse),
        _ => throw UnimplementedError(),
      };

  T operationOf<T>(T a, T b) => switch (a) {
        double _ => operateDouble(a, b as double),
        Duration _ => operateDuration(a, b as Duration),
        DurationFR _ => operateDurationFR(a, b as DurationFR),
        _ => throw UnimplementedError(),
      } as T;

  ///
  /// mapper
  ///

  double Function(double value) doubleCompanion(double b) => switch (this) {
        Operator.plus => (a) => a + b,
        Operator.minus => (a) => a - b,
        Operator.multiply => (a) => a * b,
        Operator.divide => (a) => a / b,
        Operator.modulus => (a) => a % b,
      };
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
/// direction
///
///
///
/// See Also:
///   * [KRadian]
///   * [_MationTransformBase], [MationTransform]
///   * [Coordinate.transferToTransformOf], [Coordinate.fromDirection]
///
///
///
///
///
///
///

base mixin Direction<D> {
  D get flipped;

  Offset get toOffset;

  Coordinate get toCoordinate;

  static const radian2D_right = 0;
  static const radian2D_bottomRight = KRadian.angle_45;
  static const radian2D_bottom = KRadian.angle_90;
  static const radian2D_bottomLeft = KRadian.angle_135;
  static const radian2D_left = KRadian.angle_180;
  static const radian2D_topLeft = KRadian.angle_225;
  static const radian2D_top = KRadian.angle_270;
  static const radian2D_topRight = KRadian.angle_315;

  static const offset_top = Offset(0, -1);
  static const offset_left = Offset(-1, 0);
  static const offset_right = Offset(1, 0);
  static const offset_bottom = Offset(0, 1);
  static const offset_center = Offset.zero;
  static const offset_topLeft = Offset(-math.sqrt1_2, -math.sqrt1_2);
  static const offset_topRight = Offset(math.sqrt1_2, -math.sqrt1_2);
  static const offset_bottomLeft = Offset(-math.sqrt1_2, math.sqrt1_2);
  static const offset_bottomRight = Offset(math.sqrt1_2, math.sqrt1_2);

  static const coordinate_center = Coordinate.zero;
  static const coordinate_left = Coordinate.ofX(-1);
  static const coordinate_top = Coordinate.ofY(-1);
  static const coordinate_right = Coordinate.ofX(1);
  static const coordinate_bottom = Coordinate.ofY(1);
  static const coordinate_front = Coordinate.ofZ(1);
  static const coordinate_back = Coordinate.ofZ(-1);

  static const coordinate_topLeft =
      Coordinate.ofXY(-math.sqrt1_2, -math.sqrt1_2);
  static const coordinate_topRight =
      Coordinate.ofXY(math.sqrt1_2, -math.sqrt1_2);
  static const coordinate_bottomLeft =
      Coordinate.ofXY(-math.sqrt1_2, math.sqrt1_2);
  static const coordinate_bottomRight =
      Coordinate.ofXY(math.sqrt1_2, math.sqrt1_2);
  static const coordinate_frontLeft =
      Coordinate.ofXZ(-math.sqrt1_2, math.sqrt1_2);
  static const coordinate_frontTop =
      Coordinate.ofYZ(-math.sqrt1_2, math.sqrt1_2);
  static const coordinate_frontRight =
      Coordinate.ofXZ(math.sqrt1_2, math.sqrt1_2);
  static const coordinate_frontBottom =
      Coordinate.ofYZ(math.sqrt1_2, math.sqrt1_2);
  static const coordinate_backLeft =
      Coordinate.ofXZ(-math.sqrt1_2, -math.sqrt1_2);
  static const coordinate_backTop =
      Coordinate.ofYZ(-math.sqrt1_2, -math.sqrt1_2);
  static const coordinate_backRight =
      Coordinate.ofXZ(math.sqrt1_2, -math.sqrt1_2);
  static const coordinate_backBottom =
      Coordinate.ofYZ(math.sqrt1_2, -math.sqrt1_2);

  static const coordinate_frontTopLeft = Coordinate(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontTopRight = Coordinate(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomLeft = Coordinate(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomRight = Coordinate(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_backTopLeft = Coordinate(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backTopRight = Coordinate(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomLeft = Coordinate(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomRight = Coordinate(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
}

enum Direction2DIn4 with Direction<Direction2DIn4> {
  left,
  right,
  top,
  bottom;

  @override
  Direction2DIn4 get flipped => switch (this) {
        Direction2DIn4.left => Direction2DIn4.right,
        Direction2DIn4.right => Direction2DIn4.left,
        Direction2DIn4.top => Direction2DIn4.top,
        Direction2DIn4.bottom => Direction2DIn4.bottom,
      };

  @override
  Offset get toOffset => switch (this) {
        Direction2DIn4.left => Direction.offset_left,
        Direction2DIn4.right => Direction.offset_right,
        Direction2DIn4.top => Direction.offset_top,
        Direction2DIn4.bottom => Direction.offset_bottom,
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        Direction2DIn4.left => Direction.coordinate_left,
        Direction2DIn4.right => Direction.coordinate_right,
        Direction2DIn4.top => Direction.coordinate_top,
        Direction2DIn4.bottom => Direction.coordinate_bottom,
      };
}

enum Direction2DIn8 with Direction<Direction2DIn8> {
  topLeft,
  top,
  topRight,
  left,
  right,
  bottomLeft,
  bottom,
  bottomRight;

  @override
  Direction2DIn8 get flipped => switch (this) {
        top => Direction2DIn8.bottom,
        left => Direction2DIn8.right,
        right => Direction2DIn8.left,
        bottom => Direction2DIn8.top,
        topLeft => Direction2DIn8.bottomRight,
        topRight => Direction2DIn8.bottomLeft,
        bottomLeft => Direction2DIn8.topRight,
        bottomRight => Direction2DIn8.topLeft,
      };

  @override
  Offset get toOffset => switch (this) {
        top => Direction.offset_top,
        left => Direction.offset_left,
        right => Direction.offset_right,
        bottom => Direction.offset_bottom,
        topLeft => Direction.offset_topLeft,
        topRight => Direction.offset_topRight,
        bottomLeft => Direction.offset_bottomLeft,
        bottomRight => Direction.offset_bottomRight,
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        top => Direction.coordinate_top,
        left => Direction.coordinate_left,
        right => Direction.coordinate_right,
        bottom => Direction.coordinate_bottom,
        topLeft => Direction.coordinate_topLeft,
        topRight => Direction.coordinate_topRight,
        bottomLeft => Direction.coordinate_bottomLeft,
        bottomRight => Direction.coordinate_bottomRight,
      };

  Alignment get toAlignment => switch (this) {
        top => Alignment.topCenter,
        left => Alignment.centerLeft,
        right => Alignment.centerRight,
        bottom => Alignment.bottomCenter,
        topLeft => Alignment.topLeft,
        topRight => Alignment.topRight,
        bottomLeft => Alignment.bottomLeft,
        bottomRight => Alignment.bottomRight,
      };
}

enum Direction3DIn6 with Direction<Direction3DIn6> {
  left,
  top,
  right,
  bottom,
  front,
  back;

  @override
  Direction3DIn6 get flipped => switch (this) {
        Direction3DIn6.left => Direction3DIn6.right,
        Direction3DIn6.top => Direction3DIn6.bottom,
        Direction3DIn6.right => Direction3DIn6.left,
        Direction3DIn6.bottom => Direction3DIn6.top,
        Direction3DIn6.front => Direction3DIn6.back,
        Direction3DIn6.back => Direction3DIn6.front,
      };

  @override
  Offset get toOffset => switch (this) {
        Direction3DIn6.left => Direction.offset_left,
        Direction3DIn6.top => Direction.offset_top,
        Direction3DIn6.right => Direction.offset_right,
        Direction3DIn6.bottom => Direction.offset_bottom,
        _ => throw UnimplementedError(),
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        Direction3DIn6.left => Direction.coordinate_left,
        Direction3DIn6.top => Direction.coordinate_top,
        Direction3DIn6.right => Direction.coordinate_right,
        Direction3DIn6.bottom => Direction.coordinate_bottom,
        Direction3DIn6.front => Direction.coordinate_front,
        Direction3DIn6.back => Direction.coordinate_back,
      };

  ///
  /// The angle value belows are "[Matrix4] radian". see [Coordinate.fromDirection] for my "math radian".
  ///
  /// [front] can be seen within {angleY(-90 ~ 90), angleX(-90 ~ 90)}
  /// [left] can be seen within {angleY(0 ~ -180), angleZ(-90 ~ 90)}
  /// [top] can be seen within {angleX(0 ~ 180), angleZ(-90 ~ 90)}
  /// [back] can be seen while [front] not be seen.
  /// [right] can be seen while [left] not be seen.
  /// [bottom] can be seen while [top] not be seen.
  ///
  ///
  static List<Direction3DIn6> parseRotation(Coordinate radian) {
    // ?
    final r = FRadianCoordinate.restrictInAngle180Of(radian);

    final rX = r.dx;
    final rY = r.dy;
    final rZ = r.dz;

    return <Direction3DIn6>[
      FRadian.ifWithinAngle90_90N(rY) && FRadian.ifWithinAngle90_90N(rX)
          ? Direction3DIn6.front
          : Direction3DIn6.back,
      FRadian.ifWithinAngle0_180N(rY) && FRadian.ifWithinAngle90_90N(rZ)
          ? Direction3DIn6.left
          : Direction3DIn6.right,
      FRadian.ifWithinAngle0_180(rX) && FRadian.ifWithinAngle90_90N(rZ)
          ? Direction3DIn6.top
          : Direction3DIn6.bottom,
    ];
  }

  Widget buildTransform({
    Coordinate initialRadian = Coordinate.zero,
    double zDeep = 100,
    required Widget child,
  }) {
    Matrix4 instance() => Matrix4.identity();
    return initialRadian == Coordinate.zero
        ? switch (this) {
            Direction3DIn6.front => Transform(
                transform: instance(),
                alignment: Alignment.center,
                child: child,
              ),
            Direction3DIn6.back => Transform(
                transform: instance()..translate(Vector3(0, 0, -zDeep)),
                alignment: Alignment.center,
                child: child,
              ),
            Direction3DIn6.left => Transform(
                alignment: Alignment.centerLeft,
                transform: instance()..rotateY(KRadian.angle_90),
                child: child,
              ),
            Direction3DIn6.right => Transform(
                alignment: Alignment.centerRight,
                transform: instance()..rotateY(-KRadian.angle_90),
                child: child,
              ),
            Direction3DIn6.top => Transform(
                alignment: Alignment.topCenter,
                transform: instance()..rotateX(-KRadian.angle_90),
                child: child,
              ),
            Direction3DIn6.bottom => Transform(
                alignment: Alignment.bottomCenter,
                transform: instance()..rotateX(KRadian.angle_90),
                child: child,
              ),
          }
        : throw UnimplementedError();
  }
}

enum Direction3DIn14 with Direction<Direction3DIn14> {
  left,
  top,
  right,
  bottom,
  front,
  frontLeft,
  frontTop,
  frontRight,
  frontBottom,
  back,
  backLeft,
  backTop,
  backRight,
  backBottom;

  @override
  Direction3DIn14 get flipped => switch (this) {
        Direction3DIn14.left => Direction3DIn14.right,
        Direction3DIn14.top => Direction3DIn14.bottom,
        Direction3DIn14.right => Direction3DIn14.left,
        Direction3DIn14.bottom => Direction3DIn14.top,
        Direction3DIn14.front => Direction3DIn14.front,
        Direction3DIn14.frontLeft => Direction3DIn14.frontLeft,
        Direction3DIn14.frontTop => Direction3DIn14.frontTop,
        Direction3DIn14.frontRight => Direction3DIn14.frontRight,
        Direction3DIn14.frontBottom => Direction3DIn14.frontBottom,
        Direction3DIn14.back => Direction3DIn14.back,
        Direction3DIn14.backLeft => Direction3DIn14.backLeft,
        Direction3DIn14.backTop => Direction3DIn14.backTop,
        Direction3DIn14.backRight => Direction3DIn14.backRight,
        Direction3DIn14.backBottom => Direction3DIn14.backBottom,
      };

  @override
  Offset get toOffset => switch (this) {
        Direction3DIn14.left => Direction.offset_left,
        Direction3DIn14.top => Direction.offset_top,
        Direction3DIn14.right => Direction.offset_right,
        Direction3DIn14.bottom => Direction.offset_bottom,
        _ => throw UnimplementedError(),
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        Direction3DIn14.left => Direction.coordinate_left,
        Direction3DIn14.top => Direction.coordinate_top,
        Direction3DIn14.right => Direction.coordinate_right,
        Direction3DIn14.bottom => Direction.coordinate_bottom,
        Direction3DIn14.front => Direction.coordinate_front,
        Direction3DIn14.frontLeft => Direction.coordinate_frontLeft,
        Direction3DIn14.frontTop => Direction.coordinate_frontTop,
        Direction3DIn14.frontRight => Direction.coordinate_frontRight,
        Direction3DIn14.frontBottom => Direction.coordinate_frontBottom,
        Direction3DIn14.back => Direction.coordinate_back,
        Direction3DIn14.backLeft => Direction.coordinate_backLeft,
        Direction3DIn14.backTop => Direction.coordinate_backTop,
        Direction3DIn14.backRight => Direction.coordinate_backRight,
        Direction3DIn14.backBottom => Direction.coordinate_backBottom,
      };
}

enum Direction3DIn22 {
  top;
}

///
///
///
///
///
///
///
/// coordinate
///
///
///
///
///
///
///
///
///

class Coordinate extends Offset with _CoordinateBase {
  @override
  final double dz;

  const Coordinate(super.dx, super.dy, this.dz);

  const Coordinate.cube(double dimension)
      : dz = dimension,
        super(dimension, dimension);

  const Coordinate.ofX(double x)
      : dz = 0,
        super(x, 0);

  const Coordinate.ofY(double y)
      : dz = 0,
        super(0, y);

  const Coordinate.ofZ(double z)
      : dz = z,
        super(0, 0);

  const Coordinate.ofXY(super.dx, super.dy) : dz = 0;

  const Coordinate.ofYZ(double dy, this.dz) : super(0, dy);

  const Coordinate.ofXZ(double dx, this.dz) : super(dx, 0);

  static const Coordinate zero = Coordinate.cube(0);

  static Coordinate maxDistance(Coordinate a, Coordinate b) =>
      a.distance > b.distance ? a : b;

  ///
  ///
  /// [Coordinate.transferToTransformOf] transfer from my coordinate system:
  /// x axis is [Direction3DIn6.left] -> [Direction3DIn6.right], radian start from [Direction3DIn6.back]
  /// y axis is [Direction3DIn6.front] -> [Direction3DIn6.back], radian start from [Direction3DIn6.left]
  /// z axis is [Direction3DIn6.bottom] -> [Direction3DIn6.top], radian start from [Direction3DIn6.right]
  /// (see [Coordinate.fromDirection] for implementation)
  ///
  /// to dart matrix4 coordinate system (see the comment over [_MationTransformBase] for detail):
  /// x axis is [Direction3DIn6.left] -> [Direction3DIn6.right], radian start from [Direction3DIn6.back] ?
  /// y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom], radian start from [Direction3DIn6.left] ?
  /// z axis is [Direction3DIn6.front] -> [Direction3DIn6.back], radian start from [Direction3DIn6.right]
  ///
  ///
  /// See Also:
  ///   * [Offset.fromDirection], [Coordinate.fromDirection]
  ///   * [KDirection], [KCoordinateDirection]
  ///   * [_MationTransformBase], [MationTransform]
  ///
  static Coordinate transferToTransformOf(Coordinate radian) => Coordinate(
        radian.dx,
        -radian.dz,
        -radian.dy,
      );

  factory Coordinate.fromDirection({
    required Coordinate direction,
    required double distance,
    Coordinate scale = KCoordinate.cube_1,
  }) {
    final rX = direction.dx;
    final rY = direction.dy;
    final rZ = direction.dz;
    return Coordinate(
      distance * (math.cos(rZ) * math.cos(rY)),
      distance * (math.sin(rZ) * math.cos(rX)),
      distance * (math.sin(rX) * math.sin(rY)),
    );
  }

  Coordinate scaling(Coordinate scale) =>
      super.scale(scale.dx, scale.dy, scaleZ: scale.dz);

  Coordinate abs() => Coordinate(dx.abs(), dy.abs(), dz.abs());
}

mixin _CoordinateBase on Offset {
  double get dz;

  bool get isNot3D => (dz == 0 || dx == 0 || dy == 0);

  bool get isNegative => (dz < 0 && dx < 0 && dy < 0);

  bool get hasNegative => (dz < 0 || dx < 0 || dy < 0);

  bool get hasNoXY => (dx == 0 && dy == 0);

  Coordinate get modulus360Angle => Coordinate(
        dx % KRadian.angle_360,
        dy % KRadian.angle_360,
        dz % KRadian.angle_360,
      );

  Coordinate get modulus180Angle => Coordinate(
        dx % KRadian.angle_180,
        dy % KRadian.angle_180,
        dz % KRadian.angle_180,
      );

  Coordinate get modulus90Angle => Coordinate(
        dx % KRadian.angle_90,
        dy % KRadian.angle_90,
        dz % KRadian.angle_90,
      );

  Coordinate get retainX => Coordinate(dx, 0, 0);

  Coordinate get retainY => Coordinate(0, dy, 0);

  Coordinate get retainXY => Coordinate(dx, dy, 0);

  Coordinate get retainYZAsYX => Coordinate(dz, dy, 0);

  Coordinate get retainYZAsXY => Coordinate(dy, dz, 0);

  Coordinate get retainXZAsXY => Coordinate(dx, dz, 0);

  Coordinate get retainXZAsYX => Coordinate(dz, dx, 0);

  Coordinate get roundup => Coordinate(
        dx.roundToDouble(),
        dy.roundToDouble(),
        dz.roundToDouble(),
      );

  @override
  double get distanceSquared => super.distanceSquared + dz * dz;

  @override
  double get distance => math.sqrt(distanceSquared);

  double get volume => dx * dy * dz;

  @override
  double get direction => throw UnimplementedError();

  @override
  bool get isFinite => super.isFinite && dz.isFinite;

  @override
  bool get isInfinite => super.isInfinite && dz.isInfinite;

  @override
  Coordinate operator +(covariant Coordinate other) =>
      Coordinate(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Coordinate operator -(covariant Coordinate other) =>
      Coordinate(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Coordinate operator -() => Coordinate(-dx, -dy, -dz);

  @override
  Coordinate operator *(double operand) => Coordinate(
        dx * operand,
        dy * operand,
        dz * operand,
      );

  @override
  Coordinate operator /(double operand) => Coordinate(
        dx / operand,
        dy / operand,
        dz / operand,
      );

  @override
  Coordinate operator ~/(double operand) => Coordinate(
        (dx ~/ operand).toDouble(),
        (dy ~/ operand).toDouble(),
        (dz ~/ operand).toDouble(),
      );

  @override
  Coordinate operator %(double operand) => Coordinate(
        dx % operand,
        dy % operand,
        dz % operand,
      );

  @override
  bool operator <(covariant Coordinate other) =>
      dz < other.dz && (super < other);

  @override
  bool operator <=(covariant Coordinate other) =>
      dz <= other.dz && (super <= other);

  @override
  bool operator >(covariant Coordinate other) =>
      dz > other.dz && (super > other);

  @override
  bool operator >=(covariant Coordinate other) =>
      dz >= other.dz && (super >= other);

  @override
  bool operator ==(covariant Coordinate other) =>
      dz == other.dz && (super == other);

  @override
  int get hashCode => Object.hash(super.hashCode, dz);

  @override
  Rect operator &(Size other) =>
      isNot3D ? (super & other) : (throw UnimplementedError());

  @override
  Coordinate scale(
    double scaleX,
    double scaleY, {
    double scaleZ = 0,
  }) =>
      Coordinate(dx * scaleX, dy * scaleY, dz * scaleZ);

  @override
  Coordinate translate(
    double translateX,
    double translateY, {
    double translateZ = 0,
  }) =>
      Coordinate(
        dx + translateX,
        dy + translateY,
        dz + translateZ,
      );

  @override
  String toString() => 'Coordinate('
      '${dx.toStringAsFixed(1)}, '
      '${dy.toStringAsFixed(1)}, '
      '${dz.toStringAsFixed(1)})';
}

class Vector3D {
  final Coordinate direction;
  final double distance;

  const Vector3D(this.direction, this.distance);

  Offset get toOffset => Offset.fromDirection(-direction.dy, distance);

  Coordinate get toCoordinate => Coordinate.fromDirection(
        direction: direction,
        distance: distance,
      );

  Vector3D rotated(Coordinate d) => Vector3D(direction + d, distance);

  @override
  String toString() => "Vector($direction, $distance)";

  static Vector3D lerp(Vector3D begin, Vector3D end, double t) => Vector3D(
      Tween(
        begin: begin.direction,
        end: end.direction,
      ).transform(t),
      Tween(
        begin: begin.distance,
        end: end.distance,
      ).transform(t));
}

class Curving extends Curve {
  final Mapper<double> mapper;

  const Curving(this.mapper);

  Curving.sinPeriodOf(int times)
      : mapper = FMapperDouble.sinFromPeriod(times.toDouble());

  @override
  double transformInternal(double t) => mapper(t);
}

///
///
///
/// regular polygon
///
///
///

abstract class RegularPolygon {
  static double radianCornerOf(int n) => (n - 2) * KRadian.angle_180 / n;

  static double lengthSideOf(int n, num radiusCircumscribedCircle) => math.sqrt(
        radiusCircumscribedCircle.square *
            2 *
            (1 - math.cos(KRadian.angle_360 / n)),
      );

  static List<Offset> cornersOf(
    int n,
    num radiusCircumscribedCircle, {
    Size? size,
  }) {
    final step = KRadian.angle_360 / n;
    final center = size?.center(Offset.zero) ?? Offset.zero;
    return List.generate(
      n,
      (i) =>
          center +
          Offset.fromDirection(step * i, radiusCircumscribedCircle.toDouble()),
      growable: false,
    );
  }

  static double inscribedCircleRadiusOf(
    int n,
    num radiusCircumscribedCircle,
    double radianCorner,
  ) =>
      switch (n) {
        3 => radiusCircumscribedCircle / 2,
        4 => radiusCircumscribedCircle * DoubleExtension.sqrt1_2,
        6 => radiusCircumscribedCircle * DoubleExtension.sqrt3 / 2,
        _ => radiusCircumscribedCircle *
            math.sin(FRadian.radianOf(FRadian.angleOf(radianCorner) / 2)),
      };

  /// properties

  final int n;
  final double radiusCircumscribedCircle;

  List<Offset> get corners => cornersOf(n, radiusCircumscribedCircle);

  double get lengthSide => lengthSideOf(n, radiusCircumscribedCircle);

  double get radianSideSide => radianCornerOf(n);

  double get radianCornerCenterSide => KRadian.angle_180 / n;

  double get radiusInscribedCircle => inscribedCircleRadiusOf(
        n,
        radiusCircumscribedCircle,
        radianSideSide,
      );

  const RegularPolygon(
    this.n, {
    required this.radiusCircumscribedCircle,
  });
}

sealed class RRegularPolygon extends RegularPolygon {
  final double cornerRadius;
  final Mapper<Map<Offset, List<Offset>>> cubicPointsMapper;
  final Companion<Iterable<Offset>, Size> cornerAdjust;

  Map<Offset, List<Offset>> get cubicPointsForEachCorners;

  Iterable<List<Offset>> get cubicPoints =>
      cubicPointsMapper(cubicPointsForEachCorners).values;

  const RRegularPolygon(
    super.n, {
    required this.cornerRadius,
    required this.cornerAdjust,
    required this.cubicPointsMapper,
    required super.radiusCircumscribedCircle,
  });
}

///
///
/// [RRegularPolygonCubicOnEdge.cubicPointsForEachCorners]
/// [RRegularPolygonCubicOnEdge.timesForEdgeUnitOf]
/// [RRegularPolygonCubicOnEdge.cubicPointsForEachCornersOf]
///
/// each list of [cubicPointsForEachCorners] is based on the constant properties of [RRegularPolygonCubicOnEdge].
///
/// See Also:
///   * [KMapperCubicPointsPermutation]
///   * [FSizingPath.polygonCubic], [FSizingPath.polygonCubicFromSize]
///   * [BetweenRRegularPolygon.cubicOnEdge]
///
/// TODO: create [CubicOffset] class with two [Cubic] as properties to replace [List]<[Offset]>
///
///
class RRegularPolygonCubicOnEdge extends RRegularPolygon {
  final double timesForEdge;

  const RRegularPolygonCubicOnEdge(
    super.n, {
    this.timesForEdge = 0,
    super.cornerRadius = 0,

    // [cornerPrevious, controlPointA, controlPointB, cornerNext]
    super.cubicPointsMapper = KMapperCubicPointsPermutation.p0231,
    super.cornerAdjust = IterableOffsetExtension.adjustCenterCompanion,
    required super.radiusCircumscribedCircle,
  });

  Iterable<List<Offset>> _cubicPointsOf(
    double cornerRadius,
    double timesForEdge,
  ) =>
      cubicPointsMapper(cubicPointsForEachCornersOf(
        timesForEdgeUnitOf(cornerRadius),
        timesForEdge,
      )).values;

  @override
  Map<Offset, List<Offset>> get cubicPointsForEachCorners =>
      cubicPointsForEachCornersOf(
        timesForEdgeUnitOf(cornerRadius),
        timesForEdge,
      );

  double timesForEdgeUnitOf(double cornerRadius) =>
      cornerRadius * math.tan(KRadian.angle_180 / n);

  Map<Offset, List<Offset>> cubicPointsForEachCornersOf(
    double timesForEdgeUnit,
    double timesForEdge,
  ) =>
      corners
          .asMap()

          // [cornerPrevious, cornerNext]
          .map((index, current) => MapEntry(
                current,
                [
                  // offset from current corner to previous corner
                  OffsetExtension.parallelOffsetUnitOf(
                    current,
                    index == 0 ? corners.last : corners[index - 1],
                    timesForEdgeUnit,
                  ),

                  // offset from current corner to next corner
                  OffsetExtension.parallelOffsetUnitOf(
                    current,
                    index == n - 1 ? corners.first : corners[index + 1],
                    timesForEdgeUnit,
                  )
                ],
              ))

          // [controlPointA, controlPointB,]
          .map(
            (current, list) => MapEntry(
              current,
              list
                ..add(OffsetExtension.parallelOffsetOf(
                  list[0],
                  current,
                  timesForEdge,
                ))
                ..add(OffsetExtension.parallelOffsetOf(
                  current,
                  list[1],
                  timesForEdge,
                )),
            ),
          );

  ///
  ///
  /// the "steps" below [stepsOfCornerRadius], [stepsOfEdgeTimes] are some values that can help to create [cornerRadius]
  ///
  ///
  List<double> get stepsOfCornerRadius => [
        double.negativeInfinity,
        0, // no radius (cause a normal regular polygon)
        stepCornerRadiusInscribedCircle,
        stepCornerRadiusFragmentFitCorner(),
        stepCornerRadiusArcCrossCenter(),
        double.infinity,
      ];

  List<double> get stepsOfEdgeTimes => [
        double.negativeInfinity,
        0,
        1,
        double.infinity,
      ];

  ///
  /// the 'Pa' in below discussion, treats as every corner in [corners], and also,
  /// a = [radianSideSide],
  /// c = [radianCornerCenterSide],
  /// Rc = [radiusCircumscribedCircle],
  /// Ri = [radiusInscribedCircle]
  ///
  /// Pa----------------Pb----------(La)
  ///  --            -------
  ///    --       --    -    --
  ///      --    -      -      -
  ///        -- -      Pc       - (the circle with radius R (PbPc = PcPd = R))
  ///          ---   --        -
  ///            -Pd         --
  ///              ---------
  ///                --
  ///                  (Lb)
  ///

  ///
  /// [stepCornerRadiusInscribedCircle] is the step that
  /// 1. PaPc = Rc
  /// 2. R = Ri
  /// 3. cos(c) = Ri / Rc
  ///
  double get stepCornerRadiusInscribedCircle => radiusInscribedCircle;

  ///
  /// when [inset] = 0 in [stepCornerRadiusFragmentFitCorner], it means that each corner's Pb and Pd are overlap on the nearest two [corners],
  /// which implies: [lengthSide] = PaPb = PaPd = |[timesForEdgeUnit] * borderVectorUnit|
  ///
  ///   [lengthSide] = |[timesForEdgeUnit] * borderVectorUnit| = R * tan(c)
  ///   R = [lengthSide] / tan(c)
  ///
  double stepCornerRadiusFragmentFitCorner({double inset = 0}) =>
      (lengthSide - inset) / math.tan(radianCornerCenterSide);

  ///
  /// when [inset] = 0 in [stepCornerRadiusArcCrossCenter], it means that all [corners]' PbPd arc crossing on the polygon center,
  /// which implies: PaPc = Rc + R
  ///
  ///   cos(c) = R / PaPc = R / (Rc + R)
  ///   Rc * cos(c) = R - R * cos(c)
  ///   R = (Rc * cos(c)) / (1 - cos(c))
  ///
  /// also implies the inequality: Rc + R > (P(0.5) - cornerOffset).distance.
  ///                       (see [PathExtension.cubicToPoint] for detail)
  /// it seems that triangle, square are not satisfy the inequality above,
  /// and P(0.5 - cornerOffset) is too complex to compute. there is two approximate value for triangle and square.
  ///
  double stepCornerRadiusArcCrossCenter({double inset = 0}) => switch (n) {
        3 => radiusCircumscribedCircle * 1.2 - inset,
        4 => radiusCircumscribedCircle * 2.6 - inset,
        _ => ((radiusCircumscribedCircle - inset) *
                math.cos(radianCornerCenterSide)) /
            (1 - math.cos(radianCornerCenterSide)),
      };
}

abstract class RsRegularPolygon extends RRegularPolygon {
  final List<Radius> cornerRadiusList;

  const RsRegularPolygon(
    super.n, {
    required this.cornerRadiusList,
    required super.cornerAdjust,
    required super.cubicPointsMapper,
    required super.radiusCircumscribedCircle,
  }) : super(cornerRadius: 0);
}

///
///
///

class IconAction {
  final Icon icon;
  final VoidCallback action;

  const IconAction(this.icon, this.action);
}

extension _IconActionListExtension on List<IconAction> {
  double maxSizeOf(BuildContext context) =>
      map((e) => e.icon.size ?? context.theme.iconTheme.size ?? 24.0)
          .reduce((a, b) => math.max(a, b));
}

///
///
///
/// private usages:
///
///
///
typedef _AnimationsBuilder<T> = Widget Function(
  Iterable<Animation<T>> animations,
  Widget child,
);

extension _AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void addStatusListenerIfNotNull(AnimationStatusListener? listener) {
    if (listener != null) {
      addStatusListener(listener);
    }
  }
}

extension _FOnLerp on OnLerp {
  static OnLerp<T> constant<T>(T value) => (_) => value;

  static OnLerp<T> of<T>(T a, T b) => switch (a) {
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

extension _FOnAnimateMatrix4 on OnAnimateMatrix4 {
  static Matrix4 _scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4.scaledCoordinate(value);

  static Matrix4 _translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective..translateCoordinate(value);

  static Matrix4 _rotating(Matrix4 matrix4, Coordinate value) => matrix4
    ..setRotation((Matrix4.identity()..rotateCoordinate(value)).getRotation());

  // ///
  // /// with mapper
  // ///
  // static OnAnimateMatrix4 scaleMapping(Mapper<Coordinate> mapper) =>
  //     (matrix4, value) => matrix4.scaledCoordinate(mapper(value));
  //
  // static OnAnimateMatrix4 translateMapping(Mapper<Coordinate> mapper) =>
  //     (matrix4, value) => matrix4
  //       ..identityPerspective
  //       ..translateCoordinate(mapper(value));
  //
  // static OnAnimateMatrix4 rotateMapping(Mapper<Coordinate> mapper) =>
  //     (matrix4, value) => matrix4
  //       ..setRotation((Matrix4.identity()..rotateCoordinate(mapper(value)))
  //           .getRotation());
  //
  // ///
  // /// with fixed value
  // ///
  // static OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
  //     (matrix4, value) => matrix4.scaledCoordinate(value + fixed);
  //
  // static OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
  //     (matrix4, value) => matrix4
  //       ..identityPerspective
  //       ..translateCoordinate(value + fixed);
  //
  // static OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
  //     (matrix4, value) => matrix4
  //       ..setRotation((Matrix4.identity()..rotateCoordinate(fixed + value))
  //           .getRotation());
}

///
///
///
///
///
///
/// extensions
///
///
///
///
///
///
///

extension _Matrix4Extension on Matrix4 {
  Matrix4 scaledCoordinate(Coordinate coordinate) => scaled(
        coordinate.dx,
        coordinate.dy,
        coordinate.dz,
      );

  void rotateCoordinate(Coordinate coordinate) => this
    ..rotateX(coordinate.dx)
    ..rotateY(coordinate.dy)
    ..rotateZ(coordinate.dz);

  void translateCoordinate(Coordinate coordinate) =>
      translate(coordinate.dx, coordinate.dy, coordinate.dz);

  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  double entryPerspective() => entry(3, 2);

  void copyPerspectiveFrom(Matrix4 matrix4) =>
      setPerspective(matrix4.entryPerspective());

  Matrix4 get identityPerspective =>
      Matrix4.identity()..copyPerspectiveFrom(this);
}

extension _PathOperationExtension on PathOperation {
  SizingPath _combine(SizingPath previous, SizingPath next) =>
      (size) => Path.combine(this, previous(size), next(size));

  SizingPath _combineAll(Iterable<SizingPath> iterable) =>
      iterable.reduce((previous, next) => _combine(previous, next));
}
