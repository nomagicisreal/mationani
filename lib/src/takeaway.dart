part of '../api.dart';

///
/// [between_double_0From], ...
/// [between_offset_0From], ...
/// [between_point3_0From], ...
/// [between_radian3_0From], ...
///
/// [amplitude_double_0From], ...
/// [amplitude_offset_0From], ...
/// [amplitude_point3_0From], ...
/// [amplitude_radian3_0From], ...
///
abstract final class FMationValue {
  ///
  ///
  ///
  static Between<double> between_double_0From(double begin, {CurveFR? curve}) =>
      Between(begin, 0, curve: curve);

  static Between<double> between_double_0To(double end, {CurveFR? curve}) =>
      Between(0, end, curve: curve);

  static Between<double> between_double_1From(double begin, {CurveFR? curve}) =>
      Between(begin, 1, curve: curve);

  static Between<double> between_double_1To(double end, {CurveFR? curve}) =>
      Between(1, end, curve: curve);

  ///
  ///
  ///
  static Between<Offset> between_offset_0From(Offset begin, {CurveFR? curve}) =>
      Between(begin, Offset.zero, curve: curve);

  static Between<Offset> offset_0To(Offset end, {CurveFR? curve}) =>
      Between(Offset.zero, end, curve: curve);

  static Between<Offset> between_offset_ofDirection(
          double direction, double begin, double end,
          {CurveFR? curve}) =>
      Between(
        Offset.fromDirection(direction, begin),
        Offset.fromDirection(direction, end),
        curve: curve,
      );

  static Between<Offset> between_offset_ofDirection0From(
    double direction,
    double begin, {
    CurveFR? curve,
  }) =>
      between_offset_ofDirection(direction, begin, 0, curve: curve);

  static Between<Offset> between_offset_ofDirection0To(
    double direction,
    double end, {
    CurveFR? curve,
  }) =>
      between_offset_ofDirection(direction, 0, end, curve: curve);

  ///
  ///
  ///
  static Between<Point3> between_point3_0From(Point3 begin, {CurveFR? curve}) =>
      Between<Point3>(begin, Point3.zero, curve: curve);

  static Between<Point3> between_point3_0To(Point3 end, {CurveFR? curve}) =>
      Between<Point3>(Point3.zero, end, curve: curve);

  ///
  ///
  ///
  static Between<Radian3> between_radian3_0From(Radian3 begin,
          {CurveFR? curve}) =>
      Between<Radian3>(begin, Radian3.zero, curve: curve);

  static Between<Radian3> between_radian3_0To(Radian3 end, {CurveFR? curve}) =>
      Between<Radian3>(Radian3.zero, end, curve: curve);

  ///
  ///
  ///
  static Amplitude<double> amplitude_double_0From(
    double begin,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(begin, 0.0, times, style: style);

  static Amplitude<double> amplitude_double_0To(
    double end,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(0, end, times, style: style);

  static Amplitude<double> amplitude_double_1To(
    double end,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(1, end, times, style: style);

  ///
  ///
  ///
  static Amplitude<Offset> amplitude_offset_0From(
    Offset begin,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(begin, Offset.zero, times, style: style);

  static Amplitude<Offset> amplitude_offset_0To(
    Offset end,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Offset.zero, end, times, style: style);

  ///
  ///
  ///
  static Amplitude<Point3> amplitude_point3_0From(
    Point3 begin,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(begin, Point3.zero, times, style: style);

  static Amplitude<Point3> amplitude_point3_0To(
    Point3 end,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Point3.zero, end, times, style: style);

  ///
  ///
  ///
  static Amplitude<Radian3> amplitude_radian3_0From(
    Radian3 begin,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(begin, Radian3.zero, times, style: style);

  static Amplitude<Radian3> amplitude_radian3_0To(
    Radian3 end,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Radian3.zero, end, times, style: style);
}
