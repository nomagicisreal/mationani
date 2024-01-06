part of 'mationani.dart';

///
/// this file contains:
/// [Predicator], [PredicatorTernary]
///
/// [Supplier]         (return value without argument)
/// [Consumer]         (return void, with 1 argument)
/// [Decider]          (return [Consumer], with 1 argument)
/// [Mapper]           (return value that has the same type with argument)
/// [Generator]        (return value from index)
/// [Translator]       (return valur from argument in different type)
/// [Sequencer]        (return [Translator]<[int], [R]> that comes from "previous", "next", "interval" for list generation)
/// [Companion]        (return value that has the same type with first argument with a companion argument)
///
/// [AnimationBuilder]
/// [AnimatingProcessor]
/// [AnimationControllerInitializer], [AnimationControllerDecider], [AnimationControllerDeciderTernary], ...
/// [MationBuilder], [MationSequencer],
/// [SizingPath], [SizingOffset], ..., [SizingPaintFromCanvas], ...
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
///
/// private usages:
/// [_AnimationsBuilder]
///
/// [_AnimationControllerExtension]
/// [_Matrix4Extension]
/// [_FOnLerp],
/// [_PathOperationExtension]
///
///

typedef Predicator<T> = bool Function(T a);
typedef PredicatorTernary<T> = bool? Function(T value);

// generics
typedef Supplier<T> = T Function();
typedef Consumer<T> = void Function(T value);
typedef Combiner<T, S> = S Function(T v1, T v2);
typedef Decider<T, S> = Consumer<T> Function(S toggle);
typedef Mapper<T> = T Function(T value);
typedef Generator<T> = T Function(int index);
typedef Translator<T, S> = S Function(T value);
typedef Sequencer<R, S, I> = Translator<int, R> Function(
  S previous,
  S next,
  I interval,
);
typedef Companion<T, S> = T Function(T host, S value);

///
/// others
///
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

typedef AnimatingProcessor = void Function(
  AnimationController controller,
  bool isForward,
);

typedef AnimationControllerDecider = Consumer<AnimationController> Function(
  bool toggle,
);

typedef AnimationControllerDeciderTernary = Consumer<AnimationController>
    Function(
  bool? toggle,
);

typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider tickerProvider,
  Duration forward,
  Duration reverse,
);

typedef MationBuilder<T> = Widget Function(
  BuildContext context,
  MationBase<T> mation,
);

typedef MationSequencer<T> = Translator<int, MationBase<T>> Function(
  MationSequenceStep previos,
  MationSequenceStep next,
  MationSequenceInterval interval,
);

///
///
/// sizing, painting
///
///
typedef SizingDouble = double Function(Size size);
typedef SizingOffset = Offset Function(Size size);
typedef SizingRect = Rect Function(Size size);
typedef SizingPath = Path Function(Size size);
typedef SizingPathWithRect = Path Function(Rect rect, Size size);
typedef SizingPathWithRRect = Path Function(RRect rect, Size size);
typedef SizingOffsetIterable = Iterable<Offset> Function(Size size);
typedef SizingOffsetList = List<Offset> Function(Size size);
typedef SizingPaintFromCanvas = Paint Function(Canvas canvas, Size size);
typedef PaintingPath = void Function(Canvas canvas, Paint paint, Path path);

///
///
///
///
///
///
/// extensions
///
///
///
///
///
///
extension FComparingPredicator on Combiner {
  static bool alwaysTrue<T>(T a, T? b) => true;

  static bool alwaysFalse<T>(T a, T? b) => false;

  static bool equal(bool a, bool? b) => a == b;

  static bool unequal(bool a, bool? b) => a != b;

  static bool intEqual(int a, int? b) => a == b;

  static bool intBigger(int a, int? b) => b != null && a > b;

  static bool intSmaller(int a, int? b) => b != null && a < b;
}

extension FComparingPredicatorTernary on Combiner {
  static bool? alwaysTrue<T>(T a, T? b) => true;

  static bool? alwaysFalse<T>(T a, T? b) => false;

  static bool? alwaysNull<T>(T a, T? b) => null;

  static bool? intEqualOrSmallerOrBigger(int? a, int? b) =>
      b == null || a == null
          ? null
          : switch (a - b) {
              0 => true,
              < 0 => false,
              _ => null,
            };
}

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

typedef _AnimationsBuilder<T> = Widget Function(
  Iterable<Animation<T>> animations,
  Widget child,
);

///
/// on (the type that may process in every tick)
///
/// [OnAnimateMatrix4]<[T]>:
/// - [double] for 2d scaling, rotation
/// - [Offset] for 2d translation
/// - [Coordinate] for 3D scaling, translation, rotation
///
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Coordinate>;

///
///
///
///
/// extensions
///
///
///
///

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

///
///
///
/// these are [Between] related extensions
///
///
///
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

extension _PathOperationExtension on PathOperation {
  SizingPath _combine(SizingPath previous, SizingPath next) =>
      (size) => Path.combine(this, previous(size), next(size));

  SizingPath _combineAll(Iterable<SizingPath> iterable) =>
      iterable.reduce((previous, next) => _combine(previous, next));
}
