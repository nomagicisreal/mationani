part of '../api.dart';

///
///
/// * [FMatable]
///
///

///
///
/// [generator_mamableSet_spill]
/// [generator_mamableSet_shoot],
///
///
abstract final class FMatable {
  const FMatable();

  ///
  /// fading first
  ///
  static MamableSet appear({
    Alignment alignmentScale = Alignment.center,
    required Between<double> fading,
    required Between<double> scaling,
  }) =>
      MamableSet([
        MamableTransition.fade(fading),
        MamableTransition.scale(scaling, alignment: alignmentScale),
      ]);

  static MamableSet spill({
    required Between<double> fading,
    required Between<Offset> sliding,
  }) =>
      MamableSet([
        MamableTransition.fade(fading),
        MamableTransition.slide(sliding),
      ]);

  static MamableSet penetrate({
    double opacityShowing = 1.0,
    CurveFR? curveClip,
    Clip clipBehavior = Clip.hardEdge,
    required Between<double> fading,
    required Between<Rect> recting,
    required SizingPathFrom<Rect> sizingPathFrom,
  }) =>
      MamableSet([
        MamableTransition.fade(fading),
        MamableClipper(
          BetweenPath<Rect>(
            recting,
            onAnimate: (t, rect) => sizingPathFrom(rect),
            curve: curveClip,
          ),
          clipBehavior: clipBehavior,
        ),
      ]);

  ///
  /// with slide
  ///
  static MamableSet mamableSet_leave({
    Alignment alignment = Alignment.topLeft,
    required Between<double> rotation,
    required Between<Offset> sliding,
  }) =>
      MamableSet([
        MamableTransition.rotate(rotation, alignment: alignment),
        MamableTransition.slide(sliding),
      ]);

  static MamableSet mamableSet_shoot({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<Offset> sliding,
    required Between<double> scaling,
  }) =>
      MamableSet([
        MamableTransition.slide(sliding),
        MamableTransition.scale(scaling, alignment: alignmentScale),
      ]);

  static MamableSet enlarge({
    Alignment alignmentScale = Alignment.topLeft,
    required Between<double> scaling,
    required Between<Offset> sliding,
  }) =>
      MamableSet([
        MamableTransition.scale(scaling, alignment: alignmentScale),
        MamableTransition.slide(sliding),
      ]);

  static MamableSet slideToThenScale({
    required Offset destination,
    required double scaleEnd,
    double interval = 0.5, // must between 0.0 ~ 1.0
    CurveFR curveScale = CurveFR.linear,
    CurveFR curveSlide = CurveFR.linear,
  }) =>
      MamableSet([
        MamableTransition.slide(Between(
          Offset.zero,
          destination,
          curve: curveSlide.interval(0, interval),
        )),
        MamableTransition.scale(
          Between(
            1.0,
            scaleEnd,
            curve: curveScale.interval(interval, 1),
          ),
          alignment: Alignment.center,
        )
      ]);

  ///
  ///
  ///
  static Generator<MamableSet> generator_mamableSet_spill(
    Generator<double> direction,
    double distance, {
    CurveFR? curve,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => FMatable.spill(
          fading: Between(0.0, 1.0, curve: curve),
          sliding: FMatalue.between_offset_ofDirection(
            direction(index),
            0,
            distance,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }

  static Generator<MamableSet> generator_mamableSet_shoot(
    Offset delta, {
    Generator<double> distribution = FKeep.generateDouble,
    CurveFR? curve,
    required Alignment alignmentScale,
    required int total,
  }) {
    final interval = 1 / total;
    return (index) => FMatable.mamableSet_shoot(
          alignmentScale: alignmentScale,
          sliding: FMatalue.offset_0To(
            delta * distribution(index),
            curve: curve,
          ),
          scaling: FMatalue.between_double_1From(
            0.0,
            curve: curve.nullOrMap((c) => c.interval(interval * index, 1.0)),
          ),
        );
  }
}
