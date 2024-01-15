///
///
/// this file contains:
/// [IfAnimating]
/// [AnimationBuilder]
/// [AnimationControllerInitializer]
/// [AnimationControllerDecider], [AnimationControllerDeciderTernary], ...
///
/// [MationBuilder], [MationSequencer],
/// [AniDecider], [AniDeciderTernary]
///
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
///
/// [FollowerInitializer]
/// [FabExpandableSetupInitializer]
///
///
/// global extensions:
/// [BetweenDoubleExtension], [BetweenOffsetExtension]
/// [BetweenCoordinateExtension], [BetweenCoordinateRadianExtension]
///
/// [FOnLerpSpline2D], [FOnAnimatePath]
///
/// [FMationsGenerator]
///
///
/// private typedef, extensions:
/// [_AnimationsBuilder]
/// [_AnimationControllerExtension]
/// [_FOnLerp], [_FOnAnimateMatrix4]
/// [_Matrix4Extension]
///
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives


typedef IfAnimating = void Function(
  AnimationController controller,
  bool isForward,
);

typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

typedef AnimationControllerDecider = Decider<AnimationController, bool>;
typedef AnimationControllerDeciderTernary = Decider<AnimationController, bool?>;

typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider tickerProvider,
  Duration forward,
  Duration reverse,
);

///
///
/// mations
///
///
typedef MationBuilder<T> = Widget Function(
  BuildContext context,
  MationBase<T> mation,
);

typedef MationsGenerator = Generator<Mations<dynamic, Mation<dynamic>>>;

typedef MationSequencer<T> = Translator<int, MationBase<T>> Function(
  MationSequenceStep previos,
  MationSequenceStep next,
  MationSequenceInterval interval,
);

///
///
/// ani
///
///
typedef AniDecider<T> = Ani Function(T toggle);


///
/// on (the type that may process in every tick)
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Coordinate>;

///
///
///
///
///

typedef FollowerInitializer
    = Supporter<OverlayInsertionFading<CompositedTransformFollower>> Function(
  LayerLink link,
);

typedef FabExpandableSetupInitializer = FabExpandableSetup Function({
  required DurationFR duration,
  required BuildContext context,
  required Rect openIconRect,
  required Alignment openIconAlignment,
  required List<IconAction> icons,
});


extension BetweenDoubleExtension on Between<double> {
  static Between<double> get zero => Between.constant(0);

  static Between<double> get k1 => Between.constant(1);

  static Between<double> zeroFrom(double v) => Between(begin: v, end: 0);

  static Between<double> zeroTo(double v) => Between(begin: 0, end: v);

  static Between<double> oneFrom(double v) => Between(begin: v, end: 1);

  static Between<double> oneTo(double v) => Between(begin: 1, end: v);

  static Between<double> o1From(double v) => Between(begin: v, end: 0.1);

  static Between<double> o1To(double v) => Between(begin: 0.1, end: v);
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => begin.directionTo(end);

  static Between<Offset> get zero => Between.constant(Offset.zero);

  static Between<Offset> zeroFrom(Offset begin, {CurveFR? curve}) =>
      Between(begin: begin, end: Offset.zero, curve: curve);

  static Between<Offset> zeroTo(Offset end, {CurveFR? curve}) =>
      Between(begin: Offset.zero, end: end, curve: curve);
}

extension BetweenCoordinateExtension on Between<Coordinate> {
  static Between<Coordinate> get zero => Between.constant(Coordinate.zero);

  static Between<Coordinate> zeroFrom(Coordinate begin, {CurveFR? curve}) =>
      Between<Coordinate>(begin: begin, end: Coordinate.zero, curve: curve);

  static Between<Coordinate> zeroTo(Coordinate end, {CurveFR? curve}) =>
      Between<Coordinate>(begin: Coordinate.zero, end: end, curve: curve);

  static Between<Coordinate> zeroBeginOrEnd(
      Coordinate another, {
        required bool isEndZero,
        CurveFR? curve,
      }) =>
      Between<Coordinate>(
        begin: isEndZero ? another : Coordinate.zero,
        end: isEndZero ? Coordinate.zero : another,
        curve: curve,
      );
}

