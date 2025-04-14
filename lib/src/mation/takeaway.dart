///
///
/// this file contains:
/// [FOnAnimateMatrix4], [FBetween], [FAmplitude]
///
///
part of '../../mationani.dart';

///
/// static methods, constants:
/// [translating], ...
/// [mapTranslating], ...
/// [fixedTranslating], ...
/// [onTranslating], ...
/// [orderTRS], ...
///
/// instance methods, getters:
/// [setPerspective], ...
/// [getPerspective], ...
/// [perspectiveIdentity], ...
///
extension FOnAnimateMatrix4 on Matrix4 {
  ///
  /// statics methods
  ///
  static Matrix4 translating(Matrix4 matrix4, Point3 value) =>
      matrix4.perspectiveIdentity..translateOf(value);

  static Matrix4 rotating(Matrix4 matrix4, Point3 value) =>
      matrix4..setRotation((Matrix4.identity()..rotateOf(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Point3 value) =>
      matrix4.scaledOf(value);

// with mapping
  static OnAnimateMatrix4 mapTranslating(Applier<Point3> mapping) =>
      (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(mapping(value));

  static OnAnimateMatrix4 mapRotating(Applier<Point3> mapping) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(mapping(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Applier<Point3> mapping) =>
      (matrix4, value) => matrix4.scaledOf(mapping(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Point3 fixed) =>
      (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Point3 fixed) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Point3 fixed) =>
      (matrix4, value) => matrix4.scaledOf(value + fixed);

  ///
  /// static constants
  ///
  static const OnAnimateMatrix4 onTranslating = FOnAnimateMatrix4.translating;
  static const OnAnimateMatrix4 onRotating = FOnAnimateMatrix4.rotating;
  static const OnAnimateMatrix4 onScaling = FOnAnimateMatrix4.scaling;
  static const List<OnAnimateMatrix4> orderTRS = [
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.scaling,
  ];
  static const List<OnAnimateMatrix4> orderTSR = [
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.rotating,
  ];
  static const List<OnAnimateMatrix4> orderSTR = [
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.rotating,
  ];
  static const List<OnAnimateMatrix4> orderSRT = [
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.translating,
  ];
  static const List<OnAnimateMatrix4> orderRTS = [
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.scaling,
  ];
  static const List<OnAnimateMatrix4> orderRST = [
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.translating,
  ];

  ///
  /// instance methods
  ///
  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  void translateOf(Point3 point3) =>
      translate(v64.Vector3(point3.x, point3.y, point3.z));

  void translateFor(Offset offset) =>
      translate(v64.Vector3(offset.dx, offset.dy, 0));

  void rotateOf(Point3 point3) => this
    ..rotateX(point3.x)
    ..rotateY(point3.y)
    ..rotateZ(point3.z);

  void rotateOn(Point3 point3, double radian) =>
      rotate(v64.Vector3(point3.x, point3.y, point3.z), radian);

  double getPerspective() => entry(3, 2);

  Matrix4 get perspectiveIdentity => Matrix4.identity()..copyPerspective(this);

  Matrix4 scaledOf(Point3 point3) => scaled(point3.x, point3.y, point3.z);

  Matrix4 scaledFor(Offset offset) => scaled(offset.dx, offset.dy, 1);
}

///
/// static methods:
/// [double_0], ...
/// [offsetKZero], ...
/// [point3KZero], ...
///
extension FBetween on Between {
  ///
  /// static methods
  ///
  static Between<double> double_0From(double begin, {CurveFR? curve}) =>
      Between(begin, 0, curve: curve);

  static Between<double> double_0To(double end, {CurveFR? curve}) =>
      Between(0, end, curve: curve);

  static Between<double> double_1From(double begin, {CurveFR? curve}) =>
      Between(begin, 1, curve: curve);

  static Between<double> double_1To(double end, {CurveFR? curve}) =>
      Between(1, end, curve: curve);

  static Between<double> double_0BeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEnd0,
  }) =>
      Between(isEnd0 ? another : 0, isEnd0 ? 0 : another, curve: curve);

  static Between<double> double_1BeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEndOne,
  }) =>
      Between(isEndOne ? another : 1, isEndOne ? 1 : another, curve: curve);

  ///
  ///
  ///
  static Between<Offset> offset_0From(Offset begin, {CurveFR? curve}) =>
      Between(begin, Offset.zero, curve: curve);

  static Between<Offset> offset_0To(Offset end, {CurveFR? curve}) =>
      Between(Offset.zero, end, curve: curve);

  static Between<Offset> offset_0BeginOrEnd(
    Offset another, {
    CurveFR? curve,
    required bool isEnd0,
  }) =>
      Between<Offset>(
        isEnd0 ? another : Offset.zero,
        isEnd0 ? Offset.zero : another,
        curve: curve,
      );

  static Between<Offset> offset_ofDirection(
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

  static Between<Offset> offset_ofDirection0From(
    double direction,
    double begin, {
    CurveFR? curve,
  }) =>
      offset_ofDirection(direction, begin, 0, curve: curve);

  static Between<Offset> offset_ofDirection0To(
    double direction,
    double end, {
    CurveFR? curve,
  }) =>
      offset_ofDirection(direction, 0, end, curve: curve);

  ///
  ///
  ///
  static Between<Point3> point3_0From(
    Point3 begin, {
    CurveFR? curve,
  }) =>
      Between<Point3>(begin, Point3.zero, curve: curve);

  static Between<Point3> point3_0To(
    Point3 end, {
    CurveFR? curve,
  }) =>
      Between<Point3>(Point3.zero, end, curve: curve);

  static Between<Point3> point3_0BeginOrEnd(
    Point3 another, {
    CurveFR? curve,
    required bool isEnd0,
  }) =>
      Between<Point3>(
        isEnd0 ? another : Point3.zero,
        isEnd0 ? Point3.zero : another,
        curve: curve,
      );

  static Between<Point3> point3_360From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_360));

  static Between<Point3> point3_y360From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_360));

  static Between<Point3> point3_z360From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_360));

  static Between<Point3> point3_x180From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_180));

  static Between<Point3> point3_y180From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_180));

  static Between<Point3> point3_z180From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_180));

  static Between<Point3> point3_x90From(Point3 from) =>
      Between(from, Point3.ofX(Radian.angle_90));

  static Between<Point3> point3_y90From(Point3 from) =>
      Between(from, Point3.ofY(Radian.angle_90));

  static Between<Point3> point3_z90From(Point3 from) =>
      Between(from, Point3.ofZ(Radian.angle_90));
}

///
/// static methods:
/// [double_from0], ...
/// [offset_from0], [point3_from0], ...
///
extension FAmplitude on Amplitude {
  ///
  /// static methods
  ///
  static Amplitude<double> double_from0(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(0, value, times, style: style);

  static Amplitude<double> double_fromOne(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(1, value, times, style: style);

  ///
  ///
  ///
  static Amplitude<Offset> offset_from0(
    Offset value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Offset.zero, value, times, style: style);

  static Amplitude<Point3> point3_from0(
    Point3 value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Point3.zero, value, times, style: style);

  static Amplitude<Radian3> point3_fromRadian0(
    Radian3 value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Radian3.zero, value, times, style: style);
}
