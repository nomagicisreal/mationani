part of '../mationani.dart';

///
///
/// * [FOnAnimateMatrix4]
///
/// [MamableSolo]
///   | ...
///   --[MamableTransformDelegate]
///
/// [_MamionNest]
///   | ...
///   --[MamableTransform]
///
///
///
///

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
/// its point3 system is based on [Transform] direction, translation (negative to positive).
/// direction: x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// direction: y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// direction: z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], [Offset.direction]),
/// translation: x axis comes from [Direction3DIn6.left] to [Direction3DIn6.right]
/// translation: y axis comes from [Direction3DIn6.top] to [Direction3DIn6.bottom]
/// translation: z axis comes from [Direction3DIn6.front] to [Direction3DIn6.back]
///
/// See Also:
///   * [Direction], [Direction3DIn6]
///   * [Point3.fromDirection]
///
///
/// animation for flutter [Transform]
///
final class MamableTransformDelegate extends MamableSolo<Point3> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  ///
  ///
  ///
  MamableTransformDelegate._(
      Matalue<Point3> value, {
        required this.alignment,
        required this.host,
        required this.onAnimate,
      }) : super(
      value,
          (animation, child) => Transform(
        transform: onAnimate(host, animation.value),
        alignment: alignment,
        child: child,
      ));

  MamableTransformDelegate.translation(
      Matalue<Point3> value, {
        AlignmentGeometry? alignment,
        Matrix4? host,
      }) : this._(
    value,
    alignment: alignment,
    host: host ?? Matrix4.identity(),
    onAnimate: FOnAnimateMatrix4.translating,
  );

  MamableTransformDelegate.rotation(
      Matalue<Point3> value, {
        AlignmentGeometry? alignment,
        Matrix4? host,
      }) : this._(
    value,
    alignment: alignment,
    host: host ?? Matrix4.identity(),
    onAnimate: FOnAnimateMatrix4.rotating,
  );

  MamableTransformDelegate.scale(
      Matalue<Point3> value, {
        AlignmentGeometry? alignment,
        Matrix4? host,
      }) : this._(
    value,
    alignment: alignment,
    host: host ?? Matrix4.identity(),
    onAnimate: FOnAnimateMatrix4.scaling,
  );

  ///
  ///
  ///
  void link(Matrix4 host) => this.host = host;

  bool isSameTypeWith(MamableTransformDelegate another) =>
      onAnimate == another.onAnimate;

  MamableTransformDelegate align(AlignmentGeometry? alignment) =>
      MamableTransformDelegate._(
        value,
        onAnimate: onAnimate,
        alignment: alignment,
        host: host,
      );
}


///
/// animation for [MamableTransformDelegate] combinations
///
final class MamableTransform extends _MatableSet<MamableTransformDelegate>
    with _PerformMamableSetMixin<MamableTransformDelegate> {
  MamableTransform._(
    Iterable<MamableTransformDelegate> delegates, {
    Matrix4? host,
    List<OnAnimateMatrix4> order = FOnAnimateMatrix4.orderTRS,
  })  : assert(order.length == 3 && !order.iterator.existEqual),
        super(_sort(
          delegates.map((d) => d..link(host ?? Matrix4.identity())),
          order,
        ));

  MamableTransform({
    Matrix4? host,
    Between<Point3>? translateBetween,
    Between<Point3>? rotateBetween,
    Between<Point3>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    List<OnAnimateMatrix4> order = FOnAnimateMatrix4.orderTRS,
  }) : this._([
          if (translateBetween != null)
            MamableTransformDelegate.translation(
              translateBetween,
              alignment: translateAlignment,
              host: host,
            ),
          if (rotateBetween != null)
            MamableTransformDelegate.rotation(
              rotateBetween,
              alignment: rotateAlignment,
              host: host,
            ),
          if (scaleBetween != null)
            MamableTransformDelegate.scale(
              scaleBetween,
              alignment: scaleAlignment,
              host: host,
            ),
        ]);

  MamableTransform.distanced({
    required double distanceToObserver,
    Between<Point3>? translateBetween,
    Between<Point3>? rotateBetween,
    Between<Point3>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    Matrix4? host,
  }) : this(
          host: (host ?? Matrix4.identity())..setDistance(distanceToObserver),
          translateBetween: translateBetween,
          rotateBetween: rotateBetween,
          scaleBetween: scaleBetween,
          translateAlignment: translateAlignment,
          rotateAlignment: rotateAlignment,
          scaleAlignment: scaleAlignment,
        );

  MamableTransform alignAll({
    AlignmentGeometry? translation,
    AlignmentGeometry? rotation,
    AlignmentGeometry? scaling,
  }) =>
      MamableTransform._(ables.map((base) {
        final before = base.alignment;
        final onAnimate = base.onAnimate;
        return base.align(switch (onAnimate) {
          FOnAnimateMatrix4.translating => translation ?? before,
          FOnAnimateMatrix4.rotating => rotation ?? before,
          FOnAnimateMatrix4.scaling => scaling ?? before,
          _ => throw UnimplementedError(),
        });
      }));

  ///
  ///
  ///
  static Iterable<MamableTransformDelegate> _sort(
    Iterable<MamableTransformDelegate> delegates,
    List<OnAnimateMatrix4> order,
  ) {
    final map =
        Map.fromIterable(order, value: (_) => <MamableTransformDelegate>[]);
    for (var delegate in delegates) {
      map[delegate.onAnimate]!.add(delegate);
    }
    return order.expand((onAnimate) => map[onAnimate]!);
  }

  //
  static Transform transformFromDirection({
    double zDeep = 100,
    required Direction3DIn6 direction,
    required Widget child,
  }) =>
      switch (direction) {
        Direction3DIn6.front => Transform(
            transform: Matrix4.identity(),
            alignment: Alignment.center,
            child: child,
          ),
        Direction3DIn6.back => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..translateOf(Point3.ofZ(-zDeep)),
            child: child,
          ),
        Direction3DIn6.left => Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()..rotateY(Radian.angle_90),
            child: child,
          ),
        Direction3DIn6.right => Transform(
            alignment: Alignment.centerRight,
            transform: Matrix4.identity()..rotateY(-Radian.angle_90),
            child: child,
          ),
        Direction3DIn6.top => Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()..rotateX(-Radian.angle_90),
            child: child,
          ),
        Direction3DIn6.bottom => Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()..rotateX(Radian.angle_90),
            child: child,
          ),
      };
}
