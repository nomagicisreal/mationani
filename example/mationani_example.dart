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
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Align(
        alignment: const Alignment(-0.2, 1),
        child: Padding(
          padding: const EdgeInsetsGeometry.only(bottom: 80),
          child: SizedBox(
            height: 300,
            width: 100,
            child: SampleSlide(),
            // child: SampleDraw(),
            // child: SampleCutting(),
            // child: SampleCabinet(toggle: toggle),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            setState(() {
              toggle = !toggle;
              step++;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // content: Center(child: Text('toggle: $toggle')),
              content: Center(child: Text('step: $step')),
              duration: Duration(milliseconds: 200),
            ));
          },
        ),
      ),
    );
  }
}
