part of 'mationani.dart';

///
/// this file contains:
/// primary collection:
/// [IterableExtension]
/// [IterableOffsetExtension], [IterableMapEntryExtension]
/// [ListExtension], [ListSetExtension], [ListRadiusExtension], [ListOffsetExtension]
/// [MapEntryExtension], [MapExtension]
///
/// typedefs:
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
/// [AnimatingProcessor]
/// [AnimationControllerDecider], [AnimationControllerDeciderTernary]
/// [SizingPath], [SizingRectingPath], [SizingRRectingPath], [SizingPaintFromCanvas]
///
/// [AnimationControllerInitializer],
/// [MationBuilder], [MationSequencer],
/// [AnimationBuilder]
/// [OnLerp], [OnAnimatePath]
///
/// private typedef, extensions:
/// [_AnimationsBuilder], [_OnAnimateMatrix4]
///
/// [_AnimatableExtension], [_AnimationControllerExtension]
/// [_Matrix4Extension]
/// [_FOnLerp], [_FOnLerpSpline2D], [_FOnAnimateMatrix4], [_FOnAnimatePath]
///
///

///
/// [mapToList]
/// [notContains]
/// [accompany], [foldWithIndex]
/// [flat]
/// [chunk]
///
extension IterableExtension<I> on Iterable<I> {
  bool get hasElement => !isEmpty;

  List<T> mapToList<T>(
    T Function(I element) mapper, {
    bool growable = false,
  }) =>
      map(mapper).toList(growable: growable);

  bool notContains(I element) => !contains(element);

  I reduceWithIndex(
    I Function(int i, I value, I element) combine, {
    bool isPreviousIndex = true,
  }) {
    int index = -1;
    return reduce((value, element) => combine(++index, value, element));
  }

  T foldWithIndex<T>(
    T initialValue,
    T Function(T current, I element, int i) combine,
  ) {
    int index = -1;
    return fold(
      initialValue,
      (previousValue, element) => combine(previousValue, element, ++index),
    );
  }

  T accompany<T, O>(
    T initialValue,
    List<O> another,
    T Function(T current, I element, O elementAnother) foldIterable,
  ) {
    assert(length == another.length, 'length must be equal');
    return foldWithIndex(
      initialValue,
      (previousValue, element, index) => foldIterable(
        previousValue,
        element,
        another[index],
      ),
    );
  }

  Iterable<T> flat<T>({bool isNested = false}) => fold<List<T>>(
        [],
        (list, element) => switch (element) {
          T() => list..add(element),
          Iterable<T>() => list..addAll(element),
          _ => throw UnimplementedError(),
        },
      );

  Iterable<Iterable<I>> chunk(Iterable<int> lengthOfEachChunk) {
    assert(lengthOfEachChunk.reduce((a, b) => a + b) == length);
    final list = toList(growable: false);
    final splitList = <List<I>>[];

    int start = 0;
    int end;
    for (var i in lengthOfEachChunk) {
      end = i + start;
      splitList.add(list.getRange(start, end).toList(growable: false));
      start = end;
    }
    return splitList;
  }
}

extension IterableOffsetExtension on Iterable<Offset> {
  Iterable<Offset> scaling(double value) => map((o) => o * value);

  Iterable<Offset> adjustCenterFor(
    Size size, {
    Offset origin = Offset.zero,
  }) {
    final center = size.center(origin);
    return map((p) => p + center);
  }
}

extension IterableMapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get toMap => Map.fromEntries(this);
}

///
///
/// [addIfNotNull]
/// [addFirstAndRemoveFirst]
/// [addFirstAndRemoveFirst]
/// [getOrDefault]
/// [removeFirst]
/// [sortAs]
/// [intersectionWith]
/// [differenceIndexWith]
/// [differenceWith]
///
///
extension ListExtension<T> on List<T> {
  static List<R> linking<R, S, I>({
    required int totalStep,
    required Generator<S> step,
    required Generator<I> interval,
    required Sequencer<R, S, I> sequencer,
  }) {
    final steps = List.generate(totalStep, step);
    final lengthIntervals = totalStep - 1;
    final intervals = List.generate(lengthIntervals, interval);

    final result = <R>[];

    S previous = steps.first;
    for (var i = 0; i < lengthIntervals; i++) {
      final next = steps[i + 1];
      result.add(sequencer(previous, next, intervals[i])(i));
      previous = next;
    }
    return result;
  }

  void addIfNotNull(T? element) => element == null ? null : add(element);

  void addFirstAndRemoveFirst() => this
    ..add(first)
    ..removeFirst();

