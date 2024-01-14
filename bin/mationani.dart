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
        child: MationaniCutting(
          aniFadeOut: Ani(
            duration: KDurationFR.second1,
            updateConsumer: Ani.decideForwardOrReverse(toggle),
          ),
          ani: Ani(
            duration: KDurationFR.milli800,
            updateConsumer: Ani.decideForwardOrReverse(toggle),
          ),
          rotation: KRadian.angle_10,
          distance: 0.2,
          child: SizedBox.square(
            dimension: 100,
            child: ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
