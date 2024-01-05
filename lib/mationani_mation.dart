part of 'mationani.dart';

///
///
/// this file contains:
/// [MationBase]
///   [Mation]
///     * [MationSequence]
///       * [MationSequenceStyle]
///       * [MationSequenceStep], [MationSequenceInterval]
///     [MationTransition]
///       [MationTransitionDouble]
///       [MationTransitionOffset]
///       [MationTransitionAlign]
///       [MationTransitionDecoration]
///       ...
///     [MationClipper]
///     [MationPainter]
///   [Mations]
///     [MationTransform]
///       * [_MationTransformDelegate]
///       * [_MationTransformBase]
///
///
///

///
/// See also:
///  * [Mation], which triggers 1 tween animation
///       [_MationTransformBase], which implements [Transform] animation to used in [Mationani]
///       [MationTransition], which implements animation of [AnimatedWidget] subclasses to used in [Mationani]
///       [MationClipper], which implements animation of [ClipPath] to used in [Mationani]
///       [MationPainter], which implements animation of [CustomPaint] to used in [Mationani]
///       ...
///  * [Mations], which trigger multiple tweens animations
///       [MationTransform]
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
  /// See Also
  ///   constant variables of [MationTransition].
  ///

  _AnimationsBuilder get _builder;

  Iterable<Animation> _animationsOf(AnimationController c, Curve curve);
}

class Mation<T> extends MationBase<T> {
  final AnimationBuilder __builder;
  final Between<T> between;

  Mation(
    this.between, {
    AnimationBuilder builder = _animationBuilder,
  }) : __builder = builder;

  @override
  String toString() => 'Mation: $between';

  static Widget _animationBuilder(Animation animation, Widget child) => child;

  Animation<T> _animationOf(AnimationController c, Curve curve) =>
      between.animate(c);

  @override
  Iterable<Animation> _animationsOf(AnimationController c, Curve curve) =>
      [_animationOf(c, curve)];

  @override
  _AnimationsBuilder get _builder =>
      (animations, child) => __builder(animations.first, child);

  Mation<T> map(Mapper<Mation<T>> mapper) => mapper(this);

  Mation<T> mapBetween(Mapper<Between<T>> mapper) => Mation(
        between,
        builder: __builder,
      );
}

///
///
/// [MationTransition]
///
/// See Also:
///   * [MationTransitionDouble] ...
///   * [MationTransitionOffset] ...
///   * [MationTransitionAlign] ...
///   * [MationTransitionDecoration] ...
///
///
abstract class MationTransition<T> extends Mation<T> {
  MationTransition(super.between, {required super.builder});

  ///
  /// these constants must be dynamic type, see the comment over [MationBase._builder]
  ///

  static const AnimationBuilder<dynamic> slide = _slide;
  static const AnimationBuilder<dynamic> decoration = _decoration;
  static const AnimationBuilder<dynamic> fade = _fade;
  static const AnimationBuilder<dynamic> silverFade = _silverFade;
  static const AnimationBuilder<dynamic> align = _align;
  static const AnimationBuilder<dynamic> defaultTextStyle = _defaultTextStyle;
  static const AnimationBuilder<dynamic> positioned = _positioned;

  static Widget _slide(Animation animation, Widget child) => SlideTransition(
        position: animation as Animation<Offset>,
        child: child,
      );

  static Widget _decoration(Animation animation, Widget child) =>
      DecoratedBoxTransition(
        decoration: animation as Animation<Decoration>,
        child: child,
      );

  static Widget _fade(Animation animation, Widget child) => FadeTransition(
        opacity: animation as Animation<double>,
        child: child,
      );

  static Widget _silverFade(Animation animation, Widget child) =>
      SliverFadeTransition(
        opacity: animation as Animation<double>,
        sliver: child,
      );

  static Widget _align(Animation animation, Widget child) => AlignTransition(
        alignment: animation as Animation<AlignmentGeometry>,
        child: child,
      );

  static Widget _defaultTextStyle(Animation animation, Widget child) =>
      DefaultTextStyleTransition(
        style: animation as Animation<TextStyle>,
        child: child,
      );

  static Widget _positioned(Animation animation, Widget child) =>
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

class MationTransitionDouble extends MationTransition<double> {
  ///
  /// fade
  ///
  MationTransitionDouble.fade(double begin, double end, {CurveFR? curve})
      : super(Between(begin: begin, end: end, curve: curve),
            builder: MationTransition.fade);

