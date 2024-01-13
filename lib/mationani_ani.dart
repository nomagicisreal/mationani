part of 'mationani.dart';

///
/// this file contains:
/// [Ani]
///   [AniProgress]
///     [AniProgressBool]
///     [AniProgressTernary]
///
///
/// [FAni], [FAnimationStatusListener], [FOnAnimatingProcessor]
///
///

///
/// the named constructors or mation setting:
///
/// [Ani.initForward]
/// [Ani.initForwardReset]
/// [Ani.initRepeat]
/// [Ani.initForwardAndUpdateReverse]
/// [Ani.initForwardAndUpdateRepeat]
/// [Ani.initForwardAndUpdateResetForward]
/// [Ani.initForwardAndUpdateForwardOrReverse]
/// [Ani.initForwardResetAndUpdateForwardReset]
/// [Ani.updateSequencingWhen]
/// ...
///
class Ani {
  final DurationFR duration;
  final Curve? curve;
  final AnimationControllerInitializer? initializer;
  final AnimationStatusListener? initialStatusListener;
  final Consumer<AnimationController>? updateProcess;
  final IfAnimating? onAnimating;

  AnimationController _initializing(TickerProvider ticker) =>
      (initializer ?? FAni.initialize)(
        ticker,
        duration.forward,
        duration.reverse,
      )..addStatusListenerIfNotNull(initialStatusListener);

  WidgetBuilder _building(
    AnimationController controller,
    MationBase mation,
    Widget child,
  ) {
    final animations = mation._animationsOf(
      controller,
      curve ?? Curves.linear,
    );
    Widget build(BuildContext context) => mation._builder(animations, child);

    return switch (mation) {
      MationTransition() => build,
      _ => (_) => AnimatedBuilder(
            animation: controller,
            builder: (context, __) => build(context),
          ),
    };
  }

  WidgetBuilder _updating({
    required AnimationController controller,
    required Mationani oldWidget,
    required MationBase mation,
    required Widget child,
  }) {
    if (controller.isAnimating) {
      (onAnimating ?? FOnAnimatingProcessor.back)(
        controller,
        controller.status == AnimationStatus.forward,
      );
    } else {
      if (oldWidget.ani.duration != duration) {
        controller.duration = duration.forward;
        controller.reverseDuration = duration.reverse;
      }
      (updateProcess ?? FAni.processNothing)(controller);
    }
    return _building(controller, mation, child);
  }

  const Ani({
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.updateProcess,
    this.onAnimating,
    this.curve,
  });

  /// init

  const Ani.initForward({
    required this.duration,
    this.initialStatusListener,
    this.updateProcess,
    this.onAnimating,
    this.curve,
  }) : initializer = FAni.initializeForward;

  const Ani.initForwardReset({
    required this.duration,
    this.initialStatusListener,
    this.updateProcess,
    this.onAnimating,
    this.curve,
  }) : initializer = FAni.initializeForwardReset;

  const Ani.initRepeat({
    bool reverseEnable = false,
    required this.duration,
    this.initialStatusListener,
    this.updateProcess,
    this.onAnimating,
    this.curve,
  }) : initializer = reverseEnable
            ? FAni.initializeRepeatReverse
            : FAni.initializeRepeat;

  /// init ... and update ...

