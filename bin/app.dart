import 'package:damath/damath.dart';
import 'package:datter/datter.dart';
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

class _MyHomeState extends State<MyHome>
    with OverlayStateNormalMixin<MyHome> {
  bool toggle = false;
  int count = 0;

  void _onPressed({bool update = true}) {
    count++;
    if (overlays.isEmpty) {
      overlayInsertUpdateToRemove(
        builder: (context, callToRemove) => Mationani.mamion(
          ani: Ani.initForwardAndWaitUpdateReverseTo(
            count % 2 == 0,
            dismissedCall: () {
              context.showSnackBarMessage(count.toString());
              callToRemove();
            },
          ),
          ability: MamionTransition.fadeIn(),
          builder: (context) => Mationani.mamion(
            ani: Ani.updateForwardOrReverse(
              initializer: Ani.initializeForward,
            ),
            ability: MamionMulti.slideToThenScale(
              scaleEnd: 2,
              destination: KGeometry.offset_bottomRight * 0.1,
            ),
            builder: (context) => Center(
              child: WSizedBox.squareColored(
                dimension: 100,
                color: Colors.red.shade100,
              ),
            ),
          ),
        ),
      );
      return;
    }
    overlays.first.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SizedBox.expand(
        child: GridPaper(
          interval: 100,
          divisions: 2,
          subdivisions: 1,
          color: Colors.white54,
        ),
      ),
      floatingActionButton: FabExpandable(
        initialLocation: FloatingActionButtonLocation.centerTop,
        durationOpen: KCore.durationMilli500,
        elementsAlign: Alignment.topCenter,
        elements: [
          IconAction(WIcon.add, () {}),
          IconAction(Icon(Icons.password), () {}),
          IconAction(Icon(Icons.email), _onPressed),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
