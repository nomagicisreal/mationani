this is a repository for dart pub.dev library see [Mationani](https://pub.dev/packages/mationani)

To prevent scattered instances of `AnimationController`, `Animation`, `Tween` in multiple widgets;
there is a stateful widget called `Mationani` takes an easy way to enable beautiful flutter animation (in my acquisition).
With `Matoinani`, we can only create widgets inside a builder.

before,
```dart
class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> with SingleTickerProviderStateMixin {
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
class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

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

In tradition, we need create a stateful widget with ticker mixin to enable animation,
but now, we can use stateless widget with `Mation` and `Ani` as argument inside a build to enable animation, too.

