part of '../mationani.dart';

///
///
/// * [Ani]
/// * [AniInitializer]
/// * [AniUpdater]
///
/// * [AniSequenceCommand]
/// * [AniSequenceCommandInit]
/// * [AniSequenceCommandUpdate]
///
///
///

///
/// static methods:
/// [initialize], ...
/// [statusListenForward], ...
/// [updaterBinary]
/// [controlForward], ...
/// [decideForward], ...
/// [updateDurationOnly], ...
///
abstract final class Ani {
  ///
  /// [initialize]
  /// [initializeForward], [initializeForwardReset]
  /// [initializeRepeat], [initializeRepeatReverse]
  ///
  static AnimationController initialize(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      AnimationController(
          vsync: vsync, duration: forward, reverseDuration: reverse);

  static AnimationController initializeForward(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      initialize(vsync, forward, reverse)..forward();

  static AnimationController initializeForwardReset(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      initialize(vsync, forward, reverse)..forwardReset();

  static AnimationController initializeRepeat(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      initialize(vsync, forward, reverse)..repeat();

  static AnimationController initializeRepeatReverse(
          TickerProvider vsync, Duration forward, Duration reverse) =>
      initialize(vsync, forward, reverse)..repeat(reverse: true);

  static AnimationController initializeForwardThenUpdateReverse(
      TickerProvider vsync, Duration forward, Duration reverse) {
    final controller = initialize(vsync, forward, reverse);
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
  /// [updaterBinary]
  ///
  static AniUpdater updaterBinary({
    void Function(AnimationController)? onAnimating,
    void Function(AnimationController)? onNotAnimating,
  }) =>
      (controller, oldWidget, widget) {
        controller.updateDurationIfNew(oldWidget, widget);
        controller.isAnimating
            ? onAnimating?.call(controller)
            : onNotAnimating?.call(controller);
      };

  ///
  /// [controlForward], [controlForwardReset], [controlForwardOrReverse], [controlReverse]
  /// [controlRepeat], [controlRepeatReverse]
  /// [controlResetForward]
  /// [controlBack]
  ///
  static void controlForward(AnimationController c) => c.forward();

  static void controlForwardReset(AnimationController c) => c.forwardReset();

  static void controlForwardOrReverse(AnimationController controller) =>
      controller.status == AnimationStatus.dismissed
          ? controller.forward()
          : controller.reverse();

  static void controlReverse(AnimationController c) => c.reverse();

  static void controlRepeat(AnimationController c) => c.repeat();

  static void controlRepeatReverse(AnimationController c) =>
      c.repeat(reverse: true);

  static void controlResetForward(AnimationController c) => c.resetForward();

  static void controlBack(AnimationController controller) =>
      controller.status == AnimationStatus.forward
          ? controller.reverse(from: controller.value)
          : controller.forward(from: controller.value);

  ///
  /// [decideNothing]
  /// [decideForward], [decideReverse], [decideRepeat], [decideForwardReset]
  /// [decideForwardOrReverse], [decideForwardOrRepeat]
  ///
  static void Function(AnimationController controller)? decideNothing(
          bool trigger) =>
      null;

  static void Function(AnimationController controller)? decideForward(
          bool trigger) =>
      trigger ? controlForward : null;

  static void Function(AnimationController controller)? decideReverse(
          bool trigger) =>
      trigger ? controlReverse : null;

  static void Function(AnimationController controller)? decideForwardReset(
          bool trigger) =>
      trigger ? controlForwardReset : null;

  static void Function(AnimationController controller)? decideRepeat(
          bool trigger) =>
      trigger ? controlRepeat : null;

  static void Function(AnimationController controller)? decideForwardOrReverse(
          bool forward) =>
      forward ? controlForward : controlReverse;

  static void Function(AnimationController controller)? decideForwardOrRepeat(
          bool forward) =>
      forward ? controlForward : controlRepeat;

  ///
  /// [updateDurationOnly]
  /// [updateFr]            (forward or reverse)
  /// [updateDecideFr]      (decide forward or reverse)
  ///
  static void updateDurationOnly(
    AnimationController controller,
    Mationani oldW,
    Mationani w,
  ) =>
      controller.updateDurationIfNew(oldW, w);

  static void updateFr(AnimationController c, Mationani oldW, Mationani w) {
    c.updateDurationIfNew(oldW, w);
    if (!c.isAnimating) controlForwardOrReverse(c);
  }

  static AniUpdater updateDecideFr(bool toggle) => (controller, oldW, w) {
        controller.updateDurationIfNew(oldW, w);
        if (!controller.isAnimating) {
          toggle ? controlForward(controller) : controlReverse(controller);
        }
      };
}

///
///
///
typedef AniInitializer = AnimationController Function(
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
enum AniSequenceCommandInit {
  forward,
  forwardStep,
  forwardReset,
  forwardRepeat,
  pulse, // forward then reverse
  pulseRepeat,
}

enum AniSequenceCommandUpdate {
  forwardIfDismissed,
  forwardStepExceptReverse,
  reverseIfCompleted,
  reverseStepExceptForward,
  stopOrResume,
}
