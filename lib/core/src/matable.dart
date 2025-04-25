part of '../mationani.dart';

///
///
/// * [FOnAnimateMatrix4]
///
/// * [Matable]
///     --[_MatableSolo]
///     |   --[MamableSolo]
///     |   |   --[MamableTransition]
///     |   |   --[MamableClipper]
///     |   |   --[MamablePainter]
///     |   |   --[MamableTransformDelegate]
///     |   |
///     |   --[ManableSolo]
///     |
///     --[_MatableNest]
///         --[MamableSet]
///         --[MamableTransform]
///         --[ManableSet]
///         |   --[_MNA]
///         |   --[_MNE]
///         |
///         --[ManableRespectively]
///             --[_MNRParent]
///
///
///

///
/// [MamableTransition.fade], ...
/// [MamableTransition.scale], ...
/// [MamableTransition.rotate], ...
/// [MamableTransition.slide], ...
/// [MamableTransition.decoration], ...
///
final class MamableTransition extends MamableSolo {
  MamableTransition.fade(Matalue<double> value)
      : super(
          value,
          (animation, child) => FadeTransition(
            opacity: animation as Animation<double>,
            child: child,
          ),
        );

  MamableTransition.fadeIn({CurveFR? curve})
      : this.fade(Between(0.0, 1.0, curve: curve));

  MamableTransition.fadeInTo(double opacity, {CurveFR? curve})
      : this.fade(Between(0.0, opacity, curve: curve));

  MamableTransition.fadeOut({CurveFR? curve})
      : this.fade(Between(1.0, 0.0, curve: curve));

  MamableTransition.silverFade(Matalue<double> value)
      : super(
          value,
          (animation, child) => SliverFadeTransition(
            opacity: animation as Animation<double>,
            sliver: child,
          ),
        );

  ///
  ///
  ///
  MamableTransition.scale(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          value,
          (animation, child) => ScaleTransition(
            scale: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MamableTransition.size(
    Matalue<double> value, {
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
  }) : super(
          value,
          (animation, child) => SizeTransition(
            sizeFactor: animation as Animation<double>,
            axis: axis,
            axisAlignment: axisAlignment,
            child: child,
          ),
        );

  ///
  ///
  ///
  MamableTransition.rotate(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          value,
          (animation, child) => RotationTransition(
            turns: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MamableTransition.rotateInRadian(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : this.rotate(Matalue.doubleToRadian(value), alignment: alignment);

  ///
  ///
  ///
  MamableTransition.slide(
    Matalue<Offset> value, {
    bool transformHitTests = true,
    TextDirection? textDirection,
  }) : super(
          value,
          (animation, child) => SlideTransition(
            position: animation as Animation<Offset>,
            transformHitTests: transformHitTests,
            textDirection: textDirection,
            child: child,
          ),
        );

  MamableTransition.positioned(Matalue<RelativeRect> value)
      : super(
          value,
          (animation, child) => PositionedTransition(
            rect: animation as Animation<RelativeRect>,
            child: child,
          ),
        );

  MamableTransition.relativePositioned(
    Matalue<double> value, {
    required Size size,
  }) : super(
          value,
          (animation, child) => RelativePositionedTransition(
            rect: animation as Animation<Rect>,
            size: size,
            child: child,
          ),
        );

  MamableTransition.align(Matalue<AlignmentGeometry> value)
      : super(
          value,
          (animation, child) => AlignTransition(
            alignment: animation as Animation<AlignmentGeometry>,
            child: child,
          ),
        );

  ///
  ///
  ///
  MamableTransition.decoration(Matalue<Decoration> value)
      : super(
          value,
          (animation, child) => DecoratedBoxTransition(
            decoration: animation as Animation<Decoration>,
            child: child,
          ),
        );

  MamableTransition.defaultTextStyle(Matalue<TextStyle> value)
      : super(
          value,
          (animation, child) => DefaultTextStyleTransition(
            style: animation as Animation<TextStyle>,
            child: child,
          ),
        );
}

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
  ///
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
///
/// the coordinate system of [MamableTransformDelegate] is same as [Transform] widget's direction, translation.
/// the 'axis' below is from 'coordinate-axis-negative' to 'coordinate-axis-positive'.
/// it's easier to understand them with animated [Transform] widget with [Matrix4] instance continued setState,
/// or just using [MamableTransformDelegate] wrapped in [Mationani] widget with [Ani.initRepeat].
///
/// translation x axis comes from [Direction3DIn6.left] to [Direction3DIn6.right]
/// translation y axis comes from [Direction3DIn6.top] to [Direction3DIn6.bottom]
/// translation z axis comes from [Direction3DIn6.front] to [Direction3DIn6.back]
/// direction x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// direction y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// direction z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], [Offset.direction]),
///
///
final class MamableTransformDelegate extends MamableSolo<Point3> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

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
          ),
        );

  ///
  ///
  ///
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
///
///
final class MamableTransform extends MamableSet<MamableTransformDelegate> {
  MamableTransform.fromDelegates(
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
  }) : this.fromDelegates([
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
      MamableTransform.fromDelegates(ables.map((base) {
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

///
///
///
final class MamableClipper extends MamableSolo<SizingPath> {
  final Clip clipBehavior;

  MamableClipper(
    Between<SizingPath> value, {
    this.clipBehavior = Clip.antiAlias,
  }) : super(
          value,
          (animation, child) => ClipPath(
            clipper: Clipping.reclipWhenUpdate(animation.value),
            clipBehavior: clipBehavior,
            child: child,
          ),
        );
}

///
///
///
final class MamablePainter extends MamableSolo<SizingPath> {
  final bool isComplex;
  final CustomPainter? foreground;
  final Size size;
  final Painter painter;

  MamablePainter(
    Between<SizingPath> value, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.foreground,
    required this.painter,
  }) : super(
          value,
          (animation, child) => CustomPaint(
            willChange: true,
            painter: painter(animation.value),
            foregroundPainter: foreground,
            size: size,
            isComplex: isComplex,
            child: child,
          ),
        );

  MamablePainter.paintFrom(
    Between<SizingPath> value, {
    required PaintFrom paintFrom,
  }) : this(
          value,
          isComplex: false,
          size: Size.zero,
          foreground: null,
          painter: FPainter.of(paintFrom),
        );
}
