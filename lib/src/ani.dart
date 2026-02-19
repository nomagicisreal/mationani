part of '../mationani.dart';

///
///
/// [Ani]
///   --[AniSequence]
///
/// * [AnimationControllerInitializer]
/// * [AnimationUpdater]
///
///

///
///
/// [Ani] is a class that focus on how animation can be used in [_MationaniState].
///
/// In tradition, it's hard to implement [AnimationController] everytime we want to trigger animation; we need to
///   1. let [State] object inherit [TickerProvider].
///   2. let [AnimationController] instance hold for the [State] inherited [TickerProvider].
///   3. trigger animation be in the right place ([State.initState], [State.didUpdateWidget], [State.setState])
/// With [Ani], 1 and 2 are prevented, 3 is easier. It implement the chance we changed state in [_MationaniState]
/// [_MationaniState.initState], there is [initializing] function for configuration.
/// [_MationaniState.didUpdateWidget], there is [updater] to be defined
/// [_MationaniState.setState], there is [setStateProvider] passing callback to parent widget
///
///

///
/// constructors:
/// [Ani.initForward], ...
/// [Ani.update], ...
/// [Ani.updateForwardWhen], ...
/// [Ani.initForwardAndUpdateReverseWhen], ...
///
/// static methods:
/// [Ani._initialize], ...
/// [Ani.statusListenForward], ...
/// [Ani._updateNothing], ...
/// [Ani.decideForward], ...
///
final class Ani {
  final AnimationControllerInitializer initializer;
  final VoidCallback? initialListener;
  final AnimationStatusListener? initialStatusListener;
  final AnimationUpdater updater;
  final (Duration, Duration) duration;

  @override
  int get hashCode => Object.hash(duration.hashCode, initialListener,
      initialStatusListener, initializer, updater);

  @override
  bool operator ==(covariant Ani other) =>
      duration == other.duration &&
      initialListener == other.initialListener &&
      initialStatusListener == other.initialStatusListener &&
      initializer == other.initializer &&
      updater == other.updater;

  @override
  String toString() => 'Ani('
      '\n$duration,'
      '\n$initialListener,'
      '\n$initialStatusListener,'
      '\n$initializer,'
      '\n$updater,'
      '\n)\n';

  AnimationController initializing(TickerProvider vsync) =>
      initializer(vsync, duration.$1, duration.$2)
        ..addStatusListenerIfNotNull(initialStatusListener)
        ..addListenerIfNotNull(initialListener);

  ///
  ///
  ///
  const Ani({
    this.initializer = Ani._initialize,
    this.initialListener,
    this.initialStatusListener,
    this.updater = Ani._updateNothing,
    this.duration = const (_durationDefault, _durationDefault),
  });

  const Ani.initForward({
    this.initialListener,
    this.initialStatusListener,
    this.updater = Ani._updateNothing,
    this.duration = const (_durationDefault, _durationDefault),
  }) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({
    this.initialListener,
    this.initialStatusListener,
    this.updater = Ani._updateNothing,
    this.duration = const (_durationDefault, _durationDefault),
  }) : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reversable = false,
    this.initialListener,
    this.initialStatusListener,
    this.updater = Ani._updateNothing,
    this.duration = const (_durationDefault, _durationDefault),
  }) : initializer =
            reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  ///
  ///
  ///
  Ani.update({
    this.initialListener,
    this.initialStatusListener,
    this.initializer = Ani._initialize,
    this.duration = const (_durationDefault, _durationDefault),
    required void Function(AnimationController controller) onNotAnimating,
    void Function(AnimationController controller) onAnimating =
        Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, onNotAnimating);

  Ani.updateForwardReset({
    this.initialListener,
    this.initialStatusListener,
    this.initializer = Ani._initialize,
    this.duration = const (_durationDefault, _durationDefault),
    void Function(AnimationController controller) onAnimating =
        Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, Ani.consumeForwardReset);

  Ani.updateForwardOrReverse({
    this.initialListener,
    this.initialStatusListener,
    this.initializer = Ani._initialize,
    this.duration = const (_durationDefault, _durationDefault),
    void Function(AnimationController controller) onAnimating =
        Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, Ani.consumeForwardOrReverse);

  ///
  ///
  ///
  Ani.updateForwardWhen(
    bool trigger, {
    this.initialListener,
    this.initialStatusListener,
    this.initializer = Ani._initialize,
    required Duration duration,
  })  : duration = (duration, duration),
        updater = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForward(trigger),
        );

  Ani.updateForwardOrReverseWhen(
    bool trigger, {
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.initialListener,
    this.initialStatusListener,
    this.initializer = Ani._initialize,
    this.duration = const (_durationDefault, _durationDefault),
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
    this.initialListener,
    this.initialStatusListener,
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.duration = const (_durationDefault, _durationDefault),
  })  : initializer = Ani.initializeForward,
        updater = Ani._consumeUpdate(
          onAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
          onNotAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
        );

  Ani.initForwardAndWaitUpdateReverseTo(
    bool trigger, {
    this.initialListener,
    required VoidCallback dismissedCall,
    this.duration = const (_durationDefault, _durationDefault),
  })  : initialStatusListener = Ani.statusListenDismissed(dismissedCall),
        initializer = Ani.initializeForward,
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
  /// [statusListenForward], [statusListenReverse]
  /// [statusListenCompleted], [statusListenDismissed]
  /// [statusListenCompletedOrDismissed]
  ///
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
    void Function(AnimationController controller) onAnimating,
    void Function(AnimationController controller) onNotAnimating,
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
  static void Function(AnimationController controller) decideNothing(
          bool trigger) =>
      consumeNothing;

  static void Function(AnimationController controller) decideForward(
          bool trigger) =>
      trigger ? consumeForward : consumeNothing;

  static void Function(AnimationController controller) decideReverse(
          bool trigger) =>
      trigger ? consumeReverse : consumeNothing;

  static void Function(AnimationController controller) decideForwardReset(
          bool trigger) =>
      trigger ? consumeForwardReset : consumeNothing;

  static void Function(AnimationController controller) decideRepeat(
          bool trigger) =>
      trigger ? consumeRepeat : consumeNothing;

  static void Function(AnimationController controller) decideForwardOrReverse(
          bool? forward) =>
      switch (forward) {
        true => consumeForward,
        false => consumeReverse,
        null => consumeNothing,
      };

  static void Function(AnimationController controller) decideForwardOrRepeat(
          bool? forward) =>
      switch (forward) {
        true => consumeForward,
        false => consumeRepeat,
        null => consumeNothing,
      };
}

///
///
///
typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider vsync,
  Duration forward,
  Duration reverse,
);
typedef AnimationUpdater = void Function(
  AnimationController controller,
  Mationani oldWidget,
  Mationani widget,
);
