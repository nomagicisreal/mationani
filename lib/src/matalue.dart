part of '../mationani.dart';

///
/// .
///     --[Deviate]
///     |   --[_DeviateDouble], [_DeviateOffset]
///     |
/// * [Matalue] * [_AnimationMatalue] * [Animation]
///     |
///     --[Between]
///         --[_BetweenConstant]
///         --[_BetweenDouble], [_BetweenDoubleDouble], [_BetweenDoubleDoubleDouble]
///         --[_BetweenSize], [_BetweenRect], [_BetweenColor]
///         --[_BetweenEdgeInsets], [_BetweenRelativeRect], [_BetweenAlignmentGeometry]
///         --[_BetweenDecoration], [_BetweenBoxDecoration], [_BetweenShapeDecoration]
///         --[_BetweenBoxBorder], [_BetweenShapeBorder], [_BetweenOutlinedBorder]
///         |
///         --[BetweenTicks]
///
/// * [TransformTarget]
///
///

typedef CubicOffset = (Offset, Offset, Offset, Offset);

///
///
///
final class _AnimationMatalue<T> extends Animation<T>
    with AnimationWithParentMixin<double> {
  _AnimationMatalue(this.parent, this.animatable);

  @override
  final Animation<double> parent;

  final Matalue<T> animatable;

  @override
  T get value => animatable.evaluate(parent);
}

abstract final class Matalue<T> extends Animatable<T> {
  final BiCurve? curve;

  const Matalue(this.curve);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) {
    final curve = this.curve;
    if (curve == null) return _AnimationMatalue(parent, this);
    return _AnimationMatalue(
      CurvedAnimation(parent: parent, curve: curve.$1, reverseCurve: curve.$2),
      this,
    );
  }

  ///
  ///
  ///
  static Matalue<double> doubleRadianFromRound(Animatable<double> round) =>
      switch (round) {
        Between<double>() => Between(
            round.begin * _radian360,
            round.end * _radian360,
            round.curve,
          ),
        Deviate<double>() => Deviate(
            around: round.around * _radian360,
            amplitude: round.amplitude * _radian360,
            curve: round.curve,
          ),
        Animatable<double>() => throw UnimplementedError(),
      };
}

///
///
///
abstract final class Between<T> extends Matalue<T> {
  final T begin;
  final T end;

  const Between._(this.begin, this.end, super.curve);

  const factory Between.of(T matalue, [BiCurve? curve]) = _BetweenConstant;

  @override
  String toString() => 'Between($begin, $end, $curve)';

  @override
  int get hashCode => Object.hash(begin, end, curve?.$1, curve?.$2);

  @override
  bool operator ==(covariant Between<T> other) =>
      begin == other.begin &&
      end == other.end &&
      curve?.$1 == other.curve?.$1 &&
      curve?.$2 == other.curve?.$2;

  ///
  ///
  ///
  factory Between(T begin, T end, [BiCurve? curve]) => switch (begin) {
        double _ => _BetweenDouble(begin, end as double, curve),
        _D2 _ => _BetweenDoubleDouble(begin, end as _D2, curve),
        _D3 _ => _BetweenDoubleDoubleDouble(
            begin,
            end as _D3,
            curve,
          ),
        _D4 _ => _BetweenDoubleDoubleDoubleDouble(
            begin,
            end as _D4,
            curve,
          ),
        TransformTarget _ => _BetweenTransform(
            begin,
            end as TransformTarget,
            curve,
          ),

        ///
        ///
        ///
        Offset _ => _BetweenOffset(begin, end as Offset, curve),
        Size _ => _BetweenSize(begin, end as Size, curve),
        Rect _ => _BetweenRect(begin, end as Rect, curve),
        Color _ => _BetweenColor(begin, end as Color, curve),
        EdgeInsets _ => _BetweenEdgeInsets(begin, end as EdgeInsets, curve),
        RelativeRect _ =>
          _BetweenRelativeRect(begin, end as RelativeRect, curve),
        AlignmentGeometry _ =>
          _BetweenAlignmentGeometry(begin, end as AlignmentGeometry, curve),
        Decoration _ => switch (begin) {
            BoxDecoration _ => begin.shape == (end as BoxDecoration).shape
                ? _BetweenBoxDecoration(begin, end, curve)
                : throw _error(begin, end),
            ShapeDecoration _ => switch (end) {
                ShapeDecoration _ => begin.shape == end.shape
                    ? _BetweenShapeDecoration(begin, end, curve)
                    : begin.isRounded && end.isRounded
                        ? _BetweenDecoration(begin, end, curve)
                        : throw _error(begin, end),
                _ => throw _error(begin.shape, end!),
              },
            _ => throw _error(begin, end!),
          },
        ShapeBorder _ => switch (begin) {
            BoxBorder _ => _BetweenBoxBorder(begin, end as BoxBorder, curve),
            InputBorder _ =>
              _BetweenShapeBorder(begin, end as InputBorder, curve),
            OutlinedBorder _ =>
              _BetweenOutlinedBorder(begin, end as OutlinedBorder, curve),
            _ => throw _error(begin, end),
          },
        _ => throw _error(begin, end),
      } as Between<T>;