  T addFirstAndRemoveFirstAndGet() => (this
        ..add(first)
        ..removeFirst())
      .last;

  T getOrDefault(int position, T defaultValue) =>
      position < length ? this[position] : defaultValue;

  T removeFirst() => removeAt(0);

  List<T> sortAs(List<int> newIndex) {
    final list = <T>[];
    final length = this.length;
    for (var index = 0; index < length; index++) {
      list.add(this[newIndex.firstWhere((i) => i == index)]);
    }
    return list;
  }

  /// see also [Set.intersection]
  Map<int, T> intersectionWith(List<T> others) {
    final maxLength = math.min(length, others.length);
    final intersection = <int, T>{};

    for (var index = 0; index < maxLength; index++) {
      final current = this[index];
      if (current == others[index]) {
        intersection.putIfAbsent(index, () => current);
      }
    }

    return intersection;
  }

  /// see also [Set.difference]
  List<int> differenceIndexWith(List<T> others) {
    final difference = <int>[];
    void put(int index) => difference.add(index);

    final differentiationLength = math.min(length, others.length);
    for (var index = 0; index < differentiationLength; index++) {
      final current = this[index];
      if (current != others[index]) put(index);
    }

    if (length > others.length) {
      for (var index = others.length; index < length; index++) {
        put(index);
      }
    }

    return difference;
  }

  Map<int, T> differenceWith(List<T> others) =>
      differenceIndexWith(others).fold(
        <int, T>{},
        (difference, i) => difference..putIfAbsent(i, () => this[i]),
      );

  Iterable<MapEntry<T, V>> combine<V>(
    List<V> values, {
    bool joinInValuesLength = true,
  }) sync* {
    final length = joinInValuesLength ? values.length : this.length;
    for (var i = 0; i < length; i++) {
      yield MapEntry(this[i], values[i]);
    }
  }
}

extension ListSetExtension<I> on List<Set<I>> {
  void forEachAddAll(List<Set<I>>? another) {
    if (another != null) {
      for (var i = 0; i < length; i++) {
        this[i].addAll(another[i]);
      }
    }
  }
}

extension ListRadiusExtension on List<Radius> {
  static List<Radius> generateCircular(int n, double radius) =>
      List.generate(n, (index) => Radius.circular(radius));
}

extension ListOffsetExtension on List<Offset> {
  List<Offset> symmetryInsert(
    double dPerpendicular,
    double dParallel,
  ) {
    final length = this.length;
    assert(length % 2 == 0);
    final insertionIndex = length ~/ 2;

    final begin = this[insertionIndex - 1];
    final end = this[insertionIndex];

    final unitParallel = OffsetExtension.parallelUnitOf(begin, end);
    final point =
        begin.middleWith(end) + unitParallel.toPerpendicular * dPerpendicular;

    return this
      ..insertAll(insertionIndex, [
        point - unitParallel * dParallel,
        point + unitParallel * dParallel,
      ]);
  }
}

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  MapEntry<V, K> get reversed => MapEntry(value, key);

  String joinKeyValue([String separator = '']) => '$key$separator$value';
}

extension MapExtension<K, V> on Map<K, V> {
  String join([String entrySeparator = '', String separator = '']) => entries
      .map((entry) => entry.joinKeyValue(entrySeparator))
      .join(separator);

  T fold<T>(
    T initialValue,
    T Function(T current, MapEntry<K, V> entry) foldMap,
  ) =>
      entries.fold<T>(
        initialValue,
        (previousValue, element) => foldMap(previousValue, element),
      );

  T foldWithIndex<T>(
    T initialValue,
    T Function(T current, MapEntry<K, V> entry, int entryIndex) foldMap,
  ) {
    int index = -1;
    return entries.fold<T>(
      initialValue,
      (previousValue, element) => foldMap(previousValue, element, ++index),
    );
  }

  void replaceAll(Iterable<K>? keys, V Function(V value) value) {
    if (keys != null) {
      for (var k in keys) {
        update(k, value);
      }
    }
  }

  bool notContainsKey(K key) => !containsKey(key);

  bool containsKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (notContainsKey(key)) {
        return false;
      }
    }
    return true;
  }
}

///
///
///
///
/// typedefs
///
///
///
///
///

///
/// predicator
///
typedef Predicator<T> = bool Function(T a);
typedef PredicatorTernary<T> = bool? Function(T value);

///
/// generics
///
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
/// processor
///
typedef AnimatingProcessor = void Function(
  AnimationController controller,
  bool isForward,
);

typedef CanvasProcessor = void Function(Canvas canvas, Paint paint, Path path);

