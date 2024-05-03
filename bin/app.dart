
import 'package:damath/damath.dart';
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
      backgroundColor: Colors.black45,
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SizedBox.expand(
        child: Mationani(
          ani: AniUpdateIfAnimating.backOr(
            duration: DurationFR.second3,
            onNotAnimating: Ani.consumeForwardOrReverse,
          ),
          mation: Mamion(
            ability: MamionMulti.slideAndScale(
              scaleEnd: 2,
              position: KOffset.square_1 * 0.5,
              interval: 0.7,
              curveSlide: CurveFR.fastOutSlowIn,
              curveScale: CurveFR.fastOutSlowIn,
            ),
            builder: (context) => GridPaper(
              interval: 100,
              divisions: 2,
              subdivisions: 1,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
