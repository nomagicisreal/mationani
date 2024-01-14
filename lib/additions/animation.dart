part of '../mationani.dart';

///
/// this file contains:
///
/// [Ani]
///   * [_AniBase]
///   --[AniProgress]
///     [AniProgressBool]
///     [AniProgressTernary]
///
/// [MationBase]
///   [Mation]
///     * [MationSequence]
///       * [MationSequenceStyle]
///       * [MationSequenceStep], [MationSequenceInterval]
///   --[_MationTransition]
///       [MationTransitionDouble]
///       [MationTransitionOffset]
///       [MationTransitionAlign]
///       [MationTransitionDecoration]
///       [MationTransitionTextStyle]
///       [MationTransitionPositioned]
///       [MationTransitionPositionedRelative]
///       ...
///     [MationClipper]
///     [MationPainter]
///   [Mations]
///     [MationTransform]
///       * [MationTransformDelegate]
///       * [_MationTransformBase]
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

///
///
///
/// See also:
///  * [Mation]
///       [_MationTransition], which implements animation of [AnimatedWidget] subclasses to used in [Mationani]
///       [MationClipper], which implements animation of [ClipPath] to used in [Mationani]
///       [MationPainter], which implements animation of [CustomPaint] to used in [Mationani]
///       [_MationTransformBase], which implements [Transform] animation to used in [Mationani]
///       ...
///  * [Mations], which trigger multiple tweens animations
///       [MationTransform]
///
///
///
sealed class MationBase<T> {
  const MationBase();

  ///
  ///
  /// if [_AnimationsBuilder] specify type [T],
  /// compiler will check if all the [AnimationBuilder] is of type [T].
  /// there will be a type cast error when [_AnimationsBuilder] fold different [AnimationBuilder]<[T]>.
  /// therefore, [AnimationBuilder] or [Animation] under [MationBase] should be defined in dynamic type.
  ///
  _AnimationsBuilder get _builder;

  ///
  /// this method only been invoked in [_AniBase._building]
  ///
  Iterable<Animation> _animationsOf(AnimationController c, Curve curve);
}

///
/// all the subclass of [Mation] only triggers only 1 animation with only 1 [Between],
/// but the [Between] also has a wide range of instance to create beautiful animation.
/// for example [Between.sequence] can sequence lots of values into an animation.
///
/// in short, it's a cheep way to create [Mation] instead of [Mations]
///
class Mation<T> extends MationBase<T> {
  ///
  /// in most of the usecase, [__builder] will be assign implicitly.
  /// When create [Mation] by the default constructor here.
  /// it's possible to have simple [Between] like [Between]<[Color]> with simple builder,
  /// for instance, setting [Material.color] inside the builder.
  ///
  final AnimationBuilder __builder;
  final Between<T> between;

  static Widget _animationBuilder(Animation animation, Widget child) => child;

  Mation(
    this.between, {
    AnimationBuilder builder = _animationBuilder,
  }) : __builder = builder;

  @override
  String toString() => 'Mation: $between';

  ///
  /// [Between.animate] already have [Between.curve]
  /// the [curve] here comes from [Ani.curve]. it's an easy way to control entire [AnimationController] flow.
  /// see also [_AniBase._building] to understand when this method been invoke.
  ///
  Animation<T> _animationOf(AnimationController c, Curve curve) =>
      between.animate(c.drive(CurveTween(curve: curve)));

  @override
  Iterable<Animation> _animationsOf(AnimationController c, Curve curve) =>
      [_animationOf(c, curve)];

  @override
  _AnimationsBuilder get _builder =>
      (animations, child) => __builder(animations.first, child);

  ///
  /// [map] and [mapBetween] let existing [Mation] be more useful
  ///
  Mation<T> map(Mapper<Mation<T>> mapper) => mapper(this);

  Mation<T> mapBetween(Mapper<Between<T>> mapper) => Mation(
        between,
        builder: __builder,
      );
}