///
///
/// decider
///
///
typedef AnimationControllerDecider = Consumer<AnimationController> Function(
  bool toggle,
);

typedef AnimationControllerDeciderTernary = Consumer<AnimationController>
    Function(
  bool? toggle,
);

///
///
/// sizing
///
///
typedef SizingDouble = double Function(Size size);
typedef SizingOffset = Offset Function(Size size);
typedef SizingRect = Rect Function(Size size);
typedef SizingPath = Path Function(Size size);
typedef SizingOffsetIterable = Iterable<Offset> Function(Size size);
typedef SizingRectingPath = Path Function(Rect rect, Size size);
typedef SizingRRectingPath = Path Function(RRect rect, Size size);
typedef SizingPaintFromCanvas = Paint Function(Canvas canvas, Size size);

///
/// initializer
///
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

///
/// builder
///
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);
typedef _AnimationsBuilder<T> = Widget Function(
  Iterable<Animation<T>> animations,
  Widget child,
);

///
/// on (the type that may process in every tick)
///
/// [_OnAnimateMatrix4]<[T]>:
/// - [double] for 2d scaling, rotation
/// - [Offset] for 2d translation
/// - [Coordinate] for 3D scaling, translation, rotation
///
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef _OnAnimateMatrix4 = Companion<Matrix4, Coordinate>;

///
///
///
///
/// extensions
///
///
///
///

