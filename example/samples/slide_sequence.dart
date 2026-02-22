import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  static const List<AnimationStep> cubics = [
    AnimationStep(1, 0, Offset.zero),
    AnimationStep(2, 0.2, Offset(1, 1)),
    AnimationStep(1.2, 2, Offset(1, -1)),
    AnimationStep(0.2, 2.1, Offset(1.5, 3)),
    AnimationStep(0.5, 0, Offset(-2, 3)),
    AnimationStep(0.8, -0.1, Offset(-1, 13)),
    AnimationStep(1.2, 0, Offset(3, 10)),
  ];

  Mamable _sMamable(
    AnimationStep previous,
    AnimationStep next,
    BiCurve curve,
  ) =>
      MamableSet([
        MamableTransition.scale(Between(previous.s, next.s)),
        MamableTransition.rotate(Between(previous.r, next.r)),
        MamableTransition.slide(Between(previous.p, next.p)),
      ]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Masionani.mamion(
          steps: cubics,
          aniUpdate: AniSequenceCommandUpdate.forwardStepExceptReverse,
          sMamable: _sMamable,
          child: ColoredBox(
            color: Colors.green.shade400,
            child: SizedBox.square(dimension: 20),
          ),
        ),
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
      ],
    );
  }
}

class AnimationStep {
  final double s;
  final double r;
  final Offset p;

  const AnimationStep(this.s, this.r, this.p);
}
