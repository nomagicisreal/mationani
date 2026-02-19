import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleDraw extends StatelessWidget {
  const SampleDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani.manion(
      ani: Ani.updateForwardOrReverse(),
      manable: ManableSet.each([
        MamablePaint.path(
          BetweenTicks(
            BetweenTicks.pathRPCOnEdge(
              5,
              40,
              cornerRadius: Between(0, 120),
            ),
          ),
          pen: Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.brown,
        ),
        MamablePaint(
          Path()
            ..moveTo(5, 50)
            ..lineTo(100, 120),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red.shade100
            ..strokeWidth = 4,
        ),
        MamableClip(
          Path()
            ..moveTo(70, 150)
            ..lineTo(80, 150 - 10 * math.sqrt(3))
            ..arcToPoint(
              Offset(80, 150 + 10 * math.sqrt(3)),
              radius: Radius.circular(40),
              clockwise: false,
              largeArc: true,
            )
            ..close(),
        ),
      ]),
      parenting: (children) => Stack(children: children),
      children: [
        SizedBox.expand(),
        SizedBox.expand(),
        SizedBox.expand(child: ColoredBox(color: Colors.blue.shade100)),
      ],
    );
  }
}
