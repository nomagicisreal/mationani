part of '../mationani.dart';

///
/// this file contains:
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
/// [reduceToNum]
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

  N reduceToNum<N extends num>(
    Translator<I, N> translate, {
    Combiner<N, N>? combine,
  }) {
    final combining = combine ?? math.max<N>;
    final iterator = this.iterator..moveNext();
    N val = translate(iterator.current);
    while (iterator.moveNext()) {
      val = combining(translate(iterator.current), val);
    }
    return val;
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
///
/// [add2]
/// [addIfNotNull]
/// [addFirstAndRemoveFirst], [addFirstAndRemoveFirstAndGet]
///
/// [getOrDefault],
///
/// [update], [updateWithMapper]
/// [updateAll], [updateAllWithMapper]
///
/// [removeFirst], [removeWhereAndGet]
///
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

  void update(int index, T value) => this[index] = value;

  void updateWithMapper(int index, Mapper<T> mapper) =>
      this[index] = mapper(this[index]);

  void updateAll(T value) {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  void updateAllWithMapper(Mapper<T> mapper) {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      this[i] = mapper(this[i]);
    }
  }

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
