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
/// [initialStatusController] see [Ani.listenForward]
/// [onAnimating] see [Ani.animatingNothing], [Ani.animatingBack]
/// [updateConsumer] see [Ani.consumeNothing], ..., [Ani.decideNothing], ...
///
class Ani extends _AniBase {
  const Ani({
    required super.duration,
    super.initializer,
    super.initialStatusController,
    super.updateConsumer,
    super.onAnimating,
    super.curve,
  });

  const Ani.initRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusController,
    super.updateConsumer,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: reverseEnable
                ? Ani.initializeRepeatReverse
                : Ani.initializeRepeat);

  const Ani.initForwardAndUpdateReverse({
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeReverse);

  const Ani.initForwardAndUpdateRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer:
                reverseEnable ? Ani.consumeRepeat : Ani.consumeRepeatReverse);

  const Ani.initForwardAndUpdateResetForward({
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeResetForward);

  const Ani.initForwardAndUpdateForwardOrReverse({
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.consumeForwardOrReverse);

  const Ani.initForwardResetAndUpdateForwardReset({
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForwardReset,
            updateConsumer: Ani.consumeForwardReset);

  Ani.initForwardAndUpdateReverseWhen(
    bool trigger, {
    required super.duration,
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(
            initializer: Ani.initializeForward,
            updateConsumer: Ani.decideReverse(trigger));

  Ani.initForwardAndUpdateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initialStatusController,
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
    super.initialStatusController,
    super.onAnimating,
    super.curve,
  }) : super(updateConsumer: Ani.decideForward(trigger));

  Ani.updateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initializer,
    super.initialStatusController,
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
  /// belows are variables for [initialStatusController],
  ///
  /// [listenForward]
  /// [listenReverse]
  /// [listenCompleted]
  /// [listenDismissed]
  /// [listenCompletedOrDismissed]
  ///
  ///
  static AnimationStatusController listenForward(
    Consumer<AnimationController> consume,
  ) =>
      (status, controller) =>
          status == AnimationStatus.forward ? consume(controller) : null;

  static AnimationStatusController listenReverse(
    Consumer<AnimationController> consume,
  ) =>
      (status, controller) =>
          status == AnimationStatus.reverse ? consume(controller) : null;

  static AnimationStatusController listenCompleted(
    Consumer<AnimationController> consume,
  ) =>
      (status, controller) =>
          status == AnimationStatus.completed ? consume(controller) : null;

  static AnimationStatusController listenDismissed(
    Consumer<AnimationController> consume,
  ) =>
      (status, controller) =>
          status == AnimationStatus.dismissed ? consume(controller) : null;

  static AnimationStatusController listenCompletedOrDismissed(
    Consumer<AnimationController> consume,
  ) =>
      (status, controller) => status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed
          ? consume(controller)
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
/// 1. invoking [_initializing] in [_MationaniState.initState]
/// 2. invoking [_updating] in [_MationaniState.didUpdateWidget]
/// 3. invoking [_plan] in both [_MationaniState.initState] and [_MationaniState.didUpdateWidget]
///
/// [_plan] returns a [WidgetBuilder] to [_MationaniState._builder].
/// see the implementations of [Mationable._animate] to understand how animation works.
///
///
abstract class _AniBase {
  final DurationFR duration;
  final Curve? curve;
  final AnimationControllerInitializer? initializer;
  final AnimationStatusController? initialStatusController;
  final Consumer<AnimationController>? updateConsumer;
  final IfAnimating? onAnimating;

  const _AniBase({
    required this.duration,
    required this.curve,
    required this.initializer,
    required this.initialStatusController,
    required this.updateConsumer,
    required this.onAnimating,
  });

  AnimationController _initializing(TickerProvider ticker) =>
      (initializer ?? Ani.initialize)(
        ticker,
        duration.forward,
        duration.reverse,
      )..addStatusListenerIfNotNull(initialStatusController);

  ///
  /// [Ani.curve] is an easy way to control entire [AnimationController] flow.
  /// notice that there is also a [Between.curve] when [Between.animate].
  /// this method is called when [_MationaniState.initState] and [_MationaniState.didUpdateWidget]
  ///
  WidgetBuilder _plan(
    AnimationController controller,
    Mation mation,
    WidgetBuilder builder,
  ) {
    final build = mation._plan(
      controller.drive(CurveTween(curve: curve ?? Curves.linear)),
      builder,
    );

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
    required Mation mation,
    required WidgetBuilder builder,
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
    return _plan(controller, mation, builder);
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
    super.initialStatusController,
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
    super.initialStatusController,
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
    super.initialStatusController,
    super.onAnimating,
    this.hear,
    this.comparison,
  });
}
