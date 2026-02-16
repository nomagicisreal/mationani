import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SamplePath extends StatelessWidget {
  const SamplePath({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani.manion(
      ani: Ani.updateForwardOrReverse(),
      manable: ManableSet.each([
        MamablePaint(
          BetweenPath.regularPolygonCubicOnEdge(
            5,
            40,
            cornerRadius: Between(begin: 0, end: 120),
          ),
          paintFrom: (canvas, size) => Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.brown,
        ),
        MamablePaint(
          BetweenPath.line(Offset(1, 1), Offset(100, 300), 3),
          paintFrom: (_, __) => Paint()..color = Colors.deepOrange.shade100,
        ),
        MamableClip(BetweenPath.line(Offset(5, 200), Offset(50, 50), 5)),
      ]),
      parenting: (children) => Stack(children: children),
      children: [
        SizedBox.expand(),
        SizedBox.expand(),
        ColoredBox(
          color: Colors.blue.shade100,
          child: SizedBox.expand(),
        )
      ],
    );
  }
}
