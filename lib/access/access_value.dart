// ignore_for_file: constant_identifier_names
part of '../mationani.dart';

///
/// this file contains:
/// [KSize], [KSize3Ratio4], [KSize9Ratio16], [KSize16Ratio9]
/// [KDirection], [KOffset], [KOffsetPermutation4], [KCoordinate], [KVector]
///
/// [KRadian], [FRadian], [KRadianCoordinate], [FRadianCoordinate]
/// [FRect]
///
/// [KRadius], [KBorderRadius]
/// [KEdgeInsets]
///
/// [KDuration], [KDurationFR]
/// [KCurveFR], [KInterval]
///
///
///
///

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
///
///
///
///
/// duration, curve, interval
///
///
///
///
///
///
///


extension KDuration on Duration {
  static const milli5 = Duration(milliseconds: 5);
  static const milli10 = Duration(milliseconds: 10);
  static const milli20 = Duration(milliseconds: 20);
  static const milli30 = Duration(milliseconds: 30);
  static const milli40 = Duration(milliseconds: 40);
  static const milli50 = Duration(milliseconds: 50);
  static const milli60 = Duration(milliseconds: 60);
  static const milli70 = Duration(milliseconds: 70);
  static const milli80 = Duration(milliseconds: 80);
  static const milli90 = Duration(milliseconds: 90);
  static const milli100 = Duration(milliseconds: 100);
  static const milli110 = Duration(milliseconds: 110);
  static const milli120 = Duration(milliseconds: 120);
  static const milli130 = Duration(milliseconds: 130);
  static const milli140 = Duration(milliseconds: 140);
  static const milli150 = Duration(milliseconds: 150);
  static const milli160 = Duration(milliseconds: 160);
  static const milli170 = Duration(milliseconds: 170);
  static const milli180 = Duration(milliseconds: 180);
  static const milli190 = Duration(milliseconds: 190);
  static const milli200 = Duration(milliseconds: 200);
  static const milli210 = Duration(milliseconds: 210);
  static const milli220 = Duration(milliseconds: 220);
  static const milli230 = Duration(milliseconds: 230);
  static const milli240 = Duration(milliseconds: 240);
  static const milli250 = Duration(milliseconds: 250);
  static const milli260 = Duration(milliseconds: 260);
  static const milli270 = Duration(milliseconds: 270);
  static const milli280 = Duration(milliseconds: 280);
  static const milli290 = Duration(milliseconds: 290);
  static const milli295 = Duration(milliseconds: 295);
  static const milli300 = Duration(milliseconds: 300);
  static const milli306 = Duration(milliseconds: 306);
  static const milli307 = Duration(milliseconds: 307);
  static const milli308 = Duration(milliseconds: 308);
  static const milli310 = Duration(milliseconds: 310);
  static const milli320 = Duration(milliseconds: 320);
  static const milli330 = Duration(milliseconds: 330);
  static const milli335 = Duration(milliseconds: 335);
  static const milli340 = Duration(milliseconds: 340);
  static const milli350 = Duration(milliseconds: 350);
  static const milli360 = Duration(milliseconds: 360);
  static const milli370 = Duration(milliseconds: 370);
  static const milli380 = Duration(milliseconds: 380);
  static const milli390 = Duration(milliseconds: 390);
  static const milli400 = Duration(milliseconds: 400);
  static const milli410 = Duration(milliseconds: 410);
  static const milli420 = Duration(milliseconds: 420);
  static const milli430 = Duration(milliseconds: 430);
  static const milli440 = Duration(milliseconds: 440);
  static const milli450 = Duration(milliseconds: 450);
  static const milli460 = Duration(milliseconds: 460);
  static const milli466 = Duration(milliseconds: 466);
  static const milli467 = Duration(milliseconds: 467);
  static const milli468 = Duration(milliseconds: 468);
  static const milli470 = Duration(milliseconds: 470);
  static const milli480 = Duration(milliseconds: 480);
  static const milli490 = Duration(milliseconds: 490);
  static const milli500 = Duration(milliseconds: 500);
  static const milli600 = Duration(milliseconds: 600);
  static const milli700 = Duration(milliseconds: 700);
  static const milli800 = Duration(milliseconds: 800);
  static const milli810 = Duration(milliseconds: 810);
  static const milli820 = Duration(milliseconds: 820);
  static const milli830 = Duration(milliseconds: 830);
  static const milli840 = Duration(milliseconds: 840);
  static const milli850 = Duration(milliseconds: 850);
  static const milli860 = Duration(milliseconds: 860);
  static const milli870 = Duration(milliseconds: 870);
  static const milli880 = Duration(milliseconds: 880);
  static const milli890 = Duration(milliseconds: 890);
  static const milli900 = Duration(milliseconds: 900);
  static const milli910 = Duration(milliseconds: 910);
  static const milli920 = Duration(milliseconds: 920);
  static const milli930 = Duration(milliseconds: 930);
  static const milli940 = Duration(milliseconds: 940);
  static const milli950 = Duration(milliseconds: 950);
  static const milli960 = Duration(milliseconds: 960);
  static const milli970 = Duration(milliseconds: 970);
  static const milli980 = Duration(milliseconds: 980);
  static const milli990 = Duration(milliseconds: 990);
  static const milli1100 = Duration(milliseconds: 1100);
  static const milli1200 = Duration(milliseconds: 1200);
  static const milli1300 = Duration(milliseconds: 1300);
  static const milli1400 = Duration(milliseconds: 1400);
  static const milli1500 = Duration(milliseconds: 1500);
  static const milli1600 = Duration(milliseconds: 1600);
  static const milli1700 = Duration(milliseconds: 1700);
  static const milli1800 = Duration(milliseconds: 1800);
  static const milli1900 = Duration(milliseconds: 1900);
  static const milli1933 = Duration(milliseconds: 1933);
  static const milli1934 = Duration(milliseconds: 1934);
  static const milli1936 = Duration(milliseconds: 1936);
  static const milli1940 = Duration(milliseconds: 1940);
  static const milli1950 = Duration(milliseconds: 1950);
  static const milli2100 = Duration(milliseconds: 2100);
  static const milli2200 = Duration(milliseconds: 2200);
  static const milli2300 = Duration(milliseconds: 2300);
  static const milli2400 = Duration(milliseconds: 2400);
  static const milli2500 = Duration(milliseconds: 2500);
  static const milli2600 = Duration(milliseconds: 2600);
  static const milli2700 = Duration(milliseconds: 2700);
  static const milli2800 = Duration(milliseconds: 2800);
  static const milli2900 = Duration(milliseconds: 2900);
  static const milli3800 = Duration(milliseconds: 3800);
  static const milli3822 = Duration(milliseconds: 3822);
  static const milli3833 = Duration(milliseconds: 3833);
  static const milli3866 = Duration(milliseconds: 3866);
  static const milli4500 = Duration(milliseconds: 4500);
  static const second1 = Duration(seconds: 1);
  static const second2 = Duration(seconds: 2);
  static const second3 = Duration(seconds: 3);
  static const second4 = Duration(seconds: 4);
  static const second5 = Duration(seconds: 5);
  static const second6 = Duration(seconds: 6);
  static const second7 = Duration(seconds: 7);
  static const second8 = Duration(seconds: 8);
  static const second9 = Duration(seconds: 9);
  static const second10 = Duration(seconds: 10);
  static const second14 = Duration(seconds: 14);
  static const second15 = Duration(seconds: 15);
  static const second20 = Duration(seconds: 20);
  static const second30 = Duration(seconds: 30);
  static const second40 = Duration(seconds: 40);
  static const second50 = Duration(seconds: 50);
  static const second58 = Duration(seconds: 58);
  static const min1 = Duration(minutes: 1);
}

