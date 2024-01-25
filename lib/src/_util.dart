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
/// [AniDecider]
/// [MationBuilder], [MationMultiGenerator], [MationSequencer],
///
/// [FollowerInitializer]
/// [FabExpandableSetupInitializer]
///
///
/// global extensions:
/// [BetweenOffsetExtension], [BetweenCoordinateRadianExtension]
/// [FMationsGenerator]
/// [FBetween]
///
///
/// private typedef, extensions:
/// [_BetweenAnimation]
/// [_MationAnimating]
/// [_AnimationControllerExtension]
/// [_IterableMamionTransformBase], [IterableWidgetBuilderExtension]
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
    Companion<Iterable<Offset>, Size> adjust =
        IterableOffsetExtension.adjustCenterCompanion,
  }) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubic(polygon.cubicPoints),
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
    RRegularPolygon polygon,
    PaintFrom draw, {
    Widget? child,
  }) =>
      CustomPaint(
        painter: Painting.rRegularPolygon(draw, polygon),
        child: child,
      );
}

///
/// [rRectColored]
///
/// [pathReClipNever]
/// [pathRectFromZeroToSize]
/// [pathRRegularPolygonDecoratedBox]
///
extension WClipping on ClipPath {
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
  /// path with [Clipping]
  ///
  static ClipPath pathReClipNever({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath pathFromSize,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(pathFromSize),
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

  static ClipPath pathRRegularPolygonDecoratedBox(
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

typedef AnimationStatusController = void Function(
  AnimationStatus status,
  AnimationController controller,
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
  W newWidget,
);

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
/// ani
///
///
typedef AniDecider<T> = AniGeneral Function(T toggle);

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

extension BetweenOffsetExtension on Between<Offset> {
  double get direction => begin.directionTo(end);
}

extension BetweenCoordinateRadianExtension on Between<Coordinate> {
  static Between<Coordinate> toX360From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleX_360);

  static Between<Coordinate> toY360From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleY_360);

  static Between<Coordinate> toZ360From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleZ_360);

  static Between<Coordinate> toX180From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleX_180);

  static Between<Coordinate> toY180From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleY_180);

  static Between<Coordinate> toZ180From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleZ_180);

  static Between<Coordinate> toX90From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleX_90);

  static Between<Coordinate> toY90From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleY_90);

  static Between<Coordinate> toZ90From(Coordinate from) =>
      Between<Coordinate>(from, KRadianCoordinate.angleZ_90);

  ///
  /// see the comment above [Coordinate.transferToTransformOf]
  ///
  Between<Coordinate> get transferToTransform => Between(
        Coordinate.transferToTransformOf(begin),
        Coordinate.transferToTransformOf(end),
        curve: curve,
        onLerp: onLerp,
      );
}

///
///
///
/// mation
///
///
///
///

extension FMationsGenerator on MationMultiGenerator {
  static MationMultiGenerator fadeInRadiationStyle1(
    Generator<double> direction,
    double distance, {
    CurveFR? curve,
  }) =>
      (index) => MamionMulti([
            MamionTransition.fadeIn(curve: curve),
            MamionTransition.slide(
              FBetween.offsetOfDirection(
                direction(index),
                0,
                distance,
                curve: curve.nullOrTranslate(
                  (value) => CurveFR.intervalFlip(value, 0.2 * index, 1.0),
                ),
              ),
            ),
          ]);

  static MationMultiGenerator lineAndScale(Offset delta, {CurveFR? curve}) =>
      (index) => MamionMulti([
            MamionTransition.slide(FBetween.offsetZeroTo(
              delta * (index + 1).toDouble(),
              curve: curve,
            )),
            MamionTransition.scale(FBetween.doubleOneFrom(
              0.0,
              curve: curve.nullOrTranslate(
                (value) => CurveFR.intervalFlip(value, 0.2 * index, 1.0),
              ),
            )),
          ]);
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

class _BetweenAnimation<T> extends Animation<T>
    with AnimationWithParentMixin<double> {
  _BetweenAnimation(this.parent, this.between);

  @override
  final Animation<double> parent;

  final Between<T> between;

  @override
  T get value => between.evaluate(parent);

  @override
  String toString() => '$parent\u27A9$between\u27A9$value';

  @override
  String toStringDetails() => '${super.toStringDetails()} $between';
}

typedef _MationAnimating = Iterable<Animation> Function(_Mationable able);

extension _AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void addStatusListenerIfNotNull(AnimationStatusController? controller) {
    if (controller != null) {
      addStatusListener((status) => controller(status, this));
    }
  }
}
