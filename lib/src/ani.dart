///
/// this file contains:
///
/// [Ani]
///   * [_AniBase]
///   --[AniProgress]
///     [AniProgressBool]
///     [AniProgressTernary]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
/// [initializer] see [Ani.initialize], ...
/// [initialStatusListener] see [Ani.listenForward]
/// [onAnimating] see [Ani.animatingNothing], [Ani.animatingBack]
/// [updateConsumer] see [Ani.consumeNothing], ..., [Ani.decideNothing], ...
///
class Ani extends _AniBase {
  const Ani({
    required super.duration,
    super.initializer,
    super.initialStatusListener,
    super.updateConsumer,
    super.onAnimating,
    super.curve,
  });

  const Ani.initRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusListener,
    super.updateConsumer,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: reverseEnable
                ? Ani.initializeRepeatReverse
                : Ani.initializeRepeat);

  const Ani.initForwardAndUpdateReverse({
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeReverse);

  const Ani.initForwardAndUpdateRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer:
                reverseEnable ? Ani.consumeRepeat : Ani.consumeRepeatReverse);

  const Ani.initForwardAndUpdateResetForward({
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeResetForward);

  const Ani.initForwardAndUpdateForwardOrReverse({
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeForwardOrReverse);

  const Ani.initForwardResetAndUpdateForwardReset({
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForwardReset,
            updateConsumer: Ani.consumeForwardReset);

  Ani.initForwardAndUpdateReverseWhen(
    bool trigger, {
    required super.duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.decideReverse(trigger));

  Ani.initForwardAndUpdateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
          initializer: Ani.initializeForward,
          duration: duration.toDurationFR,
          updateConsumer: Ani.decideForwardOrReverse(trigger),
        );

  Ani.updateForwardWhen(
    bool trigger, {
    required super.duration,
    super.initializer,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(updateConsumer: Ani.decideForward(trigger));

  Ani.updateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initializer,
    super.initialStatusListener,
    super.onAnimating,
    super.curve,
  }) : super(
            duration: duration.toDurationFR,
            updateConsumer: Ani.decideForwardOrReverse(trigger));

  ///
  ///
  /// belows are variables for [initializer],
  ///
  /// [initialize]
  /// [initializeForward]
  /// [initializeForwardReset]
  /// [initializeRepeat]
  /// [initializeRepeatReverse]
  ///
  ///
  static AnimationController initialize(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      AnimationController(
        vsync: tickerProvider,
        duration: forward,
        reverseDuration: reverse,
      );

  static AnimationController initializeForward(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      initialize(tickerProvider, forward, reverse)..forward();

  static AnimationController initializeForwardReset(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      initialize(tickerProvider, forward, reverse)..forwardReset();

  static AnimationController initializeRepeat(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      initialize(tickerProvider, forward, reverse)..repeat();

  static AnimationController initializeRepeatReverse(
    TickerProvider tickerProvider,
    Duration forward,
    Duration reverse,
  ) =>
      initialize(tickerProvider, forward, reverse)..repeat(reverse: true);

  ///
  ///
  /// belows are variables for [initialStatusListener],
  ///
  /// [listenForward]
  /// [listenReverse]
  /// [listenCompleted]
  /// [listenDismissed]
  /// [listenCompletedOrDismissed]
  ///
  ///
  static AnimationStatusListener listenForward(VoidCallback listener) =>
      (status) => status == AnimationStatus.forward ? listener() : null;

  static AnimationStatusListener listenReverse(VoidCallback listener) =>
      (status) => status == AnimationStatus.reverse ? listener() : null;

  static AnimationStatusListener listenCompleted(VoidCallback listener) =>
      (status) => status == AnimationStatus.completed ? listener() : null;

  static AnimationStatusListener listenDismissed(VoidCallback listener) =>
      (status) => status == AnimationStatus.dismissed ? listener() : null;

  static AnimationStatusListener listenCompletedOrDismissed(
    VoidCallback listener,
  ) =>
      (status) => status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed
          ? listener()
          : null;

  ///
  ///
  /// belows are variables for [onAnimating],
  ///
  /// [animatingNothing]
  /// [animatingBack]
  ///
  ///
  static void animatingNothing(
      AnimationController controller, bool isForward) {}

  static void animatingBack(AnimationController controller, bool isForward) =>
      isForward
          ? controller.reverse(from: controller.value)
          : controller.forward(from: controller.value);

  ///
  ///
  /// belows are variables for [updateConsumer],
  ///
  /// [consumeNothing]
  /// [consumeForward]
  /// [consumeForwardReset]
  /// [consumeForwardOrReverse]
  /// [consumeReverse]
  /// [consumeRepeat]
  /// [consumeRepeatReverse]
  /// [consumeResetForward]
  ///
  ///
  static void consumeNothing(AnimationController c) {}

  static void consumeForward(AnimationController c) => c.forward();

  static void consumeForwardReset(AnimationController c) => c.forwardReset();

  static void consumeForwardOrReverse(AnimationController controller) =>
      controller.status == AnimationStatus.dismissed
          ? controller.forward()
          : controller.reverse();

  static void consumeReverse(AnimationController c) => c.reverse();

  static void consumeRepeat(AnimationController c) => c.repeat();

  static void consumeRepeatReverse(AnimationController c) =>
      c.repeat(reverse: true);

  static void consumeResetForward(AnimationController c) => c.resetForward();

  ///
  ///
  /// belows are variables for [updateConsumer], too,
  ///
  /// [decideNothing]
  /// [decideForward]
  /// [decideReverse]
  /// [decideForwardReset]
  /// [decideRepeat]
  /// [decideResetForward]
  /// [decideForwardOrReverse]
  /// [decideForwardOrRepeat]
  ///
  ///
  static Consumer<AnimationController> decideNothing(bool trigger) =>
      consumeNothing;

  static Consumer<AnimationController> decideForward(bool trigger) =>
      trigger ? consumeForward : consumeNothing;

  static Consumer<AnimationController> decideReverse(bool trigger) =>
      trigger ? consumeReverse : consumeNothing;

  static Consumer<AnimationController> decideForwardReset(bool trigger) =>
      trigger ? consumeForwardReset : consumeNothing;

  static Consumer<AnimationController> decideRepeat(bool trigger) =>
      trigger ? consumeRepeat : consumeNothing;

  static Consumer<AnimationController> decideResetForward(bool trigger) =>
      trigger ? consumeResetForward : consumeNothing;

  static Consumer<AnimationController> decideForwardOrReverse(
    bool? forward,
  ) =>
      switch (forward) {
        null => consumeNothing,
        true => consumeForward,
        false => consumeReverse,
      };

  static Consumer<AnimationController> decideForwardOrRepeat(
    bool? forward,
  ) =>
      switch (forward) {
        null => consumeNothing,
        true => consumeForward,
        false => consumeRepeat,
      };
}

///
///
/// [_AniBase] is the implementation for [Mationani] to trigger animation by
/// 1. invoking [_initializing] in [MationaniState.initState]
/// 2. invoking [_updating] in [MationaniState.didUpdateWidget]
/// 3. invoking [_building] in both [MationaniState.initState] and [MationaniState.didUpdateWidget]
///
/// [_building] returns a [WidgetBuilder] to [MationaniState._builder].
/// see also [MationBase._animationsOf] to understand how animation works.
///
///
abstract class _AniBase {
  final DurationFR duration;
  final Curve? curve;
  final AnimationControllerInitializer? initializer;
  final AnimationStatusListener? initialStatusListener;
  final Consumer<AnimationController>? updateConsumer;
  final IfAnimating? onAnimating;

  const _AniBase({
    required this.duration,
    required this.curve,
    required this.initializer,
    required this.initialStatusListener,
    required this.updateConsumer,
    required this.onAnimating,
  });

  AnimationController _initializing(TickerProvider ticker) =>
      (initializer ?? Ani.initialize)(
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
      _MationTransition() => build,
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
      (onAnimating ?? Ani.animatingBack)(
        controller,
        controller.status == AnimationStatus.forward,
      );
    } else {
      if (oldWidget.ani.duration != duration) {
        controller.duration = duration.forward;
        controller.reverseDuration = duration.reverse;
      }
      (updateConsumer ?? Ani.consumeNothing)(controller);
    }
    return _building(controller, mation, child);
  }
}

///
///
/// in short,
/// the value of [updateConsumer] comes from the comparison of [delegate] and [current].
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
  Consumer<AnimationController> get updateConsumer =>
      throw UnimplementedError();

  AniProgress({
    required super.duration,
    required this.delegate,
    super.initializer,
    super.initialStatusListener,
    super.updateConsumer,
    super.onAnimating,
    super.curve,
  });
}

class AniProgressBool extends AniProgress {
  final AnimationControllerDecider? hear;
  final Combiner<int, bool>? comparison;

  @override
  Consumer<AnimationController> get updateConsumer => (hear ??
          Ani.decideForward)(
      (comparison ?? FPredicatorCombiner.alwaysTrue<int>)(delegate, current));

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
  Consumer<AnimationController> get updateConsumer =>
      (hear ?? Ani.decideForwardOrReverse)((comparison ??
          FPredicatorTernaryCombiner.alwaysTrue<int>)(delegate, current));

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

