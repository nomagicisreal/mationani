import 'dart:developer';
import 'dart:math' hide log;

import 'package:dastore/dastore.dart';
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

Widget yellow100(BuildContext context) => WSizedBox.squareColored(
      dimension: 100,
      color: Colors.yellow,
    );

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
      body: SizedBox.expand(
        child: Mationani(
          ani: AniUpdateIfAnimating.backOr(
            duration: KDurationFR.second5,
            onNotAnimating: Ani.consumeForwardOrReverse,
          ),
          mation: Mamion(
            ability: MamionMulti.slideAndScale(
              scaleEnd: 2,
              position: KOffset.square_1 * 0.5,
              interval: 0.7,
            ),
            builder: (context) => GridPaper(
              interval: 100,
              divisions: 2,
              subdivisions: 1,
            ),
          ),
        ),
      ),
    );
  }
}
