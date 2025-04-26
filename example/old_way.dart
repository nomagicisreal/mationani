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



///
/// the 'axis' below is from 'coordinate-axis-negative' to 'coordinate-axis-positive'.
/// it's easier to understand them with animated [Transform] widget with [Matrix4] instance continued setState,
/// or just using [MamableTransformDelegate] wrapped in [Mationani] widget with [Ani.initRepeat].
///
/// translation x axis comes from [Direction3DIn6.left] to [Direction3DIn6.right]
/// translation y axis comes from [Direction3DIn6.top] to [Direction3DIn6.bottom]
/// translation z axis comes from [Direction3DIn6.front] to [Direction3DIn6.back]
/// direction x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// direction y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// direction z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], [Offset.direction]),
///
///