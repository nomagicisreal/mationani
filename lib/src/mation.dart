///
///
/// this file contains:
/// [Mation]
/// [Mationable]
///   * [_MationableSingle]
///     * [_MationableSingleChildSingle]
///     * [_MationableSingleChildMulti]
///   * [_MationableMulti]
///     * [_MationableMultiChildSingle]
///     * [_MationableMultiChildMulti]
///   [MationSingle]
///     * [MationSequenceStep]
///     * [MationSequenceInterval]
///     * [MationSequenceStyle]
///     * [MationSequence]
///     [MationTransition]
///     [MationClipper]
///     [MationPainter]
///   * [MationTransformDelegate]
///   [MationMulti]
///     [MationTransform]
///   [MationStack]
///     [MationStackSibling]
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
///  * [MationSingle]
///       [MationTransition], which implements animation of [AnimatedWidget] subclasses to used in [Mationani]
///       [MationClipper], which implements animation of [ClipPath] to used in [Mationani]
///       [MationPainter], which implements animation of [CustomPaint] to used in [Mationani]
///  * [MationTransformDelegate], which implements [Transform] animation to used in [Mationani]
///       ...
///  * [MationMulti], which trigger multiple tweens animations
///       [MationTransform], which is the combinations of [MationTransformDelegate]
///
///

///
///
///
/// [Mation] and [Mationable]
///
///
///

///
/// all the class implement it must overwrite [Mation._plan] that will be used in [_AniBase._plan],
/// which enable the class instance can be passed to [Mationani.mation].
///
/// Notice that there are some class that better not to pass as [Mationani.mation],
/// it's the reason why these classes are not implements [Mation],
/// [_MationableSingle], [_MationableMulti],
/// [_MationableSingleChildSingle], [_MationableSingleChildMulti]
/// [_MationableMultiChildSingle],[_MationableMultiChildMulti]
/// In the future, providing that there is a mation class that developer want to treated as [Mationani.mation].
/// it's should implement [Mation] directly.
///
abstract interface class Mation {
  WidgetBuilder _plan(Animation<double> animation, WidgetBuilder builder);
}

///
/// there are only two subclass directly extend it, [_MationableSingle], [_MationableMulti].
/// they provide [_animate] and [_builder] to have animation practice,
/// and those practice can be used in implementation of [Mation._plan]
///
sealed class Mationable {
  const Mationable();

  // ignore: unused_element
  Object _animate(Animation<double> animation);

  // ignore: unused_element
  Object get _builder;
}

///
///
///
/// [_MationableSingle],
/// [_MationableSingleChildSingle] and [_MationableSingleChildMulti]
///
///
///

///
/// To prevent type check on every animation in most of the case,
/// [_animate] return type and [_builder] should be in dynamic. ([T] should keep in dynamic when inherited)
///
abstract class _MationableSingle<T> extends Mationable {
  final Between<T> between;

  const _MationableSingle(this.between, this._builder);

  @override
  Animation<T> _animate(Animation<double> animation) =>
      between.animate(animation);

  @override
  final AnimationBuilder<T> _builder;
}

///
///
abstract class _MationableSingleChildSingle extends _MationableSingle {
  const _MationableSingleChildSingle(super.between, super._builder);
}

///
///
abstract class _MationableSingleChildMulti extends _MationableSingle {
  const _MationableSingleChildMulti(super.between, super._builder);
}

///
///
/// [_MationableMulti],
/// [_MationableMultiChildSingle] and [_MationableMultiChildMulti]
///
///

///
/// [_MationableMulti] is based on [_MationableSingle].
/// thee outer [Iterable] of [_animate] and [_builder] are defined to have consistency with [_iterable].
///
abstract class _MationableMulti<M extends Mationable> extends Mationable {
  final Iterable<M> _iterable;

  const _MationableMulti(this._iterable);

