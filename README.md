see mationani in [Pub.dev](https://pub.dev/packages/mationani) and [Github](https://github.com/nomagicisreal/mationani)

To prevent scattered instances of `AnimationController`, `Animation`, `Tween` in multiple widgets;
there is a stateful widget called `Mationani` empower us to have an easy way to create animation.
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
      child: CircularProgressIndicator(),
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
      mation: MamionTransition.slide(Between(Offset.zero, Offset(1, 1))),
      ani: Ani(
        style: AnimationStyle(duration: Duration(seconds: 1)),
        initializer: Ani.initializeForward,
      ),
      child: CircularProgressIndicator(),
    );
  }
}

```

In tradition, an animation needs a stateful widget with ticker mixin,
but now, an animation just needs a stateless widget with `Mation` and `Ani` as argument.

`Mationani` is different to `ImplicitlyAnimatedWidget`.
`ImplicitlyAnimatedWidget` provides implicitly animation by inheritance through many classes,
while `Mationani` requires only `Mation`, `Between`, `Ani` as arguments in widget build,