  MationTransitionDouble.fadeIn({CurveFR? curve})
      : super(FBetweenDouble.zeroTo(1), builder: MationTransition.fade);

  MationTransitionDouble.fadeOut({CurveFR? curve})
      : super(FBetweenDouble.oneTo(0), builder: MationTransition.fade);

  factory MationTransitionDouble.fadeWithValue(
    double value, {
    required Mapper<double> begin,
    required Mapper<double> end,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.fade(begin(value), end(value), curve: curve);

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
          builder: MationTransition.scaleOf(alignment),
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
          builder: MationTransition.rotationOf(alignment),
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
          builder: MationTransition.rotationOf(alignment),
        );

  factory MationTransitionDouble.rotateFromZeroTo(
    double end, {
    Alignment alignment = Alignment.center,
    CurveFR? curve,
  }) =>
      MationTransitionDouble.rotate(
        0,
        end,
        alignment: alignment,
        curve: curve,
      );

  factory MationTransitionDouble.rotateToZeroFrom(
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

  factory MationTransitionDouble.rotateBeginOrEndZero(
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
}

class MationTransitionOffset extends MationTransition<Offset> {
  MationTransitionOffset.at(Offset p)
      : super(Between.constant(p), builder: MationTransition.slide);

  MationTransitionOffset(Offset begin, Offset end, {CurveFR? curve})
      : super(
          Between(begin: begin, end: end, curve: curve),
          builder: MationTransition.slide,
        );

  MationTransitionOffset.zeroTo(Offset end, {CurveFR? curve})
      : super(
          FBetweenOffset.zeroTo(end, curve: curve),
          builder: MationTransition.slide,
        );

  MationTransitionOffset.zeroFrom(Offset begin, {CurveFR? curve})
      : super(
          FBetweenOffset.zeroFrom(begin, curve: curve),
          builder: MationTransition.slide,
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
          builder: MationTransition.slide,
        );

  MationTransitionOffset.ofDistance(
    double distance,
    Between<double> direction, {
    CurveFR? curve,
  }) : super(
          BetweenSpline2D.arcCircle(
            direction,
            distance,
            curve: curve,
          ),
          builder: MationTransition.slide,
        );

  MationTransitionOffset.from(Between<Offset> between, {CurveFR? curve})
      : super(
          between,
          builder: MationTransition.slide,
        );
}

class MationTransitionAlign extends MationTransition<AlignmentGeometry> {
  MationTransitionAlign({
    required AlignmentGeometry begin,
    required AlignmentGeometry end,
    CurveFR? curve,
  }) : super(
          Between(begin: begin, end: end, curve: curve),
          builder: MationTransition.align,
        );
}

///
///
///
///
/// See Also:
///   * [_FOnLerp._decoration] to know the practice for creation
///   * [_FOnLerp._shapeBorder] to know the practice for creation, not all [ShapeDecoration.shape] are interpolatable.
///   * [BoxDecoration.lerp], [ShapeDecoration.lerp] to find the right decoration that can be interpolated.
///   * [KBoxDecoration]
///
///
///
class MationTransitionDecoration extends MationTransition<Decoration> {
  MationTransitionDecoration({
    required Decoration begin,
    required Decoration end,
    CurveFR? curve,
  }) : super(
          Between(begin: begin, end: end, curve: curve),
          builder: MationTransition.decoration,
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
    BetweenPath between, {
    this.behavior = Clip.antiAlias,
  }) : super(between);

  @override
  AnimationBuilder get __builder => (animation, child) => ClipPath(
        clipper: Clipping.reclipWhenUpdate(animation.value),
        clipBehavior: behavior,
        child: child,
      );

  @override
  Mation<SizingPath> mapBetween(
    Mapper<Between<SizingPath>> mapper,
  ) =>
      throw UnimplementedError();
}

class MationPainter extends Mation<SizingPath> {
  final bool isComplex;
  final bool willChange;
  final CustomPainter? foregroundPainter;
  final Size size;
  final CanvasProcessor canvasListener;
  final SizingPaintFromCanvas sizingPaintingFromCanvas;

  MationPainter._(
    super.between, {
    required this.isComplex,
    required this.willChange,
    required this.foregroundPainter,
    required this.size,
    required this.canvasListener,
    required this.sizingPaintingFromCanvas,
  });

  MationPainter.drawPathTweenWithPaint(
    BetweenPath pathBetween, {
    this.sizingPaintingFromCanvas = FPaintFromCanvasSize.redFill,
  })  : isComplex = false,
        willChange = true,
        size = Size.zero,
        foregroundPainter = null,
        canvasListener = FCanvasProcessor.drawPathWithPaint,
        super(pathBetween);

  @override
  AnimationBuilder get __builder => (animation, child) => CustomPaint(
        painter: Painting.rePaintWhenDiff(
          paintFromCanvasSize: sizingPaintingFromCanvas,
          pathFromSize: animation.value,
          canvasListener: canvasListener,
        ),
        foregroundPainter: foregroundPainter,
        size: size,
        isComplex: isComplex,
        willChange: willChange,
        child: child,
      );

  @override
  MationPainter mapBetween(Mapper<Between<SizingPath>> mapper) =>
      MationPainter._(
        between,
        isComplex: isComplex,
        willChange: willChange,
        foregroundPainter: foregroundPainter,
        size: size,
        canvasListener: canvasListener,
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
  Iterable<Animation> _animationsOf(
          AnimationController controller, Curve curve) =>
      _list.map((mation) => mation._animationOf(controller, curve));

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

class _MationTransformDelegate {
  final int type;
  Between<Coordinate> between;
  AlignmentGeometry? alignment;

  _MationTransformDelegate._(this.type, this.between);

  static final _MationTransformDelegate translate = _MationTransformDelegate._(
    0,
    Between(begin: Coordinate.zero, end: Coordinate.zero),
  );
  static final _MationTransformDelegate rotate = _MationTransformDelegate._(
    1,
    Between(begin: Coordinate.zero, end: Coordinate.zero),
  );
  static final _MationTransformDelegate scale = _MationTransformDelegate._(
    2,
    Between(begin: KCoordinate.cube_1, end: KCoordinate.cube_1),
  );

  _OnAnimateMatrix4 get _onAnimate => switch (type) {
        0 => _FOnAnimateMatrix4.translating,
        1 => _FOnAnimateMatrix4.rotating,
        2 => _FOnAnimateMatrix4.scaling,
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
  final _OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  AnimationBuilder _transform(_OnAnimateMatrix4 animate) =>
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

  /// instead of using scale, translate, rotate here, using [MationTransition], prevent ambiguous dependency for api
  _MationTransformBase._scale(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = _MationTransformDelegate.scale._onAnimate;

  _MationTransformBase._translate(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = _MationTransformDelegate.translate._onAnimate;

  _MationTransformBase._rotate(
    super.between, {
    Matrix4? host,
    this.alignment,
  })  : host = host ?? Matrix4.identity(),
        onAnimate = _MationTransformDelegate.rotate._onAnimate;

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
    List<_MationTransformDelegate> delegates, {
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

///
///
///
///
/// mation sequence
///
/// [MationSequence]
/// [MationSequenceStyle]
/// [MationSequenceStep]
/// [MationSequenceInterval]
///
///
///
///

///
/// see also [BetweenInterval], [Between.sequenceFromGenerator]
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

enum MationSequenceStyle {
  transformTRS,
  transitionRotateSlideBezierCubic;

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
        // rotation, translation, scaling

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
                    _MationTransformDelegate.translate
                      ..between = Between(begin: a[0], end: b[0], curve: curve)
                      ..alignment = Alignment.topLeft,
                    _MationTransformDelegate.rotate
                      ..between = Between(begin: a[1], end: b[1], curve: curve)
                      ..alignment = Alignment.topLeft,
                    _MationTransformDelegate.scale
                      ..between = Between(begin: a[2], end: b[2], curve: curve)
                      ..alignment = Alignment.topLeft,
                  ],
                );
              },
            );
          },

        // rotate, slide in bezier cubic

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
                  BetweenSpline2D.bezierCubic(
                    begin.offsets[0],
                    end.offsets[0],
                    c1: previous.offsets[0] + controlPoints[0],
                    c2: previous.offsets[0] + controlPoints[1],
                    curve: curve,
                  ),
                ),
              ]),
            );
          },
      };
}

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
