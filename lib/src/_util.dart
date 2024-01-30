///
///
/// this file contains:
///
/// painting and clipping:
/// [Painting], [Clipping],
/// [WPainting], [WClipping]
///
///
/// typedefs:
/// [AnimationBuilder], [AnimationStatusController], [AnimatedStatefulWidgetUpdater]
/// [AnimationControllerInitializer]
/// [AnimationControllerDecider], [AnimationControllerDeciderTernary], ...
///
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
///
/// [MationBuilder], [MationMultiGenerator], [MationSequencer],
///
/// [FollowerInitializer]
/// [FabExpandableSetupInitializer]
///
/// global extensions:
/// [MationableValueDoubleExtension]
/// [BetweenOffsetExtension], [BetweenCoordinateExtension], [BetweenCoordinateRadianExtension]
/// [FBetween]
/// [FOnAnimateMatrix4]
///
///
/// private typedef, extensions:
/// [MationableValue], [_AnimationValue]
/// [_AnimatingMationable]
/// [_AnimationControllerExtension]
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
/// [_shouldRePaint]
/// [paintFrom]
/// [sizingPath]
/// [paintingPath]
///
/// [Painting.rePaintWhenUpdate]
/// [Painting.rePaintNever]
///
///
class Painting extends CustomPainter {
  final Combiner<Painting, bool> _shouldRePaint;
  final SizingPath sizingPath;
  final PaintFrom paintFrom;
  final PaintingPath paintingPath;

  @override
  void paint(Canvas canvas, Size size) {
    final path = sizingPath(size);
    final paint = paintFrom(canvas, size);
    paintingPath(canvas, paint, path);
  }

  @override
  bool shouldRepaint(Painting oldDelegate) => _shouldRePaint(oldDelegate, this);

  static bool _rePaintWhenUpdate(Painting oldP, Painting p) => true;

  static bool _rePaintNever(Painting oldP, Painting p) => false;

  const Painting.rePaintWhenUpdate({
    this.paintingPath = FPaintingPath.draw,
    required this.sizingPath,
    required this.paintFrom,
  }) : _shouldRePaint = _rePaintWhenUpdate;

  const Painting.rePaintNever({
    this.paintingPath = FPaintingPath.draw,
    required this.paintFrom,
    required this.sizingPath,
  }) : _shouldRePaint = _rePaintNever;

  ///
  /// factories
  ///
  factory Painting.rRegularPolygon(
    PaintFrom paintFrom,
    RRegularPolygon polygon,
  ) =>
      Painting.rePaintNever(
        paintFrom: paintFrom,
        sizingPath: FSizingPath.polygonCubic(polygon.cubicPoints),
      );
}

///
///
/// [_shouldReClip]
/// [sizingPath]
///
/// [Clipping.reclipWhenUpdate]
/// [Clipping.reclipNever]
///
/// [Clipping.rectOf]
/// [Clipping.rectFromZeroTo]
/// [Clipping.rectFromZeroToOffset]
/// [Clipping.rRegularPolygon]
///
///
class Clipping extends CustomClipper<Path> {
  final SizingPath sizingPath;
  final Combiner<Clipping, bool> _shouldReClip;

  @override
  Path getClip(Size size) => sizingPath(size);

  @override
  bool shouldReclip(Clipping oldClipper) => _shouldReClip(oldClipper, this);

  static bool _reclipWhenUpdate(Clipping oldC, Clipping c) => true;

  static bool _reclipNever(Clipping oldC, Clipping c) => false;

  const Clipping.reclipWhenUpdate(this.sizingPath)
      : _shouldReClip = _reclipWhenUpdate;

  const Clipping.reclipNever(this.sizingPath) : _shouldReClip = _reclipNever;

  ///
  /// factories
  ///
  factory Clipping.rectOf(Rect rect) =>
      Clipping.reclipNever(FSizingPath.rect(rect));

  factory Clipping.rectFromZeroTo(Size size) =>
      Clipping.rectOf(Offset.zero & size);

  factory Clipping.rectFromZeroToOffset(Offset corner) =>
      Clipping.rectOf(Rect.fromPoints(Offset.zero, corner));

  factory Clipping.rRegularPolygon(
    RRegularPolygon polygon, {
    Companion<CubicOffset, Size> adjust = CubicOffset.companionSizeAdjustCenter,
  }) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubic(polygon.cubicPoints, adjust: adjust),
      );
}

///
///
/// painting
///
///
///
extension WPainting on CustomPaint {
  static CustomPaint drawRRegularPolygon(
    RRegularPolygon polygon, {
    required PaintFrom pathFrom,
    Widget? child,
  }) =>
      CustomPaint(
        painter: Painting.rRegularPolygon(pathFrom, polygon),
        child: child,
      );
}

