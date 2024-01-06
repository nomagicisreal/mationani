// ignore_for_file: constant_identifier_names
part of '../mationani.dart';

///
/// this file contains:
/// [SizeExtension], [OffsetExtension], [RectExtension]
/// [AlignmentExtension]
///
/// [KSize], [KSize3Ratio4], [KSize9Ratio16], [KSize16Ratio9]
/// [KDirection], [KOffset], [KOffsetPermutation4], [KCoordinate], [KVector]
///
/// [KRadian], [FRadian], [KRadianCoordinate], [FRadianCoordinate]
/// [FRect]
///
/// [KRadius], [KBorderRadius]
/// [KEdgeInsets]
///
/// [FMapper], [FMapperDouble]
/// [KMapperCubicPointsPermutation]
/// [FGeneratorOffset]
///
///

extension SizeExtension on Size {
  double get diagonal => math.sqrt(width * width + height * height);

  Radius get toRadiusEllipse => Radius.elliptical(width, height);

  Size extrudeHeight(double ratio) => Size(width, width * ratio);

  Size extrudeWidth(double ratio) => Size(height * ratio, height);
}

extension OffsetExtension on Offset {
  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Coordinate get toCoordinate => Coordinate.ofXY(dx, dy);

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
  ///

  ///
  ///
  /// instance methods
  ///
  ///
  String toStringAsFixed1() =>
      '(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';

  double directionTo(Offset p) => (p - this).direction;

  double distanceTo(Offset p) => (p - this).distance;

  double distanceHalfTo(Offset p) => (p - this).distance / 2;

  Offset middleWith(Offset p) => (p + this) / 2;

  Offset direct(double direction, [double distance = 1]) =>
      this + Offset.fromDirection(direction, distance);

  double directionPerpendicular({bool isCounterclockwise = true}) =>
      direction + math.pi / 2 * (isCounterclockwise ? 1 : -1);

  Offset get toPerpendicularUnit =>
      Offset.fromDirection(directionPerpendicular());

  Offset get toPerpendicular =>
      Offset.fromDirection(directionPerpendicular(), distance);

  bool isAtBottomRightOf(Offset offset) => this > offset;

  bool isAtTopLeftOf(Offset offset) => this < offset;

  bool isAtBottomLeftOf(Offset offset) => dx < offset.dx && dy > offset.dy;

  bool isAtTopRightOf(Offset offset) => dx > offset.dx && dy < offset.dy;

  ///
  ///
  /// instance getters
  ///
  ///

  Size get toSize => Size(dx, dy);

  Offset get toReciprocal => Offset(1 / dx, 1 / dy);

  ///
  ///
  /// static methods:
  ///
  ///
  static Offset square(double value) => Offset(value, value);

  ///
  /// [parallelUnitOf]
  /// [parallelVectorOf]
  /// [parallelOffsetOf]
  /// [parallelOffsetUnitOf]
  /// [parallelOffsetUnitOnCenterOf]
  ///
  static Offset parallelUnitOf(Offset a, Offset b) {
    final offset = b - a;
    return offset / offset.distance;
  }

  static Offset parallelVectorOf(Offset a, Offset b, double t) => (b - a) * t;

  static Offset parallelOffsetOf(Offset a, Offset b, double t) =>
      a + parallelVectorOf(a, b, t);

  static Offset parallelOffsetUnitOf(Offset a, Offset b, double t) =>
      a + parallelUnitOf(a, b) * t;

  static Offset parallelOffsetUnitOnCenterOf(Offset a, Offset b, double t) =>
      a.middleWith(b) + parallelUnitOf(a, b) * t;

  ///
  /// [perpendicularUnitOf]
  /// [perpendicularVectorOf]
  /// [perpendicularOffsetOf]
  /// [perpendicularOffsetUnitOf]
  /// [perpendicularOffsetUnitFromCenterOf]
  ///
  static Offset perpendicularUnitOf(Offset a, Offset b) =>
      (b - a).toPerpendicularUnit;

  static Offset perpendicularVectorOf(Offset a, Offset b, double t) =>
      (b - a).toPerpendicular * t;

  static Offset perpendicularOffsetOf(Offset a, Offset b, double t) =>
      a + perpendicularVectorOf(a, b, t);

  static Offset perpendicularOffsetUnitOf(Offset a, Offset b, double t) =>
      a + perpendicularUnitOf(a, b) * t;

  static Offset perpendicularOffsetUnitFromCenterOf(
    Offset a,
    Offset b,
    double t,
  ) =>
      a.middleWith(b) + perpendicularUnitOf(a, b) * t;
}

extension RectExtension on Rect {
  static Rect fromLTSize(double left, double top, Size size) =>
      Rect.fromLTWH(left, top, size.width, size.height);

  static Rect fromOffsetSize(Offset zero, Size size) =>
      Rect.fromLTWH(zero.dx, zero.dy, size.width, size.height);

  static Rect fromCenterSize(Offset center, Size size) =>
      Rect.fromCenter(center: center, width: size.width, height: size.height);