extension KDurationFR on DurationFR {
  static const milli100 = DurationFR.constant(KDuration.milli100);
  static const milli300 = DurationFR.constant(KDuration.milli300);
  static const milli500 = DurationFR.constant(KDuration.milli500);
  static const milli800 = DurationFR.constant(KDuration.milli800);
  static const milli1500 = DurationFR.constant(KDuration.milli1500);
  static const milli2500 = DurationFR.constant(KDuration.milli2500);
  static const second1 = DurationFR.constant(KDuration.second1);
  static const second2 = DurationFR.constant(KDuration.second2);
  static const second3 = DurationFR.constant(KDuration.second3);
  static const second4 = DurationFR.constant(KDuration.second4);
  static const second5 = DurationFR.constant(KDuration.second5);
  static const second6 = DurationFR.constant(KDuration.second6);
  static const second7 = DurationFR.constant(KDuration.second7);
  static const second8 = DurationFR.constant(KDuration.second8);
  static const second9 = DurationFR.constant(KDuration.second9);
  static const second10 = DurationFR.constant(KDuration.second10);
  static const second20 = DurationFR.constant(KDuration.second20);
  static const second30 = DurationFR.constant(KDuration.second30);
  static const min1 = DurationFR.constant(KDuration.min1);
}

///
///
///
/// curve
///
///
///


extension KCurveFR on CurveFR {
  /// list.length == 43, see https://api.flutter.dev/flutter/animation/Curves-class.html?gclid=CjwKCAiA-bmsBhAGEiwAoaQNmg9ZfimSGJRAty3QNZ0AA32ztq51qPlJfFPBsFc5Iv1n-EgFQtULyxoC8q0QAvD_BwE&gclsrc=aw.ds
  static const List<CurveFR> all = [
    linear,
    decelerate,
    fastLinearToSlowEaseIn,
    fastEaseInToSlowEaseOut,
    ease,
    easeInToLinear,
    linearToEaseOut,
    easeIn,
    easeInSine,
    easeInQuad,
    easeInCubic,
    easeInQuart,
    easeInQuint,
    easeInExpo,
    easeInCirc,
    easeInBack,
    easeOut,
    easeOutSine,
    easeOutQuad,
    easeOutCubic,
    easeOutQuart,
    easeOutQuint,
    easeOutExpo,
    easeOutCirc,
    easeOutBack,
    easeInOut,
    easeInOutSine,
    easeInOutQuad,
    easeInOutCubic,
    easeInOutCubicEmphasized,
    easeInOutQuart,
    easeInOutQuint,
    easeInOutExpo,
    easeInOutCirc,
    easeInOutBack,
    fastOutSlowIn,
    slowMiddle,
    bounceIn,
    bounceOut,
    bounceInOut,
    elasticIn,
    elasticOut,
    elasticInOut,
  ];

