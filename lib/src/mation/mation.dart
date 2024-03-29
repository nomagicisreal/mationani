///
///
/// this file contains:
/// [Mation]
///   [Mamion]
///   [Manion]
///
///
/// [Mationability]
///   --[Mamionability]
///   |   --[MamionSingle]
///   |   |   [MamionTransition]
///   |   |   * [_MamionSingleSizingPath]
///   |   |   [MamionClipper]
///   |   |   [MamionPainter]
///   |   |
///   |   --[MamionMulti]
///   |   |   [MamionTransform]
///   |   |   * [MamionTransformDelegate]
///   |   |
///   |
///   |
///   --[Manionability]
///       --[ManionChildren]
///       --[ManionParentChildren]
///
///
/// typedefs:
/// [AnimationBuilder]
/// [MationBuilder]
/// [MationMultiGenerator]
/// [MationSequencer]
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
///
///
/// [Mation], [Mamion], [Manion]
///
///
///

///
///
/// [Mation] is a class that helps creating animation for [Mationani].
/// its name comes from the trailing of 'animation' word.
///
/// it has function [planning] that enforce subclass to implement,
/// which will be called at [Ani.building] to enable animations.
/// [Mamion] is a subclass of [Mation] that holds only a child.
/// [Manion] is a subclass of [Mation] that holds a parent that can have many child.
///
///

//
abstract class Mation<M extends Mationability> {
  final M ability;

  const Mation({required this.ability});

  @override
  String toString() => 'Mation($ability)';

  WidgetBuilder planning(Animation<double> animation);
}

//
class Mamion<M extends Mamionability> extends Mation<M> {
  final WidgetBuilder builder;

  const Mamion({
    required super.ability,
    required this.builder,
  });

  Mamion.clipped({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath sizingPath,
    required M ability,
    required WidgetBuilder builder,
  }) : this(
          ability: ability,
          builder: (context) => ClipPath(
            clipper: Clipping.reclipNever(sizingPath),
            clipBehavior: clipBehavior,
            child: builder(context),
          ),
        );

  @override
  WidgetBuilder planning(Animation<double> animation) {
    final ability = this.ability;
    final build = ability.planFor(animation, builder);
    return switch (ability) {
      MamionTransition() => build,
      _ => (_) => AnimatedBuilder(
            animation: animation,
            builder: (context, __) => build(context),
          ),
    };
  }
}

///
/// [Manion.stack]
/// [Manion.flex], [Manion.flexRow], [Manion.flexColumn]
///
class Manion<M extends Manionability> extends Mation<M> {
  final WidgetParentBuilder parent;

  const Manion({
    required this.parent,
    required super.ability,
  });

  Manion.stack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    required M ability,
  }) : this(
          parent: (context, children) => Stack(
            key: key,
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            clipBehavior: clipBehavior,
            children: children,
          ),
          ability: ability,
        );

  Manion.flex({
    required Axis direction,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Clip clipBehavior = Clip.none,
    required M ability,
  }) : this(
          parent: (context, children) => Flex(
            direction: direction,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            clipBehavior: clipBehavior,
            children: children,
          ),
          ability: ability,
        );

  @override
  WidgetBuilder planning(Animation<double> animation) {
    final ability = this.ability;
    final parent = ability.planForParent(animation, this.parent);
    final children = ability.planForChildren(animation);
    return switch (ability) {
      _ => parent.builderFrom(children),
    };
  }
}

///
///
///
/// [Mationability], [Mamionability], [Manionability]
///
///
///

///
/// All the class that implements [Mationability] calls 'have mationability'
/// and 'mationability' have two type for now: [Mamionability] and [Manionability].
/// [Mamionability] requires subclasses to implement [Mamionability.planFor].
/// [Manionability] requires subclasses to implement [Manionability.planForParent], [Manionability.planForChildren]
/// the implementation will be invoked by [Mation.planning].
///

//
abstract interface class Mationability implements _Mationable {}

///
/// See Also
///  [MamionSingle]
///     [MamionTransition], which implements animation of [AnimatedWidget] subclasses to used in [Mationani]
///     [MamionClipper], which implements animation of [ClipPath] to used in [Mationani]
///     [MamionPainter], which implements animation of [CustomPaint] to used in [Mationani]
///     ...
///  [MamionMulti], which trigger animations by multiple between
///     [MamionTransform], which is the combinations of [MamionTransformDelegate]
///     ...
/// they are the classes that have 'mamionability'
///
abstract interface class Mamionability implements Mationability {
  WidgetBuilder planFor(Animation<double> animation, WidgetBuilder builder);
}

///
/// See Also
///   [ManionChildren]
///   ...
/// they are the classes that have 'manionability'
///
abstract interface class Manionability<M extends Mamionability>
    implements Mationability {
  WidgetParentBuilder planForParent(
    Animation<double> animation,
    WidgetParentBuilder parent,
  );

  List<WidgetBuilder> planForChildren(Animation<double> animation);
}

///
///
///
/// [MamionSingle], [MamionTransition]
///
///
///

//
class MamionSingle<T> extends _MationableBetween<T> implements Mamionability {
  const MamionSingle(super.value, super.plan);

