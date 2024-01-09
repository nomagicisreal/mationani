part of '../mationani.dart';

///
/// this file contains:
///
/// [NumExtension], [DoubleExtension], [IntExtension]
/// [SizeExtension], [OffsetExtension], [RectExtension]
/// [AlignmentExtension]
/// [DurationExtension], [CurveExtension]
///
/// [BetweenDoubleExtension], [BetweenOffsetExtension]
/// [BetweenCoordinateExtension], [BetweenCoordinateRadianExtension]
///
/// [IterableExtension]
/// [IterableIntExtension], [IterableOffsetExtension], [IterableTimerExtension]
/// [IterableIterableExtension], [IterableSetExtension]
///
/// [ListExtension]
/// [ListOffsetExtension]
/// [ListSetExtension]
///
/// [MapEntryExtension]
/// [MapEntryIterableExtension]
/// [MapExtension]
///
///
///

extension NumExtension on num {
  num get square => math.pow(this, 2);

  bool isSmallerOrEqualTo(int value) => this == value || this < value;

  bool isLessOneOrEqualTo(int value) => this == value || this + 1 == value;

  bool isHigherOrEqualTo(int value) => this == value || this > value;

  bool isHigherOneOrEqualTo(int value) => this == value || this == value + 1;
}

extension DoubleExtension on double {
  static final double infinity2_31 = DoubleExtension.proximateInfinityOf(2.31);
  static final double infinity3_2 = DoubleExtension.proximateInfinityOf(3.2);
  static const double sqrt2 = math.sqrt2;
  static const double sqrt3 = 1.7320508075688772;
  static const double sqrt5 = 2.23606797749979;
  static const double sqrt6 = 2.44948974278317;
  static const double sqrt7 = 2.6457513110645907;
  static const double sqrt8 = 2.8284271247461903;
  static const double sqrt10 = 3.1622776601683795;
  static const double sqrt1_2 = math.sqrt1_2;
  static const double sqrt1_3 = 0.5773502691896257;
  static const double sqrt1_5 = 0.4472135954999579;
  static const double sqrt1_6 = 0.408248290463863;
  static const double sqrt1_7 = 0.3779644730092272;
  static const double sqrt1_8 = 0.3535533905932738;
  static const double sqrt1_10 = 0.31622776601683794;

  Radius get toCircularRadius => Radius.circular(this);

  bool get isNearlyInt => (ceil() - this) <= 0.01;

  ///
  /// infinity usages
  ///

  static double proximateInfinityOf(double precision) =>
      1.0 / math.pow(0.1, precision);

  static double proximateNegativeInfinityOf(double precision) =>
      -1.0 / math.pow(0.1, precision);

  double filterInfinity(double precision) => switch (this) {
        double.infinity => proximateInfinityOf(precision),
        double.negativeInfinity => proximateNegativeInfinityOf(precision),
        _ => this,
      };
}

extension IntExtension on int {
  int get accumulate {
    assert(!isNegative && this != 0, 'invalid accumulate integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator += i;
    }
    return accelerator;
  }

  int get factorial {
    assert(!isNegative && this != 0, 'invalid factorial integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator *= i;
    }
    return accelerator;
  }

  static List<int> accumulationTo(int end, {int start = 0}) {
    final list = <int>[];
    for (int i = start; i <= end; i++) {
      list.add(i.accumulate);
    }
    return list;
  }
}

extension SizeExtension on Size {
  double get diagonal => math.sqrt(width * width + height * height);

  Radius get toRadiusEllipse => Radius.elliptical(width, height);

  Size extrudeHeight(double ratio) => Size(width, width * ratio);

  Size extrudeWidth(double ratio) => Size(height * ratio, height);
}

extension OffsetExtension on Offset {
  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Coordinate get toCoordinate => Coordinate.ofXY(dx, dy);

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
  ///

  ///
  ///
  /// instance methods
  ///
  ///
  String toStringAsFixed1() =>
      '(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';

  double directionTo(Offset p) => (p - this).direction;

  double distanceTo(Offset p) => (p - this).distance;

  double distanceHalfTo(Offset p) => (p - this).distance / 2;

  Offset middleWith(Offset p) => (p + this) / 2;

  Offset direct(double direction, [double distance = 1]) =>
      this + Offset.fromDirection(direction, distance);

  double directionPerpendicular({bool isCounterclockwise = true}) =>
      direction + math.pi / 2 * (isCounterclockwise ? 1 : -1);

