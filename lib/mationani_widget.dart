part of 'mationani.dart';

///
///
/// this file contains:
/// [Mationani]
///   [MationaniSin]
///   [MationaniPenetration]
///
///
///
/// [FClippingMationTransform], [FClippingMationTransformRowTransform]
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
      widget: widget,
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
  final SizingRectingPath path;
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
              sizeToPath: FSizingPath.pieSizingOf(false),
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
              sizeToPath: FSizingPath.pieSizingOf(true),
              child: childRight,
            ),
          ],
          // children: [VContainerStyled.gradiantWhitRed],
        ),
      );
}
