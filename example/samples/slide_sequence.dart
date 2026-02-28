import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  static List<AnimationStep> stepsTransition = List.generate(
    30,
    (i) => AnimationStep(
      0.3 + math.Random().nextInt(9) * 0.2,
      -1 + math.Random().nextInt(20) * 0.1,
      Offset(
        math.Random().nextInt(20) * 0.4,
        math.Random().nextInt(28) * 0.5,
      ),
    ),
  );

  static const double r60 = math.pi / 3;
  static const double r120 = r60 * 2;
  static final List<TransformTarget> stepsTransform = [
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (0, 0, r120 * i)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (0, r120 * i, 0)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (r120 * i, 0, 0)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (0, r60 * i, r60 * i)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (0, -r120 * i, r120 * i)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (r120 * i, 0, r120 * i)),
    ),
    ...List.generate(
      4,
      (i) => TransformTarget(rotation: (-r120 * i, 0, r120 * i)),
    ),
    ...List.generate(
      10,
      (_) => TransformTarget(
        translation: (
          math.Random().nextInt(200) - 100.0,
          math.Random().nextInt(300) - 150.0,
          math.Random().nextInt(200) - 100.0,
        ),
        rotation: (
          math.Random().nextInt(3) * r60,
          math.Random().nextInt(3) * r60,
          math.Random().nextInt(3) * r60,
        ),
        scale: (
          1.1 + math.Random().nextInt(8),
          1.1 + math.Random().nextInt(8),
          1.1 + math.Random().nextInt(2),
        ),
      ),
    ),
    const TransformTarget(),
  ];

  ///
  ///
  ///
  Mamable _sMamable(
    AnimationStep previous,
    AnimationStep next,
    BiCurve curve,
  ) =>
      MamableSet([
        MamableTransition.scale(Between(previous.scale, next.scale)),
        MamableTransition.rotate(Between(previous.rotation, next.rotation)),
        MamableTransition.slide(Between(previous.position, next.position)),
      ]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Mationani.mamion(
          duration: const (Duration(seconds: 5), Duration(seconds: 5)),
          ani: Ani.initForward(),
          mamable: MamableTransition.align(
            BetweenTicks.sequence(
              [
                AlignmentGeometry.topStart,
                AlignmentGeometry.topEnd,
                AlignmentGeometry.bottomEnd,
                AlignmentGeometry.bottomStart,
                AlignmentGeometry.centerStart,
                AlignmentGeometry.center,
              ],
              weights: List.generate(5, (i) => 10.0 - i, growable: false),
            ),
          ),
          child: ColoredBox(
            color: Colors.green.shade100,
            child: SizedBox.square(dimension: 10),
          ),
        ),
        Masionani.mamion(
          steps: stepsTransition,
          aniUpdate: AniSequenceCommandUpdate.forwardStepExceptReverse,
          sMamable: _sMamable,
          child: ColoredBox(
            color: Colors.green.shade400,
            child: SizedBox.square(dimension: 20),
          ),
        ),
        Center(
          child: SizedBox.square(
            dimension: 20,
            child: Masionani.mamion(
              steps: stepsTransform,
              aniUpdate: AniSequenceCommandUpdate.forwardStepExceptReverse,
              defaultDuration: const Duration(milliseconds: 300),
              sMamable: MamableTransform.sequenceCompose,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.yellow, width: 2),
                  ),
                  color: Colors.purple.shade900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimationStep {
  final double scale;
  final double rotation;
  final Offset position;

  const AnimationStep(this.scale, this.rotation, this.position);
}