  static Rect fromCircle(Offset center, double radius) =>
      Rect.fromCircle(center: center, radius: radius);

  double get distanceDiagonal => size.diagonal;

  Offset offsetFromAlignment(Alignment value) => switch (value) {
        Alignment.topLeft => topLeft,
        Alignment.topCenter => topCenter,
        Alignment.topRight => topRight,
        Alignment.centerLeft => centerLeft,
        Alignment.center => center,
        Alignment.centerRight => centerRight,
        Alignment.bottomLeft => bottomLeft,
        Alignment.bottomCenter => bottomCenter,
        Alignment.bottomRight => bottomRight,
        _ => throw UnimplementedError(),
      };

  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Offset offsetFromDirection(Direction2DIn8 value) => switch (value) {
        Direction2DIn8.topLeft => topLeft,
        Direction2DIn8.top => topCenter,
        Direction2DIn8.topRight => topRight,
        Direction2DIn8.left => centerLeft,
        Direction2DIn8.right => centerRight,
        Direction2DIn8.bottomLeft => bottomLeft,
        Direction2DIn8.bottom => bottomCenter,
        Direction2DIn8.bottomRight => bottomRight,
      };

  Rect expandToIncludeDirection({
    required Direction2DIn8 direction,
    required double width,
    required double length,
  }) {
    final start = offsetFromDirection(direction);
    return expandToInclude(
      switch (direction) {
        Direction2DIn8.top => Rect.fromPoints(
            start + Offset(width / 2, 0),
            start + Offset(-width / 2, -length),
          ),
        Direction2DIn8.bottom => Rect.fromPoints(
            start + Offset(width / 2, 0),
            start + Offset(-width / 2, length),
          ),
        Direction2DIn8.left => Rect.fromPoints(
            start + Offset(0, width / 2),
            start + Offset(-length, -width / 2),
          ),
        Direction2DIn8.right => Rect.fromPoints(
            start + Offset(0, width / 2),
            start + Offset(length, -width / 2),
          ),
        Direction2DIn8.topLeft => Rect.fromPoints(
            start,
            start + Offset(-length, -length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.topRight => Rect.fromPoints(
            start,
            start + Offset(length, -length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.bottomLeft => Rect.fromPoints(
            start,
            start + Offset(-length, length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.bottomRight => Rect.fromPoints(
            start,
            start + Offset(length, length) * DoubleExtension.sqrt1_2,
          ),
      },
    );
  }

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
}

extension AlignmentExtension on Alignment {
  double get radianRangeForSide {
    final boundary = radianBoundaryForSide;
    return boundary.$2 - boundary.$1;
  }

  (double, double) get radianBoundaryForSide => switch (this) {
        Alignment.center => (0, KRadian.angle_360),
        Alignment.centerLeft => (-KRadian.angle_90, KRadian.angle_90),
        Alignment.centerRight => (KRadian.angle_90, KRadian.angle_270),
        Alignment.topCenter => (0, KRadian.angle_180),
        Alignment.topLeft => (0, KRadian.angle_90),
        Alignment.topRight => (KRadian.angle_90, KRadian.angle_180),
        Alignment.bottomCenter => (KRadian.angle_180, KRadian.angle_360),
        Alignment.bottomLeft => (KRadian.angle_270, KRadian.angle_360),
        Alignment.bottomRight => (KRadian.angle_180, KRadian.angle_270),
        _ => throw UnimplementedError(),
      };

  double radianRangeForSideStepOf(int count) =>
      radianRangeForSide / (this == Alignment.center ? count : count - 1);

  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Generator<double> directionOfSideSpace(bool isClockwise, int count) {
    final boundary = radianBoundaryForSide;
    final origin = isClockwise ? boundary.$1 : boundary.$2;
    final step = radianRangeForSideStepOf(count);

    return isClockwise
        ? (index) => origin + step * index
        : (index) => origin - step * index;
  }

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => begin.directionTo(end);
}

extension KSize on Size {
  static const square_1 = Size.square(1);
  static const square_10 = Size.square(10);
  static const square_20 = Size.square(20);
  static const square_30 = Size.square(30);
  static const square_40 = Size.square(40);
  static const square_50 = Size.square(50);
  static const square_56 = Size.square(56);
  static const square_60 = Size.square(60);
  static const square_70 = Size.square(70);
  static const square_80 = Size.square(80);
  static const square_90 = Size.square(90);
  static const square_100 = Size.square(100);
  static const square_110 = Size.square(110);
  static const square_120 = Size.square(120);
  static const square_130 = Size.square(130);
  static const square_140 = Size.square(140);
  static const square_150 = Size.square(150);
  static const square_160 = Size.square(160);
  static const square_170 = Size.square(170);
  static const square_180 = Size.square(180);
  static const square_190 = Size.square(190);
  static const square_200 = Size.square(200);
  static const square_210 = Size.square(210);
  static const square_220 = Size.square(220);
  static const square_230 = Size.square(230);
  static const square_240 = Size.square(240);
  static const square_250 = Size.square(250);
  static const square_260 = Size.square(260);
  static const square_270 = Size.square(270);
  static const square_280 = Size.square(280);
  static const square_290 = Size.square(290);
  static const square_300 = Size.square(300);

  // in cm
  static const a4 = Size(21.0, 29.7);
  static const a3 = Size(29.7, 42.0);
  static const a2 = Size(42.0, 59.4);
  static const a1 = Size(59.4, 84.1);
}

extension KSize3Ratio4 on Size {
  static const w360_h480 = Size(360, 480);
  static const w420_h560 = Size(420, 560);
  static const w450_h600 = Size(450, 600);
  static const w480_h640 = Size(480, 640);
}

extension KSize9Ratio16 on Size {
  static const w270_h480 = Size(270, 480);
  static const w405_h720 = Size(405, 720);
  static const w450_h800 = Size(450, 800);
}

extension KSize16Ratio9 on Size {
  static const w800_h450 = Size(800, 450);
}

///
///
///
/// offset, coordinate, vector
///
///
///

extension KOffset on Offset {
  static const square_1 = Offset(1, 1);
  static const square_2 = Offset(2, 2);
  static const square_3 = Offset(3, 3);
  static const square_4 = Offset(4, 4);
  static const square_5 = Offset(5, 5);
  static const square_6 = Offset(6, 6);
  static const square_7 = Offset(7, 7);
  static const square_8 = Offset(8, 8);
  static const square_9 = Offset(9, 9);
  static const square_10 = Offset(10, 10);
  static const square_20 = Offset(20, 20);
  static const square_30 = Offset(30, 30);
  static const square_40 = Offset(40, 40);
  static const square_50 = Offset(50, 50);
  static const square_60 = Offset(60, 60);
  static const square_70 = Offset(70, 70);
  static const square_80 = Offset(80, 80);
  static const square_90 = Offset(90, 90);
  static const square_100 = Offset(100, 100);

  // y == 0
  static const x_1 = Offset(1, 0);
  static const x_2 = Offset(2, 0);
  static const x_3 = Offset(3, 0);
  static const x_4 = Offset(4, 0);
  static const x_5 = Offset(5, 0);
  static const x_6 = Offset(6, 0);
  static const x_7 = Offset(7, 0);
  static const x_8 = Offset(8, 0);
  static const x_9 = Offset(9, 0);
  static const x_10 = Offset(10, 0);
  static const x_20 = Offset(20, 0);
  static const x_30 = Offset(30, 0);
  static const x_40 = Offset(40, 0);
  static const x_50 = Offset(50, 0);
  static const x_60 = Offset(60, 0);
  static const x_70 = Offset(70, 0);
  static const x_80 = Offset(80, 0);
  static const x_90 = Offset(90, 0);
  static const x_100 = Offset(100, 0);
  static const x_110 = Offset(110, 0);

  // x == 0
  static const y_1 = Offset(0, 1);
  static const y_2 = Offset(0, 2);
  static const y_3 = Offset(0, 3);
  static const y_4 = Offset(0, 4);
  static const y_5 = Offset(0, 5);
  static const y_6 = Offset(0, 6);
  static const y_7 = Offset(0, 7);
  static const y_8 = Offset(0, 8);
  static const y_9 = Offset(0, 9);
  static const y_10 = Offset(0, 10);
  static const y_20 = Offset(0, 20);
  static const y_30 = Offset(0, 30);
  static const y_40 = Offset(0, 40);
  static const y_50 = Offset(0, 50);
  static const y_60 = Offset(0, 60);
  static const y_70 = Offset(0, 70);
  static const y_80 = Offset(0, 80);
  static const y_90 = Offset(0, 90);
  static const y_100 = Offset(0, 100);
  static const y_200 = Offset(0, 200);

  // x == 1
  static const xy_1_2 = Offset(1, 2);
  static const xy_1_3 = Offset(1, 3);
  static const xy_1_4 = Offset(1, 4);
  static const xy_1_5 = Offset(1, 5);
  static const xy_1_6 = Offset(1, 6);
  static const xy_1_7 = Offset(1, 7);
  static const xy_1_8 = Offset(1, 8);
  static const xy_1_9 = Offset(1, 9);
  static const xy_1_10 = Offset(1, 10);

  // x == 10
  static const xy_10_20 = Offset(10, 20);
  static const xy_10_30 = Offset(10, 30);
  static const xy_10_40 = Offset(10, 40);
  static const xy_10_50 = Offset(10, 50);
  static const xy_10_60 = Offset(10, 60);
  static const xy_10_70 = Offset(10, 70);
  static const xy_10_80 = Offset(10, 80);
  static const xy_10_90 = Offset(10, 90);
  static const xy_10_10N = Offset(10, -10);
  static const xy_10_20N = Offset(10, -20);
  static const xy_10_30N = Offset(10, -30);
  static const xy_10_40N = Offset(10, -40);
  static const xy_10_50N = Offset(10, -50);
  static const xy_10_60N = Offset(10, -60);
  static const xy_10_70N = Offset(10, -70);
  static const xy_10_80N = Offset(10, -80);
  static const xy_10_90N = Offset(10, -90);

  // x == 100
  static const xy_100_10 = Offset(100, 10);
  static const xy_100_20 = Offset(100, 20);
  static const xy_100_30 = Offset(100, 30);
  static const xy_100_40 = Offset(100, 40);
  static const xy_100_50 = Offset(100, 50);
  static const xy_100_60 = Offset(100, 60);
  static const xy_100_70 = Offset(100, 70);
  static const xy_100_80 = Offset(100, 80);
  static const xy_100_90 = Offset(100, 90);
  static const xy_100_10N = Offset(100, -10);
  static const xy_100_20N = Offset(100, -20);
  static const xy_100_30N = Offset(100, -30);
  static const xy_100_40N = Offset(100, -40);
  static const xy_100_50N = Offset(100, -50);
  static const xy_100_60N = Offset(100, -60);
  static const xy_100_70N = Offset(100, -70);
  static const xy_100_80N = Offset(100, -80);
  static const xy_100_90N = Offset(100, -90);
  static const xy_100_100N = Offset(100, -100);
}

extension KOffsetPermutation4 on List<Offset> {
  // 0, 1, 2, 3
  // 1, 2, 3, a (add a, remove a)
  // 2, 3, a, b
  // 3, a, 1, c
  static List<Offset> p0123(List<Offset> list) => list;

  static List<Offset> p1230(List<Offset> list) =>
      list..addFirstAndRemoveFirst();

  static List<Offset> p2301(List<Offset> list) =>
      p1230(list)..addFirstAndRemoveFirst();

  static List<Offset> p3012(List<Offset> list) =>
      p2301(list)..addFirstAndRemoveFirst();

  // a, 2, 3, b (add 1, remove b)
  // 2, 3, 1, a
  // 3, 1, a, c
  // 1, a, 2, d
  static List<Offset> p0231(List<Offset> list) => list
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p2310(List<Offset> list) =>
      p0231(list)..addFirstAndRemoveFirst();

  static List<Offset> p3102(List<Offset> list) =>
      p2310(list)..addFirstAndRemoveFirst();

  static List<Offset> p1023(List<Offset> list) =>
      p3102(list)..addFirstAndRemoveFirst();

  // 0, 1, 3, 2 (add 2, remove 2)
  // 1, 3, 2, 0
  // 3, 2, 0, 1
  // 2, 0, 1, 3
  static List<Offset> p0132(List<Offset> list) => list
    ..add(list[2])
    ..removeAt(2);

  static List<Offset> p1320(List<Offset> list) =>
      p0132(list)..addFirstAndRemoveFirst();

  static List<Offset> p3201(List<Offset> list) =>
      p1320(list)..addFirstAndRemoveFirst();

  static List<Offset> p2013(List<Offset> list) =>
      p3201(list)..addFirstAndRemoveFirst();

  // 1, 3, 0, 2 (add 02, remove 02)
  // 3, 0, 2, 1
  // 0, 2, 1, 3
  // 2, 1, 3, 0
  static List<Offset> p1302(List<Offset> list) => p1230(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3021(List<Offset> list) =>
      p1302(list)..addFirstAndRemoveFirst();

  static List<Offset> p0213(List<Offset> list) =>
      p3021(list)..addFirstAndRemoveFirst();

  static List<Offset> p2130(List<Offset> list) =>
      p0213(list)..addFirstAndRemoveFirst();

  // 0, 3, 1, 2 (add 12, remove 12)
  // 3, 1, 2, 0
  // 1, 2, 0, 3
  // 2, 0, 3, 1
  static List<Offset> p0312(List<Offset> list) => p0231(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3120(List<Offset> list) =>
      p0312(list)..addFirstAndRemoveFirst();

  static List<Offset> p1203(List<Offset> list) =>
      p3120(list)..addFirstAndRemoveFirst();

  static List<Offset> p2031(List<Offset> list) =>
      p1203(list)..addFirstAndRemoveFirst();

  // 0, 3, 2, 1 (add 21, remove 21)
  // 3, 2, 1, 0
  // 2, 1, 0, 3
  // 1, 0, 3, 2
  static List<Offset> p0321(List<Offset> list) => p0132(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3210(List<Offset> list) =>
      p0321(list)..addFirstAndRemoveFirst();

  static List<Offset> p2103(List<Offset> list) =>
      p3210(list)..addFirstAndRemoveFirst();

  static List<Offset> p1032(List<Offset> list) =>
      p2103(list)..addFirstAndRemoveFirst();
}

extension KCoordinate on Coordinate {
  static const cube_01 = Coordinate.cube(0.1);
  static const cube_02 = Coordinate.cube(0.2);
  static const cube_03 = Coordinate.cube(0.3);
  static const cube_04 = Coordinate.cube(0.4);
  static const cube_05 = Coordinate.cube(0.5);
  static const cube_06 = Coordinate.cube(0.6);
  static const cube_07 = Coordinate.cube(0.7);
  static const cube_08 = Coordinate.cube(0.8);
  static const cube_09 = Coordinate.cube(0.9);
  static const cube_1 = Coordinate.cube(1);
  static const cube_2 = Coordinate.cube(2);
  static const cube_3 = Coordinate.cube(3);
  static const cube_4 = Coordinate.cube(4);
  static const cube_5 = Coordinate.cube(5);
  static const cube_6 = Coordinate.cube(6);
  static const cube_7 = Coordinate.cube(7);
  static const cube_8 = Coordinate.cube(8);
  static const cube_9 = Coordinate.cube(9);
  static const cube_10 = Coordinate.cube(10);
  static const cube_20 = Coordinate.cube(20);
  static const cube_30 = Coordinate.cube(30);
  static const cube_40 = Coordinate.cube(40);
  static const cube_50 = Coordinate.cube(50);
  static const cube_60 = Coordinate.cube(60);
  static const cube_70 = Coordinate.cube(70);
  static const cube_80 = Coordinate.cube(80);
  static const cube_90 = Coordinate.cube(90);
  static const cube_100 = Coordinate.cube(100);

  static const x100 = Coordinate(100, 0, 0);
  static const y100 = Coordinate(0, 100, 0);
  static const z100 = Coordinate(0, 0, 100);
}

///
///
/// positive radian means clockwise for [Transform] widget and [Offset.direction],
/// but means counterclockwise for math discussion
/// see also [KDirection]
///
///
extension KRadian on double {
  static const angle_450 = math.pi * 5 / 2;
  static const angle_420 = math.pi * 7 / 3;
  static const angle_390 = math.pi * 13 / 6;
  static const angle_360 = math.pi * 2;
  static const angle_315 = math.pi * 7 / 4;
  static const angle_270 = math.pi * 3 / 2;
  static const angle_240 = math.pi * 4 / 3;
  static const angle_225 = math.pi * 5 / 4;
  static const angle_180 = math.pi;
  static const angle_150 = math.pi * 5 / 6;
  static const angle_135 = math.pi * 3 / 4;
  static const angle_120 = math.pi * 2 / 3;
  static const angle_90 = math.pi / 2;
  static const angle_85 = math.pi * 17 / 36;
  static const angle_80 = math.pi * 4 / 9;
  static const angle_75 = math.pi * 5 / 12;
  static const angle_70 = math.pi * 7 / 18;
  static const angle_60 = math.pi / 3;
  static const angle_50 = math.pi * 5 / 18;
  static const angle_45 = math.pi / 4;
  static const angle_40 = math.pi * 2 / 9;
  static const angle_30 = math.pi / 6;
  static const angle_20 = math.pi / 9;
  static const angle_15 = math.pi / 12;
  static const angle_10 = math.pi / 18;
  static const angle_5 = math.pi / 36;
  static const angle_1 = math.pi / 180;
  static const angle_01 = angle_1 / 10;
  static const angle_001 = angle_1 / 100;
}

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

extension KRadianCoordinate on Coordinate {
  static const angleX_360 = Coordinate.ofX(KRadian.angle_360);
  static const angleY_360 = Coordinate.ofY(KRadian.angle_360);
  static const angleZ_360 = Coordinate.ofZ(KRadian.angle_360);
  static const angleXYZ_360 = Coordinate.cube(KRadian.angle_360);
  static const angleXY_360 =
      Coordinate.ofXY(KRadian.angle_360, KRadian.angle_360);
  static const angleX_315 = Coordinate.ofX(KRadian.angle_315);
  static const angleY_315 = Coordinate.ofY(KRadian.angle_315);
  static const angleZ_315 = Coordinate.ofZ(KRadian.angle_315);
  static const angleXYZ_315 = Coordinate.cube(KRadian.angle_315);
  static const angleXY_315 =
      Coordinate.ofXY(KRadian.angle_315, KRadian.angle_315);
  static const angleX_270 = Coordinate.ofX(KRadian.angle_270);
  static const angleY_270 = Coordinate.ofY(KRadian.angle_270);
  static const angleZ_270 = Coordinate.ofZ(KRadian.angle_270);
  static const angleXYZ_270 = Coordinate.cube(KRadian.angle_270);
  static const angleXY_270 =
      Coordinate.ofXY(KRadian.angle_270, KRadian.angle_270);
  static const angleX_240 = Coordinate.ofX(KRadian.angle_240);
  static const angleY_240 = Coordinate.ofY(KRadian.angle_240);
  static const angleZ_240 = Coordinate.ofZ(KRadian.angle_240);
  static const angleXYZ_240 = Coordinate.cube(KRadian.angle_240);
  static const angleXY_240 =
      Coordinate.ofXY(KRadian.angle_240, KRadian.angle_240);
  static const angleX_225 = Coordinate.ofX(KRadian.angle_225);
  static const angleY_225 = Coordinate.ofY(KRadian.angle_225);
  static const angleZ_225 = Coordinate.ofZ(KRadian.angle_225);
  static const angleXYZ_225 = Coordinate.cube(KRadian.angle_225);
  static const angleXY_225 =
      Coordinate.ofXY(KRadian.angle_225, KRadian.angle_225);
  static const angleX_180 = Coordinate.ofX(KRadian.angle_180);
  static const angleY_180 = Coordinate.ofY(KRadian.angle_180);
  static const angleZ_180 = Coordinate.ofZ(KRadian.angle_180);
  static const angleXYZ_180 = Coordinate.cube(KRadian.angle_180);
  static const angleXY_180 =
      Coordinate.ofXY(KRadian.angle_180, KRadian.angle_180);
  static const angleX_135 = Coordinate.ofX(KRadian.angle_135);
  static const angleY_135 = Coordinate.ofY(KRadian.angle_135);
  static const angleZ_135 = Coordinate.ofZ(KRadian.angle_135);
  static const angleXYZ_135 = Coordinate.cube(KRadian.angle_135);
  static const angleXY_135 =
      Coordinate.ofXY(KRadian.angle_135, KRadian.angle_135);
  static const angleX_120 = Coordinate.ofX(KRadian.angle_120);
  static const angleY_120 = Coordinate.ofY(KRadian.angle_120);
  static const angleZ_120 = Coordinate.ofZ(KRadian.angle_120);
  static const angleZ_150 = Coordinate.ofZ(KRadian.angle_150);
  static const angleXYZ_120 = Coordinate.cube(KRadian.angle_120);
  static const angleXY_120 =
      Coordinate.ofXY(KRadian.angle_120, KRadian.angle_120);
  static const angleX_90 = Coordinate.ofX(KRadian.angle_90);
  static const angleY_90 = Coordinate.ofY(KRadian.angle_90);
  static const angleZ_90 = Coordinate.ofZ(KRadian.angle_90);
  static const angleXYZ_90 = Coordinate.cube(KRadian.angle_90);
  static const angleXY_90 = Coordinate.ofXY(KRadian.angle_90, KRadian.angle_90);
  static const angleYZ_90 = Coordinate.ofYZ(KRadian.angle_90, KRadian.angle_90);
  static const angleXZ_90 = Coordinate.ofXZ(KRadian.angle_90, KRadian.angle_90);
  static const angleX_80 = Coordinate.ofX(KRadian.angle_80);
  static const angleY_80 = Coordinate.ofY(KRadian.angle_80);
  static const angleZ_80 = Coordinate.ofZ(KRadian.angle_80);
  static const angleXYZ_80 = Coordinate.cube(KRadian.angle_80);
  static const angleXY_80 = Coordinate.ofXY(KRadian.angle_80, KRadian.angle_80);
  static const angleX_75 = Coordinate.ofX(KRadian.angle_75);
  static const angleY_75 = Coordinate.ofY(KRadian.angle_75);
  static const angleZ_75 = Coordinate.ofZ(KRadian.angle_75);
  static const angleXYZ_75 = Coordinate.cube(KRadian.angle_75);
  static const angleXY_75 = Coordinate.ofXY(KRadian.angle_75, KRadian.angle_75);
  static const angleX_70 = Coordinate.ofX(KRadian.angle_70);
  static const angleY_70 = Coordinate.ofY(KRadian.angle_70);
  static const angleZ_70 = Coordinate.ofZ(KRadian.angle_70);
  static const angleXYZ_70 = Coordinate.cube(KRadian.angle_70);
  static const angleXY_70 = Coordinate.ofXY(KRadian.angle_70, KRadian.angle_70);
  static const angleX_60 = Coordinate.ofX(KRadian.angle_60);
  static const angleY_60 = Coordinate.ofY(KRadian.angle_60);
  static const angleZ_60 = Coordinate.ofZ(KRadian.angle_60);
  static const angleXYZ_60 = Coordinate.cube(KRadian.angle_60);
  static const angleXY_60 = Coordinate.ofXY(KRadian.angle_60, KRadian.angle_60);
  static const angleX_50 = Coordinate.ofX(KRadian.angle_50);
  static const angleY_50 = Coordinate.ofY(KRadian.angle_50);
  static const angleZ_50 = Coordinate.ofZ(KRadian.angle_50);
  static const angleXYZ_50 = Coordinate.cube(KRadian.angle_50);
  static const angleXY_50 = Coordinate.ofXY(KRadian.angle_50, KRadian.angle_50);
  static const angleX_45 = Coordinate.ofX(KRadian.angle_45);
  static const angleY_45 = Coordinate.ofY(KRadian.angle_45);
  static const angleZ_45 = Coordinate.ofZ(KRadian.angle_45);
  static const angleXYZ_45 = Coordinate.cube(KRadian.angle_45);
  static const angleXY_45 = Coordinate.ofXY(KRadian.angle_45, KRadian.angle_45);
  static const angleX_30 = Coordinate.ofX(KRadian.angle_30);
  static const angleY_30 = Coordinate.ofY(KRadian.angle_30);
  static const angleZ_30 = Coordinate.ofZ(KRadian.angle_30);
  static const angleXYZ_30 = Coordinate.cube(KRadian.angle_30);
  static const angleXY_30 = Coordinate.ofXY(KRadian.angle_30, KRadian.angle_30);
  static const angleX_20 = Coordinate.ofX(KRadian.angle_20);
  static const angleY_20 = Coordinate.ofY(KRadian.angle_20);
  static const angleZ_20 = Coordinate.ofZ(KRadian.angle_20);
  static const angleXYZ_20 = Coordinate.cube(KRadian.angle_20);
  static const angleXY_20 = Coordinate.ofXY(KRadian.angle_20, KRadian.angle_20);
  static const angleX_15 = Coordinate.ofX(KRadian.angle_15);
  static const angleY_15 = Coordinate.ofY(KRadian.angle_15);
  static const angleZ_15 = Coordinate.ofZ(KRadian.angle_15);
  static const angleXYZ_15 = Coordinate.cube(KRadian.angle_15);
  static const angleXY_15 = Coordinate.ofXY(KRadian.angle_15, KRadian.angle_15);
  static const angleX_10 = Coordinate.ofX(KRadian.angle_10);
  static const angleY_10 = Coordinate.ofY(KRadian.angle_10);
  static const angleZ_10 = Coordinate.ofZ(KRadian.angle_10);
  static const angleXYZ_10 = Coordinate.cube(KRadian.angle_10);
  static const angleXY_10 = Coordinate.ofXY(KRadian.angle_10, KRadian.angle_10);
  static const angleX_5 = Coordinate.ofX(KRadian.angle_5);
  static const angleY_5 = Coordinate.ofY(KRadian.angle_5);
  static const angleZ_5 = Coordinate.ofZ(KRadian.angle_5);
  static const angleXYZ_5 = Coordinate.cube(KRadian.angle_5);
  static const angleXY_5 = Coordinate.ofXY(KRadian.angle_5, KRadian.angle_5);
  static const angleX_1 = Coordinate.ofX(KRadian.angle_1);
  static const angleY_1 = Coordinate.ofY(KRadian.angle_1);
  static const angleZ_1 = Coordinate.ofZ(KRadian.angle_1);
  static const angleXYZ_1 = Coordinate.cube(KRadian.angle_1);
  static const angleXY_1 = Coordinate.ofXY(KRadian.angle_1, KRadian.angle_1);
  static const angleX_01 = Coordinate.ofX(KRadian.angle_01);
  static const angleY_01 = Coordinate.ofY(KRadian.angle_01);
  static const angleZ_01 = Coordinate.ofZ(KRadian.angle_01);
  static const angleXYZ_01 = Coordinate.cube(KRadian.angle_01);
  static const angleXY_01 = Coordinate.ofXY(KRadian.angle_01, KRadian.angle_01);
  static const angleX_001 = Coordinate.ofX(KRadian.angle_001);
  static const angleY_001 = Coordinate.ofY(KRadian.angle_001);
  static const angleZ_001 = Coordinate.ofZ(KRadian.angle_001);
  static const angleXYZ_001 = Coordinate.cube(KRadian.angle_001);
  static const angleXY_001 =
      Coordinate.ofXY(KRadian.angle_001, KRadian.angle_001);
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
/// rect, radius
///
///
///
///

extension FRect on Rect {
  static Rect fromZeroTo(Size size) => Offset.zero & size;
}

extension KRadius on Radius {
  static const circular1 = Radius.circular(1);
  static const circular10 = Radius.circular(10);
  static const circular20 = Radius.circular(20);
  static const circular30 = Radius.circular(30);
  static const circular40 = Radius.circular(40);
  static const circular50 = Radius.circular(50);
  static const circular60 = Radius.circular(60);
  static const circular70 = Radius.circular(70);
  static const circular80 = Radius.circular(80);
  static const circular90 = Radius.circular(90);
  static const circular100 = Radius.circular(100);
}

extension KBorderRadius on BorderRadius {
  static const zero = BorderRadius.all(Radius.zero);
  static const allCircular_1 = BorderRadius.all(KRadius.circular1);
  static const allCircular_10 = BorderRadius.all(KRadius.circular10);
  static const allCircular_20 = BorderRadius.all(KRadius.circular20);
  static const allCircular_30 = BorderRadius.all(KRadius.circular30);
  static const allCircular_40 = BorderRadius.all(KRadius.circular40);
  static const allCircular_50 = BorderRadius.all(KRadius.circular50);
  static const allCircular_60 = BorderRadius.all(KRadius.circular60);
  static const allCircular_70 = BorderRadius.all(KRadius.circular70);
  static const allCircular_80 = BorderRadius.all(KRadius.circular80);
  static const allCircular_90 = BorderRadius.all(KRadius.circular90);
  static const allCircular_100 = BorderRadius.all(KRadius.circular100);
  static const vertical_0_10 =
      BorderRadius.vertical(bottom: KRadius.circular10);
  static const vertical_0_20 =
      BorderRadius.vertical(bottom: KRadius.circular20);
  static const vertical_0_30 =
      BorderRadius.vertical(bottom: KRadius.circular30);
  static const vertical_0_40 =
      BorderRadius.vertical(bottom: KRadius.circular40);
  static const vertical_0_50 =
      BorderRadius.vertical(bottom: KRadius.circular50);
  static const vertical_0_60 =
      BorderRadius.vertical(bottom: KRadius.circular60);
  static const vertical_0_70 =
      BorderRadius.vertical(bottom: KRadius.circular70);
  static const vertical_0_80 =
      BorderRadius.vertical(bottom: KRadius.circular80);
  static const vertical_0_90 =
      BorderRadius.vertical(bottom: KRadius.circular90);
  static const vertical_0_100 =
      BorderRadius.vertical(bottom: KRadius.circular100);
}

///
///
///
///
/// edgeInsets
///
///
///
///

extension KEdgeInsets on EdgeInsets {
  static const onlyLeft_4 = EdgeInsets.only(left: 4);
  static const onlyLeft_8 = EdgeInsets.only(left: 8);
  static const onlyLeft_10 = EdgeInsets.only(left: 10);
  static const onlyLeft_24 = EdgeInsets.only(left: 24);
  static const onlyLeftTop_10 = EdgeInsets.only(left: 10, top: 10);
  static const onlyTop_4 = EdgeInsets.only(top: 4);
  static const onlyTop_8 = EdgeInsets.only(top: 8);
  static const onlyTop_12 = EdgeInsets.only(top: 12);
  static const onlyTop_16 = EdgeInsets.only(top: 16);
  static const onlyTop_32 = EdgeInsets.only(top: 32);
  static const onlyTop_10 = EdgeInsets.only(top: 10);
  static const onlyTop_20 = EdgeInsets.only(top: 20);
  static const onlyTop_30 = EdgeInsets.only(top: 30);
  static const onlyTop_40 = EdgeInsets.only(top: 40);
  static const onlyTop_50 = EdgeInsets.only(top: 50);
  static const onlyBottom_8 = EdgeInsets.only(bottom: 8);
  static const onlyBottom_16 = EdgeInsets.only(bottom: 16);
  static const onlyBottom_32 = EdgeInsets.only(bottom: 32);
  static const onlyBottom_64 = EdgeInsets.only(bottom: 64);
  static const onlyRight_4 = EdgeInsets.only(right: 4);
  static const onlyRight_8 = EdgeInsets.only(right: 8);
  static const onlyRight_10 = EdgeInsets.only(right: 10);
  static const onlyRightTop_10 = EdgeInsets.only(right: 10, top: 10);

  static const symH_8 = EdgeInsets.symmetric(horizontal: 8);
  static const symH_10 = EdgeInsets.symmetric(horizontal: 10);
  static const symH_12 = EdgeInsets.symmetric(horizontal: 12);
  static const symH_16 = EdgeInsets.symmetric(horizontal: 16);
  static const symH_18 = EdgeInsets.symmetric(horizontal: 18);
  static const symH_20 = EdgeInsets.symmetric(horizontal: 20);
  static const symH_32 = EdgeInsets.symmetric(horizontal: 32);
  static const symH_64 = EdgeInsets.symmetric(horizontal: 64);
  static const symV_8 = EdgeInsets.symmetric(vertical: 8);
  static const symV_16 = EdgeInsets.symmetric(vertical: 16);
  static const symV_32 = EdgeInsets.symmetric(vertical: 32);
  static const symV_10 = EdgeInsets.symmetric(vertical: 10);
  static const symV_20 = EdgeInsets.symmetric(vertical: 20);
  static const symV_30 = EdgeInsets.symmetric(vertical: 30);

  static const symHV_64_32 = EdgeInsets.symmetric(horizontal: 64, vertical: 32);
  static const symHV_32_4 = EdgeInsets.symmetric(horizontal: 32, vertical: 4);
  static const symHV_24_8 = EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  static const all_1 = EdgeInsets.all(1);
  static const all_10 = EdgeInsets.all(10);
  static const all_100 = EdgeInsets.all(100);

  static const ltrb_2_16_2_0 = EdgeInsets.fromLTRB(2, 16, 2, 0);
  static const ltrb_2_0_2_8 = EdgeInsets.fromLTRB(2, 0, 2, 8);
  static const ltrb_4_16_4_0 = EdgeInsets.fromLTRB(4, 16, 4, 0);
  static const ltrb_8_0_8_8 = EdgeInsets.fromLTRB(8, 0, 8, 8);
  static const ltrb_8_0_8_20 = EdgeInsets.fromLTRB(8, 0, 8, 20);
  static const ltrb_8_16_8_0 = EdgeInsets.fromLTRB(8, 16, 8, 0);
  static const ltrb_16_20_16_16 = EdgeInsets.fromLTRB(64, 20, 64, 8);
  static const ltrb_32_20_32_8 = EdgeInsets.fromLTRB(32, 20, 32, 8);
  static const ltrb_64_20_64_8 = EdgeInsets.fromLTRB(64, 20, 64, 8);
  static const ltrb_50_6_0_8 = EdgeInsets.fromLTRB(50, 6, 0, 8);
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