  static Error _error(Object? begin, Object? end) => UnimplementedError(
        'lerp($begin, $end) no defined in Between, try using BetweenDepend',
      );
}

///
/// constructors, factories:
/// [BetweenTicks.sequence], see also [TweenSequence]
///
/// static methods:
/// [BetweenTicks.depend]
/// [offsetArcOval], ...
/// [pathLine], ...
///
final class BetweenTicks<T> extends Between<T> {
  final T Function(double) onLerp;

  @override
  T transform(double t) => onLerp(t);

  BetweenTicks(this.onLerp, [BiCurve? curve])
      : super._(onLerp(0), onLerp(1), curve);

  factory BetweenTicks.sequence(
    List<T> sequence, {
    BiCurve curve = (Curves.linear, Curves.linear),
    List<BiCurve>? segments,
    List<double>? weights,
    Animatable<T> Function(T begin, T end, BiCurve? curve)? construct,
  }) {
    final steps = sequence.length;
    assert(weights == null || weights.length + 1 == steps);
    assert(segments == null || segments.length + 1 == steps);

    final items = <TweenSequenceItem<T>>[],
        addition = items.add,
        wTotal = weights?.reduce(_E._doublePlus) ?? steps,
        instance = construct ?? _E._between,
        iLast = steps - 2,
        w = weights ?? List.generate(steps, _E._gen1, growable: false),
        c = segments ?? List.generate(steps, _E._genLinear, growable: false);
    var i = 0, begin = 0.0, previous = sequence[0];

    try {
      do {
        final next = sequence[i + 1],
            weight = w[i],
            end = begin + weight / wTotal;
        addition(TweenSequenceItem(
          tween: instance(
            previous,
            next,
            _CurveSegment.apply(c[i], begin, end),
          ),
          weight: weight,
        ));
        begin = end;
        previous = next;
        i++;
      } while (i <= iLast);
    } on UnimplementedError catch (e) {
      throw StateError('unknow how to sequence $sequence,\n${e.message}');
    }
    return BetweenTicks(TweenSequence(items).transform, curve);
  }

  ///
  ///
  ///
  static S Function(double) depend<T, S>(
    T Function(double) transform,
    S Function(T) map,
  ) =>
      (t) => map(transform(t));

  ///
  ///
  /// offset
  ///
  ///

