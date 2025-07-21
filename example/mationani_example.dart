// ignore_for_file: unused_import
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

import 'old_way.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: const MyHome(),
      // home: const OldWay(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool toggle = false;

  void _onPressed({bool update = true}) {
    setState(() => toggle = !toggle);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
      child: Text(toggle.toString()),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: SizedBox(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
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

  Map<int, MamableSet> get children_mamable => {
        0: MamableSet([
          MamableTransition.slide(
            BetweenSpline2D(
              onLerp: BetweenSpline2D.lerpArcCircle(
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
            BetweenPath(
              BetweenSpline2D(
                onLerp: BetweenSpline2D.lerpCatmullRom(
                  controlPoints: [
                    const Offset(0, 50),
                    Offset.zero,
                    const Offset(50, 0),
                    center * 2,
                  ],
                ),
              ),
              onAnimate: (value) => (size) => Path()
                ..addOval(
                  Rect.fromCircle(center: center, radius: 35),
                ),
              curve: (Curves.linear, Curves.linear),
            ),
          ),
          MamableTransition.fade(
            Amplitude(
              from: 1,
              value: 0.6,
              times: 2,
              curving: (value) => math.sin(math.pi * 2 * value),
            ),
          ),
        ]),
        4: MamableSet([
          MamablePainter.paintFrom(
            BetweenPath(
              Between<double>(begin: -math.pi * 0.2, end: math.pi * 1.75),
              onAnimate: (value) => (size) => Path()
                ..moveTo(center.dx, center.dy)
                ..lineTo(
                  center.dx + Offset.fromDirection(value, 30).dx,
                  center.dy + Offset.fromDirection(value, 30).dy,
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
