part of mationani;

///
///
/// [DurationFRExtension], [CurveFRExtension]
///
/// [KDuration], [KDurationFR]
/// [KInterval], [KCurveFR]
/// [FBetweenDouble], [FBetweenOffset], [FBetweenCoordinate], [FBetweenCoordinateRadian]
///
///

extension DurationFRExtension on Duration {
  DurationFR get toDurationFR => DurationFR.constant(this);
}

extension CurveFRExtension on Curve {
  CurveFR get toCurveFR => CurveFR(this, this);
}

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

extension KInterval on Interval {
  static const easeInOut_00_04 = Interval(0, 0.4, curve: Curves.easeInOut);
  static const easeInOut_00_05 = Interval(0, 0.5, curve: Curves.easeInOut);
  static const easeOut_00_06 = Interval(0, 0.6, curve: Curves.easeOut);
  static const easeInOut_02_08 = Interval(0.2, 0.8, curve: Curves.easeInOut);
  static const easeInOut_04_10 = Interval(0.4, 1, curve: Curves.easeInOut);
  static const fastOutSlowIn_00_05 =
      Interval(0, 0.5, curve: Curves.fastOutSlowIn);
}

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
/// between
///
///

extension FBetweenDouble on Between<double> {
  static Between<double> get zero => Between.constant(0);

  static Between<double> get k1 => Between.constant(1);

  static Between<double> zeroFrom(double v) => Between(begin: v, end: 0);

  static Between<double> zeroTo(double v) => Between(begin: 0, end: v);

  static Between<double> oneFrom(double v) => Between(begin: v, end: 1);

  static Between<double> oneTo(double v) => Between(begin: 1, end: v);

  static Between<double> o1From(double v) => Between(begin: v, end: 0.1);

  static Between<double> o1To(double v) => Between(begin: 0.1, end: v);
}

extension FBetweenOffset on Between<Offset> {
  static Between<Offset> get zero => Between.constant(Offset.zero);

  static Between<Offset> zeroFrom(Offset begin, {CurveFR? curve}) =>
      Between(begin: begin, end: Offset.zero, curve: curve);

  static Between<Offset> zeroTo(Offset end, {CurveFR? curve}) =>
      Between(begin: Offset.zero, end: end, curve: curve);
}

extension FBetweenCoordinate on Between<Coordinate> {
  static Between<Coordinate> get zero => Between.constant(Coordinate.zero);

  static Between<Coordinate> zeroFrom(Coordinate begin, {CurveFR? curve}) =>
      Between<Coordinate>(begin: begin, end: Coordinate.zero, curve: curve);

  static Between<Coordinate> zeroTo(Coordinate end, {CurveFR? curve}) =>
      Between<Coordinate>(begin: Coordinate.zero, end: end, curve: curve);

  static Between<Coordinate> zeroBeginOrEnd(
    Coordinate another, {
    required bool isEndZero,
    CurveFR? curve,
  }) =>
      Between<Coordinate>(
        begin: isEndZero ? another : Coordinate.zero,
        end: isEndZero ? Coordinate.zero : another,
        curve: curve,
      );
}

extension FBetweenCoordinateRadian on Between<Coordinate> {
  static Between<Coordinate> get x_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_360);

  static Between<Coordinate> get y_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_360);

  static Between<Coordinate> get z_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_360);

  static Between<Coordinate> get x_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_180);

  static Between<Coordinate> get y_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_180);

  static Between<Coordinate> get z_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_180);

  static Between<Coordinate> get x_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_90);

  static Between<Coordinate> get y_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_90);

  static Between<Coordinate> get z_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_90);

  static Between<Coordinate> toX360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_360);

  static Between<Coordinate> toY360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_360);

  static Between<Coordinate> toZ360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_360);

  static Between<Coordinate> toX180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_180);

  static Between<Coordinate> toY180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_180);

  static Between<Coordinate> toZ180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_180);

  static Between<Coordinate> toX90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_90);

  static Between<Coordinate> toY90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_90);

  static Between<Coordinate> toZ90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_90);
}
