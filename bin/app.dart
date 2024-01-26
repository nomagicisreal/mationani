import 'dart:developer';
import 'dart:math' hide log;

import 'package:dastore/dastore.dart';
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

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

  void onPressed({bool update = true}) => update
      ? setState(() {
          toggle = !toggle;
        })
      : toggle = !toggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: Colors.white38,
      body: Center(
        child: Mationani(
          ani: AniUpdateIfAnimating.backOr(
            duration: KDurationFR.second1,
            onNotAnimating: Ani.consumeForwardOrReverse,
          ),
          mation: Mamion(
            ability: MamionPainter.paintFrom(
              BetweenPathPolygon.regularCubicOnEdge(
                polygon: RRegularPolygonCubicOnEdge(
                  6,
                  radiusCircumscribedCircle: 50,
                ),
                cornerRadius: (polygon) => Between(
                  polygon.stepCornerRadiusInscribedCircle,
                  polygon.stepCornerRadiusArcCrossCenter(),
                ),
              ),
              paintFrom: FPaintFrom.of(VPaintFill.blue),
            ),
            builder: WWidgetBuilder.none,
          ),
        ),
      ),
    );
  }
}
