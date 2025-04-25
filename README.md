see mationani in [Pub.dev](https://pub.dev/packages/mationani) and [Github](https://github.com/nomagicisreal/mationani)

To prevent scattered instances of `AnimationController`, `Animation`, `Tween` in multiple widgets;
there is a stateful widget called `Mationani`, empowering us to have an easy way to create animation.
With `Matoinani`, we can only create widgets in a build.

In tradition, an animation needs a stateful widget with ticker mixin.
```dart
class SampleSlide extends StatefulWidget {
  const SampleSlide({super.key});

  @override
  State<SampleSlide> createState() => _SampleSlideState();
}

class _SampleSlideState extends State<SampleSlide> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = controller.drive(Tween(begin: Offset.zero, end: Offset(1, 1)));
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: CircularProgressIndicator(),
    );
  }
}
```

With `Mationani`, creating animation needs only `Mation` and `Ani` as argument.
```dart
class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani(
      ani: Ani(
        style: AnimationStyle(duration: Duration(seconds: 1)),
        initializer: Ani.initializeForward,
      ),
      mation: MamableTransition.slide(Between(Offset.zero, Offset(1, 1))),
      child: CircularProgressIndicator(),
    );
  }
}

```

this is a library aims to integrate flutter animation and not limited to built-in animation; for example,
talks to `MamableTransition.fade` and `MamableTransition.slide`, there is `FadeTransition` and `SlideTransition`;
talks to `MamableClipper` or `MamablePainter`, there is no pertinent widget if `ClipPath` or `CustomPaint` is not.
whether there is a flutter animation widget or not, hopes there are more implementation in the future!
