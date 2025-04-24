part of '../mationani.dart';

///
///
/// * [Ani]
///
/// * [AniSequence]
/// * [AniSequenceStep]
/// * [AniSequenceInterval]
/// * [AniSequenceStyle]
///
///
///

///
///
/// [Ani] implement how [AnimationController] can be used in [_MationaniState].
///   - [initializing] for [_MationaniState.initState]
///   - [updating] for [_MationaniState.didUpdateWidget]
/// In tradition, it's hard to implement [AnimationController] everytime we want to trigger animation; we need to
///   1. let [State] object inherit [TickerProvider].
///   2. let [AnimationController] instance hold for the [State] inherited [TickerProvider].
///   3. trigger animation be in the right place ([State.initState], [State.didUpdateWidget], [State.setState])
/// With [Ani] as interface, 1 and 2 are prevented, 3 are easier.
/// it focus on [AnimationController] implementation, and also not limited to the it.
///
///


///
/// static methods:
/// [Ani._initialize], ...
/// [Ani._updateNothing], ...
/// [Ani.statusListenForward], ...
///
class Ani {
  final AnimationStyle? style;
  final Consumer<VoidCallback>? initialConsumeSetStateCallback;
  final AnimationControllerInitializer initializer;
  final AnimationUpdater updating;

  AnimationController initializing(TickerProvider ticker) => initializer(
      ticker,
      style?.duration ?? KCore.durationMilli500,
      style?.reverseDuration ?? KCore.durationMilli500);

  CurveFR? get curve {
    final style = this.style;
    if (style == null) return null;
    if (style.curve == null || style.reverseCurve == null) return null;
    return CurveFR(style.curve!, style.reverseCurve!);
  }

  ///
  ///
  ///
  const Ani({
    this.initializer = Ani._initialize,
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    this.style,
  });