  /// arc
  static Offset Function(double) offsetArcOval({
    required Offset origin,
    required Between<double> direction,
    required Between<double> radius,
  }) {
    final dOf = direction.transform;
    final rOf = radius.transform;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static Offset Function(double) offsetArcCircle({
    required Offset origin,
    required double radius,
    required Between<double> direction,
  }) =>
      offsetArcOval(
        origin: origin,
        direction: direction,
        radius: Between.of(radius),
      );

  static Offset Function(double) offsetArcCircleSemi({
    required Offset begin,
    required Offset end,
    required bool clockwise,
  }) {
    if (begin == end) return (_) => begin;

    final center = begin * 0.5 + end * 0.5;
    final radianBegin = begin.direction - center.direction;
    final r = math.pi * (clockwise ? 1 : -1);
    final radius = (begin - end).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  /// bezier quadratic
  static Offset Function(double) offsetBezierQuadratic({
    required Offset begin,
    required Offset end,
    required Offset controlPoint,
  }) {
    final vector1 = controlPoint - begin;
    final vector2 = end - controlPoint;
    return (t) {
      final a1 = begin + vector1 * t;
      final b1 = controlPoint + vector2 * t;
      return a1 + (b1 - a1) * t;
    };
  }

  static Offset Function(double) offsetBezierQuadraticSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5, // distance perpendicular
  }) =>
      offsetBezierQuadratic(
        begin: begin,
        end: end,
        controlPoint: (begin, end)._centerPerpendicularOf(dPerpendicular),
      );

  /// bezier cubic
  static Offset Function(double) offsetBezierCubic({
    required Offset begin,
    required Offset c1,
    required Offset c2,
    required Offset end,
  }) {
    final vector1 = c1 - begin;
    final vector2 = c2 - c1;
    final vector3 = end - c2;
    return (t) {
      final o = c1 + vector2 * t;
      final a1 = begin + vector1 * t;
      final a2 = a1 + (o - a1) * t;
      final b1 = c2 + vector3 * t;
      final b2 = o + (b1 - o) * t;
      return a2 + (b2 - a2) * t;
    };
  }

