import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleCabinet extends StatelessWidget {
  const SampleCabinet({super.key, required this.toggle});

  final bool toggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 100,
      child: Mationani.manion(
        ani: Ani.updateForwardOrReverseWhen(
          toggle,
          style: AnimationStyle(
            duration: const Duration(seconds: 3),
            reverseDuration: const Duration(seconds: 2),
          ),
        ),
        manable: ManableSet.selectedAndParent(
          parent: MamableSingle(
            Between(begin: Colors.red.shade200, end: Colors.green.shade200),
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
      ),
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
  static Offset Function(double) offsetOnSpline2D = BetweenDepend(
    BetweenDepend.offsetCatmullRom(
      controlPoints: [
        const Offset(0, 50),
        Offset.zero,
        const Offset(50, 0),
        center * 2,
      ],
    ),
  ).transform;

  static double Function(double) doubleOnBetween =
      Between<double>(begin: -math.pi * 0.2, end: math.pi * 1.75).transform;

  Map<int, MamableSet> get children_mamable => {
        0: MamableSet([
          MamableTransition.slide(
            BetweenDepend<Offset>(
              BetweenDepend.offsetArcCircle(
                origin: const Offset(0.5, 0),
                radius: 0.5,
                direction: Between(begin: 0.0, end: math.pi),
              ),
              curve: (Curves.fastOutSlowIn, Curves.fastOutSlowIn),
            ),
          ),
          MamableTransition.scale(
            Between(
                begin: 1,
                end: 0.7,
                curve: (Curves.bounceOut, Curves.bounceOut)),
          )
        ]),
        2: MamableSet([
          MamableClipper(
            BetweenDepend<Path Function(Size)>(
              (t) => (size) => Path()
                ..addOval(
                  Rect.fromCircle(center: offsetOnSpline2D(t), radius: 35),
                ),
              curve: (Curves.linear, Curves.linear),
            ),
          ),
          MamableTransition.fade(Deviate(around: 0.6, amplitude: 0.4)),
        ]),
        4: MamableSet([
          MamablePainter.paintFrom(
            BetweenDepend<Path Function(Size)>(
              (t) => (size) => Path()
                ..moveTo(center.dx, center.dy)
                ..lineTo(
                  center.dx + Offset.fromDirection(doubleOnBetween(t), 30).dx,
                  center.dy + Offset.fromDirection(doubleOnBetween(t), 30).dy,
                ),
            ),
            paintFrom: (_, __) => Paint()
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.butt
              ..color = Colors.purple
              ..strokeWidth = 5,
          ),
        ]),
        6: MamableSet([
          MamableTransform.rotation(
            rotate: Between(
              begin: (0, 0, 0),
              end: (
                math.pi * 1.75,
                math.pi * 0.5,
                math.pi * 0.2,
              ),
            ),
            alignment: Alignment.center,
          ),
        ]),
      };
}