extension BetweenCoordinateRadianExtension on Between<Coordinate> {
  static Between<Coordinate> get x_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_360);

  static Between<Coordinate> get y_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_360);

  static Between<Coordinate> get z_0_360 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_360);

  static Between<Coordinate> get x_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_180);

  static Between<Coordinate> get y_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_180);

  static Between<Coordinate> get z_0_180 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_180);

  static Between<Coordinate> get x_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleX_90);

  static Between<Coordinate> get y_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleY_90);

  static Between<Coordinate> get z_0_90 =>
      Between(begin: Coordinate.zero, end: KRadianCoordinate.angleZ_90);

  static Between<Coordinate> toX360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_360);

  static Between<Coordinate> toY360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_360);

  static Between<Coordinate> toZ360From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_360);

  static Between<Coordinate> toX180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_180);

  static Between<Coordinate> toY180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_180);

  static Between<Coordinate> toZ180From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_180);

  static Between<Coordinate> toX90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleX_90);

  static Between<Coordinate> toY90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleY_90);

  static Between<Coordinate> toZ90From(Coordinate from) =>
      Between<Coordinate>(begin: from, end: KRadianCoordinate.angleZ_90);

  Between<Coordinate> get transferToTransform => Between(
    begin: Coordinate.transferToTransformOf(begin),
    end: Coordinate.transferToTransformOf(end),
    curve: curve,
    onLerp: _onLerp,
  );
}

///
/// [FOnLerpSpline2D.arcOval]
/// [FOnLerpSpline2D.arcCircleSemi]
/// [FOnLerpSpline2D.bezierQuadratic]
/// [FOnLerpSpline2D.bezierQuadraticSymmetry]
/// [FOnLerpSpline2D.bezierCubic]
/// [FOnLerpSpline2D.bezierCubicSymmetry]
/// [FOnLerpSpline2D.catmullRom]
/// [FOnLerpSpline2D.catmullRomSymmetry]
///
/// See Also:
///   * [BetweenSpline2D]
///
///
extension FOnLerpSpline2D on OnLerp<Offset> {
  static OnLerp<Offset> arcOval(
      Offset origin,
      Between<double> direction,
      Between<double> radius,
      ) {
    final dOf = direction._onLerp;
    final rOf = radius._onLerp;
    Offset onLerp(double t) => Offset.fromDirection(dOf(t), rOf(t));
    return origin == Offset.zero ? onLerp : (t) => origin + onLerp(t);
  }

  static OnLerp<Offset> arcCircle(
      Offset origin,
      double radius,
      Between<double> direction,
      ) =>
      FOnLerpSpline2D.arcOval(origin, direction, Between.constant(radius));