  Offset get toPerpendicularUnit =>
      Offset.fromDirection(directionPerpendicular());

  Offset get toPerpendicular =>
      Offset.fromDirection(directionPerpendicular(), distance);

  bool isAtBottomRightOf(Offset offset) => this > offset;

  bool isAtTopLeftOf(Offset offset) => this < offset;

  bool isAtBottomLeftOf(Offset offset) => dx < offset.dx && dy > offset.dy;

  bool isAtTopRightOf(Offset offset) => dx > offset.dx && dy < offset.dy;

  ///
  ///
  /// instance getters
  ///
  ///

  Size get toSize => Size(dx, dy);

  Offset get toReciprocal => Offset(1 / dx, 1 / dy);

  ///
  ///
  /// static methods:
  ///
  ///
  static Offset square(double value) => Offset(value, value);

  ///
  /// [parallelUnitOf]
  /// [parallelVectorOf]
  /// [parallelOffsetOf]
  /// [parallelOffsetUnitOf]
  /// [parallelOffsetUnitOnCenterOf]
  ///
  static Offset parallelUnitOf(Offset a, Offset b) {
    final offset = b - a;
    return offset / offset.distance;
  }

  static Offset parallelVectorOf(Offset a, Offset b, double t) => (b - a) * t;

  static Offset parallelOffsetOf(Offset a, Offset b, double t) =>
      a + parallelVectorOf(a, b, t);

  static Offset parallelOffsetUnitOf(Offset a, Offset b, double t) =>
      a + parallelUnitOf(a, b) * t;

  static Offset parallelOffsetUnitOnCenterOf(Offset a, Offset b, double t) =>
      a.middleWith(b) + parallelUnitOf(a, b) * t;

  ///
  /// [perpendicularUnitOf]
  /// [perpendicularVectorOf]
  /// [perpendicularOffsetOf]
  /// [perpendicularOffsetUnitOf]
  /// [perpendicularOffsetUnitFromCenterOf]
  ///
  static Offset perpendicularUnitOf(Offset a, Offset b) =>
      (b - a).toPerpendicularUnit;

  static Offset perpendicularVectorOf(Offset a, Offset b, double t) =>
      (b - a).toPerpendicular * t;

  static Offset perpendicularOffsetOf(Offset a, Offset b, double t) =>
      a + perpendicularVectorOf(a, b, t);

  static Offset perpendicularOffsetUnitOf(Offset a, Offset b, double t) =>
      a + perpendicularUnitOf(a, b) * t;

  static Offset perpendicularOffsetUnitFromCenterOf(
    Offset a,
    Offset b,
    double t,
  ) =>
      a.middleWith(b) + perpendicularUnitOf(a, b) * t;
}

extension RectExtension on Rect {
  static Rect fromLTSize(double left, double top, Size size) =>
      Rect.fromLTWH(left, top, size.width, size.height);

  static Rect fromOffsetSize(Offset zero, Size size) =>
      Rect.fromLTWH(zero.dx, zero.dy, size.width, size.height);

  static Rect fromCenterSize(Offset center, Size size) =>
      Rect.fromCenter(center: center, width: size.width, height: size.height);

  static Rect fromCircle(Offset center, double radius) =>
      Rect.fromCircle(center: center, radius: radius);

  double get distanceDiagonal => size.diagonal;

  Offset offsetFromAlignment(Alignment value) => switch (value) {
        Alignment.topLeft => topLeft,
        Alignment.topCenter => topCenter,
        Alignment.topRight => topRight,
        Alignment.centerLeft => centerLeft,
        Alignment.center => center,
        Alignment.centerRight => centerRight,
        Alignment.bottomLeft => bottomLeft,
        Alignment.bottomCenter => bottomCenter,
        Alignment.bottomRight => bottomRight,
        _ => throw UnimplementedError(),
      };

  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Offset offsetFromDirection(Direction2DIn8 value) => switch (value) {
        Direction2DIn8.topLeft => topLeft,
        Direction2DIn8.top => topCenter,
        Direction2DIn8.topRight => topRight,
        Direction2DIn8.left => centerLeft,
        Direction2DIn8.right => centerRight,
        Direction2DIn8.bottomLeft => bottomLeft,
        Direction2DIn8.bottom => bottomCenter,
        Direction2DIn8.bottomRight => bottomRight,
      };