///
///
/// See Also:
///   [MationSequenceStyle], [MationSequenceStep], [MationSequenceInterval]
///
///   [Mationani.sequence],
///     which takes [MationSequence] as required argument, and use [Ani.updateSequencingWhen].
///     it is possible to use other ani like [Ani.initForwardAndUpdateSequencingWhen].
///
///   [Between.sequence],
///     which is similar to [MationSequence].
///     [MationSequence] is an easy way to enable animations during widget creation
///     [Between.sequence] is a light way to focus on how [Animation.value] been lerp in the same [MationBase]
///
class MationSequence {
  final List<MationBase<dynamic>> mations;
  final List<Duration> durations;

  const MationSequence._(this.mations, this.durations);

  factory MationSequence({
    required int totalStep,
    required MationSequenceStyle style,
    required Generator<MationSequenceStep> step,
    required Generator<MationSequenceInterval> interval,
  }) {
    final durations = <Duration>[];
    MationSequenceInterval intervalGenerator(int index) {
      final i = interval(index);
      durations.add(i.duration);
      return i;
    }

    return MationSequence._(
      ListExtension.linking<MationBase<dynamic>, MationSequenceStep,
          MationSequenceInterval>(
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
/// it's possible to have a wide range of [MationSequenceStyle] in the future
/// 'transform' use [MationTransform]
/// 'transition' use the subclass(s) of [_MationTransition]
///
/// See Also:
///   [MationSequence], [MationSequenceStep], [MationSequenceInterval]
///
enum MationSequenceStyle {
  // TRS: Translation, Rotation, Scaling
  transformTRS,

  // rotate, slide in bezier cubic
  transitionRotateSlideBezierCubic;

  ///
  /// [_forwardOrReverse] is the only way to sequence [MationBase] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Translator<int, MationBase> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required MationSequenceStep previous,
    required MationSequenceStep next,
    required Combiner<MationSequenceStep, MationBase> combine,
  }) =>
      (i) => combine(
            predicator(i) ? previous : next,
            predicator(i) ? next : previous,
          );

  MationSequencer get sequencer => switch (this) {
        transformTRS => (previous, next, interval) {
            final curve = interval.curves[0].toCurveFR;
            return MationSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) {
                final a = begin.coordinates;
                final b = end.coordinates;
                return MationTransform.list(
                  [
                    MationTransformDelegate.translate
                      ..between = Between(begin: a[0], end: b[0], curve: curve)
                      ..alignment = Alignment.topLeft,
                    MationTransformDelegate.rotate
                      ..between = Between(begin: a[1], end: b[1], curve: curve)
                      ..alignment = Alignment.topLeft,
                    MationTransformDelegate.scale
                      ..between = Between(begin: a[2], end: b[2], curve: curve)
                      ..alignment = Alignment.topLeft,
                  ],
                );
              },
            );
          },
        transitionRotateSlideBezierCubic => (previous, next, interval) {
            final curve = interval.curves[0].toCurveFR;
            final controlPoints = interval.offsets;
            return MationSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) => Mations<dynamic, Mation<dynamic>>([
                MationTransitionDouble.rotate(
                  begin.values[0],
                  end.values[0],
                  curve: curve,
                ),
                MationTransitionOffset.from(
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

///
/// See Also:
///   [MationSequence], [MationSequenceStyle], [MationSequenceInterval]
///
class MationSequenceStep {
  final List<double> values;
  final List<Offset> offsets;
  final List<Coordinate> coordinates;

  const MationSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.coordinates = const [],
  });
}

///
/// See Also:
///   [MationSequence], [MationSequenceStyle], [MationSequenceStep]
///   [BetweenInterval], which is similar
///
class MationSequenceInterval {
  final Duration duration;
  final List<Curve> curves;
  final List<Offset> offsets; // for curving control, interval step

  const MationSequenceInterval({
    required this.duration,
    required this.curves,
    this.offsets = const [],
  });
}

///
///
///
///
///
///
///
/// [_MationTransition] a class that implement traditional transition like [SlideTransition], [FadeTransition],
/// [DecoratedBoxTransition], enable traditional animation for [Mationani]
///
///
///
///
///
///
abstract class _MationTransition<T> extends Mation<T> {
  _MationTransition(super.between, {required super.builder});

  ///
  /// these constants must be dynamic type, see the comment over [MationBase._builder]
  ///
  static Widget slide(Animation animation, Widget child) => SlideTransition(
        position: animation as Animation<Offset>,
        child: child,
      );

  static Widget decoration(Animation animation, Widget child) =>
      DecoratedBoxTransition(
        decoration: animation as Animation<Decoration>,
        child: child,
      );

  static Widget fade(Animation animation, Widget child) => FadeTransition(
        opacity: animation as Animation<double>,
        child: child,
      );

  static Widget silverFade(Animation animation, Widget child) =>
      SliverFadeTransition(
        opacity: animation as Animation<double>,
        sliver: child,
      );

  static Widget align(Animation animation, Widget child) => AlignTransition(
        alignment: animation as Animation<AlignmentGeometry>,
        child: child,
      );

  static Widget defaultTextStyle(Animation animation, Widget child) =>
      DefaultTextStyleTransition(
        style: animation as Animation<TextStyle>,
        child: child,
      );

  static Widget positioned(Animation animation, Widget child) =>
      PositionedTransition(
        rect: animation as Animation<RelativeRect>,
        child: child,
      );

  ///
  /// the builders with argument
  ///

  static AnimationBuilder rotationOf(Alignment alignment) =>
      (Animation animation, Widget child) => RotationTransition(
            turns: animation as Animation<double>,
            alignment: alignment,
            child: child,
          );

  static AnimationBuilder scaleOf(Alignment alignment) =>
      (Animation animation, Widget child) => ScaleTransition(
            scale: animation as Animation<double>,
            alignment: alignment,
            child: child,
          );

  static AnimationBuilder sizeOf(Axis? axis, double? axisAlignment) =>
      (Animation animation, Widget child) => SizeTransition(
            sizeFactor: animation as Animation<double>,
            axis: axis ?? Axis.vertical,
            axisAlignment: axisAlignment ?? 0.0,
            child: child,
          );

  static AnimationBuilder relativePositionedOf(Size size) =>
      (Animation animation, Widget child) => RelativePositionedTransition(
            rect: animation as Animation<Rect>,
            size: size,
            child: child,
          );
}

class MationTransitionDouble extends _MationTransition<double> {
  ///
  /// fade
  ///
  MationTransitionDouble.fade(double begin, double end, {CurveFR? curve})
      : super(Between(begin: begin, end: end, curve: curve),
            builder: _MationTransition.fade);

  MationTransitionDouble.fadeIn({CurveFR? curve})
      : super(BetweenDoubleExtension.zeroTo(1),
            builder: _MationTransition.fade);

  MationTransitionDouble.fadeOut({CurveFR? curve})
      : super(BetweenDoubleExtension.oneTo(0), builder: _MationTransition.fade);

  factory MationTransitionDouble.fadeWithValue(
    double value, {
    required Mapper<double> begin,
    required Mapper<double> end,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.fade(begin(value), end(value), curve: curve);

  ///
  /// silver fade
  ///
  MationTransitionDouble.silverFade(double begin, double end, {CurveFR? curve})
      : super(Between(begin: begin, end: end, curve: curve),
            builder: _MationTransition.silverFade);

  MationTransitionDouble.silverFadeIn({CurveFR? curve})
      : super(BetweenDoubleExtension.zeroTo(1),
            builder: _MationTransition.silverFade);

  MationTransitionDouble.silverFadeOut({CurveFR? curve})
      : super(BetweenDoubleExtension.oneTo(0),
            builder: _MationTransition.silverFade);

  ///
  /// scale
  ///
  MationTransitionDouble.scale(
    double begin,
    double end, {
    Alignment alignment = Alignment.topLeft,
    CurveFR? curve,
  }) : super(
          Between(begin: begin, end: end, curve: curve),
          builder: _MationTransition.scaleOf(alignment),
        );

  factory MationTransitionDouble.scaleOneTo(
    double end, {
    Alignment alignment = Alignment.topLeft,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.scale(1, end, alignment: alignment, curve: curve);

  factory MationTransitionDouble.scaleOneFrom(
    double begin, {
    Alignment alignment = Alignment.topLeft,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.scale(begin, 1,
          alignment: alignment, curve: curve);

  factory MationTransitionDouble.scaleOneBeginOrEnd(
    double another, {
    required bool isEndOne,
    Alignment alignment = Alignment.topLeft,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.scale(
        isEndOne ? another : 1,
        isEndOne ? 1 : another,
        alignment: alignment,
        curve: curve,
      );

  factory MationTransitionDouble.scaleWithValue(
    double value, {
    required Mapper<double> begin,
    required Mapper<double> end,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.scale(begin(value), end(value), curve: curve);

  ///
  /// rotate
  ///
  MationTransitionDouble.rotated(
    double value, {
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) : super(
          Between(
            begin: value / KRadian.angle_360,
            end: value / KRadian.angle_360,
            curve: curve,
          ),
          builder: _MationTransition.rotationOf(alignment),
        );

  MationTransitionDouble.rotate(
    double begin,
    double end, {
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) : super(
          Between(
            begin: begin / KRadian.angle_360,
            end: end / KRadian.angle_360,
            curve: curve,
          ),
          builder: _MationTransition.rotationOf(alignment),
        );

  factory MationTransitionDouble.rotateZeroTo(
    double end, {
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.rotate(0, end, alignment: alignment, curve: curve);

  factory MationTransitionDouble.rotateZeroFrom(
    double begin, {
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.rotate(
        begin,
        0,
        alignment: alignment,
        curve: curve,
      );

  factory MationTransitionDouble.rotateZeroFromOrTo(
    double another, {
    required bool isEndZero,
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.rotate(
        isEndZero ? another : 0,
        isEndZero ? 0 : another,
        alignment: alignment,
        curve: curve,
      );

  ///
  /// size
  ///
  MationTransitionDouble.size({
    required double begin,
    required double end,
    Axis? axis,
    double? axisAlignment,
  }) : super(
          Between(begin: begin, end: end),
          builder: _MationTransition.sizeOf(axis, axisAlignment),
        );
}

class MationTransitionOffset extends _MationTransition<Offset> {
  MationTransitionOffset(Offset begin, Offset end, {CurveFR? curve})
      : super(
          Between(begin: begin, end: end, curve: curve),
          builder: _MationTransition.slide,
        );

  MationTransitionOffset.at(Offset p)
      : super(Between.constant(p), builder: _MationTransition.slide);

  MationTransitionOffset.from(super.between)
      : super(builder: _MationTransition.slide);

  MationTransitionOffset.zeroTo(Offset end, {CurveFR? curve})
      : super(
          BetweenOffsetExtension.zeroTo(end, curve: curve),
          builder: _MationTransition.slide,
        );

  MationTransitionOffset.zeroFrom(Offset begin, {CurveFR? curve})
      : super(
          BetweenOffsetExtension.zeroFrom(begin, curve: curve),
          builder: _MationTransition.slide,
        );

  MationTransitionOffset.ofDirection(
    double direction,
    double begin,
    double end, {
    CurveFR? curve,
  }) : super(
          Between(
            begin: Offset.fromDirection(direction, begin),
            end: Offset.fromDirection(direction, end),
            curve: curve,
          ),
          builder: _MationTransition.slide,
        );

  MationTransitionOffset.ofDistance(
    double distance,
    Between<double> direction, {
    Offset origin = Offset.zero,
    CurveFR? curve,
  }) : super(
          BetweenSpline2D(
            onLerp: FOnLerpSpline2D.arcCircle(origin, distance, direction),
            curve: curve,
          ),
          builder: _MationTransition.slide,
        );
}

class MationTransitionAlign extends _MationTransition<AlignmentGeometry> {
  MationTransitionAlign({
    required AlignmentGeometry begin,
    required AlignmentGeometry end,
    CurveFR? curve,
  }) : super(
          Between(begin: begin, end: end, curve: curve),
          builder: _MationTransition.align,
        );
}

///
///
/// See Also:
///   * [_FOnLerp._decoration] to know the practice for creation
///   * [_FOnLerp._shapeBorder] to know the practice for creation, not all [ShapeDecoration.shape] are interpolatable.
///   * [BoxDecoration.lerp], [ShapeDecoration.lerp] to find the right decoration that can be interpolated.
///   * [KBoxDecoration]
///
class MationTransitionDecoration extends _MationTransition<Decoration> {
  MationTransitionDecoration({
    required Decoration begin,
    required Decoration end,
    CurveFR? curve,
  }) : super(
          Between(begin: begin, end: end, curve: curve),
          builder: _MationTransition.decoration,
        );
}

class MationTransitionTextStyle extends _MationTransition<DefaultTextStyle> {
  MationTransitionTextStyle({
    required DefaultTextStyle begin,
    required DefaultTextStyle end,
  }) : super(
          Between(begin: begin, end: end),
          builder: _MationTransition.defaultTextStyle,
        );
}

class MationTransitionPositioned extends _MationTransition<Rect> {
  MationTransitionPositioned({
    required Size size,
    required Rect begin,
    required Rect end,
  }) : super(
          Between(begin: begin, end: end),
          builder: _MationTransition.relativePositionedOf(size),
        );
}

class MationTransitionPositionedRelative extends _MationTransition<RelativeRect> {
  MationTransitionPositionedRelative({
    required RelativeRect begin,
    required RelativeRect end,
  }) : super(
          Between(begin: begin, end: end),
          builder: _MationTransition.positioned,
        );
}

///
///
///
/// clipper, painter
///
///
///

class MationClipper extends Mation<SizingPath> {
  final Clip behavior;

  MationClipper(
    BetweenPath super.between, {
    this.behavior = Clip.antiAlias,
  });

  @override
  AnimationBuilder get __builder => (animation, child) => ClipPath(
        clipper: Clipping.reclipWhenUpdate(animation.value),
        clipBehavior: behavior,
        child: child,
      );
}

///
///
/// [MationPainter.drawPathWithPaint]
/// [MationPainter.progressingCircles]
///
///
class MationPainter extends Mation<SizingPath> {
  final bool isComplex;
  final bool willChange;
  final CustomPainter? foreground;
  final Size size;
  final PaintingPath paintingPath;
  final SizingPaintFromCanvas sizingPaintingFromCanvas;

  MationPainter.drawPathWithPaint(
    BetweenPath super.between, {
    this.sizingPaintingFromCanvas = FSizingPaintFromCanvas.redFill,
  })  : isComplex = false,
        willChange = true,
        size = Size.zero,
        foreground = null,
        paintingPath = Painting.draw;

  factory MationPainter.progressingCircles({
    double initialCircleRadius = 5.0,
    double circleRadiusFactor = 0.1,
    required Ani setting,
    required Paint paint,
    required Tween<double> radiusOrbit,
    required int circleCount,
    required Companion<Vector3D, int> planetGenerator,
  }) =>
      MationPainter.drawPathWithPaint(
        sizingPaintingFromCanvas: (_, __) => paint,
        BetweenPath(
          Between<Vector3D>(
            begin: Vector3D(Coordinate.zero, radiusOrbit.begin!),
            end: Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end!),
          ),
          onAnimate: (t, vector) => PathOperation.union._combineAll(
            Iterable.generate(
              circleCount,
              (i) => (size) => Path()
                ..addOval(
                  Rect.fromCircle(
                    center: planetGenerator(vector, i).toCoordinate,
                    radius: initialCircleRadius * (i + 1) * circleRadiusFactor,
                  ),
                ),
            ),
          ),
        ),
      );

  @override
  AnimationBuilder get __builder => (animation, child) => CustomPaint(
        painter: Painting.rePaintWhenUpdate(
          sizingPaintFromCanvas: sizingPaintingFromCanvas,
          sizingPath: animation.value,
          paintingPath: paintingPath,
        ),
        foregroundPainter: foreground,
        size: size,
        isComplex: isComplex,
        willChange: willChange,
        child: child,
      );

  MationPainter._(
    super.between, {
    required this.isComplex,
    required this.willChange,
    required this.foreground,
    required this.size,
    required this.paintingPath,
    required this.sizingPaintingFromCanvas,
  });

  @override
  MationPainter mapBetween(Mapper<Between<SizingPath>> mapper) =>
      MationPainter._(
        between,
        isComplex: isComplex,
        willChange: willChange,
        foreground: foreground,
        size: size,
        paintingPath: paintingPath,
        sizingPaintingFromCanvas: sizingPaintingFromCanvas,
      );
}

///
///
///
/// mations
///
///
///

class Mations<T, M extends Mation<T>> extends MationBase<T> {
  final List<M> _list;

  Mations(this._list);

  @override
  String toString() => 'Mations: $_list';

  @override
  Iterable<Animation> _animationsOf(AnimationController c, Curve curve) =>
      _list.map((mation) => mation._animationOf(c, curve));

  @override
  _AnimationsBuilder get _builder {
    final builders = _list.map((m) => m.__builder).toList(growable: false);
    return (animations, child) => animations.foldWithIndex(
          child,
          (child, animation, i) => builders[i](animation, child),
        );
  }

  int get length => _list.length;

  void add(M element) => _list.add(element);

  void addAll(Iterable<M> elements) => _list.addAll(elements);

  void insert(int index, M element) => _list.insert(index, element);

  void insertAll(int index, Iterable<M> elements) =>
      _list.insertAll(index, elements);
}

///
///
///
/// mation transform
///
///
///
///

class MationTransform extends Mations<Coordinate, _MationTransformBase> {
  final double? distanceToObserver;

  Matrix4 get host => Matrix4.identity()..setDistance(distanceToObserver);

  MationTransform({
    Between<Coordinate>? translateBetween,
    Between<Coordinate>? rotateBetween,
    Between<Coordinate>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    this.distanceToObserver,
  }) : super([
          if (translateBetween != null)
            _MationTransformBase._translate(
              translateBetween,
              alignment: translateAlignment,
            ),
          if (rotateBetween != null)
            _MationTransformBase._rotate(
              rotateBetween,
              alignment: rotateAlignment,
            ),
          if (scaleBetween != null)
            _MationTransformBase._scale(
              scaleBetween,
              alignment: scaleAlignment,
            ),
        ]);

  MationTransform.list(
    List<MationTransformDelegate> delegates, {
    this.distanceToObserver,
  }) : super(delegates.foldWithIndex(
          [],
          (list, delegate, i) => list
            ..add(_MationTransformBase(
              delegate.between,
              onAnimate: delegate._onAnimate,
              alignment: delegate.alignment,
            )),
        ));

  // TODO: sort in order of translate -> rotate -> scale
  // MationTransform.listInOrder();

  @override
  List<_MationTransformBase> get _list =>
      super._list.map((mation) => mation..link(host)).toList(growable: false);
}

class MationTransformDelegate {
  final int type;
  Between<Coordinate> between;
  AlignmentGeometry? alignment;

  MationTransformDelegate._(this.type, this.between);

  static final MationTransformDelegate translate = MationTransformDelegate._(
    0,
    Between(begin: Coordinate.zero, end: Coordinate.zero),
  );
  static final MationTransformDelegate rotate = MationTransformDelegate._(
    1,
    Between(begin: Coordinate.zero, end: Coordinate.zero),
  );
  static final MationTransformDelegate scale = MationTransformDelegate._(
    2,
    Between(begin: KCoordinate.cube_1, end: KCoordinate.cube_1),
  );

  OnAnimateMatrix4 get _onAnimate => switch (type) {
        0 => _FOnAnimateMatrix4._translating,
        1 => _FOnAnimateMatrix4._rotating,
        2 => _FOnAnimateMatrix4._scaling,
        _ => throw UnimplementedError(),
      };
}

///
///
/// The radian discussion here, follows these rules:
/// - "positive radian" is counterclockwise, going through 0 ~ 2π.
/// - [Direction3DIn6] is user perspective. ([Direction3DIn6.back] is user side, [Direction3DIn6.front] is screen side)
///
/// For example,
/// [Offset.fromDirection] radian 0 ~ 2π going through:
/// [Direction3DIn6.right], [Direction3DIn6.bottom], [Direction3DIn6.left], [Direction3DIn6.top], [Direction3DIn6.right] in sequence;
/// its axis is [Direction3DIn6.front] -> [Direction3DIn6.back] not [Direction3DIn6.back] -> [Direction3DIn6.front],
/// because it is not counterclockwise in user perspective ([Direction3DIn6.back] -> [Direction3DIn6.front]).
/// only if viewing the screen face from [Direction3DIn6.front] to [Direction3DIn6.back],
/// the rotation 0 ~ 2π will be counterclockwise; therefore,
/// the axis of [Offset.fromDirection] is [Direction3DIn6.front] -> [Direction3DIn6.back],
/// the [Direction3DIn6] below based on the concept above.
///
///
/// the coordinate of [_MationTransformBase] is based on dart coordinate system of rotation:
/// x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], same with [Offset.fromDirection]),
///
/// and of translation:
/// x is negative from [Direction3DIn6.left] to positive [Direction3DIn6.right]
/// y is negative from [Direction3DIn6.top] to positive [Direction3DIn6.bottom]
/// z is negative from [Direction3DIn6.front] to positive [Direction3DIn6.back]
///
/// See Also:
///   * [MationTransform]
///   * [KDirection], [KCoordinateDirection]
///   * [Coordinate.transferToTransformOf], [Coordinate.fromDirection]
///
///
class _MationTransformBase extends Mation<Coordinate> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  AnimationBuilder _transform(OnAnimateMatrix4 animate) =>
      ((animation, child) => Transform(
            transform: animate(host, animation.value),
            alignment: alignment,
            child: child,
          ));

  @override
  AnimationBuilder get __builder => _transform(onAnimate);

  _MationTransformBase(
    super.between, {
    Matrix4? host,
    this.alignment,
    required this.onAnimate,
  }) : host = host ?? Matrix4.identity();

  /// instead of using scale, translate, rotate here, using [_MationTransition], prevent ambiguous dependency for api
  _MationTransformBase._scale(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = MationTransformDelegate.scale._onAnimate;

  _MationTransformBase._translate(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = MationTransformDelegate.translate._onAnimate;

  _MationTransformBase._rotate(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = MationTransformDelegate.rotate._onAnimate;

  @override
  _MationTransformBase mapBetween(Mapper<Between<Coordinate>> mapper) =>
      _MationTransformBase(
        mapper(between),
        host: host,
        alignment: alignment,
        onAnimate: onAnimate,
      );

  @override
  _MationTransformBase map(Mapper<Mation<Coordinate>> mapper) =>
      super.map(mapper) as _MationTransformBase;

  void link(Matrix4 host) => this..host = host;
}
