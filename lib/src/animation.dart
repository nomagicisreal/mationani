part of '../mationani.dart';

///
///
/// [Mationani]
/// * [Ani]
/// * [Mation]
///     --[_Mamion]
///     --[_Manion]
///
///
///

///
///
/// [Mationani] takes [Mation] ([Mationani.mation])
/// [Mation] takes [Matable] ([Mation.matable])
/// [Matable] takes [Matalue] ([_MatableDriver.matalue], [MamableSet.ables].matalueS)
/// [Matalue] is the subtype of [Animatable], super type of [Between]
/// [Between] is similar to [Tween], having more custom implementation
///
///
final class Mationani extends StatefulWidget {
  final Ani ani;
  final Mation mation;
  final (Duration, Duration) duration;

  // create animation for a child
  Mationani.mamion({
    super.key,
    this.duration = const (_durationDefault, _durationDefault),
    required this.ani,
    required Mamable mamable,
    required Widget child,
  }) : mation = _Mamion(mamable: mamable, child: child);

  // create animation for children
  Mationani.manion({
    super.key,
    this.duration = const (_durationDefault, _durationDefault),
    required this.ani,
    required Manable manable,
    required Widget Function(List<Widget> children) parenting,
    required List<Widget> children,
  }) : mation = _Manion(
          manable: manable,
          child: parenting,
          grandChildren: children,
        );

  @override
  State<Mationani> createState() => _MationaniState();

  static bool dismissUpdateBuilder(Mationani oldWidget, Mationani widget) =>
      oldWidget.duration == widget.duration &&
      oldWidget.mation.matable == widget.mation.matable &&
      oldWidget.ani == widget.ani;
}

class _MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin<Mationani> {
  late final AnimationController controller;
  late Widget child;

  @override
  void initState() {
    super.initState();
    final widget = this.widget, duration = widget.duration;
    controller = widget.ani.initializer(this, duration.$1, duration.$2);
    child = widget.mation.plan(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  ///
  /// If we called [setState] function in parent widget,
  /// it triggers [_MationaniState.didUpdateWidget] no matter [Mationani] configuration changed or not.
  /// Instead of performing the expensive [setState] function in parent,
  /// we can also received [_MationaniState.setState] callback by [Ani.setStateProvider] in parent,
  ///
  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    super.didUpdateWidget(oldWidget);
    final widget = this.widget;
    widget.ani.updater?.call(controller, oldWidget, widget);
    if (Mationani.dismissUpdateBuilder(widget, oldWidget)) return;
    child = widget.mation.plan(controller);
  }

  @override
  Widget build(BuildContext context) => child;
}

///
///
///
abstract final class Mation<A extends Matable, C> {
  final A matable;
  final C child;

  const Mation({required this.matable, required this.child});

  Widget plan(Animation<double> parent);

  @override
  String toString() => 'Mation($matable)';
}

///
/// [_Mamion] responsible for animation on a child widget. ([SizedBox], [Container], [Scaffold], ...)
///
final class _Mamion extends Mation<Mamable, Widget> {
  const _Mamion({required Mamable mamable, required super.child})
      : super(matable: mamable);

