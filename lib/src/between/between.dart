///
///
/// this file contains:
/// [Between]
///   --[BetweenSpline2D]
///   --[BetweenPath]
///   |   [BetweenPathOffset]
///   |   [BetweenPathVector3D]
///   |   * [_BetweenPathConcurrent]
///   |   [BetweenPathPolygon]
///   ...
///
///
///
/// [BetweenInterval]
/// [BetweenConcurrent]
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
/// [Between] is my implementation for [Tween.animate],
/// which aims to have an easier way to enable beautiful animation for [_MationAnimatable] in [Mationani]
///
/// [Between.constant]
/// [Between.of]
/// [Between.sequenceFromGenerator], ...
///
/// overrides:
/// [begin], [end], [onLerp], [curve],
/// [transform], [evaluate], [animate], [toString]
///
/// custom properties, methods:
/// [reverse]
/// [follow], [followPlus], ...
///
class Between<T> extends Animatable<T> {
  ///
  /// constructors
  ///
  Between(this.begin, this.end, {OnLerp<T>? onLerp, this.curve})
      : onLerp = onLerp ?? _FOnLerp._of(begin, end);

  const Between.constant(this.begin, this.end, this.onLerp, this.curve);

  Between.of(T value)
      : begin = value,
        end = value,
        curve = null,
        onLerp = _FOnLerp._constant(value);

  Between.sequence({
    required List<T> steps,
    this.curve,
  })  : begin = steps.first,
        end = steps.last,
        onLerp = BetweenInterval._linking(
          totalStep: steps.length,
          step: (i) => steps[i],
          interval: (i) => const BetweenInterval(1),
        );