  static const linear = CurveFR.symmetry(Curves.linear);
  static const decelerate = CurveFR.symmetry(Curves.decelerate);
  static const fastLinearToSlowEaseIn =
  CurveFR.symmetry(Curves.fastLinearToSlowEaseIn);
  static const fastEaseInToSlowEaseOut =
  CurveFR.symmetry(Curves.fastEaseInToSlowEaseOut);
  static const ease = CurveFR.symmetry(Curves.ease);
  static const easeInToLinear = CurveFR.symmetry(Curves.easeInToLinear);
  static const linearToEaseOut = CurveFR.symmetry(Curves.linearToEaseOut);
  static const easeIn = CurveFR.symmetry(Curves.easeIn);
  static const easeInSine = CurveFR.symmetry(Curves.easeInSine);
  static const easeInQuad = CurveFR.symmetry(Curves.easeInQuad);
  static const easeInCubic = CurveFR.symmetry(Curves.easeInCubic);
  static const easeInQuart = CurveFR.symmetry(Curves.easeInQuart);
  static const easeInQuint = CurveFR.symmetry(Curves.easeInQuint);
  static const easeInExpo = CurveFR.symmetry(Curves.easeInExpo);
  static const easeInCirc = CurveFR.symmetry(Curves.easeInCirc);
  static const easeInBack = CurveFR.symmetry(Curves.easeInBack);
  static const easeOut = CurveFR.symmetry(Curves.easeOut);
  static const easeOutSine = CurveFR.symmetry(Curves.easeOutSine);
  static const easeOutQuad = CurveFR.symmetry(Curves.easeOutQuad);
  static const easeOutCubic = CurveFR.symmetry(Curves.easeOutCubic);
  static const easeOutQuart = CurveFR.symmetry(Curves.easeOutQuart);
  static const easeOutQuint = CurveFR.symmetry(Curves.easeOutQuint);
  static const easeOutExpo = CurveFR.symmetry(Curves.easeOutExpo);
  static const easeOutCirc = CurveFR.symmetry(Curves.easeOutCirc);
  static const easeOutBack = CurveFR.symmetry(Curves.easeOutBack);
  static const easeInOut = CurveFR.symmetry(Curves.easeInOut);
  static const easeInOutSine = CurveFR.symmetry(Curves.easeInOutSine);
  static const easeInOutQuad = CurveFR.symmetry(Curves.easeInOutQuad);
  static const easeInOutCubic = CurveFR.symmetry(Curves.easeInOutCubic);
  static const easeInOutCubicEmphasized =
  CurveFR.symmetry(Curves.easeInOutCubicEmphasized);
  static const easeInOutQuart = CurveFR.symmetry(Curves.easeInOutQuart);
  static const easeInOutQuint = CurveFR.symmetry(Curves.easeInOutQuint);
  static const easeInOutExpo = CurveFR.symmetry(Curves.easeInOutExpo);
  static const easeInOutCirc = CurveFR.symmetry(Curves.easeInOutCirc);
  static const easeInOutBack = CurveFR.symmetry(Curves.easeInOutBack);
  static const fastOutSlowIn = CurveFR.symmetry(Curves.fastOutSlowIn);
  static const slowMiddle = CurveFR.symmetry(Curves.slowMiddle);
  static const bounceIn = CurveFR.symmetry(Curves.bounceIn);
  static const bounceOut = CurveFR.symmetry(Curves.bounceOut);
  static const bounceInOut = CurveFR.symmetry(Curves.bounceInOut);
  static const elasticIn = CurveFR.symmetry(Curves.elasticIn);
  static const elasticOut = CurveFR.symmetry(Curves.elasticOut);
  static const elasticInOut = CurveFR.symmetry(Curves.elasticInOut);

  ///
  /// f, r
  ///
  static const fastOutSlowIn_easeOutQuad =
  CurveFR(Curves.fastOutSlowIn, Curves.easeOutQuad);

  ///
  /// interval
  ///
  static const easeInOut_00_04 = CurveFR.symmetry(KInterval.easeInOut_00_04);
}

///
///
///
/// interval
///
///
///
///

extension KInterval on Interval {
  static const easeInOut_00_04 = Interval(0, 0.4, curve: Curves.easeInOut);
  static const easeInOut_00_05 = Interval(0, 0.5, curve: Curves.easeInOut);
  static const easeOut_00_06 = Interval(0, 0.6, curve: Curves.easeOut);
  static const easeInOut_02_08 = Interval(0.2, 0.8, curve: Curves.easeInOut);
  static const easeInOut_04_10 = Interval(0.4, 1, curve: Curves.easeInOut);
  static const fastOutSlowIn_00_05 =
  Interval(0, 0.5, curve: Curves.fastOutSlowIn);
}