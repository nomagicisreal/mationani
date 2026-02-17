import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani.mamion(
      ani: Ani.updateForwardOrReverse(),
      mamable: MamableTransition.align(
        BetweenDepend.sequence(
          sequence: [
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
        child: SizedBox.square(
          dimension: 10,
        ),
      ),
    );
  }
}