  @override
  Widget plan(Animation<double> parent) => matable._perform(parent, child);
}

///
/// [_Manion] responsible for animation on a parent widget with 'children'. ([Stack], [Column], ...)
///
final class _Manion
    extends Mation<Manable, Widget Function(List<Widget> children)> {
  final List<Widget> grandChildren;

  const _Manion({
    required Manable manable,
    required super.child,
    required this.grandChildren,
  }) : super(matable: manable);

  @override
  Widget plan(Animation<double> parent) {
    final matable = this.matable;
    return matable is _ManableParent
        ? (matable as _ManableParent).parent._perform(
              parent,
              child(matable._perform(parent, grandChildren)),
            )
        : child(matable._perform(parent, grandChildren));
  }
}

// ///
// ///
// ///
// /// todo: sequence step by step (onAnimating -> next)
// ///
// ///
// class MationaniSequence<T> extends StatefulWidget {
//   final List<T> steps;
//   final List<AnimationStyle>? styles;
//   final Duration defaultDuration;
//   final Curve defaultCurve;
//   final Mation Function(T, T, BiCurve) sMation;
//   final AniSequence ani;
//
//   MationaniSequence.mamion({
//     super.key,
//     this.styles,
//     this.defaultDuration = _durationDefault,
//     this.defaultCurve = Curves.fastOutSlowIn,
//     required this.steps,
//     required this.ani,
//     required Mamable Function(T, T, BiCurve) sMamable,
//     required Widget child,
//   }) : sMation = _sMamion(sMamable, child);
//
//   MationaniSequence.manion({
//     super.key,
//     this.styles,
//     this.defaultDuration = _durationDefault,
//     this.defaultCurve = Curves.fastOutSlowIn,
//     required this.steps,
//     required this.ani,
//     required Manable Function(T, T, BiCurve) sManable,
//     required Widget Function(List<Widget> children) parenting,
//     required List<Widget> children,
//   }) : sMation = _sManion(sManable, parenting, children);
//
//   ///
//   ///
//   ///
//   static _Mamion Function(T, T, BiCurve) _sMamion<T>(
//     Mamable Function(T, T, BiCurve) mamable,
//     Widget child,
//   ) =>
//       (previous, next, curve) =>
//           _Mamion(mamable: mamable(previous, next, curve), child: child);
//
//   static _Manion Function(T, T, BiCurve) _sManion<T>(
//     Manable Function(T, T, BiCurve) manable,
//     Widget Function(List<Widget> children) parenting,
//     List<Widget> children,
//   ) =>
//       (previous, next, curve) => _Manion(
//             manable: manable(previous, next, curve),
//             child: parenting,
//             grandChildren: children,
//           );
//
//   @override
//   State<MationaniSequence<T>> createState() => _MationaniSequenceState<T>();
//
//   ///
//   /// except animation controller repeats forward-reverse-forward... (0.0 ~ 1.0 ~ 0.0 ~ 1.0 ...)
//   /// return (durationForward, durationReverse, curveForward, curveReverse, mamable)
//   ///
//   static List<(Duration, Duration, T, T, BiCurve)> stepsFrom<T>(
//     List<T> steps, {
//     List<AnimationStyle>? styles,
//     Duration defaultDuration = _durationDefault,
//     Curve defaultCurve = Curves.fastOutSlowIn,
//   }) {
//     late final int count;
//     late final List<(Duration, Duration, Curve, Curve)> times;
//     if (styles == null) {
//       count = steps.length - 1;
//       times = List.filled(count,
//           (defaultDuration, defaultDuration, defaultCurve, defaultCurve));
//     } else {
//       count = styles.length;
//       times = List.of(
//         [
//           ...styles.map(
//             (style) => (
//               style.duration ?? defaultDuration,
//               style.reverseDuration ?? defaultDuration,
//               style.curve ?? defaultCurve,
//               style.reverseCurve ?? defaultCurve
//             ),
//           )
//         ],
//         growable: false,
//       );
//       assert(count + 1 == steps.length);
//     }
//
//     // controller is forward(0.0 ~ 1.0) when i % 2 == 0
//     // controller is reverse(1.0 ~ 0.0) when i % 2 == 1
//     final elements = <(Duration, Duration, T, T, BiCurve)>[];
//     var previous = steps[0];
//     for (var i = 0; i < count; i++) {
//       final next = steps[i + 1], fr = times[i];
//       elements.add(
//         i % 2 == 0
//             ? (fr.$1, fr.$2, previous, next, (fr.$3, fr.$4))
//             : (fr.$2, fr.$1, next, previous, (fr.$4, fr.$3)),
//       );
//       previous = next;
//     }
//     return List.of(elements, growable: false);
//   }
//
//   static bool dismissUpdateBuilder<T>(
//     MationaniSequence<T> oldWidget,
//     MationaniSequence<T> widget,
//   ) =>
//       oldWidget.steps == widget.steps &&
//       oldWidget.styles == widget.styles &&
//       oldWidget.defaultDuration == widget.defaultDuration &&
//       oldWidget.defaultCurve == widget.defaultCurve &&
//       oldWidget.sMation == widget.sMation &&
//       oldWidget.ani == widget.ani;
// }
//
// class _MationaniSequenceState<T> extends State<MationaniSequence<T>>
//     with SingleTickerProviderStateMixin<MationaniSequence<T>> {
//   final List<(Duration, Duration, T, T, BiCurve)> steps = [];
//   late final AnimationController controller;
//   late final int _iMax;
//   late Widget child;
//   int i = 0;
//
//   Widget get planForChild {
//     final widget = this.widget, current = steps[i];
//     return widget.sMation(current.$3, current.$4, current.$5).plan(controller);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     final widget = this.widget, steps = this.steps;
//     steps.addAll(MationaniSequence.stepsFrom(
//       widget.steps,
//       styles: widget.styles,
//       defaultDuration: widget.defaultDuration,
//       defaultCurve: widget.defaultCurve,
//     ));
//     _iMax = steps.length - 1;
//
//     final step = steps[0];
//     final controller = AnimationController(
//       vsync: this,
//       duration: step.$1,
//       reverseDuration: step.$2,
//     );
//     final initializer = widget.ani.commandInitialize;
//     if (initializer != null) {
//       late final AnimationStatusListener slListener;
//       slListener = switch (initializer) {
//         AniSequenceCommandInit.forward => _slForward,
//         AniSequenceCommandInit.forwardReset => (status) =>
//             _slForward(status, (_) {
//               i = 0;
//               controller.reset();
//             }),
//         AniSequenceCommandInit.forwardRepeat => (status) =>
//             _slForward(status, (_) {
//               i = 0;
//               controller
//                 ..reset()
//                 ..forward();
//             }),
//         AniSequenceCommandInit.pulse => (status) =>
//             _slForward(status, (completed) {
//               controller
//                 ..removeStatusListener(slListener)
//                 ..addStatusListener(_slReverse);
//               completed ? controller.reverse() : controller.forward();
//             }),
//         AniSequenceCommandInit.pulseRepeat => () {
//             late final AnimationStatusListener slF;
//             void reverse(AnimationStatus status) => _slReverse(
//                   status,
//                   (_) => controller
//                     ..removeStatusListener(reverse)
//                     ..addStatusListener(slF)
//                     ..forward(),
//                 );
//             slF = (status) => _slForward(
//                   status,
//                   (completed) {
//                     controller
//                       ..removeStatusListener(slF)
//                       ..addStatusListener(reverse);
//                     completed ? controller.reverse() : controller.forward();
//                   },
//                 );
//             return slF;
//           }(),
//         AniSequenceCommandInit.pulseExpanding => throw UnimplementedError(),
//       };
//       controller
//         ..addStatusListener(slListener)
//         ..forward();
//     }
//
//     this.controller = controller;
//     child = planForChild;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   void didUpdateWidget(covariant MationaniSequence<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final widget = this.widget;
//     if (widget.ani.commandUpdate != AniSequenceCommandUpdate.nothing) {
//       throw UnimplementedError();
//     }
//     if (MationaniSequence.dismissUpdateBuilder(widget, oldWidget)) return;
//     child = planForChild;
//   }
//
//   @override
//   Widget build(BuildContext context) => child;
//
//   void _slForward(
//     AnimationStatus status, [
//     void Function(bool)? listenFinished,
//   ]) {
//     switch (status) {
//       case AnimationStatus.dismissed:
//         if (i >= _iMax) return listenFinished?.call(false);
//         return controller.forwardAt(_durationNext().$1);
//       case AnimationStatus.completed:
//         if (i >= _iMax) return listenFinished?.call(true);
//         return controller.reverseAt(_durationNext().$1);
//       case AnimationStatus.forward || AnimationStatus.reverse:
//         return;
//     }
//   }
//
//   void _slReverse(
//     AnimationStatus status, [
//     void Function(bool)? listenFinished,
//   ]) {
//     switch (status) {
//       case AnimationStatus.dismissed:
//         if (i == -1) return listenFinished?.call(false);
//         return controller.forwardAt(_durationPrevious().$2);
//       case AnimationStatus.completed:
//         if (i == -1) return listenFinished?.call(true);
//         return controller.reverseAt(_durationPrevious().$2);
//       case AnimationStatus.forward || AnimationStatus.reverse:
//         return;
//     }
//   }
//
//   (Duration, Duration, T, T, BiCurve) _durationNext() {
//     setState(() => i++);
//     return steps[i];
//   }
//
//   (Duration, Duration, T, T, BiCurve) _durationPrevious() {
//     setState(() => i--);
//     return steps[i];
//   }
// }
