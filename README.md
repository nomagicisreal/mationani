# Mationani

see mationani in [Pub.dev](https://pub.dev/packages/mationani)
and [Github](https://github.com/nomagicisreal/mationani)

To prevent scattered instances of `AnimationController`, `Animation`, `Tween` in multiple widgets;\
there is a widget called `Mationani`.\
With `Mationani`, we can easily create animation, we can only create animated widget by a build in
parent.

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

With `Mationani`, creating animation needs only `Ani` and `Mation` as argument.

```dart
class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani.mamion(
      ani: Ani(
        style: AnimationStyle(duration: Duration(seconds: 1)),
        initializer: Ani.initializeForward,
      ),
      mamable: MamableTransition.slide(Between(Offset.zero, Offset(1, 1))),
      child: CircularProgressIndicator(),
    );
  }
}

```

There are many old ways to create animation in flutter; to name just a few,

- `ScaleTransition` requires animatable `Tween`<`double`>
- `SlideTransition` requires animatable `Tween`<`Offset`>
- `ClipPath` requires `Path` instance and additional `CustomClipper`, `ListenableBuilder` to trigger
  animation
- `Transform` requires `Matrix4` instance modification be in `State.setState` to trigger complex
  animation

It's tedious to memorize and implement those animated widget;\
not only because the implementation is hard to be translated into a simple word,\
but also the chance that we want to create some beautiful animated looks,\
and we find out that we have to wrap our child widget maybe inside 3 nested parent widget or even 5
more widget!\
With this library,

- `Mationani` try to become the only parent widget when building an animation, which consumed `Ani`,
  and `Mation`.
- `Ani` is responsible for 'when' to build animation in `_MationaniState` of `Mationani`.
- `Mation` is responsible for 'what' is the animation, which consumed `Matable`, `Matalue`
- `Matable` implements almost all flutter transition widgets, `Transform` widget, even `ClipPath`,
  `CustomPaint`.
- `Matalue` implements `Animatable`, or `Tween`, and brings `Matrix4` and `Path` as animatable.

This is a library aims to integrate flutter animation and not limited to built-in animation.\
Hopes there are more implementation in the future!\
Here is the sample that only build in a widget with only one field.\
You can check the source code at `example/mationani_example.dart`.\

<img src="https://github.com/nomagicisreal/mationani/blob/main/example/mationani_example.gif?raw=true" alt="Example ">
