part of '../api.dart';

///
///
/// [generator_mamionSet_spill], ...
///
///
abstract final class FMation {
  const FMation();

  ///
  ///
  ///
  static Generator<MamableSet> generator_mamionSet_spill(
    Generator<double> direction,
    double distance, {
    CurveFR? curve,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamableSet.spill(
          fading: Between(0.0, 1.0, curve: curve),
          sliding: FMationValue.between_offset_ofDirection(
            direction(index),
            0,
            distance,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }

  static Generator<MamableSet> generator_mamionSet_shoot(
    Offset delta, {
    Generator<double> distribution = FKeep.generateDouble,
    CurveFR? curve,
    required Alignment alignmentScale,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => MamableSet.shoot(
          alignmentScale: alignmentScale,
          sliding: FMationValue.offset_0To(
            delta * distribution(index),
            curve: curve,
          ),
          scaling: FMationValue.between_double_1From(
            0.0,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }
}
