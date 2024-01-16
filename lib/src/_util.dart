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
/// [IfAnimating]
///
/// [AnimationBuilder]
/// [AnimationControllerInitializer]
/// [AnimationControllerDecider], [AnimationControllerDeciderTernary], ...
///
/// [AniDecider]
/// [MationBuilder], [MationSequencer],
///
/// [FollowerInitializer]
/// [FabExpandableSetupInitializer]
///
///
/// global extensions:
/// [BetweenDoubleExtension], [BetweenOffsetExtension]
/// [BetweenCoordinateExtension], [BetweenCoordinateRadianExtension]
/// [FMationsGenerator]
///
///
/// private typedef, extensions:
/// [_AnimationsBuilder]
/// [_AnimationControllerExtension]
/// [_IterableMationTransformBase]
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
/// [draw]
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

  static Between<Coordinate> get one => Between.constant(KCoordinate.cube_1);

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

extension _IterableMationTransformBase on Iterable<MationTransformBase> {
  Iterable<MationTransformBase> sort(List<OnAnimateMatrix4> order) {
    final map = Map.fromIterable(order, value: (_) => <MationTransformBase>[]);
    for (var delegate in this) {
      map[delegate.onAnimate]!.add(delegate);
    }
    return order.expand((onAnimate) => map[onAnimate]!);
  }
}
