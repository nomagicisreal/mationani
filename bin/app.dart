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
    with OverlayStateMixinUpdateToRemove<MyHome> {
  bool toggle = false;
  int count = 0;

  void _onPressed({bool update = true}) {
    count++;
    print('$count, ${overlays.isEmpty}');
    if (overlays.isEmpty) {
      overlayInsert(
        builder: (context, callToRemove) => Mationani.mamion(
          ani: Ani.initForwardAndWaitUpdateReverseTo(
            count % 2 == 0,
            dismissedCall: () {
              context.showSnackBarMessage(count.toString());
              callToRemove();
            },
            duration: DurationFR.second1,
          ),
          ability: MamionTransition.fadeIn(),
          builder: (context) => Mationani.mamion(
            ani: Ani.updateForwardOrReverse(
              initializer: Ani.initializeForward,
              duration: DurationFR.milli100 * 4,
            ),
            ability: MamionMulti.slideToAndScale(
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
        durationOpen: KCore.durationMilli500,
        elementsAlign: Alignment.topCenter,
        elements: [
          IconAction(WIconMaterial.add, () {}),
          IconAction(WIconMaterial.password, () {}),
          IconAction(WIconMaterial.email, _onPressed),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