  Rect expandToIncludeDirection({
    required Direction2DIn8 direction,
    required double width,
    required double length,
  }) {
    final start = offsetFromDirection(direction);
    return expandToInclude(
      switch (direction) {
        Direction2DIn8.top => Rect.fromPoints(
            start + Offset(width / 2, 0),
            start + Offset(-width / 2, -length),
          ),
        Direction2DIn8.bottom => Rect.fromPoints(
            start + Offset(width / 2, 0),
            start + Offset(-width / 2, length),
          ),
        Direction2DIn8.left => Rect.fromPoints(
            start + Offset(0, width / 2),
            start + Offset(-length, -width / 2),
          ),
        Direction2DIn8.right => Rect.fromPoints(
            start + Offset(0, width / 2),
            start + Offset(length, -width / 2),
          ),
        Direction2DIn8.topLeft => Rect.fromPoints(
            start,
            start + Offset(-length, -length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.topRight => Rect.fromPoints(
            start,
            start + Offset(length, -length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.bottomLeft => Rect.fromPoints(
            start,
            start + Offset(-length, length) * DoubleExtension.sqrt1_2,
          ),
        Direction2DIn8.bottomRight => Rect.fromPoints(
            start,
            start + Offset(length, length) * DoubleExtension.sqrt1_2,
          ),
      },
    );
  }

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
}

extension AlignmentExtension on Alignment {
  double get radianRangeForSide {
    final boundary = radianBoundaryForSide;
    return boundary.$2 - boundary.$1;
  }

  (double, double) get radianBoundaryForSide => switch (this) {
        Alignment.center => (0, KRadian.angle_360),
        Alignment.centerLeft => (-KRadian.angle_90, KRadian.angle_90),
        Alignment.centerRight => (KRadian.angle_90, KRadian.angle_270),
        Alignment.topCenter => (0, KRadian.angle_180),
        Alignment.topLeft => (0, KRadian.angle_90),
        Alignment.topRight => (KRadian.angle_90, KRadian.angle_180),
        Alignment.bottomCenter => (KRadian.angle_180, KRadian.angle_360),
        Alignment.bottomLeft => (KRadian.angle_270, KRadian.angle_360),
        Alignment.bottomRight => (KRadian.angle_180, KRadian.angle_270),
        _ => throw UnimplementedError(),
      };

  double radianRangeForSideStepOf(int count) =>
      radianRangeForSide / (this == Alignment.center ? count : count - 1);

  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Generator<double> directionOfSideSpace(bool isClockwise, int count) {
    final boundary = radianBoundaryForSide;
    final origin = isClockwise ? boundary.$1 : boundary.$2;
    final step = radianRangeForSideStepOf(count);

    return isClockwise
        ? (index) => origin + step * index
        : (index) => origin - step * index;
  }

  ///
  /// ------------------------------------------------------------------------------------------------------
  ///
  ///
}

extension DurationExtension on Duration {
  DurationFR get toDurationFR => DurationFR.constant(this);
}

extension CurveExtension on Curve {
  CurveFR get toCurveFR => CurveFR(this, this);
}

///
///
/// between
///
///

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
}

///
///
///
///
///
///
/// collection extension
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
/// [hasElement], [notContains], [search]
/// [mapToList]
/// [reduceWithIndex], [foldWithIndex], [accompany],
/// [flat], [chunk]
///
///
extension IterableExtension<I> on Iterable<I> {
  bool get hasElement => !isEmpty;

  bool notContains(I element) => !contains(element);

  I? search(I value) {
    try {
      return firstWhere((element) => element == value);
    } catch (_) {
      return null;
    }
  }

  List<T> mapToList<T>(
    T Function(I element) mapper, {
    bool growable = false,
  }) =>
      map(mapper).toList(growable: growable);

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

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.chunk([2, 1, 3, 1]); // [[2, 3], [4], [6, 10, 3], [9]]
  ///
  List<List<I>> chunk(Iterable<int> lengthOfEachChunk) {
    assert(lengthOfEachChunk.reduce((a, b) => a + b) == length);
    final list = toList(growable: false);
    final splitList = <List<I>>[];

    int start = 0;
    int end;
    for (var i in lengthOfEachChunk) {
      end = i + start;
      splitList.add(list.sublist(start, end));
      start = end;
    }
    return splitList;
  }
}

extension IterableIntExtension on Iterable<num> {
  num get summary => reduce((value, element) => value + element);
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

  static Mapper<Iterable<Offset>> scalingMapper(double scale) =>
      scale == 1 ? FMapper.ofOffsetIterable : (points) => points.scaling(scale);

  static Iterable<Offset> adjustCenterCompanion(
    Iterable<Offset> points,
    Size size,
  ) =>
      points.adjustCenterFor(size);
}

extension IterableTimerExtension on Iterable<Timer> {
  void cancelAll() {
    for (var t in this) {
      t.cancel();
    }
  }
}

extension IterableIterableExtension<T> on Iterable<Iterable<T>> {
  String mapToStringJoin([
    String Function(Iterable<T> e)? mapper,
    String separator = "\n",
  ]) =>
      map(mapper ?? (e) => e.toString()).join(separator);
}

extension IterableSetExtension<I> on Iterable<Set<I>> {
  Set<I> mergeAll() => reduce((a, b) => a..addAll(b));
}

///
///
/// instance methods:
/// [swap]
/// [add2]
/// [addIfNotNull]
/// [addFirstAndRemoveFirst]
/// [addFirstAndRemoveFirstAndGet]
/// [getOrDefault]
/// [removeFirst]
/// [rearrangeAs]
/// [intersectionWith]
/// [differenceWith], [differenceIndexWith]
/// [combine]
///
/// static methods:
/// [linking]
///
///
extension ListExtension<T> on List<T> {
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }

  void add2(T e1, T e2) => this
    ..add(e1)
    ..add(e2);

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

  Iterable<T> removeWhereAndGet(Predicator<T> predicator) {
    final length = this.length;
    final list = <T>[];
    for (var i = 0; i < length; i++) {
      if (predicator(this[i])) {
        list.add(removeAt(i));
      }
    }
    return list;
  }

  ///
  ///
  /// overall operations
  /// [rearrangeAs]
  /// [split], [splitTwo]
  ///

  ///
  /// list = [2, 3, 4, 6];
  /// list.rearrangeAs([2, 1, 0, 3]); // [4, 3, 2, 6]
  ///
  List<T> rearrangeAs(Set<int> newIndex) {
    final length = this.length;
    assert(newIndex.every((element) => element < length && element > -1));

    final list = <T>[];
    for (var index = 0; index < length; index++) {
      list.add(this[newIndex.firstWhere((i) => i == index)]);
    }
    return list;
  }

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.split(2); // [[2, 3], [4, 6], [10, 3], [9]]
  ///
  List<List<T>> split(int count, [int? end]) {
    final length = end ?? this.length;
    assert(count <= length);

    final list = <List<T>>[];
    for (var i = 0; i < length; i += count) {
      list.add(sublist(i, i + count < length ? i + count : length));
    }
    return list;
  }

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.splitTwo(2); // [[2, 3], [4, 6, 10, 3, 9]]
  ///
  (List<T>, List<T>) splitTwo(int position, [int? end]) {
    final length = this.length;
    assert(position <= length);

    return (sublist(0, position), sublist(position, end ?? length));
  }

  ///
  ///
  /// set operations, see also [Set.intersection], [Set.difference],
  ///
  /// [intersectionWith]
  /// [differenceWith], [differenceIndexWith]
  ///
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

  Map<int, T> differenceWith(List<T> others) =>
      differenceIndexWith(others).fold(
        <int, T>{},
        (difference, i) => difference..putIfAbsent(i, () => this[i]),
      );

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

  Iterable<MapEntry<T, V>> combine<V>(
    List<V> values, {
    bool joinInValuesLength = true,
  }) sync* {
    final length = joinInValuesLength ? values.length : this.length;
    for (var i = 0; i < length; i++) {
      yield MapEntry(this[i], values[i]);
    }
  }

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

extension ListSetExtension<I> on List<Set<I>> {
  void forEachAddAll(List<Set<I>>? another) {
    if (another != null) {
      for (var i = 0; i < length; i++) {
        this[i].addAll(another[i]);
      }
    }
  }

  void mergeAndRemoveThat(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeAndRemoveThis(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereAndRemoveAllAndAdd(Predicator<Set<I>> predicator) =>
      add(removeWhereAndGet(predicator).mergeAll());
}

///
///
///
///
///
/// map entry, map
///
///
///
///
///
///

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  MapEntry<V, K> get reversed => MapEntry(value, key);

  String join([String separator = '']) => '$key$separator$value';
}

extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get toMap => Map.fromEntries(this);
}

extension MapExtension<K, V> on Map<K, V> {
  String join([String entrySeparator = '', String separator = '']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

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
