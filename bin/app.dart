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

  void onPressed() => setState(() {
        toggle = !toggle;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white38,
      body: Center(
        child: Mationani(
          ani: Ani(
            duration: KDurationFR.second1,
            updateConsumer: Ani.decideForwardOrReverse(!toggle),
          ),
          mation: MationStackSibling<Mationable>(
            alignment: Alignment.center,
            mationSibling: MationMulti([
              MationClipper(BetweenPath(
                FBetween.offsetOfDirection(
                  KRadian.angle_90,
                  0,
                  100,
                  curve: KCurveFR.fastOutSlowIn,
                ),
                onAnimate: (t, value) => FSizingPath.rect(
                  value & KSize.square_100,
                ),
              )),
              MationTransition.slide(
                FBetween.offsetOfDirection(
                  KRadian.angle_90,
                  0.1,
                  0.4,
                  curve: KCurveFR.fastOutSlowIn,
                ),
              ),
            ]),
            sibling: WSizedBox.squareColored(
              dimension: 100,
              color: Colors.red.shade200.withOpacity(0.8),
            ),
            mation: MationTransition.slide(
              FBetween.offsetOfDirection(
                KRadian.angle_30,
                1,
                0.4,
                curve: KCurveFR.fastOutSlowIn,
              ),
            ),
          ),
          child: WSizedBox.squareColored(
            dimension: 80,
            color: Colors.green.shade200,
          ),
        ),
      ),
    );
  }
}
