part of '../../mationani.dart';

///
///
/// [Mationability]
///   --[Mamionability]
///   |   --[MamionSingle] (trigger animations by 1 [Between])
///   |   |   --[MamionTransition] (implements animation for [AnimatedWidget])
///   |   |   |
///   |   |   --[_MamionSingleSizingPath]
///   |   |   |   --[MamionClipper] (implements animation for [ClipPath])
///   |   |   |   --[MamionPainter] (implements animation for [CustomPaint])
///   |   |   |
///   |   |   --[MamionTransformDelegate] (implements animation for [Transform])
///   |   |
///   |   --[MamionMulti] (trigger animations by multiple [Between])
///   |       --[MamionTransform] (combinations of [MamionTransformDelegate])
///   |
///   --[Manionability]
///       --[ManionChildren]
///       --[ManionParentChildren]
///
///

///
/// [MamionSingle], [MamionMulti]
///
class MamionSingle<T> extends _MamionSingle<T> implements Mamionability {
  const MamionSingle(super.value, super.plan);

  @override
  WidgetBuilder planFor(Animation<double> animation, WidgetBuilder builder) {
    final animate = this.animate(animation);
    final plan = this.plan;
    return (context) => plan(animate, builder(context));
  }
}

///
/// [MamionTransition.rotate], [MamionTransition.rotateInRadian]
/// [MamionTransition.scale], [MamionTransition.size], ...
/// [MamionTransition.relativePositioned], ...
/// [MamionTransition.positioned], ..., [MamionTransition.slide], ...
/// [MamionTransition.decoration], ...
/// [MamionTransition.fade], ..., [MamionTransition.silverFade], ...
/// [MamionTransition.align], ...
/// [MamionTransition.defaultTextStyle], ...
///
class MamionTransition extends MamionSingle {
  MamionTransition.rotate(
    Mationvalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          value,
          (animation, child) => RotationTransition(
            turns: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MamionTransition.rotateInRadian(
    Mationvalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : this.rotate(
          MationvalueDoubleExtension.toRadianFrom(value),
          alignment: alignment,
        );

  MamionTransition.scale(
    Mationvalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          value,
          (animation, child) => ScaleTransition(
            scale: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MamionTransition.size(
    Mationvalue<double> value, {
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

  MamionTransition.relativePositioned(
    Mationvalue<double> value, {
    required Size size,
  }) : super(
          value,
          (animation, child) => RelativePositionedTransition(
            rect: animation as Animation<Rect>,
            size: size,
            child: child,
          ),
        );

  MamionTransition.positioned(Mationvalue<RelativeRect> value)
      : super(
          value,
          (animation, child) => PositionedTransition(
            rect: animation as Animation<RelativeRect>,
            child: child,
          ),
        );

  MamionTransition.slide(
    Mationvalue<Offset> value, {
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

  MamionTransition.decoration(Mationvalue<Decoration> value)
      : super(
          value,
          (animation, child) => DecoratedBoxTransition(
            decoration: animation as Animation<Decoration>,
            child: child,
          ),
        );

  MamionTransition.fade(Mationvalue<double> value)
      : super(
          value,
          (animation, child) => FadeTransition(
            opacity: animation as Animation<double>,
            child: child,
          ),
        );

  MamionTransition.fadeIn({CurveFR? curve})
      : this.fade(FBetween.double_0To(1, curve: curve));

  MamionTransition.fadeInTo(double opacity, {CurveFR? curve})
      : this.fade(FBetween.double_0To(opacity, curve: curve));

  MamionTransition.fadeOut({CurveFR? curve})
      : this.fade(FBetween.double_0From(1, curve: curve));

  MamionTransition.silverFade(Mationvalue<double> value)
      : super(
          value,
          (animation, child) => SliverFadeTransition(
            opacity: animation as Animation<double>,
            sliver: child,
          ),
        );

  MamionTransition.align(Mationvalue<AlignmentGeometry> value)
      : super(
          value,
          (animation, child) => AlignTransition(
            alignment: animation as Animation<AlignmentGeometry>,
            child: child,
          ),
        );

  MamionTransition.defaultTextStyle(Mationvalue<TextStyle> value)
      : super(
          value,
          (animation, child) => DefaultTextStyleTransition(
            style: animation as Animation<TextStyle>,
            child: child,
          ),
        );
}

///
/// [_MamionSingleSizingPath], [MamionClipper], [MamionPainter]
///
class _MamionSingleSizingPath extends MamionSingle<SizingPath> {
  const _MamionSingleSizingPath(
    BetweenPath value, {
    AnimationBuilder builder = FWidgetBuilder.noneAnimation,
  }) : super(value, builder);
}

class MamionClipper extends _MamionSingleSizingPath {
  final Clip clipBehavior;

  @override
  AnimationBuilder get plan => (animation, child) => ClipPath(
        clipper: Clipping.reclipWhenUpdate(animation.value),
        clipBehavior: clipBehavior,
        child: child,
      );

  const MamionClipper(
    super.value, {
    this.clipBehavior = Clip.antiAlias,
    super.builder,
  });
}

class MamionPainter extends _MamionSingleSizingPath {
  final bool isComplex;
  final CustomPainter? foreground;
  final Size size;
  final Painter painter;

  @override
  AnimationBuilder get plan => (animation, child) => CustomPaint(
        willChange: true,
        painter: painter(animation.value),
        foregroundPainter: foreground,
        size: size,
        isComplex: isComplex,
        child: child,
      );

  const MamionPainter(
    super.value, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.foreground,
    required this.painter,
    super.builder,
  });

  MamionPainter.paintFrom(
    super.value, {
    required PaintFrom paintFrom,
    super.builder,
  })  : isComplex = false,
        size = Size.zero,
        foreground = null,
        painter = FPainter.of(paintFrom);
}

///
///
///
/// [MamionMulti]
///
///
///

///
/// [MamionMulti.appear]
/// [MamionMulti.spill]
/// [MamionMulti.penetrate]
/// [MamionMulti.leave]
/// [MamionMulti.shoot], [MamionMulti.enlarge]
/// [MamionMulti.slideToAndScale]
///
/// [generateSpill], [generateShoot]
///
class MamionMulti extends _MamionMulti<Mamionability> {
  const MamionMulti(super.abilities);

  MamionMulti.appear({
    Alignment alignmentScale = Alignment.center,
    required Between<double> fading,
    required Between<double> scaling,
  }) : this([
          MamionTransition.fade(fading),
          MamionTransition.scale(scaling, alignment: alignmentScale),
        ]);

  MamionMulti.spill({
    required Between<double> fading,
    required Between<Offset> sliding,
  }) : this([
          MamionTransition.fade(fading),
          MamionTransition.slide(sliding),
        ]);

  MamionMulti.penetrate({
    double opacityShowing = 1.0,
    CurveFR? curveClip,
    Clip clipBehavior = Clip.hardEdge,
    required Between<double> fading,
    required Between<Rect> recting,
    required SizingPathFrom<Rect> sizingPathFrom,
  }) : this([
          MamionTransition.fade(fading),
          MamionClipper(
            BetweenPath<Rect>(
              recting,
              onAnimate: (t, rect) => sizingPathFrom(rect),
              curve: curveClip,
            ),
            clipBehavior: clipBehavior,
          ),
        ]);

  MamionMulti.leave({
    Alignment alignment = Alignment.topLeft,
    required Between<double> rotation,
    required Between<Offset> sliding,
  }) : this([
          MamionTransition.rotate(rotation, alignment: alignment),
          MamionTransition.slide(sliding),
        ]);

  MamionMulti.shoot({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<Offset> sliding,
    required Between<double> scaling,
  }) : this([
          MamionTransition.slide(sliding),
          MamionTransition.scale(scaling, alignment: alignmentScale),
        ]);

  MamionMulti.enlarge({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<double> scaling,
    required Between<Offset> sliding,
  }) : this([
          MamionTransition.scale(scaling, alignment: alignmentScale),
          MamionTransition.slide(sliding),
        ]);

  ///
  /// factories
  ///
  factory MamionMulti.slideToAndScale({
    required Offset destination,
    required double scaleEnd,
    double interval = 0.5, // must between 0.0 ~ 1.0
    CurveFR curveScale = CurveFR.linear,
    CurveFR curveSlide = CurveFR.linear,
  }) =>
      MamionMulti.shoot(
        sliding: FBetween.offset_0To(
          destination,
          curve: curveSlide.interval(0, interval),
        ),
        alignmentScale: Alignment.center,
        scaling: FBetween.double_1To(
          scaleEnd,
          curve: curveScale.interval(interval, 1),
        ),
      );

  ///
  /// generators
  ///
  static MationMultiGenerator generateSpill(
    Generator<double> direction,
    double distance, {
    CurveFR? curve,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamionMulti.spill(
          fading: FBetween.double_0To(1, curve: curve),
          sliding: FBetween.offset_ofDirection(
            direction(index),
            0,
            distance,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }

  static MationMultiGenerator generateShoot(
    Offset delta, {
    Generator<double> distribution = FKeep.generateDouble,
    CurveFR? curve,
    required Alignment alignmentScale,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamionMulti.shoot(
          alignmentScale: alignmentScale,
          sliding: FBetween.offset_0To(
            delta * distribution(index),
            curve: curve,
          ),
          scaling: FBetween.double_1From(
            0.0,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }
}

///
/// [MamionTransform] and [MamionTransformDelegate]
///
class MamionTransform extends _MamionMulti<MamionTransformDelegate> {
  ///
  /// constructors
  ///
  MamionTransform._(
    Iterable<MamionTransformDelegate> delegates, {
    Matrix4? host,
    List<OnAnimateMatrix4> order = FOnAnimateMatrix4.orderTRS,
  })  : assert(order.length == 3 && !order.iterator.existEqual),
        super(_sort(
          delegates.map((d) => d..link(host ?? Matrix4.identity())),
          order,
        ));

  MamionTransform({
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
            MamionTransformDelegate.translation(
              translateBetween,
              alignment: translateAlignment,
              host: host,
            ),
          if (rotateBetween != null)
            MamionTransformDelegate.rotation(
              rotateBetween,
              alignment: rotateAlignment,
              host: host,
            ),
          if (scaleBetween != null)
            MamionTransformDelegate.scale(
              scaleBetween,
              alignment: scaleAlignment,
              host: host,
            ),
        ]);

  MamionTransform.distanced({
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

  MamionTransform alignAll({
    AlignmentGeometry? translation,
    AlignmentGeometry? rotation,
    AlignmentGeometry? scaling,
  }) =>
      MamionTransform._(ables.map((base) {
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
  /// static methods
  ///
  static Iterable<MamionTransformDelegate> _sort(
    Iterable<MamionTransformDelegate> delegates,
    List<OnAnimateMatrix4> order,
  ) {
    final map =
        Map.fromIterable(order, value: (_) => <MamionTransformDelegate>[]);
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
///   * [Point3.transferToTransformOf], [Point3.fromDirection]
///
class MamionTransformDelegate extends _MamionSingle<Point3> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  ///
  /// constructors
  ///
  MamionTransformDelegate._(
    Mationvalue<Point3> value, {
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

  MamionTransformDelegate.translation(
    Mationvalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.translating,
        );

  MamionTransformDelegate.rotation(
    Mationvalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.rotating,
        );

  MamionTransformDelegate.scale(
    Mationvalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.scaling,
        );

  ///
  /// instance methods
  ///
  void link(Matrix4 host) => this.host = host;

  bool isSameTypeWith(MamionTransformDelegate another) =>
      onAnimate == another.onAnimate;

  MamionTransformDelegate align(AlignmentGeometry? alignment) =>
      MamionTransformDelegate._(
        value,
        onAnimate: onAnimate,
        alignment: alignment,
        host: host,
      );
}

///
/// [ManionChildren], [ManionParentChildren]
///
class ManionChildren<M extends Mamionability> extends _ManionChildren<M> {
  ManionChildren({required super.children});
}

class ManionParentChildren<M extends Mamionability>
    extends _ManionChildrenParent<M> {
  ManionParentChildren({
    required super.parent,
    required super.children,
  });
}
