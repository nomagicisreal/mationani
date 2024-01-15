[Mationani - (Pub.dev library)](https://pub.dev/packages/mationani)
[Mationani - (Github repository)](https://github.com/nomagicisreal/mationani)

To prevent scattered instances of `AnimationController`, `Animation`, `Tween` in multiple widgets;
there is a stateful widget called `Mationani` takes an easy way to enable beautiful animation (in my acquisition).
With `Matoinani`, we can only create widgets in a build.

before,
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
      child: Center(
        child: SizedBox.square(
          dimension: 100,
          child: ColoredBox(color: Colors.blue),
        ),
      ),
    );
  }
}
```

after,
```dart
class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani(
      mation: MationTransitionOffset.zeroTo(Offset(1, 1)),
      ani: Ani(
        duration: DurationFR(Duration(seconds: 1), Duration.zero),
        initializer: Ani.initializeForward,
      ),
      child: Center(
        child: SizedBox.square(
          dimension: 100,
          child: ColoredBox(color: Colors.blue),
        ),
      ),
    );
  }
}

```

In tradition, an animation needs a stateful widget with ticker mixin,
but now, an animation just needs a stateless widget with `Mation` and `Ani` as argument.

`Mationani` is different to `ImplicitlyAnimatedWidget`.
`ImplicitlyAnimatedWidget` provides implicitly animation by inheritance through many classes,
`Mationani` gives developer more ability to control over `Mation`, `Between`, `Ani` arguments,