///
/// this file contains:
///
/// [Ani]
///   [AniUpdateIfNotAnimating]
///   [AniUpdateIfAnimating]
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
/// typedefs:
/// [AnimationControllerInitializer]
/// [AnimatedStatefulWidgetUpdater]
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
/// [Ani]
///
///
///

///
/// [Ani] is a class that helps us to create animation for [Mationani].
/// it's a separate concept from the leading of the word 'animation'.
/// it is the implementation for [Mationani] to trigger animation by
///   1. invoking [initializing] in [_MationaniState.initState]
///   2. invoking [updating] in [_MationaniState.didUpdateWidget]
/// see the comment above [_MationAnimatable.animate] to understand more.
///
///

///
/// [initializer] see [Ani.initialize], ...
/// status controller see [Ani.listenForward]
/// [updateConsumer] see [Ani.consumeNothing], [Ani.consumeBack], ..., [Ani.decideNothing], ...
///
class Ani {
  final DurationFR duration;
  final AnimationControllerInitializer initializer;
  final AnimatedStatefulWidgetUpdater<Mationani> updater;

  ///
  /// private
  ///
  Ani._updateIfNotAnimating({
    this.initializer = Ani.initialize,
    required this.duration,
    required Consumer<AnimationController> consumer,
  }) : updater = Ani.updateIfNotAnimating(consumer);

  Ani._updateIfAnimatingOr({
    this.initializer = Ani.initialize,
    required this.duration,
    required Consumer<AnimationController> onAnimating,
    required Consumer<AnimationController> onNotAnimating,
  }) : updater = Ani.updateIfAnimatingOr(onAnimating, onNotAnimating);

  ///
  /// public
  ///
  const Ani({
    this.initializer = Ani.initialize,
    required this.duration,
    required this.updater,
  });

  const Ani.initForward({
    required this.duration,
    required this.updater,
  }) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({
    required this.duration,
    required this.updater,
  }) : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reverseEnable = false,
    required this.duration,
    required this.updater,
  }) : initializer =
            reverseEnable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  Ani.initForwardAndUpdateIfNotAnimating({
    required DurationFR duration,
    required Consumer<AnimationController> consumer,
  }) : this._updateIfNotAnimating(
          initializer: Ani.initializeForward,
          duration: duration,
          consumer: consumer,
        );

  Ani.initForwardResetAndUpdateIfNotAnimating({
    required DurationFR duration,
    required Consumer<AnimationController> consumer,
  }) : this._updateIfNotAnimating(
          initializer: Ani.initializeForwardReset,
          duration: duration,
          consumer: consumer,
        );

  Ani.initRepeatAndUpdateIfNotAnimating({
    bool reversable = false,
    required DurationFR duration,
    required Consumer<AnimationController> consumer,
  }) : this._updateIfNotAnimating(
          initializer:
              reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat,
          duration: duration,
          consumer: consumer,
        );

  ///
  ///
  /// [initializing]
  /// [updating]
  ///
  AnimationController initializing(TickerProvider ticker) =>
      initializer(ticker, duration.forward, duration.reverse);

  void updating(
    AnimationController controller,
    Mationani oldWidget,
    Mationani widget,
  ) =>
      updater(controller, oldWidget, widget);

  ///
  ///
  /// [initialize]
  /// [initializeForward]
  /// [initializeForwardReset]
  /// [initializeRepeat]
  /// [initializeRepeatReverse]
  ///
  /// [initializeForwardWithListener]
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

  static AnimationControllerInitializer initializeForwardWithListener(
    AnimationStatusListener statusListener,
  ) =>
      (tickerProvider, forward, reverse) =>
          initializeForward(tickerProvider, forward, reverse)
            ..addStatusListener(statusListener);

  ///
  ///
  /// [update]
  /// [updateIfNotAnimating]
  /// [updateIfAnimatingOr]
  ///
  ///
  static AnimatedStatefulWidgetUpdater<Mationani> update(
    Consumer<AnimationController> consumer,
  ) =>
      (controller, oldWidget, widget) {
        final duration = widget.ani.duration;
        if (oldWidget.ani.duration != duration) {
          controller.duration = duration.forward;
          controller.reverseDuration = duration.reverse;
        }
        consumer(controller);
      };

  static AnimatedStatefulWidgetUpdater<Mationani> updateIfNotAnimating(
    Consumer<AnimationController> consumer,
  ) {
    final updating = update(consumer);
    return (controller, oldWidget, widget) =>
        controller.isAnimating ? null : updating(controller, oldWidget, widget);
  }

  static AnimatedStatefulWidgetUpdater<Mationani> updateIfAnimatingOr(
    Consumer<AnimationController> onAnimating,
    Consumer<AnimationController> consumer,
  ) {
    final updating = update(consumer);
    return (controller, oldWidget, widget) => controller.isAnimating
        ? onAnimating(controller)
        : updating(controller, oldWidget, widget);
  }

  ///
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
          VoidCallback listener) =>
      (status) => status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed
          ? listener()
          : null;

  ///
  ///
  /// [consumeNothing]
  /// [consumeForward]
  /// [consumeForwardReset]
  /// [consumeForwardOrReverse]
  /// [consumeReverse]
  /// [consumeRepeat]
  /// [consumeRepeatReverse]
  /// [consumeResetForward]
  /// [consumeBack]
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
///
/// [AniUpdateIfNotAnimating]
///
///
///

//
class AniUpdateIfNotAnimating extends Ani {
  AniUpdateIfNotAnimating({
    super.initializer,
    super.consumer = Ani.consumeNothing,
    required super.duration,
  }) : super._updateIfNotAnimating();

