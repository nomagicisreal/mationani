part of '../mationani.dart';

///
/// .
///     --[Amplitude]
///     |
/// * [Matalue] + [_AnimationMatalue]
///     |
///     --[Between] + [BetweenInterval]
///         |
///         --[BetweenSpline2D]
///         --[BetweenPath]
///
///

///
/// [_AnimationMatalue], [Matalue]
///
class _AnimationMatalue<T> extends Animation<T> with AnimationWithParentMixin<double> {
  _AnimationMatalue(this.parent, this.animatable);

  @override
  final Animation<double> parent;

  final Matalue<T> animatable;

  @override
  T get value => animatable.evaluate(parent);
}

///
/// [onLerp], [curve],
/// [transform], [evaluate], [animate],
///
sealed class Matalue<T> extends Animatable<T> {
  final Lerper<T> onLerp;
  final CurveFR? curve;

  const Matalue({required this.onLerp, this.curve});

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _AnimationMatalue(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );

  ///
  ///
  ///
  static Matalue<double> doubleToRadian(Matalue<double> round) =>
      switch (round) {
        Between<double>() => Between(
            Radian.fromRound(round.begin),
            Radian.fromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            Radian.fromRound(round.from),
            Radian.fromRound(round.value),
            round.times,
            curving: round.curving,
            curve: round.curve,
          ),
      };
}

///
/// [begin], [end],
/// [Between.constant], [Between.of], [Between.sequence], [Between.sequenceFromGenerator], ...
/// [reverse], [follow], [followOperate], ..., [toString]
///
class Between<T> extends Matalue<T> {
  final T begin;
  final T end;

  Between(this.begin, this.end, {super.curve})
      : super(onLerp: lerperFrom(begin, end));

  const Between.constant(
    this.begin,
    this.end, {
    required super.onLerp,
    required super.curve,
  });

  Between.of(T value)
      : begin = value,
        end = value,
        super(onLerp: DoubleExtension.lerperOf(value));

  Between.sequence({
    BetweenInterval weight = BetweenInterval.linear,
    super.curve,
    required List<T> steps,
  })  : begin = steps.first,
        end = steps.last,
        super(
          onLerp: BetweenInterval._link(
            totalStep: steps.length,
            step: (i) => steps[i],
            interval: (i) => weight,
          ),
        );

  Between.sequenceFromGenerator({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    super.curve,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  })  : begin = step(0),
        end = step(totalStep - 1),
        super(
          onLerp: BetweenInterval._link(
            totalStep: totalStep,
            step: step,
            interval: interval,
            sequencer: sequencer,
          ),
        );

  Between.outAndBack({
    required this.begin,
    required T target,
    super.curve = CurveFR.linear,
    double ratio = 1.0,
    Curve curveOut = Curves.fastOutSlowIn,
    Curve curveBack = Curves.fastOutSlowIn,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  })  : end = begin,
        super(
          onLerp: BetweenInterval._link(
            totalStep: 3,
            step: (i) => i == 1 ? target : begin,
            interval: (i) => i == 0
                ? BetweenInterval(ratio, curve: curveOut)
                : BetweenInterval(1 / ratio, curve: curveBack),
            sequencer: sequencer,
          ),
        );

  @override
  String toString() => 'Between($begin, $end, $curve)';

  ///
  /// properties
  ///
  Between<T> get reverse =>
      Between.constant(end, begin, onLerp: onLerp, curve: curve);

  Between<T> follow(T next) =>
      Between.constant(end, next, onLerp: onLerp, curve: curve);
}

///
///
///
class BetweenInterval {
  final double weight;
  final Curve curve;

  Lerper<T> lerp<T>(T a, T b) {
    final curving = curve.transform;
    final onLerp = lerperFrom<T>(a, b);
    return (t) => onLerp(curving(t));
  }

  const BetweenInterval(this.weight, {this.curve = Curves.linear});

  static const BetweenInterval linear = BetweenInterval(1);

  ///
  ///
  /// the index 0 of [interval] is between index 0 and 1 of [step]
  /// the index 1 of [interval] is between index 1 and 2 of [step], and so on.
  ///
  ///
  static Lerper<T> _link<T>({
    required int totalStep,
    required Generator<T> step,
    required Generator<BetweenInterval> interval,
    Sequencer<T, Lerper<T>, Between<T>>? sequencer,
  }) {
    final seq = sequencer ?? _sequencer<T>;
    var i = -1;
    return TweenSequence(
      step.linkToListTill(
        totalStep,
        interval,
        (previous, next, interval) => TweenSequenceItem<T>(
          tween: seq(previous, next, interval.lerp(previous, next))(++i),
          weight: interval.weight,
        ),
      ),
    ).transform;
  }

  static Mapper<int, Between<T>> _sequencer<T>(
    T previous,
    T next,
    Lerper<T> onLerp,
  ) =>
      (_) => Between.constant(
            previous,
            next,
            onLerp: onLerp,
            curve: null,
          );
}

