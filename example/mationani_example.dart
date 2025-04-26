// ignore_for_file: unused_import, unused_local_variable
import 'dart:math' show pi;

import 'package:damath/damath.dart';
import 'package:datter/datter.dart';
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
  int count = -1;

  void _onPressed({bool update = true}) {
    count++;
    context.showSnackBarMessage(count.toString());
    setState(() {});
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
              count % 2 == 0,
              style: AnimationStyle(duration: KCore.durationSecond1 * 2),
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

  Offset get center => Offset(25, 25);

  List<Widget> get children => WSizedBox.sandwich(
        dimension: 10,
        axis: Axis.vertical,
        sibling: [
          SizedBox.square(
            dimension: center.dx * 2,
            child: ColoredBox(color: Colors.blue.shade400),
          ),
          SizedBox.square(
            dimension: center.dx * 2,
            child: ColoredBox(color: Colors.yellow.shade400),
          ),
          SizedBox.square(
            dimension: center.dx * 2,
            child: ColoredBox(color: Colors.green.shade400),
          ),
          SizedBox.square(
            dimension: center.dx * 2,
            child: ColoredBox(color: Colors.brown.shade400),
          ),
        ],
      );

  Map<int, MamableSet> get children_mamable => {
        0: MamableSet([
          MamableTransition.slide(
            Between(begin: Offset.zero, end: KGeometry.offset_right),
          ),
          MamableTransition.scale(
            Amplitude(1, 0.7, 1, curving: Curving.sinPeriodOf(1)),
          )
        ]),
        2: MamableSet([
          MamableClipper(
            BetweenPath(
              BetweenSpline2D(
                onLerp: BetweenSpline2D.lerpCatmullRom(
                  controlPoints: [
                    KGeometry.offset_bottom * 50,
                    Offset.zero,
                    KGeometry.offset_right * 50,
                    center * 2,
                  ],
                ),
              ),
              onAnimate: (value) => FSizingPath.circle(value, 35),
              curve: CurveFR.linear,
            ),
          ),
          MamableTransition.fade(
            Amplitude(1, 0.6, 2, curving: Curving.sinPeriodOf(1)),
          ),
        ]),
        4: MamableSet([
          MamableTransition.slide(
            BetweenSpline2D(
              onLerp: BetweenSpline2D.lerpArcCircle(
                origin: KGeometry.offset_left * 0.5,
                radius: 0.5,
                direction: Between(begin: 0.0, end: pi),
              ),
              curve: CurveFR.fastOutSlowIn,
            ),
          ),
          MamablePainter.paintFrom(
            BetweenPath(
              Between<double>(begin: -Radian.angle_30, end: Radian.angle_315),
              onAnimate: (value) => FSizingPath.connect(
                center,
                center + Offset.fromDirection(value, 30),
              ),
            ),
            paintFrom: FPaintFrom.of(
              VPaintStroke.capButt
                ..color = Colors.purple
                ..strokeWidth = 5,
            ),
          ),
        ]),
        6: MamableSetTransform(
          distanceToObserver: 0.001,
          rotateBetween: Between(
            begin: Point3(0, 0, 0),
            end: Point3(0, Radian.angle_90, Radian.angle_30),
          ),
          rotateAlignment: Alignment.topLeft,
        ),
      };
}
