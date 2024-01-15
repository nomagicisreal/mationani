///
///
/// this file contains:
/// [Between]
///   * [BetweenInterval]
///   * [BetweenConcurrent]
///   [BetweenSpline2D]
///   [BetweenPath]
///     [BetweenPathOffset]
///     * [_BetweenPathConcurrent]
///     [BetweenPathPolygon]
///   ...
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
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
/// [Between] is my implementation for [Tween],
/// which aims to have an easier way to enable beautiful animation for [MationBase] in [Mationani]
///
/// implementations: [Between._onLerp], [Between.curve], ...
/// constructors: [Between.constant], [Between.sequenceFromGenerator], ...
/// properties: [Between.reverse], [Between.follow], ...
///
class Between<T> extends Tween<T> {
  @override
  T get begin => super.begin!;

  @override
  T get end => super.end!;

  final OnLerp<T> _onLerp;
  final CurveFR? curve;

  @override
  T transform(double t) => _onLerp(t);

  @override
  Animation<T> animate(Animation<double> parent) =>
      super.animate(CurvedAnimation(
        parent: parent,
        curve: curve?.forward ?? Curves.fastOutSlowIn,
        reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
      ));

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  /// [Between.constant]
  /// [Between.sequenceFromGenerator]
  ///
  Between({
    required T super.begin,
    required T super.end,
    OnLerp<T>? onLerp,
    this.curve,
  }) : _onLerp = onLerp ?? _FOnLerp.of(begin, end);

  Between.constant(T value)
      : curve = null,
        _onLerp = _FOnLerp.constant(value),
        super(begin: value, end: value);

  Between.sequence({
    required List<T> steps,
    this.curve,
  })  : _onLerp = BetweenInterval._linking(
          totalStep: steps.length,
          step: (i) => steps[i],
          interval: (i) => const BetweenInterval(1),
        ),
        super(begin: steps.first, end: steps.last);

  Between.sequenceFromGenerator({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    this.curve,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : _onLerp = BetweenInterval._linking(
          totalStep: totalStep,
          step: step,
          interval: interval,
          sequencer: sequencer,
        ),
        super(begin: step(0), end: step(totalStep - 1));

  Between.outAndBack({
    required T super.begin,
    required T target,
    this.curve,
    double ratio = 1.0,
    Curve curveOut = Curves.linear,
    Curve curveBack = Curves.linear,
    Sequencer<Between<T>, T, OnLerp<T>>? sequencer,
  })  : _onLerp = BetweenInterval._linking(
          totalStep: 3,
          step: (i) => i == 1 ? target : begin,
          interval: (i) => i == 0
              ? BetweenInterval(ratio, curve: curveOut)
              : BetweenInterval(1 / ratio, curve: curveBack),
          sequencer: sequencer,
        ),
        super(end: begin);

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
        begin: end,
        end: begin,
        onLerp: _onLerp,
        curve: curve,
      );

  Between<T> follow(T next) => Between(
        begin: end,
        end: next,
        onLerp: _onLerp,
        curve: curve,
      );

  Between<T> followPlus(T next) => Between(
        begin: end,
        end: Operator.plus.operationOf(end, next),
        onLerp: _onLerp,
        curve: curve,
      );

  Between<T> followMinus(T next) => Between(
        begin: end,
        end: Operator.minus.operationOf(end, next),
        onLerp: _onLerp,
        curve: curve,
      );

  Between<T> followMultiply(T next) => Between(
        begin: end,
        end: Operator.multiply.operationOf(end, next),
        onLerp: _onLerp,
        curve: curve,
      );

  Between<T> followDivide(T next) => Between(
        begin: end,
        end: Operator.divide.operationOf(end, next),
        onLerp: _onLerp,
        curve: curve,
      );
}

///
/// See Also:
///   [MationSequenceInterval], which is similar
///
class BetweenInterval {
  final double weight;
  final Curve curve;

  const BetweenInterval(this.weight, {this.curve = Curves.fastOutSlowIn});

  OnLerp<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = _FOnLerp.of<T>(a, b);
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
            begin: previous,
            end: next,
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
      onLerps.add(tween._onLerp);
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

///
/// See Also [FOnLerpSpline2D]
///
class BetweenSpline2D extends Between<Offset> {
  BetweenSpline2D({
    required OnLerp<Offset> super.onLerp,
    super.curve,
  }) : super(begin: onLerp(0), end: onLerp(1));
}

///
///
/// between path
///
class BetweenPath<T> extends Between<SizingPath> {
  final OnAnimatePath<T> onAnimate;

  BetweenPath._({
    required super.begin,
    required super.end,
    required this.onAnimate,
    super.onLerp,
    super.curve,
  });

  ///
  ///
  /// because [end] is called before [_onLerp]. no matter [end] is set to
  /// "onAnimate(1, between.end)", "onAnimate(0, between.end)" or "onAnimate(1, between.begin)",
  /// it causes ambiguous [_onLerp] for the child of [BetweenPath]
  ///
  ///
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super(
          begin: onAnimate(0, between.begin),
          end: onAnimate(0, between.begin),
          onLerp: FOnAnimatePath.of(onAnimate, between._onLerp),
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
        draw = draw.union(drawing(t, current));
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

class _BetweenPathConcurrent<T> extends BetweenPath<List<T>> {
  _BetweenPathConcurrent(BetweenConcurrent<T, SizingPath> concurrent)
      : super._(
          begin: concurrent.begins,
          end: concurrent.ends,
          onLerp: concurrent.onLerps,
          onAnimate: concurrent.onAnimate,
        );
}

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
              cornerRadius?.call(polygon) ?? BetweenDoubleExtension.zero,
              edgeVectorTimes ?? BetweenDoubleExtension.zero,
              scale ?? BetweenDoubleExtension.k1,
            ],
            onAnimate: (t, values) => FSizingPath.polygonCubicFromSize(
              polygon.cubicPointsOf(values[0], values[1]),
              scale: values[2],
              adjust: polygon.cornerAdjust,
            ),
            curve: curve,
          ),
        );
}