  const Ani.initForward({
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    this.style,
  }) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    this.style,
  }) : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reversable = false,
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    this.style,
  }) : initializer =
            reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  ///
  ///
  ///
  Ani.initForwardWithStatusListener({
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    required AnimationStatusListener statusListener,
    this.style,
  }) : initializer = Ani.initializeForwardWithStatusListener(statusListener);

  Ani.initForwardListenCompleted({
    this.updating = Ani._updateNothing,
    this.initialConsumeSetStateCallback,
    this.style,
    required VoidCallback listener,
  }) : initializer = Ani.initializeForwardWithStatusListener(
            Ani.statusListenCompleted(listener));

  ///
  ///
  ///
  Ani.update({
    this.initializer = Ani._initialize,
    this.initialConsumeSetStateCallback,
    this.style,
    required Consumer<AnimationController> onNotAnimating,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updating = Ani._consumeUpdate(onAnimating, onNotAnimating);

  Ani.updateForwardOrReverse({
    this.initializer = Ani._initialize,
    this.initialConsumeSetStateCallback,
    this.style,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updating = Ani._consumeUpdate(onAnimating, Ani.consumeForwardOrReverse);

  ///
  ///
  /// with trigger
  ///
  ///
  Ani.updateForwardWhen(
    bool trigger, {
    this.initializer = Ani._initialize,
    this.initialConsumeSetStateCallback,
    required Duration duration,
  })  : style = AnimationStyle(duration: duration, reverseDuration: duration),
        updating = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForward(trigger),
        );

  Ani.updateSequencingWhen(
    bool? trigger, {
    this.initializer = Ani._initialize,
    this.initialConsumeSetStateCallback,
    required Duration duration,
  })  : style = AnimationStyle(duration: duration, reverseDuration: duration),
        updating = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForwardOrReverse(trigger),
        );

  Ani.updateForwardOrReverseWhen(
    bool trigger, {
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.initializer = Ani._initialize,
    this.initialConsumeSetStateCallback,
    this.style,
  }) : updating = Ani._consumeUpdate(
          onAnimating
              ? Ani.decideForwardOrReverse(trigger)
              : Ani.consumeNothing,
          onNotAnimating
              ? Ani.decideForwardOrReverse(trigger)
              : Ani.consumeNothing,
        );

  ///
  ///
  ///
  Ani.initForwardAndUpdateReverseWhen(
    bool trigger, {
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.initialConsumeSetStateCallback,
    this.style,
  })  : initializer = Ani.initializeForward,
        updating = Ani._consumeUpdate(
          onAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
          onNotAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
        );

  Ani.initForwardAndWaitUpdateReverseTo(
    bool trigger, {
    required VoidCallback dismissedCall,
    this.initialConsumeSetStateCallback,
    this.style,
  })  : initializer = Ani.initializeForwardWithStatusListener(
          Ani.statusListenDismissed(dismissedCall),
        ),
        updating = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideReverse(trigger),
        );

  ///
  /// [_initialize]
  /// [initializeForward], [initializeForwardReset]
  /// [initializeRepeat], [initializeRepeatReverse]
  ///
  static AnimationController _initialize(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      AnimationController(
          vsync: vsync, duration: forward, reverseDuration: reverse);

  static AnimationController initializeForward(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      _initialize(vsync, forward, reverse)..forward();

  static AnimationController initializeForwardReset(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      _initialize(vsync, forward, reverse)..forwardReset();

  static AnimationController initializeRepeat(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      _initialize(vsync, forward, reverse)..repeat();

  static AnimationController initializeRepeatReverse(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      _initialize(vsync, forward, reverse)..repeat(reverse: true);

  ///
  /// [initializeForwardWithStatusListener]
  /// [statusListenForward], [statusListenReverse]
  /// [statusListenCompleted], [statusListenDismissed]
  /// [statusListenCompletedOrDismissed]
  ///
  static AnimationControllerInitializer initializeForwardWithStatusListener(
          AnimationStatusListener listener) =>
      (vsync, forward, reverse) => initializeForward(vsync, forward, reverse)
        ..addStatusListener(listener);

  static AnimationStatusListener statusListenForward(VoidCallback listener) =>
      (status) => status == AnimationStatus.forward ? listener() : null;

  static AnimationStatusListener statusListenReverse(VoidCallback listener) =>
      (status) => status == AnimationStatus.reverse ? listener() : null;

  static AnimationStatusListener statusListenCompleted(VoidCallback listener) =>
      (status) => status == AnimationStatus.completed ? listener() : null;

  static AnimationStatusListener statusListenDismissed(VoidCallback listener) =>
      (status) => status == AnimationStatus.dismissed ? listener() : null;

  static AnimationStatusListener statusListenCompletedOrDismissed(
          VoidCallback listener) =>
      (status) => status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed
          ? listener()
          : null;

  ///
  /// [_updateNothing]
  /// [_consumeUpdate]
  /// [consumeNothing]
  /// [consumeForward], [consumeForwardReset], [consumeForwardOrReverse], [consumeReverse]
  /// [consumeRepeat], [consumeRepeatReverse]
  /// [consumeResetForward]
  /// [consumeBack]
  ///
  static void _updateNothing(AnimationController c, Mationani o, Mationani n) {}

  static AnimationUpdater _consumeUpdate(
    Consumer<AnimationController> onAnimating,
    Consumer<AnimationController> onNotAnimating,
  ) =>
      (controller, oldWidget, widget) {
        controller.updateDurationIfNew(oldWidget, widget);
        controller.isAnimating
            ? onAnimating(controller)
            : onNotAnimating(controller);
      };

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
  /// [decideNothing]
  /// [decideForward], [decideReverse], [decideRepeat], [decideForwardReset]
  /// [decideForwardOrReverse], [decideForwardOrRepeat]
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

  static Consumer<AnimationController> decideForwardOrReverse(bool? forward) =>
      switch (forward) {
        true => consumeForward,
        false => consumeReverse,
        null => consumeNothing,
      };

  static Consumer<AnimationController> decideForwardOrRepeat(bool? forward) =>
      switch (forward) {
        true => consumeForward,
        false => consumeRepeat,
        null => consumeNothing,
      };
}

///
///
/// See Also
///   * [_Mamion], [_Manion] are [Mation] implementation
///   * [Between.sequence] achieve chaining animation by directly lerp [Animation.value].
///   * [BetweenInterval._link] is similar to [AniSequence] default factory.
///   * [Mationani.mamionSequence] takes [AniSequence] as required argument.
///
///
final class AniSequence {
  final List<Mamable> abilities;
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
      step.linkToListTill<AniSequenceInterval, Mamable>(
        totalStep,
        intervalGenerator,
        (previous, next, interval) =>
            style.sequencer(previous, next, interval)(++i),
      ),
      durations,
    );
  }
}

///
///
final class AniSequenceStep {
  final List<double> values;
  final List<Offset> offsets;
  final List<Point3> points3;

  const AniSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.points3 = const [],
  });
}

///
///
final class AniSequenceInterval {
  final Duration duration;
  final List<Curve> curves;
  final List<Offset> offsets; // for curving control, interval step

  const AniSequenceInterval({
    this.duration = KCore.durationSecond1,
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
  /// [_forwardOrReverse] is the only way to sequence [Mamable] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Mapper<int, Mamable> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required AniSequenceStep previous,
    required AniSequenceStep next,
    required Fusionor<AniSequenceStep, Mamable> combine,
  }) =>
      (i) => combine(
            predicator(i) ? previous : next,
            predicator(i) ? next : previous,
          );

  AniSequencer<Mamable> get sequencer => switch (this) {
        transformTRS => (previous, next, interval) {
            final curve = CurveFR.of(interval.curves[0]);
            return AniSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) {
                final a = begin.points3;
                final b = end.points3;
                return MamableTransform._(
                  [
                    MamableTransformDelegate.translation(
                      Between(a[0], b[0], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MamableTransformDelegate.rotation(
                      Between(a[1], b[1], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MamableTransformDelegate.scale(
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
              combine: (begin, end) => MamableSet([
                MamableTransition.rotate(Between(
                  begin.values[0],
                  end.values[0],
                  curve: curve,
                )),
                MamableTransition.slide(BetweenSpline2D(
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
