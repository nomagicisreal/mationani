part of '../mationani.dart';

///
///
/// * [Matable]
///     --[Mamable]
///     |   --[_MatableDriverMixin]
///     |   |   --[_PerformMamableSoloMixin]
///     |   |       --[MamableSolo]
///     |   |       |   --[MamableTransition]
///     |   |       |
///     |   |       --[_MamableSizingPath]
///     |   |       |   --[MamableClipper]
///     |   |       |   --[MamablePainter]
///     |   |       |
///     |   |       --[MamableTransformDelegate]
///     |   |
///     |   --[_MatableNest]
///     |       --[MamableSet]
///     |       --[MamableTransform]
///     |
///     --[Manable]
///         --[ManionSingle]
///         |   --[ManionChildren]
///         |   --[ManionChildrenParent]
///         |
///         --[ManionEach]
///         |   --[ManionEachChildren]
///         |   --[ManionEachChildrenParent]
///         |
///         --[ManionEach]
///             --[ManionEachChildren]
///             --[ManionEachChildrenParent]
///
///

///
/// animation by 1 [Matalue]
///
base class MamableSolo<T> extends _MatableSolo<T>
    with _PerformMamableSoloMixin<T> {
  @override
  final AnimationBuilder _builder;

  const MamableSolo(super.value, this._builder);
}

///
/// animation for flutter [AnimatedWidget]
/// [MamionTransition.fade], ...
/// [MamionTransition.scale], ...
/// [MamionTransition.rotate], ...
/// [MamionTransition.slide], ...
/// [MamionTransition.decoration], ...
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
///
///
abstract base class _MamableSizingPath extends _MatableSolo<SizingPath>
    with _PerformMamableSoloMixin<SizingPath> {
  const _MamableSizingPath(Between<SizingPath> super.value);
}

///
/// animation for flutter [ClipPath]
///
final class MamableClipper extends _MamableSizingPath {
  final Clip clipBehavior;

  @override
  AnimationBuilder get _builder => (animation, child) => ClipPath(
        clipper: Clipping.reclipWhenUpdate(animation.value),
        clipBehavior: clipBehavior,
        child: child,
      );

  const MamableClipper(
    super.value, {
    this.clipBehavior = Clip.antiAlias,
  });
}

///
/// animation for flutter [CustomPaint]
///
final class MamablePainter extends _MamableSizingPath {
  final bool isComplex;
  final CustomPainter? foreground;
  final Size size;
  final Painter painter;

  @override
  AnimationBuilder get _builder => (animation, child) => CustomPaint(
        willChange: true,
        painter: painter(animation.value),
        foregroundPainter: foreground,
        size: size,
        isComplex: isComplex,
        child: child,
      );

  const MamablePainter(
    super.value, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.foreground,
    required this.painter,
  });

  MamablePainter.paintFrom(
    super.value, {
    required PaintFrom paintFrom,
  })  : isComplex = false,
        size = Size.zero,
        foreground = null,
        painter = FPainter.of(paintFrom);
}

///
/// animation for [Mamable] combinations
/// [MamableSet.appear]
/// [MamableSet.spill]
/// [MamableSet.penetrate]
/// [MamableSet.leave]
/// [MamableSet.shoot], [MamableSet.enlarge]
/// [MamableSet.slideToThenScale]
///
///
final class MamableSet extends _MatableSet<_MatableSolo>
    with _PerformMamableSetMixin<_MatableSolo> {
  const MamableSet(super.ables);

  MamableSet.appear({
    Alignment alignmentScale = Alignment.center,
    required Between<double> fading,
    required Between<double> scaling,
  }) : this([
          MamableTransition.fade(fading),
          MamableTransition.scale(scaling, alignment: alignmentScale),
        ]);

  MamableSet.spill({
    required Between<double> fading,
    required Between<Offset> sliding,
  }) : this([
          MamableTransition.fade(fading),
          MamableTransition.slide(sliding),
        ]);

  MamableSet.penetrate({
    double opacityShowing = 1.0,
    CurveFR? curveClip,
    Clip clipBehavior = Clip.hardEdge,
    required Between<double> fading,
    required Between<Rect> recting,
    required SizingPathFrom<Rect> sizingPathFrom,
  }) : this([
          MamableTransition.fade(fading),
          MamableClipper(
            BetweenPath<Rect>(
              recting,
              onAnimate: (t, rect) => sizingPathFrom(rect),
              curve: curveClip,
            ),
            clipBehavior: clipBehavior,
          ),
        ]);

  MamableSet.leave({
    Alignment alignment = Alignment.topLeft,
    required Between<double> rotation,
    required Between<Offset> sliding,
  }) : this([
          MamableTransition.rotate(rotation, alignment: alignment),
          MamableTransition.slide(sliding),
        ]);

  MamableSet.shoot({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<Offset> sliding,
    required Between<double> scaling,
  }) : this([
          MamableTransition.slide(sliding),
          MamableTransition.scale(scaling, alignment: alignmentScale),
        ]);

  MamableSet.enlarge({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<double> scaling,
    required Between<Offset> sliding,
  }) : this([
          MamableTransition.scale(scaling, alignment: alignmentScale),
          MamableTransition.slide(sliding),
        ]);

  ///
  /// factories
  ///
  factory MamableSet.slideToThenScale({
    required Offset destination,
    required double scaleEnd,
    double interval = 0.5, // must between 0.0 ~ 1.0
    CurveFR curveScale = CurveFR.linear,
    CurveFR curveSlide = CurveFR.linear,
  }) =>
      MamableSet.shoot(
        sliding: Between(
          Offset.zero,
          destination,
          curve: curveSlide.interval(0, interval),
        ),
        alignmentScale: Alignment.center,
        scaling: Between(
          1.0,
          scaleEnd,
          curve: curveScale.interval(interval, 1),
        ),
      );
}

///
///
///
final class ManableMappingWithParent extends _MatablePlane<_MatableSet>
    with _PerformManablePlaneMappingMixin<_MatableSet>
    implements _ManableParent {
  @override
  final Mamable mamableParent;

  const ManableMappingWithParent({
    required Mamable parent,
    required Iterable<MamableSet> children,
  })  : mamableParent = parent,
        super(children);
}