///
///
///
class Amplitude<T> extends Matalue<T> {
  final T from;
  final T value;
  final int times;
  final Curving curving;

  const Amplitude.constant(
    this.from,
    this.value,
    this.times, {
    required this.curving,
    required super.onLerp,
    super.curve,
  });

  Amplitude(
    this.from,
    this.value,
    this.times, {
    required this.curving,
    super.curve,
  }) : super(
          onLerp: () {
            final transform = Between(from, value).transform;
            final curved = curving.transformInternal;
            return (t) => transform(curved(t));
          }(),
        );
}

///
/// static methods:
/// [BetweenSpline2D.lerpArcOval], ...
/// [BetweenSpline2D.lerpBezierQuadratic], ...
/// [BetweenSpline2D.lerpBezierCubic], ...
/// [BetweenSpline2D.lerpCatmullRom], ...
///
class BetweenSpline2D extends Between<Offset> {
  BetweenSpline2D({
    required super.onLerp,
    super.curve,
  }) : super.constant(onLerp(0), onLerp(1));

  ///
  ///
  ///
  static Lerper<Offset> lerpArcOval(
    Offset origin,
    Between<double> direction,
    Between<double> radius,
  ) {
    final dOf = direction.onLerp;
    final rOf = radius.onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Lerper<Offset> lerpArcCircle(
    Offset origin,
    double radius,
    Between<double> direction,
  ) =>
      lerpArcOval(origin, direction, Between.of(radius));

  static Lerper<Offset> lerpArcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return DoubleExtension.lerperOf(a);
    }

    final center = a.middleTo(b);
    final radianBegin = a.direction - center.direction;
    final r = clockwise ? Radian.angle_180 : -Radian.angle_180;
    final radius = (a - b).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  ///
  ///
  ///
  static Lerper<Offset> lerpBezierQuadratic(
    Offset begin,
    Offset end,
    Offset controlPoint,
  ) {
    final vector1 = controlPoint - begin;
    final vector2 = end - controlPoint;
    return (t) => OffsetExtension.parallelOffsetOf(
          begin + vector1 * t,
          controlPoint + vector2 * t,
          t,
        );
  }

  static Lerper<Offset> lerpBezierQuadraticSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      lerpBezierQuadratic(
        begin,
        end,
        OffsetExtension.perpendicularOffsetUnitFromCenterOf(
          begin,
          end,
          dPerpendicular,
        ),
      );

  /// bezier cubic
  static Lerper<Offset> lerpBezierCubic(
    Offset begin,
    Offset end, {
    required Offset c1,
    required Offset c2,
  }) {
    final vector1 = c1 - begin;
    final vector2 = c2 - c1;
    final vector3 = end - c2;
    return (t) {
      final middle = c1 + vector2 * t;
      return OffsetExtension.parallelOffsetOf(
        OffsetExtension.parallelOffsetOf(begin + vector1 * t, middle, t),
        OffsetExtension.parallelOffsetOf(middle, c2 + vector3 * t, t),
        t,
      );
    };
  }

  static Lerper<Offset> lerpBezierCubicSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return lerpBezierCubic(begin, end, c1: list[1], c2: list[2]);
  }

  ///
  ///
  ///
  static Lerper<Offset> lerpCatmullRom(
    List<Offset> controlPoints, {
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      CatmullRomSpline.precompute(
        controlPoints,
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      ).transform;

  static Lerper<Offset> lerpCatmullRomSymmetry(
    Offset begin,
    Offset end, {
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) =>
      lerpCatmullRom(
        [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

///
///
///
class BetweenPath<T> extends Between<SizingPath> {
  final OnAnimatePath<T> onAnimate;

  const BetweenPath.constant(
    super.begin,
    super.end, {
    required this.onAnimate,
    required super.onLerp,
    super.curve,
  }) : super.constant();

  ///
  /// because [end] is called before [onLerp]. no matter [end] is set to
  /// "onAnimate(1, between.end)", "onAnimate(0, between.end)" or "onAnimate(1, between.begin)",
  /// it causes ambiguous [onLerp] for the child of [BetweenPath]
  ///
  BetweenPath(
    Between<T> between, {
    required this.onAnimate,
    super.curve,
  }) : super.constant(
          onAnimate(0, between.begin),
          onAnimate(0, between.begin),
          onLerp: animateOf(onAnimate, between.onLerp),
        );

  static Lerper<SizingPath> animateOf<T>(
    OnAnimatePath<T> onAnimate,
    Lerper<T> onLerp,
  ) =>
      (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> animateShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) {
    final shaping = outerPath
        ? (s) => FSizingPath.shapeBorderOuter(s, sizingRect, textDirection)
        : (s) => FSizingPath.shapeBorderInner(s, sizingRect, textDirection);
    return (t, shape) => shaping(shape);
  }
}