///
///
/// [WClipping._shape]
///   [WClipping.shapeCircle]
///   [WClipping.shapeOval]
///   [WClipping.shapeStar]
///   [WClipping.shapeStadium]
///   [WClipping.shapeBeveledRectangle]
///   [WClipping.shapeRoundedRectangle]
///   [WClipping.shapeContinuousRectangle]
///
/// [WClipping.rRectColored]
///
/// [WClipping.pathReClipNever]
/// [WClipping.pathRectFromZeroToSize]
/// [WClipping.pathPolygonRRegular]
/// [WClipping.pathPolygonRRegularDecoratedBox]
///
///
/// there is no [BorderSide] when using [ShapeBorderClipper], See Also the comment above [FBorderSide]
///
///
extension WClipping on ClipPath {
  static Widget _shape({
    required Key? key,
    required ShapeBorder shape,
    required Clip clipBehavior,
    required Widget? child,
  }) =>
      ClipPath.shape(
        key: key,
        shape: shape,
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeCircle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double eccentricity = 0.0,
  }) =>
      _shape(
        key: key,
        shape: CircleBorder(side: BorderSide.none, eccentricity: eccentricity),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeOval({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double eccentricity = 1.0,
  }) =>
      _shape(
        key: key,
        shape: OvalBorder(side: BorderSide.none, eccentricity: eccentricity),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeStar({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) =>
      _shape(
        key: key,
        shape: StarBorder(
          side: BorderSide.none,
          points: points,
          innerRadiusRatio: innerRadiusRatio,
          pointRounding: pointRounding,
          valleyRounding: valleyRounding,
          rotation: rotation,
          squash: squash,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeStadium({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) =>
      _shape(
        key: key,
        shape: const StadiumBorder(side: BorderSide.none),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeBeveledRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      _shape(
        key: key,
        shape: BeveledRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeRoundedRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      _shape(
        key: key,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeContinuousRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      _shape(
        key: key,
        shape: ContinuousRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static ClipRRect rRectColored({
    required BorderRadius borderRadius,
    required Color color,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) =>
      ClipRRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
        borderRadius: borderRadius,
        child: ColoredBox(
          color: color,
          child: child,
        ),
      );

  ///
  ///
  ///
  /// with [Clipping]
  ///
  ///
  ///
  static ClipPath pathReClipNever({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath sizingPath,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(sizingPath),
        child: child,
      );

  static ClipPath pathRectFromZeroToSize({
    Clip clipBehavior = Clip.antiAlias,
    required Size size,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.rectOf(Offset.zero & size),
        child: child,
      );

  static ClipPath pathPolygonRRegular(
    RRegularPolygon polygon, {
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    Companion<CubicOffset, Size> adjust = CubicOffset.companionSizeAdjustCenter,
  }) =>
      ClipPath(
        key: key,
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(
          FSizingPath.polygonCubic(polygon.cubicPoints, adjust: adjust),
        ),
        child: child,
      );

  static ClipPath pathPolygonRRegularDecoratedBox(
    Decoration decoration,
    RRegularPolygon polygon, {
    DecorationPosition position = DecorationPosition.background,
    Widget? child,
  }) =>
      ClipPath(
        clipper: Clipping.rRegularPolygon(polygon),
        child: DecoratedBox(
          decoration: decoration,
          position: position,
          child: child,
        ),
      );
}

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

typedef AnimatedStatefulWidgetUpdater<W extends StatefulWidget> = void Function(
  AnimationController controller,
  W oldWidget,
  W widget,
);

///
/// on (the type that may process in every tick)
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Coordinate>;

///
///
/// mations
///
///
typedef MationBuilder<M extends Mamionability> = Widget Function(
  BuildContext context,
  M mation,
);

typedef MationMultiGenerator = Generator<MamionMulti>;

typedef MationSequencer<T> = Translator<int, Mamionability> Function(
  AniSequenceStep previos,
  AniSequenceStep next,
  AniSequenceInterval interval,
);

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
  required BuildContext context,
  required Rect openIconRect,
  required Alignment openIconAlignment,
  required List<IconAction> icons,
});

extension MationableValueDoubleExtension on MationableValue<double> {
  static MationableValue<double> toRadianFrom(MationableValue<double> round) =>
      switch (round) {
        Between<double>() => Between(
            FRadian.radianFromRound(round.begin),
            FRadian.radianFromRound(round.end),
            curve: round.curve,
          ),
        Amplitude<double>() => Amplitude(
            FRadian.radianFromRound(round.from),
            FRadian.radianFromRound(round.value),
            round.times,
            style: round.style,
            curve: round.curve,
          ),
      };
}

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => begin.directionTo(end);
}

extension BetweenCoordinateExtension on Between<Coordinate> {
  ///
  /// see the comment above [Coordinate.transferToTransformOf]
  ///
  Between<Coordinate> get transferToTransform => Between.constant(
        Coordinate.transferToTransformOf(begin),
        Coordinate.transferToTransformOf(end),
        curve: curve,
        onLerp: onLerp,
      );
}

extension BetweenCoordinateRadianExtension on Between<CoordinateRadian> {
  static Between<CoordinateRadian> x360From(CoordinateRadian from) =>
      Between<CoordinateRadian>(from, CoordinateRadian.angleX_360);

  static Between<CoordinateRadian> y360From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleY_360);

  static Between<CoordinateRadian> z360From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleZ_360);

  static Between<CoordinateRadian> x180From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleX_180);

  static Between<CoordinateRadian> y180From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleY_180);

  static Between<CoordinateRadian> z180From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleZ_180);

  static Between<CoordinateRadian> x90From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleX_90);

  static Between<CoordinateRadian> y90From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleY_90);

  static Between<CoordinateRadian> z90From(CoordinateRadian from) =>
      Between(from, CoordinateRadian.angleZ_90);
}

extension FBetween on Between {
  ///
  ///
  /// [doubleKZero], [doubleKOne]
  /// [doubleZeroFrom], [doubleZeroTo]
  /// [doubleOneFrom], [doubleOneTo]
  /// [doubleZeroBeginOrEnd], [doubleOneBeginOrEnd]
  ///
  ///
  static Between<double> get doubleKZero => Between.of(0);

  static Between<double> get doubleKOne => Between.of(1);

  static Between<double> doubleZeroFrom(double begin, {CurveFR? curve}) =>
      Between(begin, 0, curve: curve);

  static Between<double> doubleZeroTo(double end, {CurveFR? curve}) =>
      Between(0, end, curve: curve);

  static Between<double> doubleOneFrom(double begin, {CurveFR? curve}) =>
      Between(begin, 1, curve: curve);

  static Between<double> doubleOneTo(double end, {CurveFR? curve}) =>
      Between(1, end, curve: curve);

  static Between<double> doubleZeroBeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between(isEndZero ? another : 0, isEndZero ? 0 : another, curve: curve);

  static Between<double> doubleOneBeginOrEnd(
    double another, {
    CurveFR? curve,
    required bool isEndOne,
  }) =>
      Between(isEndOne ? another : 1, isEndOne ? 1 : another, curve: curve);

  ///
  ///
  /// [offsetKZero]
  /// [offsetZeroFrom], [offsetZeroTo], [offsetZeroBeginOrEnd]
  /// [offsetOfDirection], [offsetOfDirectionZeroFrom], [offsetOfDirectionZeroTo]
  ///
  ///
  static Between<Offset> get offsetKZero => Between.of(Offset.zero);

  static Between<Offset> offsetZeroFrom(Offset begin, {CurveFR? curve}) =>
      Between(begin, Offset.zero, curve: curve);

  static Between<Offset> offsetZeroTo(Offset end, {CurveFR? curve}) =>
      Between(Offset.zero, end, curve: curve);

  static Between<Offset> offsetZeroBeginOrEnd(
    Offset another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between<Offset>(
        isEndZero ? another : Offset.zero,
        isEndZero ? Offset.zero : another,
        curve: curve,
      );

  static Between<Offset> offsetOfDirection(
    double direction,
    double begin,
    double end, {
    CurveFR? curve,
  }) =>
      Between(
        Offset.fromDirection(direction, begin),
        Offset.fromDirection(direction, end),
        curve: curve,
      );

  static Between<Offset> offsetOfDirectionZeroFrom(
    double direction,
    double begin, {
    CurveFR? curve,
  }) =>
      offsetOfDirection(direction, begin, 0, curve: curve);

  static Between<Offset> offsetOfDirectionZeroTo(
    double direction,
    double end, {
    CurveFR? curve,
  }) =>
      offsetOfDirection(direction, 0, end, curve: curve);

  ///
  ///
  /// [coordinateKZero]
  /// [coordinateZeroFrom], [coordinateZeroTo]
  /// [coordinateOneFrom], [coordinateOneTo]
  /// [coordinateZeroBeginOrEnd], [coordinateOneBeginOrEnd]
  ///
  ///
  static Between<Coordinate> get coordinateKZero => Between.of(Coordinate.zero);

  static Between<Coordinate> coordinateZeroFrom(
    Coordinate begin, {
    CurveFR? curve,
  }) =>
      Between<Coordinate>(begin, Coordinate.zero, curve: curve);

  static Between<Coordinate> coordinateZeroTo(
    Coordinate end, {
    CurveFR? curve,
  }) =>
      Between<Coordinate>(Coordinate.zero, end, curve: curve);

  static Between<Coordinate> coordinateOneFrom(
    Coordinate begin, {
    CurveFR? curve,
  }) =>
      Between<Coordinate>(begin, KCoordinate.cube_1, curve: curve);

  static Between<Coordinate> coordinateOneTo(
    Coordinate end, {
    CurveFR? curve,
  }) =>
      Between<Coordinate>(KCoordinate.cube_1, end, curve: curve);

  static Between<Coordinate> coordinateZeroBeginOrEnd(
    Coordinate another, {
    CurveFR? curve,
    required bool isEndZero,
  }) =>
      Between<Coordinate>(
        isEndZero ? another : Coordinate.zero,
        isEndZero ? Coordinate.zero : another,
        curve: curve,
      );

  static Between<Coordinate> coordinateOneBeginOrEnd(
    Coordinate another,
    CurveFR? curve, {
    required bool isEndOne,
  }) =>
      Between<Coordinate>(
        isEndOne ? another : Coordinate.one,
        isEndOne ? Coordinate.one : another,
        curve: curve,
      );
}

extension FAmplitude on Amplitude {
  ///
  /// [doubleFromZero], [doubleFromOne]
  ///
  static Amplitude<double> doubleFromZero(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(0, value, times, style: style);

  static Amplitude<double> doubleFromOne(
    double value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(1, value, times, style: style);

  ///
  /// [offsetFromZero], [coordinateFromZero]
  ///
  static Amplitude<Offset> offsetFromZero(
    Offset value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Offset.zero, value, times, style: style);

  static Amplitude<Coordinate> coordinateFromZero(
    Coordinate value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(Coordinate.zero, value, times, style: style);

  static Amplitude<CoordinateRadian> coordinateRadianFromZero(
    CoordinateRadian value,
    int times, {
    AmplitudeStyle style = AmplitudeStyle.sin,
    CurveFR? curve,
  }) =>
      Amplitude(CoordinateRadian.zero, value, times, style: style);
}

///
/// instance methods:
/// [getPerspective]
/// [setPerspective], [setDistance]
/// [copyPerspective], [identityPerspective]
///
/// [_translate], [_rotate], [_scaled]
///
/// static methods:
/// [translating], [rotating], [scaling]
/// [mapTranslating], [mapRotating], [mapScaling]
/// [fixedTranslating], [fixedRotating], [fixedScaling]
///
extension FOnAnimateMatrix4 on Matrix4 {
  double getPerspective() => entry(3, 2);

  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  Matrix4 get identityPerspective => Matrix4.identity()..copyPerspective(this);

  void _translate(Coordinate coordinate) =>
      translate(coordinate.dx, coordinate.dy, coordinate.dz);

  void _rotate(Coordinate coordinate) => this
    ..rotateX(coordinate.dx)
    ..rotateY(coordinate.dy)
    ..rotateZ(coordinate.dz);

  Matrix4 _scaled(Coordinate coordinate) => scaled(
        coordinate.dx,
        coordinate.dy,
        coordinate.dz,
      );

  ///
  ///
  /// statics
  ///
  ///
  static Matrix4 translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective.._translate(value);

  static Matrix4 rotating(Matrix4 matrix4, Coordinate value) =>
      matrix4..setRotation((Matrix4.identity().._rotate(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4._scaled(value);

// with mapper
  static OnAnimateMatrix4 mapTranslating(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        .._translate(mapper(value));

  static OnAnimateMatrix4 mapRotating(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity().._rotate(mapper(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4._scaled(mapper(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        .._translate(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity().._rotate(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
      (matrix4, value) => matrix4._scaled(value + fixed);
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

///
/// [onLerp], [curve],
/// [transform], [evaluate], [animate],
///
sealed class MationableValue<T> extends Animatable<T> {
  final OnLerp<T> onLerp;
  final CurveFR? curve;

  const MationableValue({
    required this.onLerp,
    this.curve,
  });

  @override
  T transform(double t) => onLerp(t);

  @override
  T evaluate(Animation<double> animation) => transform(animation.value);

  @override
  Animation<T> animate(Animation<double> parent) => _AnimationValue(
        CurvedAnimation(
          parent: parent,
          curve: curve?.forward ?? Curves.fastOutSlowIn,
          reverseCurve: curve?.reverse ?? Curves.fastOutSlowIn,
        ),
        this,
      );
}

class _AnimationValue<T> extends Animation<T>
    with AnimationWithParentMixin<double> {
  _AnimationValue(this.parent, this.animatable);

  @override
  final Animation<double> parent;

  final MationableValue<T> animatable;

  @override
  T get value => animatable.evaluate(parent);

  @override
  String toString() => '$parent\u27A9$animatable\u27A9$value';

  @override
  String toStringDetails() => '${super.toStringDetails()} $animatable';
}

typedef _AnimatingMationable = Iterable<Animation> Function(_Mationable able);

extension _AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);
}
