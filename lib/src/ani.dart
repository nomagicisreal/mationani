///
/// this file contains:
///
/// [Ani]
///   [AniGeneral]
///     [AniGeneralProgress]
///       [AniGeneralProgressBool]
///       [AniGeneralProgressTernary]
///
///
///
///
///
///
/// [AniSequence]
///   [AniSequenceStep]
///   [AniSequenceInterval]
///   [AniSequenceStyle]
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
///
///
/// [AniGeneral]
///
///
///

///
/// [AniGeneral] is a class that helps us to create animation for [Mationani].
/// it's a separate concept from the leading of the word 'animation'.
///

///
/// [initializer] see [AniGeneral.initialize], ...
/// [initialStatusController] see [AniGeneral.listenForward]
/// [updateOnAnimating] see [AniGeneral.animatingNothing], [AniGeneral.consumeBack]
/// [updateConsumer] see [AniGeneral.consumeNothing], ..., [AniGeneral.decideNothing], ...
///
class AniGeneral extends Ani {
  const AniGeneral({
    required super.duration,
    super.initializer,
    super.initialStatusController,
    super.updateConsumer,
    super.updateOnAnimating,
    super.curve,
  });

  const AniGeneral.initRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusController,
    super.updateConsumer,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: reverseEnable
                ? AniGeneral.initializeRepeatReverse
                : AniGeneral.initializeRepeat);

  const AniGeneral.initForwardAndUpdateReverse({
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForward,
            updateConsumer: AniGeneral.consumeReverse);

  const AniGeneral.initForwardAndUpdateRepeat({
    bool reverseEnable = false,
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForward,
            updateConsumer:
                reverseEnable ? AniGeneral.consumeRepeat : AniGeneral.consumeRepeatReverse);

  const AniGeneral.initForwardAndUpdateResetForward({
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForward,
            updateConsumer: AniGeneral.consumeResetForward);

  const AniGeneral.initForwardAndUpdateForwardOrReverse({
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForward,
            updateConsumer: AniGeneral.consumeForwardOrReverse);

  const AniGeneral.initForwardResetAndUpdateForwardReset({
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForwardReset,
            updateConsumer: AniGeneral.consumeForwardReset);

  AniGeneral.initForwardAndUpdateReverseWhen(
    bool trigger, {
    required super.duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            initializer: AniGeneral.initializeForward,
            updateConsumer: AniGeneral.decideReverse(trigger));

  AniGeneral.initForwardAndUpdateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
          initializer: AniGeneral.initializeForward,
          duration: duration.toDurationFR,
          updateConsumer: AniGeneral.decideForwardOrReverse(trigger),
        );

  AniGeneral.updateForwardWhen(
    bool trigger, {
    required super.duration,
    super.initializer,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(updateConsumer: AniGeneral.decideForward(trigger));

  AniGeneral.updateSequencingWhen(
    bool? trigger, {
    required Duration duration,
    super.initializer,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
  }) : super(
            duration: duration.toDurationFR,
            updateConsumer: AniGeneral.decideForwardOrReverse(trigger));

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
  /// belows are variables for [updateConsumer] or [updateOnAnimating],
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

  static void consumeBack(AnimationController controller) =>
      controller.status == AnimationStatus.forward
          ? controller.reverse(from: controller.value)
          : controller.forward(from: controller.value);

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
/// [Ani] is the implementation for [Mationani] to trigger animation by
/// 1. invoking [initializing] in [_MationaniState.initState]
/// 2. invoking [updating] in [_MationaniState.didUpdateWidget]
/// 3. invoking [building] in both [_MationaniState.initState] and [_MationaniState.didUpdateWidget]
///
/// [building] returns a [WidgetBuilder] to [_MationaniState.builder].
/// see the implementations of [_MationAnimatable.animate] to understand how animation works.
///
///
abstract class Ani {
  final DurationFR duration;
  final Curve? curve;
  final AnimationControllerInitializer? initializer;
  final AnimationStatusController? initialStatusController;
  final Consumer<AnimationController>? updateConsumer;
  final Consumer<AnimationController>? updateOnAnimating;

  const Ani({
    required this.duration,
    required this.curve,
    required this.initializer,
    required this.initialStatusController,
    required this.updateConsumer,
    required this.updateOnAnimating,
  });

  AnimationController initializing(TickerProvider ticker) =>
      (initializer ?? AniGeneral.initialize)(
        ticker,
        duration.forward,
        duration.reverse,
      )..addStatusListenerIfNotNull(initialStatusController);

  ///
  /// [AniGeneral.curve] is an easy way to control entire [AnimationController] flow.
  /// Notice that there is also a [Between.curve] when [Between.animate] in [_MationAnimatableSingle.animate].
  /// this method is called when [_MationaniState.initState] and [_MationaniState.didUpdateWidget]
  ///
  WidgetBuilder building(AnimationController controller, Mation mation) =>
      mation.planning(
        controller.drive(CurveTween(curve: curve ?? Curves.linear)),
      );

  ///
  ///
  /// TODO: custom [AnimatedStatefulWidgetUpdater]
  ///
  ///
  WidgetBuilder updating({
    required AnimationController controller,
    required Mationani oldWidget,
    required Mationani widget,
  }) {
    // updateWhenAnimatingOr(
    //   updateOnAnimating ?? Ani.consumeBack,
    //   updateConsumer ?? Ani.consumeNothing,
    // )(
    //   controller,
    //   oldWidget,
    //   widget,
    // );
    updateIfNotAnimating(updateConsumer ?? AniGeneral.consumeNothing)(
      controller,
      oldWidget,
      widget,
    );
    return building(controller, widget.mation);
  }

  static AnimatedStatefulWidgetUpdater<Mationani> updateWhenAnimatingOr(
    Consumer<AnimationController> updateOnAnimating,
    Consumer<AnimationController> updateConsumer,
  ) =>
      (controller, oldWidget, widget) {
        final ani = widget.ani;
        final duration = ani.duration;
        if (controller.isAnimating) {
          updateOnAnimating(controller);
        } else {
          if (oldWidget.ani.duration != duration) {
            controller.duration = duration.forward;
            controller.reverseDuration = duration.reverse;
          }
          updateConsumer(controller);
        }
      };

  static AnimatedStatefulWidgetUpdater<Mationani> updateIfNotAnimating(
    Consumer<AnimationController> updateConsumer,
  ) =>
      (controller, oldWidget, widget) {
        final duration = widget.ani.duration;
        if (!controller.isAnimating) {
          if (oldWidget.ani.duration != duration) {
            controller.duration = duration.forward;
            controller.reverseDuration = duration.reverse;
          }
          updateConsumer(controller);
        }
      };
}

///
///
/// in short,
/// the value of [updateConsumer] comes from the comparison of [delegate] and [current].
/// it's useful when there are children instances of a widget, and each of child should be triggered by different step
///
/// See Also
///   * [AniGeneralProgressBool]
///   * [AniGeneralProgressTernary]
///
abstract class AniGeneralProgress extends AniGeneral {
  final int delegate;
  int current = 0;

  @override
  Consumer<AnimationController> get updateConsumer =>
      throw UnimplementedError();

  AniGeneralProgress({
    required super.duration,
    required this.delegate,
    super.initializer,
    super.initialStatusController,
    super.updateConsumer,
    super.updateOnAnimating,
    super.curve,
  });
}

class AniGeneralProgressBool extends AniGeneralProgress {
  final AnimationControllerDecider? hear;
  final Combiner<int, bool>? comparison;

  @override
  Consumer<AnimationController> get updateConsumer => (hear ??
          AniGeneral.decideForward)(
      (comparison ?? FPredicatorCombiner.alwaysTrue<int>)(delegate, current));

  AniGeneralProgressBool({
    required super.duration,
    required super.delegate,
    super.initializer,
    super.initialStatusController,
    super.updateOnAnimating,
    super.curve,
    this.hear,
    this.comparison,
  });
}

class AniGeneralProgressTernary extends AniGeneralProgress {
  final AnimationControllerDeciderTernary? hear;
  final Combiner<int?, bool?>? comparison;

  // 1. delegate > progress, listen nothing
  // 2. delegate == progress, listen forward
  // 3. delegate < progress, listen reverse
  @override
  Consumer<AnimationController> get updateConsumer =>
      (hear ?? AniGeneral.decideForwardOrReverse)((comparison ??
          FPredicatorTernaryCombiner.alwaysTrue<int>)(delegate, current));

  AniGeneralProgressTernary({
    required super.duration,
    required super.delegate,
    super.initializer,
    super.initialStatusController,
    super.updateOnAnimating,
    this.hear,
    this.comparison,
  });
}

///
///
///
/// [AniSequence]
/// [AniSequenceStep]
/// [AniSequenceInterval]
/// [AniSequenceStyle]
///
///
///

///
/// See Also
///   * [Mationani.mamionSequence],
///     which takes [AniSequence] as required argument, and use [Ani.updateSequencingWhen].
///     it is possible to use other ani like [Ani.initForwardAndUpdateSequencingWhen].
///
///   * [Between.sequence],
///     while [AniSequence] is an easy way to have animation during widget creation
///     [Between.sequence] focus more on how [Animation.value] or other generic animation.value been lerp.
///

///
///
class AniSequence {
  final List<Mamionability> motivations;
  final List<Duration> durations;

  const AniSequence._(this.motivations, this.durations);

  factory AniSequence({
    required int totalStep,
    required AniSequenceStyle style,
    required Generator<AniSequenceStep> step,
    required Generator<AniSequenceInterval> interval,
  }) {
    final durations = <Duration>[];
    AniSequenceInterval intervalGenerator(int index) {
      final i = interval(index);
      durations.add(i.duration);
      return i;
    }

    return AniSequence._(
      ListExtension.linking<Mamionability, AniSequenceStep,
          AniSequenceInterval>(
        totalStep: totalStep,
        step: step,
        interval: intervalGenerator,
        sequencer: style.sequencer,
      ),
      durations,
    );
  }
}

///
///
class AniSequenceStep {
  final List<double> values;
  final List<Offset> offsets;
  final List<Coordinate> coordinates;

  const AniSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.coordinates = const [],
  });
}

///
///
class AniSequenceInterval {
  final Duration duration;
  final List<Curve> curves;
  final List<Offset> offsets; // for curving control, interval step

  const AniSequenceInterval({
    required this.duration,
    required this.curves,
    this.offsets = const [],
  });
}

///
///
enum AniSequenceStyle {
  // TRS: Translation, Rotation, Scaling
  transformTRS,

  // rotate, slide in bezier cubic
  transitionRotateSlideBezierCubic;

  ///
  /// [_forwardOrReverse] is the only way to sequence [Mamionability] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Translator<int, Mamionability> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required AniSequenceStep previous,
    required AniSequenceStep next,
    required Combiner<AniSequenceStep, Mamionability> combine,
  }) =>
      (i) => combine(
            predicator(i) ? previous : next,
            predicator(i) ? next : previous,
          );

  MationSequencer get sequencer => switch (this) {
        transformTRS => (previous, next, interval) {
            final curve = interval.curves[0].toCurveFR;
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) {
                final a = begin.coordinates;
                final b = end.coordinates;
                return MamionTransform.list(
                  [
                    MamionTransformDelegate.translation(
                      Between(a[0], b[0], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MamionTransformDelegate.rotation(
                      Between(a[1], b[1], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MamionTransformDelegate.scale(
                      Between(a[2], b[2], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                  ],
                );
              },
            );
          },
        transitionRotateSlideBezierCubic => (previous, next, interval) {
            final curve = interval.curves[0].toCurveFR;
            final controlPoints = interval.offsets;
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) => MamionMulti([
                // MationTransitionDouble.rotate(
                MamionTransition.rotate(Between(
                  begin.values[0],
                  end.values[0],
                  curve: curve,
                )),
                MamionTransition.slide(
                  BetweenSpline2D(
                    onLerp: FOnLerpSpline2D.bezierCubic(
                      begin.offsets[0],
                      end.offsets[0],
                      c1: previous.offsets[0] + controlPoints[0],
                      c2: previous.offsets[0] + controlPoints[1],
                    ),
                    curve: curve,
                  ),
                ),
              ]),
            );
          },
      };
}
