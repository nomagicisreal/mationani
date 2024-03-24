///
///
/// this file contains:
///
/// [MationableValueDoubleExtension]
///
/// [BetweenOffsetExtension]
/// [BetweenPoint3Extension]
/// [BetweenRadian3Extension]
/// [FBetween]
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

//
extension MationableValueDoubleExtension on Mationvalue<double> {
  static Mationvalue<double> toRadianFrom(Mationvalue<double> round) =>
      switch (round) {
        Between<double>() => Between(
            RotationUnit.radianFromRound(round.begin),
            RotationUnit.radianFromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            RotationUnit.radianFromRound(round.from),
            RotationUnit.radianFromRound(round.value),
            round.times,
            style: round.style,
            curve: round.curve,
          ),
      };
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => end.direction - begin.direction;
}

extension BetweenPoint3Extension on Between<Point3> {
  static Between<Point3> x360From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_360));

  static Between<Point3> y360From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_360));

  static Between<Point3> z360From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_360));

  static Between<Point3> x180From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_180));

  static Between<Point3> y180From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_180));

  static Between<Point3> z180From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_180));

  static Between<Point3> x90From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_90));

  static Between<Point3> y90From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_90));

  static Between<Point3> z90From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_90));
}

extension FBetween on Between {
  ///
  ///
  /// [doubleKZero], [doubleKOne]
  /// [doubleZeroFrom], [doubleZeroTo]
  /// [doubleOneFrom], [doubleOneTo]
  /// [doubleZeroBeginOrEnd], [doubleOneBeginOrEnd]
  ///
  ///
  static Between<double> get doubleKZero => Between.of(0);

  static Between<double> get doubleKOne => Between.of(1);

  static Between<double> doubleZeroFrom(double begin, {CurveFR? curve}) =>
      Between(begin, 0, curve: curve);

  static Between<double> doubleZeroTo(double end, {CurveFR? curve}) =>
      Between(0, end, curve: curve);

  static Between<double> doubleOneFrom(double begin, {CurveFR? curve}) =>
      Between(begin, 1, curve: curve);

  static Between<double> doubleOneTo(double end, {CurveFR? curve}) =>
      Between(1, end, curve: curve);

  static Between<double> doubleZeroBeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between(isEndZero ? another : 0, isEndZero ? 0 : another, curve: curve);

  static Between<double> doubleOneBeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEndOne,
  }) =>
      Between(isEndOne ? another : 1, isEndOne ? 1 : another, curve: curve);

  ///
  ///
  /// [offsetKZero]
  /// [offsetZeroFrom], [offsetZeroTo], [offsetZeroBeginOrEnd]
  /// [offsetOfDirection], [offsetOfDirectionZeroFrom], [offsetOfDirectionZeroTo]
  ///
  ///
  static Between<Offset> get offsetKZero => Between.of(Offset.zero);

  static Between<Offset> offsetZeroFrom(Offset begin, {CurveFR? curve}) =>
      Between(begin, Offset.zero, curve: curve);

  static Between<Offset> offsetZeroTo(Offset end, {CurveFR? curve}) =>
      Between(Offset.zero, end, curve: curve);

  static Between<Offset> offsetZeroBeginOrEnd(
    Offset another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between<Offset>(
        isEndZero ? another : Offset.zero,
        isEndZero ? Offset.zero : another,
        curve: curve,
      );

  static Between<Offset> offsetOfDirection(
    double direction,
    double begin,
    double end, {
    CurveFR? curve,
  }) =>
      Between(
        Offset.fromDirection(direction, begin),
        Offset.fromDirection(direction, end),
        curve: curve,
      );

  static Between<Offset> offsetOfDirectionZeroFrom(
    double direction,
    double begin, {
    CurveFR? curve,
  }) =>
      offsetOfDirection(direction, begin, 0, curve: curve);

  static Between<Offset> offsetOfDirectionZeroTo(
    double direction,
    double end, {
    CurveFR? curve,
  }) =>
      offsetOfDirection(direction, 0, end, curve: curve);

  ///
  ///
  /// [coordinateKZero]
  /// [coordinateZeroFrom], [coordinateZeroTo]
  /// [coordinateOneFrom], [coordinateOneTo]
  /// [coordinateZeroBeginOrEnd], [coordinateOneBeginOrEnd]
  ///
  ///
  static Between<Point3> get coordinateKZero => Between.of(Point3.zero);

  static Between<Point3> coordinateZeroFrom(
    Point3 begin, {
    CurveFR? curve,
  }) =>
      Between<Point3>(begin, Point3.zero, curve: curve);

  static Between<Point3> coordinateZeroTo(
    Point3 end, {
    CurveFR? curve,
  }) =>
      Between<Point3>(Point3.zero, end, curve: curve);

  static Between<Point3> coordinateOneFrom(
    Point3 begin, {
    CurveFR? curve,
  }) =>
      Between<Point3>(begin, Point3.one, curve: curve);

  static Between<Point3> coordinateOneTo(
    Point3 end, {
    CurveFR? curve,
  }) =>
      Between<Point3>(Point3.one, end, curve: curve);

  static Between<Point3> coordinateZeroBeginOrEnd(
    Point3 another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between<Point3>(
        isEndZero ? another : Point3.zero,
        isEndZero ? Point3.zero : another,
        curve: curve,
      );

  static Between<Point3> coordinateOneBeginOrEnd(
    Point3 another,
    CurveFR? curve, {
    required bool isEndOne,
  }) =>
      Between<Point3>(
        isEndOne ? another : Point3.one,
        isEndOne ? Point3.one : another,
        curve: curve,
      );
}

extension FAmplitude on Amplitude {
  ///
  /// [doubleFromZero], [doubleFromOne]
  ///
  static Amplitude<double> doubleFromZero(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(0, value, times, style: style);

  static Amplitude<double> doubleFromOne(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(1, value, times, style: style);

  ///
  /// [offsetFromZero], [coordinateFromZero]
  ///
  static Amplitude<Offset> offsetFromZero(
    Offset value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Offset.zero, value, times, style: style);

  static Amplitude<Point3> coordinateFromZero(
    Point3 value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Point3.zero, value, times, style: style);

  static Amplitude<Radian3> coordinateRadianFromZero(
    Radian3 value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Radian3.zero, value, times, style: style);
}
