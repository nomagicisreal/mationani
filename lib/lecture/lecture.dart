import 'package:flutter/material.dart';

///
/// 1. what is 'state'
/// 2. what is 'widget'
/// 3. nested widget ?
/// 4. stateless vs stateful
/// 5. animation ?
/// 6. !!!! mationani !!!!
///

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {
  // bool toggle = true;
  //
  // late final AnimationController _controller;
  // late Animation<Offset> _animation;
  //
  // @override
  // void initState() {
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: KMath.durationSecond1,
  //   );
  //   _animation = Tween(begin: Offset.zero, end: KGeometry.offset_bottomRight * 3)
  //       .animate(_controller);
  //   super.initState();
  // }

  void onPressed() {
    // if (toggle) {
    //   _controller.forward();
    // } else {
    //   _controller.reverse();
    // }
    // toggle = !toggle;

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.add),
      ),

      // body: Text(
      //   'hello world',
      //   style: TextStyle(fontSize: 100),
      // ),

      // body: Center(
      //   child: Text(
      //     'hello world',
      //     style: TextStyle(fontSize: 100),
      //   ),
      // ),

      // body: Center(
      //   child: Container(
      //     color: Colors.yellow,
      //     width: 100,
      //     height: 50,
      //   ),
      // ),

      // body: SlideTransition(
      //   position: _animation,
      //   child: ColoredBox(
      //     color: KColor.blueB1,
      //     child: SizedBox.fromSize(size: KGeometry.size_square_40),
      //   ),
      // ),

      // body: Mationani(
      //   ani: AniUpdateIfNotAnimating.initForwardAndUpdateForwardOrReverse(
      //     duration: DurationFR.constant(KMath.durationSecond1),
      //   ),
      //   mation: Mamion(
      //     ability: MamionTransition.slide(
      //       Between(Offset.zero, KGeometry.offset_bottomRight * 3),
      //     ),
      //     builder: (context) => ColoredBox(
      //       color: KColor.blueB1,
      //       child: SizedBox.fromSize(size: KGeometry.size_square_40),
      //     ),
      //   ),
      // ),
    );
  }
}
