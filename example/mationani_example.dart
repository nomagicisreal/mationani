// ignore_for_file: unused_import
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

import 'samples/draw_each.dart';
import 'samples/cutting_respectively.dart';
import 'samples/cabinet_selected.dart';
import 'samples/slide_sequence.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final steps =
        List.generate(20, (_) => math.Random().nextInt(200).toDouble());
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 100,

          // child: Mationani.mamion(
          //   ani: AniSequence(steps),
          //   mamable: MamablePaint.path(
          //     BetweenTicks(
          //       BetweenTicks.depend(
          //         Between(step.$3, step.$4).transform,
          //         (scalar) => Path()
          //           ..moveTo(scalar, 0)
          //           ..quadraticBezierTo(0, 100, 100, 100),
          //       ),
          //       step.$5,
          //     ),
          //     pen: Paint()
          //       ..style = PaintingStyle.stroke
          //       ..color = Colors.black,
          //   ),
          //   child: SizedBox.expand(),
          // ),

          // child: SampleSlide(),
          // child: SampleDraw(),
          // child: SampleCutting(),
          // child: SampleCabinet(toggle: toggle),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
    );
  }
}
