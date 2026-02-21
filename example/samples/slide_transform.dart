import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleTransform extends StatelessWidget {
  const SampleTransform({super.key});

  static final Matrix4 host = Matrix4.identity();
  static const double r30 = math.pi / 6;

  static final List<TransformTarget> steps = [
    ...List.generate(
      13,
      (i) => TransformTarget(rotation: (0, 0, r30 * i)),
    ),
    ...List.generate(
      13,
      (i) => TransformTarget(rotation: (0, r30 * i, 0)),
    ),
    ...List.generate(
      13,
      (i) => TransformTarget(rotation: (r30 * i, 0, 0)),
    ),
    ...List.generate(
      13,
      (i) => TransformTarget(rotation: (0, r30 * i, r30 * i)),
    ),
    ...List.generate(
      13,
          (i) => TransformTarget(rotation: (0, -r30 * i, r30 * i)),
    ),
    ...List.generate(
      13,
      (i) => TransformTarget(rotation: (r30 * i, 0, r30 * i)),
    ),
    ...List.generate(
      13,
          (i) => TransformTarget(rotation: (-r30 * i, 0, r30 * i)),
    ),
    TransformTarget(rotation: (0, 0, 0)),
  ];

  Mamable _sMamable(TransformTarget p, TransformTarget n, BiCurve c) =>
      MamableTransformCompose(Between(p, n));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 20,
        child: Masionani.mamion(
          steps: steps,
          ani: const AniSequenceCommand(
            update: AniSequenceCommandUpdate.forwardStepExceptReverse,
          ),
          defaultDuration: const Duration(milliseconds: 300),
          sMamable: _sMamable,
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