  @override
  WidgetBuilder planFor(Animation<double> animation, WidgetBuilder builder) {
    final animate = this.animate(animation);
    final plan = this.plan;
    return (context) => plan(animate, builder(context));
  }
}

///
///
/// this is a class that implement traditional transition like [SlideTransition],
/// [FadeTransition], [DecoratedBoxTransition]..., transcribe those traditional animation to have mationability
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
          MationableValueDoubleExtension.toRadianFrom(value),
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
      : this.fade(FBetween.doubleZeroTo(1, curve: curve));

  MamionTransition.fadeInTo(double opacity, {CurveFR? curve})
      : this.fade(FBetween.doubleZeroTo(opacity, curve: curve));

  MamionTransition.fadeOut({CurveFR? curve})
      : this.fade(FBetween.doubleZeroFrom(1, curve: curve));

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
///
///
/// [_MamionSingleSizingPath], [MamionClipper], [MamionPainter]
///
///
///

//
class _MamionSingleSizingPath extends MamionSingle<SizingPath> {
  const _MamionSingleSizingPath(
    BetweenPath value, {
    AnimationBuilder builder = WWidgetBuilder.noneAnimation,
  }) : super(value, builder);
}

//
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

//
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
/// [MamionMulti.cover]
/// [MamionMulti.penetrate]
/// [MamionMulti.leave]
/// [MamionMulti.shoot], [MamionMulti.enlarge]
///
/// [MamionMulti.slideAndScale]
///
/// [generateCover], [generateShoot]
///
class MamionMulti extends _MationMulti<Mamionability> {
  const MamionMulti(super.abilities);

  MamionMulti.appear({
    Alignment alignmentScale = Alignment.center,
    required Between<double> fading,
    required Between<double> scaling,
  }) : this([
          MamionTransition.fade(fading),
          MamionTransition.scale(scaling, alignment: alignmentScale),
        ]);

  MamionMulti.cover({
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
  factory MamionMulti.slideAndScale({
    required double scaleEnd,
    required Offset position,
    required double interval,
    CurveFR curveScale = CurveFR.linear,
    CurveFR curveSlide = CurveFR.linear,
  }) =>
      MamionMulti.shoot(
        alignmentScale: Alignment.center,
        scaling: FBetween.doubleOneTo(
          scaleEnd,
          curve: curveScale.interval(interval, 1),
        ),
        sliding: FBetween.offsetZeroTo(
          -position,
          curve: curveSlide.interval(0, interval),
        ),
      );

  ///
  /// generators
  ///

  static MationMultiGenerator generateCover(
    Generator<double> direction,
    double distance, {
    CurveFR? curve,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamionMulti.cover(
          fading: FBetween.doubleZeroTo(1, curve: curve),
          sliding: FBetween.offsetOfDirection(
            direction(index),
            0,
            distance,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }

  static MationMultiGenerator generateShoot(
    Offset delta, {
    Generator<double> distribution = FGenerator.ofDouble,
    CurveFR? curve,
    required Alignment alignmentScale,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamionMulti.shoot(
          alignmentScale: alignmentScale,
          sliding: FBetween.offsetZeroTo(
            delta * distribution(index),
            curve: curve,
          ),
          scaling: FBetween.doubleOneFrom(
            0.0,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }
}

///
///
///
/// [MamionTransform] and [MamionTransformDelegate]
///
///
///

///
/// their coordinate system is based on [Transform] direction, translation (negative to positive).
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

///
/// [MamionTransform._], [MamionTransform.distanced]
/// [MamionTransform._sort]
///
class MamionTransform extends _MationMulti<MamionTransformDelegate> {
  MamionTransform._(
    Iterable<MamionTransformDelegate> delegates, {
    Matrix4? host,
    List<OnAnimateMatrix4> order = MamionTransformDelegate.orderTRS,
  })  : assert(order.length == 3 && !order.iterator.anyEqual),
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
    List<OnAnimateMatrix4> order = MamionTransformDelegate.orderTRS,
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
}

///
/// [onAnimate], [alignment], [host], [plan]
/// [onTranslating], [onRotating], [onScaling]
/// [orderTRS], [orderTSR], [orderSTR], [orderSRT], [orderRTS], [orderRST]
/// [MamionTransformDelegate._]
/// [MamionTransformDelegate.translation]
/// [MamionTransformDelegate.rotation]
/// [MamionTransformDelegate.scale]
/// [link], [isSameTypeWith], [align]
///
class MamionTransformDelegate extends _MationableBetween<Point3> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

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

//
class ManionChildren<M extends Mamionability> extends _ManionChildren<M> {
  ManionChildren({required super.children});
}

class ManionParentChildren<M extends Mamionability>
    extends _ManionParentChildren<M> {
  ManionParentChildren({
    required super.parent,
    required super.children,
  });
}

///
///
/// typedefs
///
///
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

typedef MationBuilder<M extends Mamionability> = Widget Function(
  BuildContext context,
  M mation,
);

typedef MationMultiGenerator = Generator<MamionMulti>;

typedef MationSequencer<T>
    = Sequencer<AniSequenceStep, AniSequenceInterval, Mamionability>;
