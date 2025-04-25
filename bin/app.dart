// ignore_for_file: unused_import, unused_local_variable
import 'package:datter/datter.dart';
import 'package:flutter/material.dart';

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
  int count = 0;

  void _onPressed({bool update = true}) {
    // count++;
    context.showSnackBarMessage(count.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SizedBox.expand(
        // child: GridPaper(
        //   interval: 100,
        //   divisions: 2,
        //   subdivisions: 1,
        //   color: Colors.white54,
        // ),
        // child: Mationani(
        //   ani: Ani.initForward(),
        //   mation: Mamion(
        //     mamable: MamableSolo(value, _builder),
        //     child: child,
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
    );
  }
}