  const Ani.initForwardAndUpdateReverse({
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        updateProcess = FAni.processReverse;

  const Ani.initForwardAndUpdateRepeat({
    bool reverseEnable = false,
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        updateProcess =
            reverseEnable ? FAni.processRepeat : FAni.processRepeatReverse;

  const Ani.initForwardAndUpdateResetForward({
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        updateProcess = FAni.processResetForward;

  const Ani.initForwardAndUpdateForwardOrReverse({
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        updateProcess = FAni.processForwardOrReverse;

  const Ani.initForwardResetAndUpdateForwardReset({
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForwardReset,
        updateProcess = FAni.processForwardReset;

  /// update

  const Ani.updateForward({
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni.processForward;

  const Ani.updateForwardOrReverse({
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni.processForwardOrReverse;

  /// decide update
  Ani.initForwardAndUpdateReverseWhen(
    bool trigger, {
    required this.duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        updateProcess = FAni._decideReverse(trigger);

  Ani.initForwardAndUpdateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : initializer = FAni.initializeForward,
        duration = duration.toDurationFR,
        updateProcess = FAni._decideForwardOrReverse(trigger);

  Ani.updateForwardWhen(
    bool trigger, {
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni._decideForward(trigger);

  Ani.updateForwardResetWhen(
    bool trigger, {
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni._decideForwardReset(trigger);

  Ani.updateForwardOrReverseWhen(
    bool? trigger, {
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni._decideForwardOrReverse(trigger);

  Ani.updateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  })  : duration = duration.toDurationFR,
        updateProcess = FAni._decideForwardOrReverse(trigger);

  Ani.updateReverseWhen(
    bool trigger, {
    required this.duration,
    this.initializer,
    this.initialStatusListener,
    this.onAnimating,
    this.curve,
  }) : updateProcess = FAni._decideReverse(trigger);
}

///
///
///
/// in short,
/// the value of [updateProcess] comes from the comparison of [delegate] and [current].
/// it's useful when there are children instances of a widget, and each of child should be triggered by different step
///
/// See Also
///   * [AniProgressBool]
///   * [AniProgressTernary]
///
abstract class AniProgress extends Ani {
  final int delegate;
  int current = 0;

  @override
  Consumer<AnimationController> get updateProcess => throw UnimplementedError();

  AniProgress({
    required super.duration,
    required this.delegate,
    super.initializer,
    super.initialStatusListener,
    super.updateProcess,
    super.onAnimating,
    super.curve,
  });
}

class AniProgressBool extends AniProgress {
  final AnimationControllerDecider? hear;
  final Combiner<int, bool>? comparison;

  @override
  Consumer<AnimationController> get updateProcess => (hear ??
          FAni.decideForward)(
      (comparison ?? FComparingPredicator.alwaysTrue<int>)(delegate, current));

  AniProgressBool({
    required super.duration,
    required super.delegate,
    super.initializer,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
    this.hear,
    this.comparison,
  });
}

class AniProgressTernary extends AniProgress {
  final AnimationControllerDeciderTernary? hear;
  final Combiner<int?, bool?>? comparison;

  // 1. delegate > progress, listen nothing
  // 2. delegate == progress, listen forward
  // 3. delegate < progress, listen reverse
  @override
  Consumer<AnimationController> get updateProcess =>
      (hear ?? FAni.decideForwardOrReverse)((comparison ??
          FComparingPredicatorTernary.alwaysTrue<int>)(delegate, current));

  AniProgressTernary({
    required super.duration,
    required super.delegate,
    super.initializer,
    super.initialStatusListener,
    super.onAnimating,
    this.hear,
    this.comparison,
  });
}

///
/// ani functions
///
/// [FAni.initialize] ... ([AnimationControllerInitializer])
/// [FAni.processNothing] ... ([Consumer]<[AnimationController]>)
/// [FAni.decideNothing] ... ([Decider]<[AnimationController]>)
///
extension FAni on Ani {
  static const initialize = _initialize;
  static const initializeForward = _initializeForward;
  static const initializeForwardReset = _initializeForwardReset;
  static const initializeRepeat = _initializeRepeat;
  static const initializeRepeatReverse = _initializeRepeatReverse;

  static AnimationController _initialize(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      AnimationController(
        vsync: tickerProvider,
        duration: forward,
        reverseDuration: reverse,
      );

  static AnimationController _initializeForward(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      _initialize(tickerProvider, forward, reverse)..forward();

  static AnimationController _initializeForwardReset(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      _initialize(tickerProvider, forward, reverse)..forwardReset();

  static AnimationController _initializeRepeat(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      _initialize(tickerProvider, forward, reverse)..repeat();

  static AnimationController _initializeRepeatReverse(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      _initialize(tickerProvider, forward, reverse)..repeat(reverse: true);

  ///
  /// listener
  ///

  static const processNothing = _processNothing;
  static const processForward = _processForward;
  static const processForwardOrReverse = _processForwardOrReverse;
  static const processForwardReset = _processForwardReset;
  static const processReverse = _processReverse;
  static const processRepeat = _processRepeat;
  static const processRepeatReverse = _processRepeatReverse;
  static const processResetForward = _processResetForward;

  static void _processNothing(AnimationController c) {}

  static void _processForward(AnimationController c) => c.forward();

  static void _processForwardReset(AnimationController c) => c.forwardReset();

  static void _processForwardOrReverse(AnimationController controller) =>
      controller.status == AnimationStatus.dismissed
          ? controller.forward()
          : controller.reverse();

  static void _processReverse(AnimationController c) => c.reverse();

  static void _processRepeat(AnimationController c) => c.repeat();

  static void _processRepeatReverse(AnimationController c) =>
      c.repeat(reverse: true);

  static void _processResetForward(AnimationController c) => c.resetForward();

  ///
  /// decider
  ///

  static const decideNothing = _decideNothing;
  static const decideForward = _decideForward;
  static const decideReverse = _decideReverse;
  static const decideForwardReset = _decideForwardReset;
  static const decideRepeat = _decideRepeat;
  static const decideResetForward = _decideResetForward;
  static const decideForwardOrReverse = _decideForwardOrReverse;
  static const decideForwardOrRepeat = _decideForwardOrRepeat;

  static Consumer<AnimationController> _decideNothing(bool trigger) =>
      _processNothing;

  static Consumer<AnimationController> _decideForward(bool trigger) =>
      trigger ? _processForward : _processNothing;

  static Consumer<AnimationController> _decideReverse(bool trigger) =>
      trigger ? _processReverse : _processNothing;

  static Consumer<AnimationController> _decideForwardReset(bool trigger) =>
      trigger ? _processForwardReset : _processNothing;

  static Consumer<AnimationController> _decideRepeat(bool trigger) =>
      trigger ? _processRepeat : _processNothing;

  static Consumer<AnimationController> _decideResetForward(bool trigger) =>
      trigger ? _processResetForward : _processNothing;

  static Consumer<AnimationController> _decideForwardOrReverse(
    bool? forward,
  ) =>
      switch (forward) {
        null => _processNothing,
        true => _processForward,
        false => _processReverse,
      };

  static Consumer<AnimationController> _decideForwardOrRepeat(
    bool? forward,
  ) =>
      switch (forward) {
        null => _processNothing,
        true => _processForward,
        false => _processRepeat,
      };
}

extension FAnimationStatusListener on AnimationStatusListener {
  static AnimationStatusListener forwardListen(VoidCallback listener) =>
      (status) => status == AnimationStatus.forward ? listener() : null;

  static AnimationStatusListener reverseListen(VoidCallback listener) =>
      (status) => status == AnimationStatus.reverse ? listener() : null;

  static AnimationStatusListener completedListen(VoidCallback listener) =>
      (status) => status == AnimationStatus.completed ? listener() : null;

  static AnimationStatusListener dismissedListen(VoidCallback listener) =>
      (status) => status == AnimationStatus.dismissed ? listener() : null;

  static AnimationStatusListener completedOrDismissedListen(
    VoidCallback listener,
  ) =>
      (status) => status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed
          ? listener()
          : null;
}

extension FOnAnimatingProcessor on IfAnimating {
  static void nothing(AnimationController controller, bool isForward) {}

  static void back(AnimationController controller, bool isForward) => isForward
      ? controller.reverse(from: controller.value)
      : controller.forward(from: controller.value);
}