extension _AnimatableExtension<T> on Animatable<T> {
  Animatable<T> curving(Curve curve) => chain(CurveTween(curve: curve));
}

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
        Size() => _size(a, b as Size),
        Rect() => _rect(a, b as Rect),
        Color() => _color(a, b as Color),
        Vector3D() => _vector(a, b as Vector3D),
        EdgeInsets() => _edgeInsets(a, b as EdgeInsets),
        Decoration() => _decoration(a, b as Decoration),
        ShapeBorder() => _shapeBorder(a, b as ShapeBorder),
        RelativeRect() => _relativeRect(a, b as RelativeRect),
        AlignmentGeometry() => _alignmentGeometry(
            a,
            b as AlignmentGeometry,
          ),
        SizingPath() => throw ArgumentError(
            'plz using BetweenPath constructor instead of Between<SizingPath>',
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
  /// TODO: lerp between difference [ShapeBorder], migrate with [RRegularPolygon]
  ///
  /// See Also
  ///   * [BetweenPath.shapeBorder] ...
  ///   * [FSizingPath.shapeBorder]
  ///   * [_FOnAnimatePath.shapeOuterLtr] ...
  ///   * [KBoxBorder] ...
  ///
  ///
  static OnLerp<ShapeBorder> _shapeBorder(ShapeBorder a, ShapeBorder b) =>
      switch (a) {
        BoxBorder() => switch (b) {
            BoxBorder() => (t) => BoxBorder.lerp(a, b, t)!,
            _ => throw UnimplementedError(),
          },
        InputBorder() => switch (b) {
            InputBorder() => (t) => ShapeBorder.lerp(a, b, t)!,
            _ => throw UnimplementedError(),
          },
        OutlinedBorder() => switch (b) {
            OutlinedBorder() => (t) => OutlinedBorder.lerp(a, b, t)!,
            _ => throw UnimplementedError(),
          },
        _ => throw UnimplementedError(),
      };

  static OnLerp<Decoration> _decoration(Decoration a, Decoration b) =>
      switch (a) {
        BoxDecoration() => b is BoxDecoration && a.shape == b.shape
            ? (t) => BoxDecoration.lerp(a, b, t)!
            : throw UnimplementedError('BoxShape should not be interpolated'),
        ShapeDecoration() => switch (b) {
            ShapeDecoration() => a.shape == b.shape
                ? (t) => ShapeDecoration.lerp(a, b, t)!
                : switch (a.shape) {
                    CircleBorder() || RoundedRectangleBorder() => switch (
                          b.shape) {
                        CircleBorder() || RoundedRectangleBorder() => (t) =>
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

///
///
/// [_FOnLerpSpline2D.arcOval]
/// [_FOnLerpSpline2D.arcCircleSemi]
/// [_FOnLerpSpline2D.bezierQuadratic]
/// [_FOnLerpSpline2D.bezierQuadraticSymmetry]
/// [_FOnLerpSpline2D.bezierCubic]
/// [_FOnLerpSpline2D.bezierCubicSymmetry]
/// [_FOnLerpSpline2D.catmullRom]
/// [_FOnLerpSpline2D.catmullRomSymmetry]
///
/// See Also:
///   * [BetweenSpline2D]
///
///
extension _FOnLerpSpline2D on OnLerp<Offset> {
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
    Offset o,
    double r,
    Between<double> direction,
  ) =>
      _FOnLerpSpline2D.arcOval(o, direction, Between.constant(r));

  static OnLerp<Offset> arcCircleSemi(
    Offset begin,
    Offset end,
    bool isClockwise,
  ) {
    if (begin == end) {
      return _FOnLerp.constant(begin);
    }

    final center = begin.middleWith(end);
    final radianBegin = center.directionTo(begin);
    final r = isClockwise ? KRadian.angle_180 : -KRadian.angle_180;
    final radius = (begin - end).distance / 2;

    return (t) => center + Offset.fromDirection(radianBegin + r * t, radius);
  }

  /// bezier quadratic
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
    Offset end,
    double dp, // distance perpendicular
  ) =>
      bezierQuadratic(
        begin,
        end,
        OffsetExtension.perpendicularOffsetUnitFromCenterOf(begin, end, dp),
      );

  /// bezier cubic
  static OnLerp<Offset> bezierCubic(
    Offset begin,
    Offset end,
    Offset c1,
    Offset c2,
  ) {
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
    Offset end,
    double dPerpendicular,
    double dParallel,
  ) {
    final list = [begin, end].symmetryInsert(dPerpendicular, dParallel);
    return bezierCubic(begin, end, list[1], list[2]);
  }

  /// catmullRow
  static OnLerp<Offset> catmullRom(
    List<Offset> controlPoints, {
    required double tension,
    required Offset? startHandle,
    required Offset? endHandle,
  }) =>
      CatmullRomSpline.precompute(
        controlPoints,
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      ).transform;

  static OnLerp<Offset> catmullRomSymmetry({
    required Offset begin,
    required Offset end,
    required double dPerpendicular,
    required double dParallel,
    required double tension,
    required Offset? startHandle,
    required Offset? endHandle,
  }) =>
      catmullRom(
        [begin, end].symmetryInsert(dPerpendicular, dParallel),
        tension: tension,
        startHandle: startHandle,
        endHandle: endHandle,
      );
}

extension _FOnAnimateMatrix4 on _OnAnimateMatrix4 {
  static Matrix4 scaling(Matrix4 matrix4, Coordinate value) =>
      matrix4.scaledCoordinate(value);

  static Matrix4 translating(Matrix4 matrix4, Coordinate value) =>
      matrix4.identityPerspective..translateCoordinate(value);

  static Matrix4 rotating(Matrix4 matrix4, Coordinate value) => matrix4
    ..setRotation((Matrix4.identity()..rotateCoordinate(value)).getRotation());

  ///
  /// with mapper
  ///
  static _OnAnimateMatrix4 scaleMapping(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4.scaledCoordinate(mapper(value));

  static _OnAnimateMatrix4 translateMapping(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        ..translateCoordinate(mapper(value));

  static _OnAnimateMatrix4 rotateMapping(Mapper<Coordinate> mapper) =>
      (matrix4, value) => matrix4
        ..setRotation((Matrix4.identity()..rotateCoordinate(mapper(value)))
            .getRotation());

  ///
  /// with fixed value
  ///
  static _OnAnimateMatrix4 fixedScaling(Coordinate fixed) =>
      (matrix4, value) => matrix4.scaledCoordinate(value + fixed);

  static _OnAnimateMatrix4 fixedTranslating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        ..translateCoordinate(value + fixed);

  static _OnAnimateMatrix4 fixedRotating(Coordinate fixed) =>
      (matrix4, value) => matrix4
        ..setRotation((Matrix4.identity()..rotateCoordinate(fixed + value))
            .getRotation());
}

extension _FOnAnimatePath on OnAnimatePath {
  static OnAnimatePath<Offset> stadium(
    Offset o,
    double direction,
    double r,
  ) {
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

  static OnLerp<SizingPath> of<T>(
    OnAnimatePath<T> onAnimate,
    OnLerp<T> onLerp,
  ) =>
      (t) => onAnimate(t, onLerp(t));

  static OnAnimatePath<ShapeBorder> shapeBorder({
    bool isOuter = true,
    TextDirection? textDirection,
    SizingRect sizingRect = FSizingRect.full,
  }) =>
      isOuter
          ? (t, shape) => (size) =>
              shape.getOuterPath(sizingRect(size), textDirection: textDirection)
          : (t, shape) => (size) => shape.getInnerPath(sizingRect(size),
              textDirection: textDirection);
}