  static OnLerp<Offset> arcCircleSemi(Offset a, Offset b, bool clockwise) {
    if (a == b) {
      return _FOnLerp.constant(a);
    }

    final center = a.middleWith(b);
    final radianBegin = center.directionTo(a);
    final r = clockwise ? KRadian.angle_180 : -KRadian.angle_180;
    final radius = (a - b).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  ///
  /// bezier quadratic
  ///
  static OnLerp<Offset> bezierQuadratic(
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

  static OnLerp<Offset> bezierQuadraticSymmetry(
      Offset begin,
      Offset end, {
        double dPerpendicular = 5, // distance perpendicular
      }) =>
      bezierQuadratic(
        begin,
        end,
        OffsetExtension.perpendicularOffsetUnitFromCenterOf(
          begin,
          end,
          dPerpendicular,
        ),
      );

  /// bezier cubic
  static OnLerp<Offset> bezierCubic(
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

  static OnLerp<Offset> bezierCubicSymmetry(
      Offset begin,
      Offset end, {
        double dPerpendicular = 10,
        double dParallel = 1,
      }) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return bezierCubic(begin, end, c1: list[1], c2: list[2]);
  }

  ///
  /// catmullRom
  ///
  static OnLerp<Offset> catmullRom(
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

  static OnLerp<Offset> catmullRomSymmetry(
      Offset begin,
      Offset end, {
        double dPerpendicular = 5,
        double dParallel = 2,
        double tension = 0.0,
        Offset? startHandle,
        Offset? endHandle,
      }) =>
      catmullRom(
        [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

extension FOnAnimatePath on OnAnimatePath {
  static OnAnimatePath<Offset> stadium(Offset o, double direction, double r) {
    Offset topOf(Offset p) => p.direct(direction - KRadian.angle_90, r);
    Offset bottomOf(Offset p) => p.direct(direction + KRadian.angle_90, r);
    final oTop = topOf(o);
    final oBottom = bottomOf(o);

    final radius = r.toCircularRadius;
    return (t, current) => (size) => Path()
      ..arcFromStartToEnd(oBottom, oTop, radius: radius)
      ..lineToPoint(topOf(current))
      ..arcToPoint(bottomOf(current), radius: radius)
      ..lineToPoint(oBottom);
  }

  static OnAnimatePath<Offset> lineStadium(Between<Offset> between, double w) =>
      stadium(between.begin, between.direction, w);

  static OnLerp<SizingPath> of<T>(
      OnAnimatePath<T> onAnimate,
      OnLerp<T> onLerp,
      ) =>
          (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> shapeBorder({
    bool outerPath = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) {
    final shaping = outerPath
        ? (s) => FSizingPath._shapeBorderOuter(s, sizingRect, textDirection)
        : (s) => FSizingPath._shapeBorderInner(s, sizingRect, textDirection);
    return (t, shape) => shaping(shape);
  }
}

///
///
///
/// mation
///
///
///
///

extension FMationsGenerator on MationsGenerator {
  static MationsGenerator fadeInRadiationStyle1(
      Generator<double> direction,
      double distance,
      CurveFR curve,
      ) =>
          (index) => Mations<dynamic, Mation>([
        MationTransitionDouble.fadeIn(curve: curve),
        MationTransitionOffset.ofDirection(
          direction(index),
          0,
          distance,
          curve: CurveFR.intervalFlip(0.2 * index, 1.0, curve),
        ),
      ]);

  static MationsGenerator lineAndScale(Offset delta, CurveFR curve) =>
          (index) => Mations<dynamic, Mation>([
        MationTransitionOffset.zeroTo(
          delta * (index + 1).toDouble(),
          curve: curve,
        ),
        MationTransitionDouble.scaleOneFrom(
          0.0,
          curve: CurveFR.intervalFlip(0.2 * index, 1.0, curve),
        ),
      ]);
}


///
///
///
/// 
/// 
/// 
/// 
/// 
/// private typedef, extensions
/// 
/// 
/// 
/// 
/// 
///
///
///
typedef _AnimationsBuilder<T> = Widget Function(
    Iterable<Animation<T>> animations,
    Widget child,
    );

extension _AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void addStatusListenerIfNotNull(AnimationStatusListener? listener) {
    if (listener != null) {
      addStatusListener(listener);
    }
  }
}

extension _FOnLerp on OnLerp {
  static OnLerp<T> constant<T>(T value) => (_) => value;

  static OnLerp<T> of<T>(T a, T b) => switch (a) {
    Size _ => _size(a, b as Size),
    Rect _ => _rect(a, b as Rect),
    Color _ => _color(a, b as Color),
    Vector3D _ => _vector(a, b as Vector3D),
    EdgeInsets _ => _edgeInsets(a, b as EdgeInsets),
    Decoration _ => _decoration(a, b as Decoration),
    ShapeBorder _ => _shapeBorder(a, b as ShapeBorder),
    RelativeRect _ => _relativeRect(a, b as RelativeRect),
    AlignmentGeometry _ => _alignmentGeometry(a, b as AlignmentGeometry),
    SizingPath _ => throw ArgumentError(
      'using BetweenPath constructor instead of Between<SizingPath>',
    ),
    _ => Tween<T>(begin: a, end: b).transform,
  } as OnLerp<T>;

  static OnLerp<Size> _size(Size a, Size b) => (t) => Size.lerp(a, b, t)!;

  static OnLerp<Rect> _rect(Rect a, Rect b) => (t) => Rect.lerp(a, b, t)!;

  static OnLerp<Color> _color(Color a, Color b) => (t) => Color.lerp(a, b, t)!;

  static OnLerp<Vector3D> _vector(Vector3D a, Vector3D b) =>
          (t) => Vector3D.lerp(a, b, t);

  static OnLerp<EdgeInsets> _edgeInsets(EdgeInsets a, EdgeInsets b) =>
          (t) => EdgeInsets.lerp(a, b, t)!;

  static OnLerp<RelativeRect> _relativeRect(RelativeRect a, RelativeRect b) =>
          (t) => RelativeRect.lerp(a, b, t)!;

  static OnLerp<AlignmentGeometry> _alignmentGeometry(
      AlignmentGeometry a,
      AlignmentGeometry b,
      ) =>
          (t) => AlignmentGeometry.lerp(a, b, t)!;

  ///
  ///
  /// See Also
  ///   * [FSizingPath.shapeBorder]
  ///
  ///
  static OnLerp<ShapeBorder> _shapeBorder(ShapeBorder a, ShapeBorder b) =>
      switch (a) {
        BoxBorder _ => switch (b) {
          BoxBorder _ => (t) => BoxBorder.lerp(a, b, t)!,
          _ => throw UnimplementedError(),
        },
        InputBorder _ => switch (b) {
          InputBorder _ => (t) => ShapeBorder.lerp(a, b, t)!,
          _ => throw UnimplementedError(),
        },
        OutlinedBorder _ => switch (b) {
          OutlinedBorder _ => (t) => OutlinedBorder.lerp(a, b, t)!,
          _ => throw UnimplementedError(),
        },
        _ => throw UnimplementedError(),
      };

  static OnLerp<Decoration> _decoration(Decoration a, Decoration b) =>
      switch (a) {
        BoxDecoration _ => b is BoxDecoration && a.shape == b.shape
            ? (t) => BoxDecoration.lerp(a, b, t)!
            : throw UnimplementedError('BoxShape should not be interpolated'),
        ShapeDecoration _ => switch (b) {
          ShapeDecoration _ => a.shape == b.shape
              ? (t) => ShapeDecoration.lerp(a, b, t)!
              : switch (a.shape) {
            CircleBorder _ || RoundedRectangleBorder _ => switch (
            b.shape) {
              CircleBorder _ || RoundedRectangleBorder _ => (t) =>
              Decoration.lerp(a, b, t)!,
              _ => throw UnimplementedError(
                "'$a shouldn't be interpolated to $b'",
              ),
            },
            _ => throw UnimplementedError(
              "'$a shouldn't be interpolated to $b'",
            ),
          },
          _ => throw UnimplementedError(),
        },
        _ => throw UnimplementedError(),
      };
}

extension _FOnAnimateMatrix4 on OnAnimateMatrix4 {
  static Matrix4 _scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4.scaledCoordinate(value);

  static Matrix4 _translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective..translateCoordinate(value);

  static Matrix4 _rotating(Matrix4 matrix4, Coordinate value) => matrix4
    ..setRotation((Matrix4.identity()..rotateCoordinate(value)).getRotation());

// ///
// /// with mapper
// ///
// static OnAnimateMatrix4 scaleMapping(Mapper<Coordinate> mapper) =>
//     (matrix4, value) => matrix4.scaledCoordinate(mapper(value));
//
// static OnAnimateMatrix4 translateMapping(Mapper<Coordinate> mapper) =>
//     (matrix4, value) => matrix4
//       ..identityPerspective
//       ..translateCoordinate(mapper(value));
//
// static OnAnimateMatrix4 rotateMapping(Mapper<Coordinate> mapper) =>
//     (matrix4, value) => matrix4
//       ..setRotation((Matrix4.identity()..rotateCoordinate(mapper(value)))
//           .getRotation());
//
// ///
// /// with fixed value
// ///
// static OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
//     (matrix4, value) => matrix4.scaledCoordinate(value + fixed);
//
// static OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
//     (matrix4, value) => matrix4
//       ..identityPerspective
//       ..translateCoordinate(value + fixed);
//
// static OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
//     (matrix4, value) => matrix4
//       ..setRotation((Matrix4.identity()..rotateCoordinate(fixed + value))
//           .getRotation());
}


extension _Matrix4Extension on Matrix4 {
  Matrix4 scaledCoordinate(Coordinate coordinate) => scaled(
    coordinate.dx,
    coordinate.dy,
    coordinate.dz,
  );

  void rotateCoordinate(Coordinate coordinate) => this
    ..rotateX(coordinate.dx)
    ..rotateY(coordinate.dy)
    ..rotateZ(coordinate.dz);

  void translateCoordinate(Coordinate coordinate) =>
      translate(coordinate.dx, coordinate.dy, coordinate.dz);

  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  double entryPerspective() => entry(3, 2);

  void copyPerspectiveFrom(Matrix4 matrix4) =>
      setPerspective(matrix4.entryPerspective());

  Matrix4 get identityPerspective =>
      Matrix4.identity()..copyPerspectiveFrom(this);
}