  ///
  /// init forward
  ///
  AniUpdateIfNotAnimating.initForward({
    required super.duration,
    required super.consumer,
  }) : super.initForwardAndUpdateIfNotAnimating();

  AniUpdateIfNotAnimating.initForwardAndUpdateReverse({
    required super.duration,
  }) : super.initForwardAndUpdateIfNotAnimating(consumer: Ani.consumeReverse);

  AniUpdateIfNotAnimating.initForwardAndUpdateResetForward({
    required super.duration,
  }) : super.initForwardAndUpdateIfNotAnimating(
          consumer: Ani.consumeResetForward,
        );

  AniUpdateIfNotAnimating.initForwardAndUpdateForwardOrReverse({
    required super.duration,
  }) : super.initForwardAndUpdateIfNotAnimating(
          consumer: Ani.consumeForwardOrReverse,
        );

  AniUpdateIfNotAnimating.initForwardAndUpdateRepeat({
    bool reversable = false,
    required super.duration,
  }) : super.initForwardAndUpdateIfNotAnimating(
          consumer: reversable ? Ani.consumeRepeat : Ani.consumeRepeatReverse,
        );

  AniUpdateIfNotAnimating.initForwardAndUpdateReverseWhen(
    bool trigger, {
    required super.duration,
  }) : super.initForwardAndUpdateIfNotAnimating(
          consumer: Ani.decideReverse(trigger),
        );

  AniUpdateIfNotAnimating.initForwardAndUpdateSequencingWhen(
    bool? trigger, {
    required Duration duration,
  }) : super.initForwardAndUpdateIfNotAnimating(
          duration: DurationFR.constant(duration),
          consumer: Ani.decideForwardOrReverse(trigger),
        );

  ///
  /// init forward reset
  ///
  AniUpdateIfNotAnimating.initForwardResetAndUpdateForwardReset({
    required super.duration,
  }) : super.initForwardResetAndUpdateIfNotAnimating(
          consumer: Ani.consumeForwardReset,
        );

  ///
  /// init repeat
  ///
  AniUpdateIfNotAnimating.initRepeat({
    super.reversable,
    required super.duration,
    required super.consumer,
  }) : super.initRepeatAndUpdateIfNotAnimating();

  ///
  /// update
  ///
  AniUpdateIfNotAnimating.updateForwardWhen(
    bool trigger, {
    super.initializer,
    required super.duration,
  }) : super._updateIfNotAnimating(consumer: Ani.decideForward(trigger));

  AniUpdateIfNotAnimating.updateForwardOrReverseWhen(
    bool trigger, {
    super.initializer,
    required super.duration,
  }) : super._updateIfNotAnimating(
          consumer: Ani.decideForwardOrReverse(trigger),
        );

  AniUpdateIfNotAnimating.updateSequencingWhen(
    bool? trigger, {
    super.initializer,
    required Duration duration,
  }) : super._updateIfNotAnimating(
          duration: DurationFR.constant(duration),
          consumer: Ani.decideForwardOrReverse(trigger),
        );
}

///
///
///
/// [AniUpdateIfAnimating]
///
///
///

//
class AniUpdateIfAnimating extends Ani {
  AniUpdateIfAnimating({
    super.initializer,
    required super.duration,
    required super.onAnimating,
    required super.onNotAnimating,
  }) : super._updateIfAnimatingOr();

  AniUpdateIfAnimating.backOr({
    super.initializer,
    required super.duration,
    required super.onNotAnimating,
  }) : super._updateIfAnimatingOr(onAnimating: Ani.consumeBack);

  AniUpdateIfAnimating.backOrForward({
    super.initializer,
    required super.duration,
  }) : super._updateIfAnimatingOr(
          onAnimating: Ani.consumeBack,
          onNotAnimating: Ani.consumeForward,
        );
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
///   * [BetweenInterval._link],
///     which is similar to the factory of [AniSequence]
///

///
///
class AniSequence {
  final List<Mamionability> abilities;
  final List<Duration> durations;

  const AniSequence._(this.abilities, this.durations);

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

    var i = -1;
    return AniSequence._(
      step.linkToListTill(
        totalStep,
        intervalGenerator,
        (previous, next, interval) => style.sequencer(previous, next, interval)(++i),
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
  final List<Point3> coordinates;

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

  static Mapper<int, Mamionability> _sequence({
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
            final curve = CurveFR.of(interval.curves[0]);
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) {
                final a = begin.coordinates;
                final b = end.coordinates;
                return MamionTransform._(
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
            final curve = CurveFR.of(interval.curves[0]);
            final controlPoints = interval.offsets;
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) => MamionMulti([
                MamionTransition.rotate(Between(
                  begin.values[0],
                  end.values[0],
                  curve: curve,
                )),
                MamionTransition.slide(BetweenSpline2D(
                  onLerp: BetweenSpline2D.lerpBezierCubic(
                    begin.offsets[0],
                    end.offsets[0],
                    c1: previous.offsets[0] + controlPoints[0],
                    c2: previous.offsets[0] + controlPoints[1],
                  ),
                  curve: curve,
                )),
              ]),
            );
          },
      };
}

///
///
/// typedefs:
///
///

typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider tickerProvider,
  Duration forward,
  Duration reverse,
);

typedef AnimatedStatefulWidgetUpdater<W extends StatefulWidget> = void Function(
  AnimationController controller,
  W oldWidget,
  W widget,
);