  Between.sequenceFromGenerator({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    this.curve,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : begin = step(0),
        end = step(totalStep - 1),
        onLerp = BetweenInterval._linking(
          totalStep: totalStep,
          step: step,
          interval: interval,
          sequencer: sequencer,
        );

  Between.outAndBack({
    required this.begin,
    required T target,
    this.curve = KCurveFR.linear,
    double ratio = 1.0,
    Curve curveOut = Curves.fastOutSlowIn,
    Curve curveBack = Curves.fastOutSlowIn,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : end = begin,
        onLerp = BetweenInterval._linking(
          totalStep: 3,
          step: (i) => i == 1 ? target : begin,
          interval: (i) => i == 0
              ? BetweenInterval(ratio, curve: curveOut)
              : BetweenInterval(1 / ratio, curve: curveBack),
          sequencer: sequencer,
        );

  final T begin;
  final T end;
  final OnLerp<T> onLerp;
  final CurveFR? curve;

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _BetweenAnimation(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  /// properties
  /// - [reverse]
  /// - [follow]
  /// - [followPlus]
  /// - [followMinus]
  /// - [followMultiply]
  /// - [followDivide]
  ///
  ///

  Between<T> get reverse => Between(
        end,
        begin,
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> follow(T next) => Between(
        end,
        next,
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followPlus(T next) => Between(
        end,
        Operator.plus.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followMinus(T next) => Between(
        end,
        Operator.minus.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followMultiply(T next) => Between(
        end,
        Operator.multiply.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );

  Between<T> followDivide(T next) => Between(
        end,
        Operator.divide.operationOf(end, next),
        onLerp: onLerp,
        curve: curve,
      );
}


///
/// See Also [FOnLerpSpline2D]
///
class BetweenSpline2D extends Between<Offset> {
  BetweenSpline2D({
    required OnLerp<Offset> super.onLerp,
    super.curve,
  }) : super(onLerp(0), onLerp(1));
}

///
///
/// between path
///
class BetweenPath<T> extends Between<SizingPath> {
  final OnAnimatePath<T> onAnimate;

  BetweenPath._(
    super.begin,
    super.end, {
    required this.onAnimate,
    super.onLerp,
    super.curve,
  });

  ///
  ///
  /// because [end] is called before [onLerp]. no matter [end] is set to
  /// "onAnimate(1, between.end)", "onAnimate(0, between.end)" or "onAnimate(1, between.begin)",
  /// it causes ambiguous [onLerp] for the child of [BetweenPath]
  ///
  ///
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super(
          onAnimate(0, between.begin),
          onAnimate(0, between.begin),
          onLerp: FOnAnimatePath.of(onAnimate, between.onLerp),
        );
}

class BetweenPathOffset extends BetweenPath<Offset> {
  BetweenPathOffset._(
    super.between, {
    required super.onAnimate,
    super.curve,
  });

  BetweenPathOffset.line(
    super.between,
    double width, {
    super.curve,
    StrokeCap strokeCap = StrokeCap.round,
  })  : assert(strokeCap == StrokeCap.round),
        super(onAnimate: FOnAnimatePath.lineStadium(between, width));

  factory BetweenPathOffset.linePoly(
    double r, {
    required List<Offset> nodes,
    CurveFR? curve,
  }) {
    final length = nodes.length;
    final intervals = List.generate(length, (index) => (index + 1) / length);
    final between = Between.sequence(steps: nodes, curve: curve);

    int i = 0;
    double bound = intervals[i];
    OnAnimatePath<Offset> lining(Offset a, Offset b) =>
        FOnAnimatePath.stadium(a, a.directionTo(b), r);
    OnAnimatePath<Offset> drawing = lining(nodes[0], nodes[1]);
    SizingPath draw = FSizingPath.circle(nodes[0], r);

    return BetweenPathOffset._(
      between,
      onAnimate: (t, current) {
        if (t > bound) {
          i++;
          bound = intervals[i];
          drawing = i == length - 1 ? drawing : lining(nodes[i], nodes[i + 1]);
        }
        draw = draw.combine(drawing(t, current));
        return draw;
      },
      curve: curve,
    );
  }

  factory BetweenPathOffset.linePolyFromGenerator(
    double width, {
    required int totalStep,
    required Generator<Offset> step,
    required Generator<BetweenInterval> interval,
    CurveFR? curve,
  }) {
    // final offset = Between.sequenceFromGenerator(
    //   totalStep: totalStep,
    //   step: step,
    //   interval: interval,
    //   curve: curve,
    // );
    throw UnimplementedError();
  }
}

//
class BetweenPathVector3D extends BetweenPath<Vector3D> {
  BetweenPathVector3D(
    super.between, {
    required super.onAnimate,
    super.curve,
  });

  BetweenPathVector3D.progressingCircles({
    double initialCircleRadius = 5.0,
    double circleRadiusFactor = 0.1,
    required AniGeneral setting,
    required Paint paint,
    required Between<double> radiusOrbit,
    required int circleCount,
    required Companion<Vector3D, int> planetGenerator,
  }) : this(
          Between<Vector3D>(
            Vector3D(Coordinate.zero, radiusOrbit.begin),
            Vector3D(KRadianCoordinate.angleZ_360, radiusOrbit.end),
          ),
          onAnimate: (t, vector) => FSizingPath.combineAll(
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
        );
}

//
class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
  _BetweenPathConcurrent(BetweenConcurrent<T, SizingPath> concurrent)
      : super._(
          concurrent.begins,
          concurrent.ends,
          onLerp: concurrent.onLerps,
          onAnimate: concurrent.onAnimate,
        );
}

//
class BetweenPathPolygon extends _BetweenPathConcurrent<double> {
  BetweenPathPolygon.regularCubicOnEdge({
    required RRegularPolygonCubicOnEdge polygon,
    Between<double>? scale,
    Between<double>? edgeVectorTimes,
    Translator<RRegularPolygonCubicOnEdge, Between<double>>? cornerRadius,
    CurveFR? curve,
  }) : super(
          BetweenConcurrent(
            betweens: [
              cornerRadius?.call(polygon) ?? FBetween.doubleKZero,
              edgeVectorTimes ?? FBetween.doubleKZero,
              scale ?? FBetween.doubleKOne,
            ],
            onAnimate: (t, values) => FSizingPath.polygonCubic(
              polygon.cubicPointsOf(values[0], values[1]),
              scale: values[2],
              adjust: polygon.cornerAdjust,
            ),
            curve: curve,
          ),
        );
}


///
///
///
///
///
/// See Also:
///   [AniSequenceInterval], which is similar
///
class BetweenInterval {
  final double weight;
  final Curve curve;

  const BetweenInterval(this.weight, {this.curve = Curves.fastOutSlowIn});

  OnLerp<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = _FOnLerp._of<T>(a, b);
    return (t) => onLerp(curving(t));
  }

  ///
  ///
  /// the index 0 of [interval] is between index 0 and 1 of [step]
  /// the index 1 of [interval] is between index 1 and 2 of [step], and so on.
  ///
  ///
  static OnLerp<T> _linking<T>({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  }) {
    final seq = sequencer ?? _sequencer<T>;
    return TweenSequence(
        ListExtension.linking<TweenSequenceItem<T>, T, BetweenInterval>(
          totalStep: totalStep,
          step: step,
          interval: interval,
          sequencer: (previous, next, interval) => (index) => TweenSequenceItem(
            tween: seq(previous, next, interval.lerp(previous, next))(index),
            weight: interval.weight,
          ),
        )).transform;
  }

  static Translator<int, Between<T>> _sequencer<T>(
      T previous,
      T next,
      OnLerp<T> onLerp,
      ) =>
          (_) => Between(
        previous,
        next,
        onLerp: onLerp,
      );
}

class BetweenConcurrent<T, S> {
  final S begins;
  final S ends;
  final OnLerp<S> onLerps;
  final OnAnimate<List<T>, S> onAnimate;

  const BetweenConcurrent._({
    required this.begins,
    required this.ends,
    required this.onLerps,
    required this.onAnimate,
  });

  factory BetweenConcurrent({
    required List<Between<T>> betweens,
    required OnAnimate<List<T>, S> onAnimate,
    CurveFR? curve,
  }) {
    final begins = <T>[];
    final ends = <T>[];
    final onLerps = <OnLerp<T>>[];
    for (var tween in betweens) {
      begins.add(tween.begin);
      ends.add(tween.end);
      onLerps.add(tween.onLerp);
    }

    return BetweenConcurrent._(
      begins: onAnimate(0, begins),
      ends: onAnimate(0, ends),
      onLerps: (t) {
        final values = <T>[];
        for (var onLerp in onLerps) {
          values.add(onLerp(t));
        }
        return onAnimate(t, values);
      },
      onAnimate: onAnimate,
    );
  }
}