  static Offset Function(double) offsetBezierCubicSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 10,
    double dParallel = 1,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return offsetBezierCubic(begin: begin, end: end, c1: s.$1, c2: s.$2);
  }

  /// catmull rom
  static Offset Function(double) offsetCatmullRom({
    required List<Offset> controlPoints,
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

  static Offset Function(double) offsetCatmullRomSymmetry({
    required Offset begin,
    required Offset end,
    double dPerpendicular = 5,
    double dParallel = 2,
    double tension = 0.0,
    Offset? startHandle,
    Offset? endHandle,
  }) {
    final s = (begin, end)._symmetryInsert(dPerpendicular, dParallel);
    return offsetCatmullRom(
      controlPoints: [begin, end, s.$1, s.$2],
      tension: tension,
      startHandle: startHandle,
      endHandle: endHandle,
    );
  }

  ///
  ///
  ///
  static Path Function(Size) Function(ShapeBorder) pathAdjustShapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    Rect Function(Size size) sizingRect = _E._rectFull,
  }) =>
      outerPath
          ? (shape) => (size) => shape.getOuterPath(
                sizingRect(size),
                textDirection: textDirection,
              )
          : (shape) => (size) => shape.getInnerPath(
                sizingRect(size),
                textDirection: textDirection,
              );

  ///
  ///
  ///
  static Path Function(double) pathLine(
    Offset begin,
    Offset end,
    double width, {
    StrokeCap strokeCap = StrokeCap.round,
  }) {
    assert(strokeCap != StrokeCap.square);
    final direction = math.atan2(end.dy - begin.dy, end.dx - begin.dx),
        dTop = direction - _radian90,
        dBottom = direction + _radian90,
        radius = Radius.circular(width),
        pTop = begin + Offset.fromDirection(dTop, width),
        pBottom = begin + Offset.fromDirection(dBottom, width),
        lerpTop = Between(
          pTop,
          end + Offset.fromDirection(dTop, width),
        ).transform,
        lerpBottom = Between(
          pBottom,
          end + Offset.fromDirection(dBottom, width),
        ).transform;

    // StrokeCap.round
    if (strokeCap == StrokeCap.round) {
      final clockwise = direction.abs() < _radian90,
          beginPath = Path()
            ..moveTo(pBottom.dx, pBottom.dy)
            ..arcToPoint(pTop, radius: radius, clockwise: clockwise);
      return (t) {
        final tTop = lerpTop(t);
        return Path.from(beginPath)
          ..lineTo(tTop.dx, tTop.dy)
          ..arcToPoint(lerpBottom(t), radius: radius, clockwise: clockwise)
          ..close();
      };
    }

    // StrokeCap.butt
    final beginPath = Path()
      ..moveTo(pBottom.dx, pBottom.dy)
      ..lineTo(pTop.dx, pTop.dy);
    return (t) {
      final tTop = lerpTop(t), tBottom = lerpBottom(t);
      return Path.from(beginPath)
        ..lineTo(tTop.dx, tTop.dy)
        ..lineTo(tBottom.dx, tBottom.dy)
        ..close();
    };
  }

  ///
  /// RPC stands for Regular Polygon bezier-Cubic
  ///
  static Path Function(double) pathRPCOnEdge(
    int n,
    double rCircumscribe, {
    Offset center = Offset.zero,
    Between<double> edgeVectorTimes = const Between.of(0.0),
    Between<double> cornerRadius = const Between.of(0.0),
    CubicOffset Function(CubicOffset) cubicSwitch = _E._rpcSwitch_1342,
  }) {
    final lerpRadius = cornerRadius.transform,
        lerpTimes = edgeVectorTimes.transform,
        iLast = n - 1,
        rStep = math.pi * 2 / n,
        corners = List.generate(
          n,
          (i) => center + Offset.fromDirection(rStep * i, rCircumscribe),
          growable: false,
        ),
        tangent = math.tan(math.pi / n);

    return (t) {
      final timesUnit = lerpRadius(t) * tangent,
          times = lerpTimes(t),
          points = <CubicOffset>[];

      // find all 4 cubic points for each corners
      for (var i = 0; i < n; i++) {
        final current = corners[i];
        final previous = current._parallelOffsetUnitOf(
          i == 0 ? corners[iLast] : corners[i - 1],
          timesUnit,
        );
        final next = current._parallelOffsetUnitOf(
          i == iLast ? corners[0] : corners[i + 1],
          timesUnit,
        );
        points.add(cubicSwitch((
          previous,
          next,
          previous._parallelOffsetOf(current, times),
          current._parallelOffsetOf(next, times),
        )));
      }

      // create path
      final it = points.iterator;
      var path = Path();
      if (it.moveNext()) {
        final p = it.current, pA = p.$1, pB = p.$2, pC = p.$3, pD = p.$4;
        path = path
          ..moveTo(pA.dx, pA.dy)
          ..cubicTo(pB.dx, pB.dy, pC.dx, pC.dy, pD.dx, pD.dy);
      }
      while (it.moveNext()) {
        final p = it.current, pA = p.$1, pB = p.$2, pC = p.$3, pD = p.$4;
        path = path
          ..lineTo(pA.dx, pA.dy)
          ..cubicTo(pB.dx, pB.dy, pC.dx, pC.dy, pD.dx, pD.dy);
      }
      return path..close();
    };
  }
}

///
///
///
abstract final class Deviate<T> extends Matalue<T> {
  final T around;
  final T amplitude;

  const Deviate._(this.around, this.amplitude, super.curve);

  factory Deviate({required T around, required T amplitude, BiCurve? curve}) =>
      switch (around) {
        double _ => _DeviateDouble(around, amplitude as double, curve),
        Offset _ => _DeviateOffset(around, amplitude as Offset, curve),
        _ => throw UnimplementedError('$around, $amplitude, $curve'),
      } as Deviate<T>;

  @override
  String toString() => 'Deviate($around, $amplitude, $curve)';

  @override
  int get hashCode => Object.hash(around, amplitude, curve?.$1, curve?.$2);

  @override
  bool operator ==(covariant Deviate<T> other) =>
      around == other.around &&
      amplitude == other.amplitude &&
      curve == other.curve;
}

///
///
///
final class TransformTarget {
  final (double, double, double) translation;
  final (double, double, double) rotation;
  final (double, double, double) scale;

  @override
  String toString() => 'TransformTarget(\n$translation\n$rotation\n$scale\n)';

  const TransformTarget({
    this.translation = (0, 0, 0),
    this.rotation = (0, 0, 0),
    this.scale = (1, 1, 1),
  });
}
