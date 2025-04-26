part of '../mationani.dart';

///
///
/// [Mationani]
/// * [Ani]
/// * [Mation]
///     --[_Mamion]
///     --[_Manion]
///
///
///
///

///
///
///
final class Mationani extends StatefulWidget {
  final Ani ani;
  final Mation mation;

  // create animation for a child
  Mationani.mamion({
    super.key,
    required this.ani,
    required Mamable mamable,
    required Widget child,
  }) : mation = _Mamion(mamable: mamable, child: child);

  // create animation for children
  Mationani.manion({
    super.key,
    required this.ani,
    required Manable manable,
    required Parenting parenting,
    required List<Widget> children,
  }) : mation = _Manion(
    manable: manable,
    child: parenting,
    grandChildren: children,
  );

  ///
  ///
  ///
  @override
  State<Mationani> createState() => _MationaniState();

  static bool dismissUpdateBuilder(Mationani oldWidget, Mationani widget) =>
      oldWidget.mation == widget.mation &&
          oldWidget.ani.style.isCurveEqualTo(widget.ani.style);
}

class _MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late Widget child;

  Widget get planForChild => widget.mation.plan(
    controller,
    widget.ani.curve,
  );

  @override
  void initState() {
    super.initState();
    widget.ani.initialConsumeSetStateCallback?.call(() => setState(() {}));
    controller = widget.ani.initializing(this);
    child = planForChild;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  ///
  /// If we called [setState] function in parent widget,
  /// it triggers [_MationaniState.didUpdateWidget] no matter [Mationani] configuration changed or not.
  /// Instead of performing the expensive [setState] function in parent,
  /// we can also received [_MationaniState.setState] callback by [Ani.initialConsumeSetStateCallback] in parent,
  ///
  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.ani.updating(controller, oldWidget, widget);
    if (Mationani.dismissUpdateBuilder(widget, oldWidget)) return;
    child = planForChild;
  }

  @override
  Widget build(BuildContext context) => child;
}


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
/// [_MationaniState.didUpdateWidget], there is [updating] to be defined
/// [_MationaniState.setState], there is [initialConsumeSetStateCallback] passing callback to parent widget
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
  final AnimationStyle? style;
  final Consumer<VoidCallback>? initialConsumeSetStateCallback;
  final VoidCallback? initialListener;
  final AnimationStatusListener? initialStatusListener;
  final AnimationControllerInitializer initializer;
  final AnimationUpdater updating;

  AnimationController initializing(TickerProvider ticker) => initializer(
        ticker,
        style?.duration ?? KCore.durationMilli500,
        style?.reverseDuration ?? KCore.durationMilli500,
      )
        ..addStatusListenerIfNotNull(initialStatusListener)
        ..addListenerIfNotNull(initialListener);

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
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
    this.updating = Ani._updateNothing,
    this.style,
  });

  const Ani.initForward({
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.updating = Ani._updateNothing,
    this.style,
  }) : initializer = Ani.initializeForward;

  const Ani.initForwardReset({
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.updating = Ani._updateNothing,
    this.style,
  }) : initializer = Ani.initializeForwardReset;

  const Ani.initRepeat({
    bool reversable = false,
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.updating = Ani._updateNothing,
    this.style,
  }) : initializer =
            reversable ? Ani.initializeRepeatReverse : Ani.initializeRepeat;

  ///
  ///
  ///
  Ani.update({
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
    this.style,
    required Consumer<AnimationController> onNotAnimating,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updating = Ani._consumeUpdate(onAnimating, onNotAnimating);

  Ani.updateForwardOrReverse({
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
    this.style,
    Consumer<AnimationController> onAnimating = Ani.consumeNothing,
  }) : updating = Ani._consumeUpdate(onAnimating, Ani.consumeForwardOrReverse);

  ///
  ///
  ///
  Ani.updateForwardWhen(
    bool trigger, {
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
    required Duration duration,
  })  : style = AnimationStyle(duration: duration, reverseDuration: duration),
        updating = Ani._consumeUpdate(
          Ani.consumeNothing,
          Ani.decideForward(trigger),
        );

  Ani.updateSequencingWhen(
    bool? trigger, {
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
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
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    this.initializer = Ani._initialize,
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
    this.initialListener,
    this.initialStatusListener,
    this.initialConsumeSetStateCallback,
    bool onAnimating = false,
    bool onNotAnimating = true,
    this.style,
  })  : initializer = Ani.initializeForward,
        updating = Ani._consumeUpdate(
          onAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
          onNotAnimating ? Ani.decideReverse(trigger) : Ani.consumeNothing,
        );

  Ani.initForwardAndWaitUpdateReverseTo(
    bool trigger, {
    this.initialListener,
    this.initialConsumeSetStateCallback,
    required VoidCallback dismissedCall,
    this.style,
  })  : initialStatusListener = Ani.statusListenDismissed(dismissedCall),
        initializer = Ani.initializeForward,
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
/// below is an approximate flow illustrating how [Mation] works, take [MamableClipper] as example.
/// .
///                           [MamableClipper] <  <  [MamableSingle._perform]
///                                      v               ^
/// [_Mamion.matable] < [Mation.matable]  v               ^    [_MatableDriver._drive]
///                  [Mationani.mation]  v               ^    [_MatableDriver._builder]
///      [_MationaniState.planForChild]  v               ^
///                                      v               ^
///          [Mation.plan] > [_Mamion.plan] required [Mamable._perform] < [Matable._perform]
///
///
abstract base class Mation<A extends Matable, C> {
  final A matable;
  final C child;

  // factory cannot construct typed generic, so it's not possible to integrate subclasses into Mation for now
  // static methods as constructor is not referenced well in android studio.
  const Mation({required this.matable, required this.child});

  Widget plan(Animation<double> parent, CurveFR? curve);

  @override
  String toString() => 'Mation($matable)';
}

///
/// [_Mamion] responsible for animation on a child widget. ([SizedBox], [Container], [Scaffold], ...)
///
final class _Mamion extends Mation<Mamable, Widget> {
  const _Mamion({required Mamable mamable, required super.child})
      : super(matable: mamable);

  @override
  Widget plan(Animation<double> parent, CurveFR? curve) =>
      matable._perform(parent, curve, child);
}

///
/// [_Manion] responsible for animation on a parent widget with 'children'. ([Stack], [Column], ...)
///
/// notice that the 'parent' of [Parenting] is different from 'parent' argument in [Mation.plan],
/// the former means the 'widget parent' be like [Stack] or [Column]
/// the latter means the 'animation parent', [AnimationController], see also the 'parent' in [Animatable.animate]
///
final class _Manion extends Mation<Manable, Parenting> {
  final List<Widget> grandChildren;

  const _Manion({
    required Manable manable,
    required super.child,
    required this.grandChildren,
  }) : super(matable: manable);

  @override
  Widget plan(Animation<double> parent, CurveFR? curve) =>
      matable is _ManableParent
          ? (matable as _ManableParent).parent._perform(
                parent,
                curve,
                child(matable._perform(parent, curve, grandChildren)),
              )
          : child(matable._perform(parent, curve, grandChildren));
}
