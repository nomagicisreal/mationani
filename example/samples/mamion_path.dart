import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SamplePath extends StatelessWidget {
  const SamplePath({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Mationani.mamion(
          ani: Ani.updateForwardOrReverse(),
          mamable: MamablePaint(
            BetweenPath.line(Offset(1, 1), Offset(100, 300), 3),
            paintFrom: (_, __) => Paint()..color = Colors.deepOrange.shade100,
          ),
        ),
        Mationani.mamion(
          ani: Ani.updateForwardOrReverse(),
          mamable: MamableClip(
            BetweenPath.line(Offset(5, 200), Offset(50, 50), 5),
          ),
          child: ColoredBox(
            color: Colors.blue.shade100,
            child: SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}
