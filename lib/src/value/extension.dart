///
///
/// this file contains:
///
/// [MationableValueDoubleExtension]
///
/// [BetweenOffsetExtension]
/// [BetweenSpace3Extension]
/// [BetweenSpace3RadianExtension]
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
            Radian.radianFromRound(round.begin),
            Radian.radianFromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            Radian.radianFromRound(round.from),
            Radian.radianFromRound(round.value),
            round.times,
            style: round.style,
            curve: round.curve,
          ),
      };
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => begin.directionTo(end);
}

extension BetweenSpace3Extension on Between<Space3> {
  ///
  /// see the comment above [Space3.transferToTransformOf]
  ///
  Between<Space3> get transferToTransform => Between.constant(
        Space3.transferToTransformOf(begin),
        Space3.transferToTransformOf(end),
        curve: curve,
        onLerp: onLerp,
      );
}

extension BetweenSpace3RadianExtension on Between<Space3Radian> {
  static Between<Space3Radian> x360From(Space3Radian from) =>
      Between<Space3Radian>(from, Space3Radian.angleX_360);

  static Between<Space3Radian> y360From(Space3Radian from) =>
      Between(from, Space3Radian.angleY_360);

  static Between<Space3Radian> z360From(Space3Radian from) =>
      Between(from, Space3Radian.angleZ_360);

  static Between<Space3Radian> x180From(Space3Radian from) =>
      Between(from, Space3Radian.angleX_180);

  static Between<Space3Radian> y180From(Space3Radian from) =>
      Between(from, Space3Radian.angleY_180);

  static Between<Space3Radian> z180From(Space3Radian from) =>
      Between(from, Space3Radian.angleZ_180);

  static Between<Space3Radian> x90From(Space3Radian from) =>
      Between(from, Space3Radian.angleX_90);

  static Between<Space3Radian> y90From(Space3Radian from) =>
      Between(from, Space3Radian.angleY_90);

  static Between<Space3Radian> z90From(Space3Radian from) =>
      Between(from, Space3Radian.angleZ_90);
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
  static Between<Space3> get coordinateKZero => Between.of(Space3.zero);

  static Between<Space3> coordinateZeroFrom(
    Space3 begin, {
    CurveFR? curve,
  }) =>
      Between<Space3>(begin, Space3.zero, curve: curve);

  static Between<Space3> coordinateZeroTo(
    Space3 end, {
    CurveFR? curve,
  }) =>
      Between<Space3>(Space3.zero, end, curve: curve);

  static Between<Space3> coordinateOneFrom(
    Space3 begin, {
    CurveFR? curve,
  }) =>
      Between<Space3>(begin, Space3.cube_1, curve: curve);

  static Between<Space3> coordinateOneTo(
    Space3 end, {
    CurveFR? curve,
  }) =>
      Between<Space3>(Space3.cube_1, end, curve: curve);

  static Between<Space3> coordinateZeroBeginOrEnd(
    Space3 another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between<Space3>(
        isEndZero ? another : Space3.zero,
        isEndZero ? Space3.zero : another,
        curve: curve,
      );

  static Between<Space3> coordinateOneBeginOrEnd(
    Space3 another,
    CurveFR? curve, {
    required bool isEndOne,
  }) =>
      Between<Space3>(
        isEndOne ? another : Space3.one,
        isEndOne ? Space3.one : another,
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

  static Amplitude<Space3> coordinateFromZero(
    Space3 value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Space3.zero, value, times, style: style);

  static Amplitude<Space3Radian> coordinateRadianFromZero(
    Space3Radian value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Space3Radian.zero, value, times, style: style);
}
