part of 'mationani.dart';

///
///
/// this file contains:
/// [Mationani]
///   [MationaniSin]
///   [MationaniPenetration]
///   []
///
///
///
/// [FClipping], [FClippingMationTransform], [FClippingMationTransformRowTransform], ...
/// [FPainting], [FCustomPaint],  [FMationPainter]
///
///
///
///

class Mationani extends StatefulWidget {
  final MationBase mation;
  final Ani ani;
  final Widget child;

  const Mationani({
    super.key,
    required this.mation,
    required this.ani,
    this.child = const SizedBox(),
  });

  ///
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  /// see [MationSequenceStyle.sequence] for [mations] creation
  ///
  factory Mationani.sequence(
    int? step, {
    Key? key,
    required MationSequence sequence,
    required Widget child,
    AnimationControllerInitializer? initializer,
    AnimationStatusListener? initialStatusListener,
    AnimatingProcessor? onAnimating,
    Curve? curve,
  }) {
    final i = step ?? 0;
    return Mationani(
      key: key,
      ani: Ani.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
        initialStatusListener: initialStatusListener,
        onAnimating: onAnimating,
        curve: curve,
      ),
      mation: sequence.mations[i],
      child: child,
    );
  }

  @override
  State<Mationani> createState() => MationaniState();

  static MationaniState of(BuildContext context) =>
      context.findAncestorStateOfType<MationaniState>()!;
}

class MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late WidgetBuilder _builder;

  @override
  void initState() {
    final ani = widget.ani;
    controller = ani._initializing(this);
    _builder = ani._building(controller, widget.mation, widget.child);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    _builder = widget.ani._updating(
      controller: controller,
      oldWidget: oldWidget,
      mation: widget.mation,
      child: widget.child,
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => _builder(context);
}

///
/// [MyAnimationSin.shaker]
/// [MyAnimationSin.flicker]
/// [MyAnimationSin.slider]
///
///

class MationaniSin extends StatelessWidget {
  const MationaniSin._({
    super.key,
    required this.duration,
    required this.initializer,
    required this.updateListener,
    required this.mation,
    required this.child,
  });

  factory MationaniSin.shaker({
    required DurationFR duration,
    required int times,
    required double amplitudeRadian,
    required Widget child,
    Key? key,
    Alignment alignment = Alignment.center,
    bool adjustStart = true,
    AnimationControllerInitializer initializer = FAni.initialize,
    Consumer<AnimationController> updateListener = FAni.processNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransitionDouble.rotate(
          0,
          amplitudeRadian / KRadian.angle_360,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
          alignment: alignment,
        ),
        child: child,
      );

  factory MationaniSin.flicker({
    required DurationFR duration,
    required int times,
    required double amplitudeOpacity,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = FAni.initialize,
    Consumer<AnimationController> updateListener = FAni.processNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransitionDouble.fade(
          1.0,
          amplitudeOpacity,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        ),
        child: child,
      );

  factory MationaniSin.slider({
    required DurationFR duration,
    required int times,
    required Offset amplitudePosition,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = FAni.initialize,
    Consumer<AnimationController> updateListener = FAni.processNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransitionOffset(
          Offset.zero,
          amplitudePosition,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        ),
        child: child,
      );

  final DurationFR duration;
  final AnimationControllerInitializer initializer;
  final Consumer<AnimationController> updateListener;
  final MationBase mation;
  final Widget child;

  @override
  Widget build(BuildContext context) => Mationani(
        ani: Ani(
          duration: duration,
          initializer: initializer,
          updateProcess: updateListener,
        ),
        mation: mation,
        child: child,
      );
}

class MationaniPenetration extends StatelessWidget {
  const MationaniPenetration({
    required this.ani,
    required this.onTap,
    required this.rect,
    required this.path,
    super.key,
    this.opacityEnd = 1.0,
    this.curveFade = KCurveFR.fastOutSlowIn_easeOutQuad,
    this.curveClipper = KCurveFR.fastOutSlowIn_easeOutQuad,
    this.clip = Clip.antiAlias,
    this.color = Colors.black54,
    this.child,
  });

  final Ani ani;
  final double opacityEnd;
  final CurveFR curveFade;
  final CurveFR curveClipper;
  final Clip clip;
  final Color color;
  final Widget? child;
  final Between<Rect> rect;
  final SizingPathWithRect path;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Mationani(
        ani: ani,
        mation: Mations<dynamic, Mation>([
          MationClipper(
            BetweenPath<Rect>(
              rect,
              onAnimate: (t, rect) => (size) => path(rect, size),
              curve: curveClipper,
            ),
            behavior: clip,
          ),
          MationTransitionDouble.fade(
            0.0,
            opacityEnd,
            curve: curveFade,
          ),
        ]),
        child: ColoredBox(color: color, child: child),
      ),
    );
  }
}

class MationaniCutting extends StatelessWidget {
  const MationaniCutting({
    super.key,
    this.pieces = 2,
    this.direction = Direction.radian2D_bottomRight,
    this.curveFadeOut,
    this.curve,
    Ani? aniFadeOut,
    required this.ani,
    required this.rotation,
    required this.distance,
    required this.child,
  })  : aniFadeOut = aniFadeOut ?? ani,
        assert(pieces == 2 && direction == Direction.radian2D_bottomRight);

  final int pieces;
  final double direction;
  final double rotation;
  final double distance;
  final Ani aniFadeOut;
  final Ani ani;
  final CurveFR? curveFadeOut;
  final CurveFR? curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Mationani(
      mation: MationTransitionDouble.fadeOut(curve: curveFadeOut),
      ani: aniFadeOut,
      child: Stack(
        children: List.generate(
          pieces,
          (index) => Mationani(
            mation: Mations<dynamic, Mation>([
              MationTransitionDouble.rotateZeroTo(
                index == 0 ? -rotation : rotation,
                alignment: Alignment.bottomRight,
                curve: curve,
              ),
              MationTransitionOffset.zeroTo(
                index == 0
                    ? Direction.offset_bottomLeft * distance
                    : Direction.offset_topRight * distance,
                curve: curve,
              ),
            ]),
            ani: ani,
            child: ClipPath(
              clipper: Clipping.reclipNever(
                index == 0
                    ? (size) => Path()
                      ..lineToPoint(size.bottomRight(Offset.zero))
                      ..lineToPoint(size.bottomLeft(Offset.zero))
                    : (size) => Path()
                      ..lineToPoint(size.bottomRight(Offset.zero))
                      ..lineToPoint(size.topRight(Offset.zero)),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

///
///
///
/// clip
///
///
///

extension FClipPath on CustomPaint {
  static ClipPath rectFromZeroToSize({
    Clip clipBehavior = Clip.antiAlias,
    required Size size,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: FClipping.rectOf(Offset.zero & size),
        child: child,
      );

  static ClipPath reClipNeverOf({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath pathFromSize,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(pathFromSize),
        child: child,
      );

  static ClipPath decoratedPolygon(
    Decoration decoration,
    RRegularPolygon polygon, {
    DecorationPosition position = DecorationPosition.background,
    Widget? child,
  }) =>
      ClipPath(
        clipper: FClipping.polygonCubicCornerFromSize(polygon),
        child: DecoratedBox(
          decoration: decoration,
          position: position,
          child: child,
        ),
      );
}

extension FClipping on Clipping {
  static Clipping rectOf(Rect rect) =>
      Clipping.reclipNever(FSizingPath.rect(rect));

  static Clipping rectFromZeroTo(Size size) => rectOf(Offset.zero & size);

  static Clipping rectFromZeroToOffset(Offset corner) =>
      rectOf(Rect.fromPoints(Offset.zero, corner));

  static Clipping polygonCubicCornerFromSize(RRegularPolygon polygon) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubicFromSize(polygon.cubicPoints),
      );
}

extension FClippingMationTransform on Mationani {
  static Mationani rotate({
    Clip clipBehavior = Clip.antiAlias,
    required AlignmentGeometry alignment,
    required Ani ani,
    required Between<Coordinate> tween,
    required SizingPath sizeToPath,
    required Widget child,
  }) =>
      Mationani(
        ani: ani,
        mation: _MationTransformBase._rotate(alignment: alignment, tween),
        child: ClipPath(
          clipper: Clipping.reclipNever(sizeToPath),
          clipBehavior: clipBehavior,
          child: child,
        ),
      );
}

extension FClippingMationTransformRowTransform on Mationani {
  static Mationani rotateSemicircleFlip({
    MainAxisAlignment semicircleAlignment = MainAxisAlignment.center,
    required DurationFR duration,
    required Between<Coordinate> tweenRotate,
    required Between<Coordinate> tweenFlip,
    required AnimationStatusListener statusListenerRotate,
    required AnimationStatusListener statusListenerFlip,
    required bool isFlipped,
    required Widget childRight,
    required Widget childLeft,
  }) =>
      Mationani(
        ani: Ani.initForward(
          duration: duration,
          initialStatusListener: statusListenerRotate,
          updateProcess: FAni.decideResetForward(isFlipped),
        ),
        mation: _MationTransformBase._rotate(
          alignment: Alignment.center,
          tweenRotate,
        ),
        child: Row(
          mainAxisAlignment: semicircleAlignment,
          children: [
            FClippingMationTransform.rotate(
              tween: tweenFlip,
              alignment: Alignment.centerRight,
              sizeToPath: FSizingPath.pieOfLeftRight(false),
              ani: Ani(
                duration: duration,
                updateProcess: FAni.decideResetForward(!isFlipped),
              ),
              child: childLeft,
            ),
            FClippingMationTransform.rotate(
              ani: Ani(
                duration: duration,
                initialStatusListener: statusListenerFlip,
                updateProcess: FAni.decideResetForward(!isFlipped),
              ),
              tween: tweenFlip,
              alignment: Alignment.centerLeft,
              sizeToPath: FSizingPath.pieOfLeftRight(true),
              child: childRight,
            ),
          ],
          // children: [VContainerStyled.gradiantWhitRed],
        ),
      );
}

///
///
///
///
///
/// paint
///
///
///
///
///

extension FPainting on Painting {
  static Painting polygonCubicCorner(
    SizingPaintFromCanvas paintFromCanvasSize,
    RRegularPolygon polygon,
  ) =>
      Painting.rePaintNever(
        sizingPaintFromCanvas: paintFromCanvasSize,
        sizingPath: FSizingPath.polygonCubic(polygon.cubicPoints),
      );
}

extension FCustomPaint on CustomPaint {
  static CustomPaint polygonCanvasSizeToPaint(
    RRegularPolygon polygon,
    SizingPaintFromCanvas paintFromCanvasSize, {
    Widget? child,
  }) =>
      CustomPaint(
        painter: FPainting.polygonCubicCorner(paintFromCanvasSize, polygon),
        child: child,
      );
}

extension FMationPainter on MationPainter {
  static MationPainter progressingCircles({
    double initialCircleRadius = 5.0,
    double circleRadiusFactor = 0.1,
    required Ani setting,
    required Paint paint,
    required Tween<double> radiusOrbit,
    required int circleCount,
    required Companion<Vector3D, int> planetGenerator,
  }) =>
      MationPainter.drawPathTweenWithPaint(
        sizingPaintingFromCanvas: (_, __) => paint,
        BetweenPath(
          Between<Vector3D>(
            begin: Vector3D(Coordinate.zero, radiusOrbit.begin!),
            end: Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end!),
          ),
          onAnimate: (t, vector) => PathOperation.union._combineAll(
            Iterable.generate(
              circleCount,
              (i) => (size) => Path()
                ..addOval(
                  Rect.fromCircle(
                    center: planetGenerator(vector, i).toCoordinate,
                    radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
                  ),
                ),
            ),
          ),
        ),
      );
}
