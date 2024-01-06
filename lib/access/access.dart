part of '../mationani.dart';

///
/// this file contains:
///
/// [NumExtension]
/// [DoubleExtension]
/// [IntExtension]
///
/// [IterableExtension]
/// [IterableOffsetExtension]
/// [IterableMapEntryExtension]
///
/// [ListExtension]
/// [ListSetExtension]
/// [ListRadiusExtension]
/// [ListOffsetExtension]
///
/// [MapEntryExtension]
///
/// [MapExtension]
///
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

///
///
/// [hasElement], [notContains]
/// [mapToList]
/// [reduceWithIndex], [foldWithIndex], [accompany],
/// [flat], [chunk]
///
///
extension IterableExtension<I> on Iterable<I> {
  bool get hasElement => !isEmpty;

  bool notContains(I element) => !contains(element);

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

  static Mapper<Iterable<Offset>> scalingMapper(double scale) => scale == 1
      ? FMapper.ofOffsetIterable
      : (points) => points.scaling(scale);

  static Iterable<Offset> adjustCenterCompanion(
      Iterable<Offset> points,
      Size size,
      ) =>
      points.adjustCenterFor(size);
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

