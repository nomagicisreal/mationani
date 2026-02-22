import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleCabinet extends StatelessWidget {
  const SampleCabinet({super.key, required this.toggle});

  final bool toggle;

  @override
  Widget build(BuildContext context) {
    return Mationani.manion(
      duration: (Duration(seconds: 3), Duration(seconds: 2)),
      ani: Ani.updateForwardOrReverseWhen(
        toggle,
      ),
      manable: ManableSet.selectedAndParent(
        parent: MamableSingle(
          Between(Colors.red.shade200, Colors.green.shade200),
          (animation, child) => ColoredBox(
            color: animation.value,
            child: child,
          ),
        ),
        selected: children_mamable,
      ),
      parenting: (children) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
      children: children,
    );
  }

  static const Offset center = Offset(25, 25);
  static const SizedBox _height10 = SizedBox(height: 10);

  List<Widget> get children => [
        SizedBox.square(
          dimension: center.dx * 2,
          child: ColoredBox(color: Colors.blue.shade400),
        ),
        _height10,
        SizedBox.square(
          dimension: center.dx * 2,
          child: ColoredBox(color: Colors.yellow.shade400),
        ),
        _height10,
        SizedBox.square(
          dimension: center.dx * 2,
          child: ColoredBox(color: Colors.green.shade400),
        ),
        _height10,
        SizedBox.square(
          dimension: center.dx * 2,
          child: ColoredBox(color: Colors.brown.shade400),
        ),
        _height10,
      ];

  //
  static Offset Function(double) offsetOnSpline2D = BetweenTicks(
    BetweenTicks.offsetCatmullRom(
      controlPoints: [
        const Offset(0, 50),
        Offset.zero,
        const Offset(50, 0),
        center * 2,
      ],
    ),
  ).transform;

  static double Function(double) doubleOnBetween =
      Between<double>(-math.pi * 0.2, math.pi * 1.75).transform;

  Map<int, MamableSet> get children_mamable => {
        0: MamableSet([
          MamableTransition.slide(
            BetweenTicks<Offset>(
              BetweenTicks.offsetArcCircle(
                origin: const Offset(0.5, 0),
                radius: 0.5,
                direction: Between(0.0, math.pi),
              ),
              (Curves.fastOutSlowIn, Curves.fastOutSlowIn),
            ),
          ),
          MamableTransition.scale(
            Between(1, 0.7, (Curves.bounceOut, Curves.bounceOut)),
          )
        ]),
        2: MamableSet([
          MamableClip.path(
            BetweenTicks(
              (t) => Path()
                ..addOval(
                  Rect.fromCircle(center: offsetOnSpline2D(t), radius: 35),
                ),
              (Curves.linear, Curves.linear),
            ),
          ),
          MamableTransition.fade(Deviate(around: 0.6, amplitude: 0.4)),
        ]),
        4: MamableSet([
          MamablePaint.path(
            BetweenTicks(
              (t) => Path()
                ..moveTo(center.dx, center.dy)
                ..lineTo(
                  center.dx + Offset.fromDirection(doubleOnBetween(t), 30).dx,
                  center.dy + Offset.fromDirection(doubleOnBetween(t), 30).dy,
                ),
            ),
            pen: Paint()
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.butt
              ..color = Colors.purple
              ..strokeWidth = 5,
          ),
        ]),
        6: MamableSet([
          MamableTransform.rotate(
            Between(
              (0, 0, 0),
              (
                math.pi * 1.75,
                math.pi * 0.5,
                math.pi * 0.2,
              ),
            ),
            Matrix4.identity(),
            alignment: Alignment.center,
          ),
        ]),
      };
}
