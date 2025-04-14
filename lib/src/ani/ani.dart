part of '../../mationani.dart';

///
///
/// [Ani] and [Mation] helps us to create animation for [Mationani].
/// [Mation] implement how [Animation] can be triggered by [Ani] in [_MationaniState].
/// while [Ani] implement how [AnimationController] can be used in [_MationaniState].
///   - [initializing] for [_MationaniState.initState]
///   - [updating] for [_MationaniState.didUpdateWidget]
/// Normally, it's hard to implement [AnimationController] everytime we want to trigger animation; we need to
///   1. let stateful widget state inherit ticker provider.
///   2. let controller instance hold for state inherited ticker provider.
///   3. be in right place to let controller instance control animation (initState, didUpdateWidget, ...)
///   4. be in right way to let controller instance trigger animation (by invoke function , by change value)
/// With [Ani] as interface, 1 and 2 are prevented. 3 and 4 are easier.
///
/// In short,
/// the development of [Ani] focus on implementing the [AnimationController] functionality,
/// and explore the capability of animation control, not limited to the [AnimationController] functionality.
///
///

///
///
/// [AniSequence]
///   [AniSequenceStep]
///   [AniSequenceInterval]
///   [AniSequenceStyle]
///
/// typedefs:
///   [AnimationControllerInitializer]
///   [AnimatedStatefulWidgetUpdater]
///
/// extensions:
///
///
///

///
/// [initializer] see [Ani._initialize], ...
/// [updater] see [Ani.consumeNothing], [Ani.consumeBack], ..., [Ani.decideNothing], ...
/// status controller see [Ani.statusListenForward]
///
class Ani {
  final DurationFR duration;
  final AnimationControllerInitializer initializer;
  final AnimatedStatefulWidgetUpdater<Mationani> updater;

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
  ///
  const Ani({
    this.initializer = Ani._initialize,
    this.updater = Ani._update,
    required this.duration,
  });

  const Ani.initForward({
    this.updater = _update,
    required this.duration,
  }) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({
    this.updater = _update,
    required this.duration,
  }) : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reversable = false,
    this.updater = _update,
    required this.duration,
  }) : initializer =
            reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  ///
  ///
  ///
  Ani.initForwardWithStatusListener({
    this.updater = _update,
    required AnimationStatusListener statusListener,
    required this.duration,
  }) : initializer = Ani.initializeForwardWithStatusListener(statusListener);

  ///
  ///
  ///
  Ani.update({
    this.initializer = Ani._initialize,
    required this.duration,
    required Consumer<AnimationController> onNotAnimating,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, onNotAnimating);

  Ani.updateForwardOrReverse({
    this.initializer = Ani._initialize,
    required this.duration,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, Ani.consumeForwardOrReverse);

  ///
  ///
  /// with trigger
  ///
  ///
  Ani.updateForwardWhen(
    bool trigger, {
    this.initializer = Ani._initialize,
    required Duration duration,
  })  : duration = DurationFR.of(duration),
        updater = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForward(trigger),
        );

  Ani.updateSequencingWhen(
    bool? trigger, {
    this.initializer = Ani._initialize,
    required Duration duration,
  })  : duration = DurationFR.of(duration),
        updater = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForwardOrReverse(trigger),
        );

  Ani.updateForwardOrReverseWhen(
    bool trigger, {
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.initializer = Ani._initialize,
    required this.duration,
  }) : updater = Ani._consumeUpdate(
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
    required this.duration,
  })  : initializer = Ani.initializeForward,
        updater = Ani._consumeUpdate(
          onAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
          onNotAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
        );

  Ani.initForwardAndWaitUpdateReverseTo(
    bool trigger, {
    required VoidCallback dismissedCall,
    required this.duration,
  })  : initializer = Ani.initializeForwardWithStatusListener(
          Ani.statusListenDismissed(dismissedCall),
        ),
        updater = Ani._consumeUpdate(
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
  /// [_update]
  /// [_consumeUpdate]
  /// [consumeNothing]
  /// [consumeForward], [consumeForwardReset], [consumeForwardOrReverse], [consumeReverse]
  /// [consumeRepeat], [consumeRepeatReverse]
  /// [consumeResetForward]
  /// [consumeBack]
  ///
  static void _update(AnimationController c, Mationani oW, Mationani nW) {}

  static AnimatedStatefulWidgetUpdater<Mationani> _consumeUpdate(
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
///   * [Mamion], [Manion] are [Mation] implementation
///   * [Between.sequence] achieve chaining animation by directly lerp [Animation.value].
///   * [BetweenInterval._link] is similar to [AniSequence] default factory.
///   * [Mationani.mamionSequence] takes [AniSequence] as required argument.
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
        (previous, next, interval) =>
            style.sequencer(previous, next, interval)(++i),
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
  final List<Point3> points3;

  const AniSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.points3 = const [],
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
    required Fusionor<AniSequenceStep, Mamionability> combine,
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
                final a = begin.points3;
                final b = end.points3;
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
/// typedefs:
///
typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider vsync,
  Duration forward,
  Duration reverse,
);

typedef AnimatedStatefulWidgetUpdater<W extends StatefulWidget> = void Function(
  AnimationController controller,
  W oldWidget,
  W widget,
);

///
/// extensions:
///
extension AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  ///
  ///
  void updateDurationIfNew(Mationani oldWidget, Mationani widget) {
    final d = widget.ani.duration;
    if (oldWidget.ani.duration != d) {
      duration = d.forward;
      reverseDuration = d.reverse;
    }
  }
}
