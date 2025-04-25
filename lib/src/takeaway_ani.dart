part of '../api.dart';

///
///
/// * [AniSequence]
/// * [AniSequenceStep]
/// * [AniSequenceInterval]
/// * [AniSequenceStyle]
///
///


///
///
///
typedef AniSequencer<M extends Matable>
= Sequencer<AniSequenceStep, AniSequenceInterval, M>;

///
///
///
final class AniSequence {
  final List<Mamable> abilities;
  final List<Duration> durations;

  const AniSequence._(this.abilities, this.durations);

  factory AniSequence({
    required int totalStep,
    required AniSequenceStyle style,
    required Generator<AniSequenceStep> step,
    required Generator<AniSequenceInterval> interval,
  }) {
    final durations = <Duration>[];
    AniSequenceInterval intervalGenerator(int index) {
      final i = interval(index);
      durations.add(i.duration);
      return i;
    }

    var i = -1;
    return AniSequence._(
      step.linkToListTill<AniSequenceInterval, Mamable>(
        totalStep,
        intervalGenerator,
            (previous, next, interval) =>
            style.sequencer(previous, next, interval)(++i),
      ),
      durations,
    );
  }

  ///
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  static Mationani mationani_mamionSequence(
      int? step, {
        Key? key,
        required AniSequence sequence,
        required Widget child,
        required AnimationControllerInitializer initializer,
      }) {
    final i = step ?? 0;
    return Mationani.mamion(
      key: key,
      ani: Ani.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
      ),
      mamable: sequence.abilities[i],
      child: child,
    );
  }
}

///
///
final class AniSequenceStep {
  final List<double> values;
  final List<Offset> offsets;
  final List<Point3> points3;

  const AniSequenceStep({
    this.values = const [],
    this.offsets = const [],
    this.points3 = const [],
  });
}

///
///
final class AniSequenceInterval {
  final Duration duration;
  final List<Curve> curves;
  final List<Offset> offsets; // for curving control, interval step

  const AniSequenceInterval({
    this.duration = KCore.durationSecond1,
    required this.curves,
    this.offsets = const [],
  });
}

///
///
enum AniSequenceStyle {
  // TRS: Translation, Rotation, Scaling
  transformTRS,

  // rotate, slide in bezier cubic
  transitionRotateSlideBezierCubic;

  ///
  /// [_forwardOrReverse] is the only way to sequence [Mamable] for now
  ///
  static bool _forwardOrReverse(int i) => i % 2 == 0;

  static Mapper<int, Mamable> _sequence({
    Predicator<int> predicator = _forwardOrReverse,
    required AniSequenceStep previous,
    required AniSequenceStep next,
    required Fusionor<AniSequenceStep, Mamable> combine,
  }) =>
          (i) => combine(
        predicator(i) ? previous : next,
        predicator(i) ? next : previous,
      );

  AniSequencer<Mamable> get sequencer => switch (this) {
    transformTRS => (previous, next, interval) {
      final curve = CurveFR.of(interval.curves[0]);
      return AniSequenceStyle._sequence(
        previous: previous,
        next: next,
        combine: (begin, end) {
          final a = begin.points3;
          final b = end.points3;
          return MamableTransform.fromDelegates(
            [
              MamableTransformDelegate.translation(
                Between(a[0], b[0], curve: curve),
                alignment: Alignment.topLeft,
              ),
              MamableTransformDelegate.rotation(
                Between(a[1], b[1], curve: curve),
                alignment: Alignment.topLeft,
              ),
              MamableTransformDelegate.scale(
                Between(a[2], b[2], curve: curve),
                alignment: Alignment.topLeft,
              ),
            ],
          );
        },
      );
    },
    transitionRotateSlideBezierCubic => (previous, next, interval) {
      final curve = CurveFR.of(interval.curves[0]);
      final controlPoints = interval.offsets;
      return AniSequenceStyle._sequence(
        previous: previous,
        next: next,
        combine: (begin, end) => MamableSet([
          MamableTransition.rotate(Between(
            begin.values[0],
            end.values[0],
            curve: curve,
          )),
          MamableTransition.slide(BetweenSpline2D(
            onLerp: BetweenSpline2D.lerpBezierCubic(
              begin.offsets[0],
              end.offsets[0],
              c1: previous.offsets[0] + controlPoints[0],
              c2: previous.offsets[0] + controlPoints[1],
            ),
            curve: curve,
          )),
        ]),
      );
    },
  };
}
