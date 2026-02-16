// ignore_for_file: unused_import
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

import 'samples/mamion_path.dart';
import 'samples/manion_respectively.dart';
import 'samples/manion_selected.dart';

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
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Center(
    //   child: Text(toggle.toString()),
    // )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 100,
          // child: SampleCabinet(toggle: toggle),
          // child: SampleCutting(),
          child: SamplePath(),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
    );
  }
}
