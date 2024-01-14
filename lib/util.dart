part of 'mationani.dart';

///
/// this file contains:
///
/// [Predicator], [PredicatorTernary]
///
/// [Supplier]         (return value without argument)
/// [Consumer]         (return void, with 1 argument)
/// [Decider]          (return [Consumer], with 1 argument)
/// [Mapper]           (return value that has the same type with argument)
/// [Generator]        (return value from index)
/// [Supporter]        (return value from index [Supplier])
/// [Translator]       (return valur from argument in different type)
/// [Sequencer]        (return [Translator]<[int], [R]> that comes from "previous", "next", "interval" for list generation)
/// [Companion]        (return value that has the same type with first argument with a companion argument)
/// ?? [Conductor]                   (with 2 argument, return void)
/// ?? [Reducer]                     (return value that comes from two argument with same type)
///
/// [IfAnimating]
/// [AnimationBuilder]
/// [AnimationControllerInitializer], [AnimationControllerDecider], [AnimationControllerDeciderTernary], ...
/// [MationBuilder], [MationSequencer],
/// [SizingPath], [SizingOffset], ..., [SizingPaintFromCanvas], ..., [RectBuilder]
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
///
/// [FollowerInitializer]
/// [FabExpandableSetupInitializer]
///
///
///
///
///
///
///
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
typedef Supporter<T> = T Function(Supplier<int> indexing);
typedef Translator<T, S> = S Function(T value);
typedef Sequencer<R, S, I> = Translator<int, R> Function(
  S previous,
  S next,
  I interval,
);
typedef Companion<T, S> = T Function(T host, S value);
// typedef Conductor<T> = void Function(T a, T b);
// typedef Reducer<T> = T Function(T v1, T v2);

///
/// others
///
typedef IfAnimating = void Function(
  AnimationController controller,
  bool isForward,
);

typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
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
typedef Sizing = Size Function(Size size);
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

typedef RectBuilder = Rect Function(BuildContext context);

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
