part of '../mationani.dart';

///
///
/// * [Ani]
/// * [AniControllerInitializer]
/// * [AniUpdater]
///
/// * [AniSequenceCommand]
/// * [AniSequenceCommandInit]
/// * [AniSequenceCommandUpdate]
///
///
///

///
///
///
/// [Ani] is a class that focus on how animation can be used in [_MationaniState],
/// hiding the logic of [AnimationController] implementation.
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
  final AniControllerInitializer initializer;
  final AniUpdater? updater;

  @override
  int get hashCode => Object.hash(initializer, updater);

  @override
  bool operator ==(covariant Ani other) =>
      initializer == other.initializer && updater == other.updater;

  @override
  String toString() => 'Ani($initializer, $updater)';

  const Ani({
    this.initializer = Ani._initialize,
    this.updater,
  });

  const Ani.initForward({this.updater}) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({this.updater})
      : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reversable = false,
    this.updater,
  }) : initializer =
            reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  ///
  ///
  ///
  Ani.update({
    this.initializer = Ani._initialize,
    required void Function(AnimationController) onNotAnimating,
    void Function(AnimationController) onAnimating = Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, onNotAnimating);

  Ani.updateForwardReset({
    this.initializer = Ani._initialize,
    void Function(AnimationController) onAnimating = Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, Ani.consumeForwardReset);

  Ani.updateForwardOrReverse({
    this.initializer = Ani._initialize,
    void Function(AnimationController) onAnimating = Ani.consumeNothing,
  }) : updater = Ani._consumeUpdate(onAnimating, Ani.consumeForwardOrReverse);

  ///
  ///
  ///
  Ani.updateForwardWhen(
    bool trigger, {
    this.initializer = Ani._initialize,
    required Duration duration,
  }) : updater = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForward(trigger),
        );

  Ani.updateForwardOrReverseWhen(
    bool trigger, {
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.initializer = Ani._initialize,
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
  })  : initializer = Ani.initializeForward,
        updater = Ani._consumeUpdate(
          onAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
          onNotAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
        );

  Ani.initForwardAndWaitUpdateReverseTo(
    bool trigger, {
    required VoidCallback dismissedCall,
  })  : initializer = Ani.initializeForwardThenUpdateReverse,
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

  static AnimationController initializeForwardThenUpdateReverse(
      TickerProvider vsync, Duration forward, Duration reverse) {
    final controller = _initialize(vsync, forward, reverse);
    return controller
      ..forward()
      ..addStatusListener(statusListenDismissed(controller.reverse));
  }

  ///
  /// [statusListenForward], [statusListenReverse]
  /// [statusListenCompleted], [statusListenDismissed]
  /// [statusListenCompletedOrDismissed]
  ///
  static AnimationStatusListener statusListenForward(VoidCallback listener) =>
      (status) {
        if (status == AnimationStatus.forward) listener();
      };

  static AnimationStatusListener statusListenReverse(VoidCallback listener) =>
      (status) {
        if (status == AnimationStatus.reverse) listener();
      };

  static AnimationStatusListener statusListenCompleted(VoidCallback listener) =>
      (status) {
        if (status == AnimationStatus.completed) listener();
      };

  static AnimationStatusListener statusListenDismissed(VoidCallback listener) =>
      (status) {
        if (status == AnimationStatus.dismissed) listener();
      };

  static AnimationStatusListener statusListenCompletedOrDismissed(
    VoidCallback listener,
  ) =>
      (status) {
        switch (status) {
          case AnimationStatus.dismissed || AnimationStatus.completed:
            listener();
          case AnimationStatus.forward || AnimationStatus.reverse:
            return;
        }
      };

  ///
  /// [_consumeUpdate]
  /// [consumeNothing]
  /// [consumeForward], [consumeForwardReset], [consumeForwardOrReverse], [consumeReverse]
  /// [consumeRepeat], [consumeRepeatReverse]
  /// [consumeResetForward]
  /// [consumeBack]
  ///
  // static void _updateNothing(AnimationController c, Mationani o, Mationani n) {}

  static AniUpdater _consumeUpdate(
    void Function(AnimationController) onAnimating,
    void Function(AnimationController) onNotAnimating,
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
typedef AniControllerInitializer = AnimationController Function(
  TickerProvider vsync,
  Duration forward,
  Duration reverse,
);
typedef AniUpdater = void Function(
  AnimationController controller,
  Mationani oldWidget,
  Mationani widget,
);

///
///
///
final class AniSequenceCommand {
  final AniSequenceCommandInit? initialize;
  final AniSequenceCommandUpdate update;

  const AniSequenceCommand({
    this.initialize = AniSequenceCommandInit.forward,
    this.update = AniSequenceCommandUpdate.nothing,
  });
}

enum AniSequenceCommandInit {
  forward,
  forwardReset,
  forwardRepeat,
  pulse, // forward then reverse
  pulseRepeat,
}

enum AniSequenceCommandUpdate {
  nothing,
  forward,
  forwardStep,
  reverse,
  reverseStep,
  stopOrResume,
}