  ///
  /// [_animate]
  /// [_builder]
  ///
  @override
  Iterable<Iterable<Animation>> _animate(Animation<double> animation) =>
      _iterable.map(_animating((mation) => mation._animate(animation)));

  @override
  Iterable<Iterable<AnimationBuilder>> get _builder => _iterable.map(_building);

  ///
  /// [_animating]
  /// [_building]
  ///
  static _MationAnimating _animating(
    Translator<_MationableSingle, Animation> animate,
  ) =>
      (mation) => switch (mation) {
            _MationableSingle() => [animate(mation)],
            _MationableMulti<Mationable>() =>
              mation._iterable.map(_animating(animate)).flat(),
          };

  static Iterable<AnimationBuilder> _building(Mationable mation) =>
      switch (mation) {
        _MationableSingle() => [mation._builder],
        _MationableMulti<Mationable>() => mation._builder.flat(),
      };

  ///
  /// [_isFlat]
  /// [lengthFlatted]
  ///
  bool get _isFlat => _iterable.every((m) => m is _MationableSingle);

  static int lengthFlatted(Mationable mation) => switch (mation) {
        _MationableSingle() => 1,
        _MationableMulti<Mationable>() => mation._iterable.reduceToNum(
            reducer: FReducerNum.intAdding,
            translator: lengthFlatted,
          ),
      };
}

///
///
abstract class _MationableMultiChildSingle<M extends Mationable>
    extends _MationableMulti<M> {
  const _MationableMultiChildSingle(super._iterable);
}

///
///
abstract class _MationableMultiChildMulti<M extends Mationable>
    extends _MationableMulti<M> {
  final M? m;
  final bool isMFirst;
  final WidgetChildrenBuilder parent;
  final List<WidgetBuilder> children;

  _MationableMultiChildMulti({
    required this.parent,
    required Iterable<M> mations,
    required this.children,
    this.m,
    this.isMFirst = true,
  })  : assert(
          mations.length == children.length,
          '(mations length, builders length) should be the same'
          'current: (${mations.length}, ${children.length})',
        ),
        super(mations);

  ///
  /// [_animate]
  /// [_builder]
  /// [_childrenOf]
  ///
  @override
  List<Iterable<Animation>> _animate(Animation<double> animation) {
    final animationM = m.translateOr<Iterable<Animation>>(
      (v) => _MationableMulti._animating((m) => m._animate(animation))(v),
      ifAbsent: () => [],
    );
    final animations = super._animate(animation);
    return isMFirst ? [animationM, ...animations] : [...animations, animationM];
  }

  @override
  List<Iterable<AnimationBuilder>> get _builder {
    final builderM = m.translateOr<Iterable<AnimationBuilder>>(
      (v) => _MationableMulti._building(v),
      ifAbsent: () => [],
    );
    final builders = super._builder;
    return isMFirst ? [builderM, ...builders] : [...builders, builderM];
  }

  WidgetListBuilder _childrenOf(WidgetBuilder builder) {
    final children = this.children;
    return isMFirst
        ? (_) => [builder(_), ...children.map((build) => build(_))]
        : (_) => [...children.map((build) => build(_)), builder(_)];
  }
}

///
///
///
/// [MationSingle]
///
/// all the subclass of [MationSingle] only triggers only 1 animation with only 1 [Between],
/// but the [Between] also has a wide range of instance to create beautiful animation.
/// for example [Between.sequence] can sequence lots of values into an animation.
///
///
///

///
/// [_nothing], [toString], [_plan]
///
class MationSingle<T> extends _MationableSingleChildSingle implements Mation {
  static Widget _nothing(Animation animation, Widget child) => child;

  const MationSingle(Between<T> between, [AnimationBuilder? builder])
      : super(between, builder ?? _nothing);

  @override
  String toString() => 'Mation: $between';

  @override
  WidgetBuilder _plan(Animation<double> animation, WidgetBuilder builder) {
    final build = _builder;
    return (context) => build(animation, builder(context));
  }
}

