import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleTransform extends StatelessWidget {
  const SampleTransform({super.key});

  static const double r60 = math.pi / 3;
  static final List<TransformTarget> steps = [
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (0, 0, r60 * i)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (0, r60 * i, 0)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (r60 * i, 0, 0)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (0, r60 * i, r60 * i)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (0, -r60 * i, r60 * i)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (r60 * i, 0, r60 * i)),
    ),
    ...List.generate(
      7,
      (i) => TransformTarget(rotation: (-r60 * i, 0, r60 * i)),
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 20,
        child: Masionani.mamion(
          steps: steps,
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
    );
  }
}
