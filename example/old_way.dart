import 'package:datter/datter.dart';
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class OldWay extends StatefulWidget {
  const OldWay({super.key});

  @override
  State<OldWay> createState() => _OldWayState();
}

class _OldWayState extends State<OldWay> with SingleTickerProviderStateMixin {
  bool toggle = false;
  int count = 0;

  void _onPressed({bool update = true}) {
    count++;
    context.showSnackBarMessage('$toggle on $count');
    toggle
        ? controller.forward().then((_) => toggle = !toggle)
        : controller.reverse().then((_) => toggle = !toggle);
  }

  late final AnimationController controller;
  late final Animation<SizingPath> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = controller.drive(
      BetweenPath(
        Between(begin: 10.0, end: 50.0),
        onAnimate: (value) => FSizingPath.circle(Offset.zero, value),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 100,
          child: ListenableBuilder(
              listenable: animation,
              builder: (context, child) {
                return ClipPath(
                  clipper: Clipping.reclipWhenUpdate(animation.value),
                  child: ColoredBox(color: Colors.red.shade200),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
    );
  }
}
