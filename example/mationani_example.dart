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

  Mamable _sMamable(double previous, double next, BiCurve curve) =>
      MamablePaint.path(
        BetweenTicks(
          BetweenTicks.depend(
            Between(previous, next).transform,
            (scalar) => Path()
              ..moveTo(scalar, 0)
              ..quadraticBezierTo(0, 100, 100, 100),
          ),
          curve,
        ),
        pen: Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    final steps =
        List.generate(10, (_) => math.Random().nextInt(200).toDouble());
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 100,

          child: MationaniSequence.mamion(
            steps: steps,
            ani: const AniSequenceCommand(
              initialize: AniSequenceCommandInit.pulseRepeat,
              update: AniSequenceCommandUpdate.stopOrResume,
            ),
            sMamable: _sMamable,
            child: SizedBox.expand(),
          ),

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