///
///
///
/// [MationSequenceStep]
/// [MationSequenceInterval]
/// [MationSequenceStyle]
/// [MationSequence]
///
///
///

///
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
enum MationSequenceStyle {
  // TRS: Translation, Rotation, Scaling
  transformTRS,

  // rotate, slide in bezier cubic
  transitionRotateSlideBezierCubic;

  ///
  /// [_forwardOrReverse] is the only way to sequence [Mation] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Translator<int, Mation> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required MationSequenceStep previous,
    required MationSequenceStep next,
    required Combiner<MationSequenceStep, Mation> combine,
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
                    MationTransformDelegate.translation(
                      Between(a[0], b[0], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MationTransformDelegate.rotation(
                      Between(a[1], b[1], curve: curve),
                      alignment: Alignment.topLeft,
                    ),
                    MationTransformDelegate.scale(
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
            return MationSequenceStyle._sequence(
              previous: previous,
              next: next,
              combine: (begin, end) => MationMulti<MationSingle>([
                // MationTransitionDouble.rotate(
                MationTransition.rotate(Between(
                  begin.values[0],
                  end.values[0],
                  curve: curve,
                )),
                MationTransition.slide(
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
/// See Also
///   * [Mationani.sequence],
///     which takes [MationSequence] as required argument, and use [Ani.updateSequencingWhen].
///     it is possible to use other ani like [Ani.initForwardAndUpdateSequencingWhen].
///
///   * [Between.sequence],
///     while [MationSequence] is an easy way to have animation during widget creation
///     [Between.sequence] focus more on how [Animation.value] or other generic animation.value been lerp.
///
class MationSequence {
  final List<Mation> mations;
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
      ListExtension.linking<Mation, MationSequenceStep, MationSequenceInterval>(
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
///
/// [MationTransition]
///
/// this is a class that implement traditional transition like [SlideTransition],
/// [FadeTransition], [DecoratedBoxTransition]..., transcribe those traditional animation into [Mationani]
///
///
///

///
/// [MationTransition.rotate], [MationTransition.scale], [MationTransition.size], ...
/// [MationTransition.relativePositioned], ...
/// [MationTransition.positioned], ..., [MationTransition.slide], ...
/// [MationTransition.decoration], ...
/// [MationTransition.fade], ..., [MationTransition.silverFade], ...
/// [MationTransition.align], ...
/// [MationTransition.defaultTextStyle], ...
///
class MationTransition extends MationSingle {
  MationTransition.rotate(
    Between<double> between, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          between,
          (animation, child) => RotationTransition(
            turns: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MationTransition.scale(
    Between<double> between, {
    Alignment alignment = Alignment.topLeft,
  }) : super(
          between,
          (animation, child) => ScaleTransition(
            scale: animation as Animation<double>,
            alignment: alignment,
            child: child,
          ),
        );

  MationTransition.size(
    Between<double> between, {
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
  }) : super(
          between,
          (animation, child) => SizeTransition(
            sizeFactor: animation as Animation<double>,
            axis: axis,
            axisAlignment: axisAlignment,
            child: child,
          ),
        );

  MationTransition.relativePositioned(
    Between<double> between, {
    required Size size,
  }) : super(
          between,
          (animation, child) => RelativePositionedTransition(
            rect: animation as Animation<Rect>,
            size: size,
            child: child,
          ),
        );

  ///
  ///
  ///
  MationTransition.positioned(Between<RelativeRect> between)
      : super(
          between,
          (animation, child) => PositionedTransition(
            rect: animation as Animation<RelativeRect>,
            child: child,
          ),
        );

  MationTransition.slide(Between<Offset> between)
      : super(
          between,
          (animation, child) => SlideTransition(
            position: animation as Animation<Offset>,
            child: child,
          ),
        );

  MationTransition.decoration(Between<Decoration> between)
      : super(
          between,
          (animation, child) => DecoratedBoxTransition(
            decoration: animation as Animation<Decoration>,
            child: child,
          ),
        );

  MationTransition.fade(Between<double> between)
      : super(
          between,
          (animation, child) => FadeTransition(
            opacity: animation as Animation<double>,
            child: child,
          ),
        );

  MationTransition.fadeIn({CurveFR? curve})
      : this.fade(FBetween.doubleZeroTo(1, curve: curve));

  MationTransition.fadeOut({CurveFR? curve})
      : this.fade(FBetween.doubleZeroFrom(1, curve: curve));

  MationTransition.silverFade(Between<double> between)
      : super(
          between,
          (animation, child) => SliverFadeTransition(
            opacity: animation as Animation<double>,
            sliver: child,
          ),
        );

  MationTransition.align(Between<AlignmentGeometry> between)
      : super(
          between,
          (animation, child) => AlignTransition(
            alignment: animation as Animation<AlignmentGeometry>,
            child: child,
          ),
        );

  MationTransition.defaultTextStyle(Between<TextStyle> between)
      : super(
          between,
          (animation, child) => DefaultTextStyleTransition(
            style: animation as Animation<TextStyle>,
            child: child,
          ),
        );
}

///
///
///
/// [MationClipper] and [MationPainter]
///
///
///

///
/// [behavior], [_builder]
///
class MationClipper extends MationSingle<SizingPath> {
  final Clip behavior;

  @override
  AnimationBuilder get _builder => (animation, child) => ClipPath(
        clipper: Clipping.reclipWhenUpdate(animation.value),
        clipBehavior: behavior,
        child: child,
      );

  const MationClipper(
    BetweenPath super.between, {
    this.behavior = Clip.antiAlias,
  });
}

///
/// [isComplex], [foreground], [size], [painter], [_builder]
/// [MationPainter.paintFrom]
/// [MationPainter.progressingCircles]
///
class MationPainter extends MationSingle<SizingPath> {
  final bool isComplex;
  final CustomPainter? foreground;
  final Size size;
  final Painter painter;

  @override
  AnimationBuilder get _builder => (animation, child) => CustomPaint(
        willChange: true,
        painter: painter(animation.value),
        foregroundPainter: foreground,
        size: size,
        isComplex: isComplex,
        child: child,
      );

  const MationPainter(
    super.between, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.foreground,
    required this.painter,
  });

  MationPainter.paintFrom(
    BetweenPath super.between, {
    PaintFrom paintFrom = FPaintFrom.redFill,
  })  : isComplex = false,
        size = Size.zero,
        foreground = null,
        painter = FPainter.of(paintFrom);

  MationPainter.progressingCircles({
    double initialCircleRadius = 5.0,
    double circleRadiusFactor = 0.1,
    required Ani setting,
    required Paint paint,
    required Tween<double> radiusOrbit,
    required int circleCount,
    required Companion<Vector3D, int> planetGenerator,
  }) : this.paintFrom(
          paintFrom: (_, __) => paint,
          BetweenPath(
            Between<Vector3D>(
              Vector3D(Coordinate.zero, radiusOrbit.begin!),
              Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end!),
            ),
            onAnimate: (t, vector) => FSizingPath.combineAll(
              Iterable.generate(
                circleCount,
                (i) => (size) => Path()
                  ..addOval(
                    Rect.fromCircle(
                      center: planetGenerator(vector, i).toCoordinate,
                      radius:
                          initialCircleRadius * (i + 1) * circleRadiusFactor,
                    ),
                  ),
              ),
            ),
          ),
        );
}

///
///
///
/// [MationTransformDelegate]
///
/// [MationTransformDelegate] coordinate is based on [Transform] direction, translation (negative to positive).
/// direction: x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// direction: y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// direction: z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], [Offset.direction]),
/// translation: x axis comes from [Direction3DIn6.left] to [Direction3DIn6.right]
/// translation: y axis comes from [Direction3DIn6.top] to [Direction3DIn6.bottom]
/// translation: z axis comes from [Direction3DIn6.front] to [Direction3DIn6.back]
///
/// See Also:
///   * [Direction], [Direction3DIn6]
///   * [Coordinate.transferToTransformOf], [Coordinate.fromDirection]
///   * [MationTransform]
///
///
///

///
/// [onAnimate], [alignment], [host], [_builder]
/// [onTranslating], [onRotating], [onScaling]
/// [MationTransformDelegate._]
/// [MationTransformDelegate.translation]
/// [MationTransformDelegate.rotation]
/// [MationTransformDelegate.scale]
///
/// [link]
/// [isSameTypeWith]
/// [align]
///
class MationTransformDelegate extends _MationableSingle<Coordinate> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  @override
  AnimationBuilder get _builder {
    final onAnimate = this.onAnimate;
    final host = this.host;
    final alignment = this.alignment;

    return (animation, child) => Transform(
          transform: onAnimate(host, animation.value),
          alignment: alignment,
          child: child,
        );
  }

  static const OnAnimateMatrix4 onTranslating = FOnAnimateMatrix4.translating;
  static const OnAnimateMatrix4 onRotating = FOnAnimateMatrix4.rotating;
  static const OnAnimateMatrix4 onScaling = FOnAnimateMatrix4.scaling;

  MationTransformDelegate._(
    Between<Coordinate> between, {
    required this.alignment,
    required this.host,
    required this.onAnimate,
  }) : super(
          between,
          (animation, child) => Transform(
            transform: onAnimate(host, animation.value),
            alignment: alignment,
            child: child,
          ),
        );

  MationTransformDelegate.translation(
    Between<Coordinate> between, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          between,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.translating,
        );

  MationTransformDelegate.rotation(
    Between<Coordinate> between, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          between,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.rotating,
        );

  MationTransformDelegate.scale(
    Between<Coordinate> between, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          between,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: FOnAnimateMatrix4.scaling,
        );

  ///
  /// instance methods
  ///
  void link(Matrix4 host) => this.host = host;

  bool isSameTypeWith(MationTransformDelegate another) =>
      onAnimate == another.onAnimate;

  MationTransformDelegate align(AlignmentGeometry? alignment) =>
      MationTransformDelegate._(
        between,
        onAnimate: onAnimate,
        alignment: alignment,
        host: host,
      );
}

///
///
///
/// [MationMulti]
///
///
///

///
/// [toString], [_plan]
///
class MationMulti<M extends Mationable> extends _MationableMultiChildSingle<M>
    implements Mation {
  MationMulti(super._iterable);

  @override
  String toString() => 'Mations: ${_iterable.fold(
        '',
        (value, element) => '$value \n|-${_isFlat ? '-' : ''}$element',
      )}';

  @override
  WidgetBuilder _plan(Animation<double> animation, WidgetBuilder builder) {
    final builders2D = _builder;
    final animations2D = _animate(animation);
    return (context) => builders2D.foldWith2D<Widget, Animation>(
          animations2D,
          builder(context),
          (child, build, animation) => build(animation, child),
        );
  }
}

///
///
///
/// [MationTransform]
///
///
///

///
/// [MationTransform.distanced]
/// [MationTransform.list], [MationTransform.listInOrder]
///
class MationTransform extends MationMulti<MationTransformDelegate> {
  MationTransform({
    Between<Coordinate>? translateBetween,
    Between<Coordinate>? rotateBetween,
    Between<Coordinate>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    Matrix4? host,
  }) : super([
          if (translateBetween != null)
            MationTransformDelegate.translation(
              translateBetween,
              alignment: translateAlignment,
              host: host,
            ),
          if (rotateBetween != null)
            MationTransformDelegate.rotation(
              rotateBetween,
              alignment: rotateAlignment,
              host: host,
            ),
          if (scaleBetween != null)
            MationTransformDelegate.scale(
              scaleBetween,
              alignment: scaleAlignment,
              host: host,
            ),
        ]);

  MationTransform.distanced({
    required double distanceToObserver,
    Between<Coordinate>? translateBetween,
    Between<Coordinate>? rotateBetween,
    Between<Coordinate>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    Matrix4? host,
  }) : this(
          host: (host ?? Matrix4.identity())..setDistance(distanceToObserver),
          translateBetween: translateBetween,
          rotateBetween: rotateBetween,
          scaleBetween: scaleBetween,
          translateAlignment: translateAlignment,
          rotateAlignment: rotateAlignment,
          scaleAlignment: scaleAlignment,
        );

  MationTransform.list(
    Iterable<MationTransformDelegate> delegates, {
    Matrix4? host,
  }) : super(delegates.fold<List<MationTransformDelegate>>(
          [],
          (list, base) => list
            ..add(MationTransformDelegate._(
              base.between,
              onAnimate: base.onAnimate,
              alignment: base.alignment,
              host: host ?? Matrix4.identity(),
            )),
        ));

  MationTransform.listInOrder(
    Iterable<MationTransformDelegate> delegates, {
    List<OnAnimateMatrix4> order = orderTRS,
    Matrix4? host,
  }) : this.list(delegates.sort(order), host: host);

  MationTransform alignAll({
    AlignmentGeometry? translation,
    AlignmentGeometry? rotation,
    AlignmentGeometry? scaling,
  }) =>
      MationTransform.list(_iterable.map((base) {
        final before = base.alignment;
        final onAnimate = base.onAnimate;
        return base.align(switch (onAnimate) {
          FOnAnimateMatrix4.translating => translation ?? before,
          FOnAnimateMatrix4.rotating => rotation ?? before,
          FOnAnimateMatrix4.scaling => scaling ?? before,
          _ => throw UnimplementedError(),
        });
      }));

  static const List<OnAnimateMatrix4> orderTRS = [
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.scaling,
  ];

  static const List<OnAnimateMatrix4> orderTSR = [
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.rotating,
  ];

  static const List<OnAnimateMatrix4> orderSTR = [
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.rotating,
  ];

  static const List<OnAnimateMatrix4> orderSRT = [
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.translating,
  ];

  static const List<OnAnimateMatrix4> orderRTS = [
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.translating,
    FOnAnimateMatrix4.scaling,
  ];

  static const List<OnAnimateMatrix4> orderRST = [
    FOnAnimateMatrix4.rotating,
    FOnAnimateMatrix4.scaling,
    FOnAnimateMatrix4.translating,
  ];
}

///
///
/// [MationStack] and [MationStackSibling]
///
///

///
///
class MationStack<M extends Mationable> extends _MationableMultiChildMulti<M>
    implements Mation {
  MationStack({
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    required super.mations,
    required List<Widget> children,
    super.m,
    super.isMFirst,
  }) : super(
          parent: (context, children) => Stack(
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            clipBehavior: clipBehavior,
            children: children,
          ),
          children: WWidgetBuilder.ofList(children),
        );

  ///
  /// see also [MationMulti._plan]
  ///
  @override
  WidgetBuilder _plan(Animation<double> animation, WidgetBuilder builder) {
    final builders2D = _builder;
    final animations2D = _animate(animation);
    final build = _childrenOf(builder);

    return (context) => parent(
          context,
          build(context).foldWithIndex(
            [],
            (i, list, child) => list
              ..add(builders2D[i].foldWith(
                animations2D[i],
                child,
                (child, build, animation) => build(animation, child),
              )),
          ),
        );
  }
}

///
///
class MationStackSibling<M extends Mationable> extends MationStack<M>
    implements Mation {
  MationStackSibling({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    required M mation,
    required M mationSibling,
    required Widget sibling,
    bool isSiblingFirst = false,
  }) : super(
          mations: [mationSibling],
          children: [sibling],
          m: mation,
          isMFirst: !isSiblingFirst,
        );
}
