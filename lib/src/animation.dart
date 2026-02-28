part of '../mationani.dart';

///
///
/// [Mationani]
/// [Masionani]
///
///

///
///
/// [Mationani] takes [Mation] (by [Mationani.mation])
/// [Matable] takes [Matalue] ( by [_MatableDriver.matalue], [MamableSet.ables].matalueS)
/// [Matalue] is the subtype of [Animatable], supertype of [Between]
/// [Between] is similar to [Tween], with more custom implementation
///
///
final class Mationani extends StatefulWidget {
  final Ani ani;
  final Widget Function(Animation<double>) mation;
  final (Duration, Duration) duration;

  ///
  /// create animation for a child ([SizedBox], [Container], [Scaffold], ...)
  ///
  Mationani.m({
    super.key,
    this.duration = const (_durationDefault, _durationDefault),
    required this.ani,
    required Mamable mamable,
    required Widget child,
  }) : mation = _planMamion(mamable, child);

  ///
  /// create animation on a parent widget with 'children'. ([Stack], [Column], ...)
  ///
  Mationani.n({
    super.key,
    this.duration = const (_durationDefault, _durationDefault),
    required this.ani,
    required Manable manable,
    required Widget Function(List<Widget>) parenting,
    required List<Widget> children,
  }) : mation = _planManion(manable, parenting, children);

  @override
  State<Mationani> createState() => _MationaniState();

  ///
  ///
  ///
  static Widget Function(Animation<double>) _planMamion(
    Mamable mamable,
    Widget child,
  ) =>
      (parent) => mamable._perform(parent, child);

  static Widget Function(Animation<double>) _planManion(
    Manable manable,
    Widget Function(List<Widget>) parenting,
    List<Widget> children,
  ) =>
      (parent) {
        final child = parenting(manable._perform(parent, children));
        if (manable is! _ManableParent) return child;
        return (manable as _ManableParent).parent._perform(parent, child);
      };

  static bool _dismissUpdateBuilder(Mationani oldWidget, Mationani widget) =>
      oldWidget.duration == widget.duration &&
      oldWidget.mation == widget.mation &&
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
    child = widget.mation(controller);
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
    if (Mationani._dismissUpdateBuilder(widget, oldWidget)) return;
    child = widget.mation(controller);
  }

  @override
  Widget build(BuildContext context) => child;
}

///
///
///
///
///
/// [Masionani] is the sequenceable version of [Mationani],
/// we can provide [styles] duration for each animation [steps].
/// While [AnimationStyle] properties are null by default,
/// there are [defaultDuration] and [defaultCurve] for each animation step.
///
///
///
///
class Masionani<T> extends StatefulWidget {
  final List<T> steps;
  final List<AnimationStyle>? styles;
  final Duration defaultDuration;
  final Curve defaultCurve;
  final Widget Function(T, T, BiCurve, Animation<double>) sequencing;
  final AniSequenceCommandInit? aniInit;
  final AniSequenceCommandUpdate? aniUpdate;

  Masionani.m({
    super.key,
    this.styles,
    this.defaultDuration = _durationDefault,
    this.defaultCurve = Curves.fastOutSlowIn,
    this.aniInit,
    this.aniUpdate,
    required this.steps,
    required Mamable Function(T, T, BiCurve) sMamable,
    required Widget child,
  })  : sequencing = _sequenceMamion(sMamable, child),
        assert(
          steps.length > 2,
          'Prefer using Mationani when there is only 1 animation: $steps',
        );

  Masionani.n({
    super.key,
    this.styles,
    this.defaultDuration = _durationDefault,
    this.defaultCurve = Curves.fastOutSlowIn,
    this.aniInit,
    this.aniUpdate,
    required this.steps,
    required Manable Function(T, T, BiCurve) sManable,
    required Widget Function(List<Widget> children) parenting,
    required List<Widget> children,
  })  : sequencing = _sequenceManion(sManable, parenting, children),
        assert(
          steps.length > 1,
          'Prefer using Mationani when there is only 1 animation: $steps',
        );

  @override
  State<Masionani<T>> createState() => _MasionaniState<T>();

  ///
  /// except animation controller repeats forward-reverse-forward... (0.0 ~ 1.0 ~ 0.0 ~ 1.0 ...)
  /// return (durationForward, durationReverse, curveForward, curveReverse, mamable)
  ///
  List<(Duration, Duration, T, T, BiCurve)> get elements {
    late final int count;
    late final List<(Duration, Duration, Curve, Curve)> times;
    final styles = this.styles;
    if (styles == null) {
      count = steps.length - 1;
      times = List.filled(count,
          (defaultDuration, defaultDuration, defaultCurve, defaultCurve));
    } else {
      count = styles.length;
      times = List.of(
        [
          ...styles.map(
            (style) => (
              style.duration ?? defaultDuration,
              style.reverseDuration ?? defaultDuration,
              style.curve ?? defaultCurve,
              style.reverseCurve ?? defaultCurve
            ),
          )
        ],
        growable: false,
      );
      assert(count + 1 == steps.length);
    }
    assert(count > 1);

    // controller is forward(0.0 ~ 1.0) when i % 2 == 0
    // controller is reverse(1.0 ~ 0.0) when i % 2 == 1
    final elements = <(Duration, Duration, T, T, BiCurve)>[];
    var previous = steps[0];
    for (var i = 0; i < count; i++) {
      final next = steps[i + 1], fr = times[i];
      elements.add(
        i % 2 == 0
            ? (fr.$1, fr.$2, previous, next, (fr.$3, fr.$4))
            : (fr.$2, fr.$1, next, previous, (fr.$4, fr.$3)),
      );
      previous = next;
    }
    return List.of(elements, growable: false);
  }

  ///
  ///
  ///
  static Widget Function(T, T, BiCurve, Animation<double>) _sequenceMamion<T>(
    Mamable Function(T, T, BiCurve) sMamable,
    Widget child,
  ) =>
      (previous, next, curve, parent) =>
          sMamable(previous, next, curve)._perform(parent, child);

  static Widget Function(T, T, BiCurve, Animation<double>) _sequenceManion<T>(
    Manable Function(T, T, BiCurve) sManable,
    Widget Function(List<Widget>) parenting,
    List<Widget> children,
  ) =>
      (previous, next, curve, parent) {
        final manable = sManable(previous, next, curve);
        final child = parenting(manable._perform(parent, children));
        if (manable is! _ManableParent) return child;
        return (manable as _ManableParent).parent._perform(parent, child);
      };
// static bool _dismissUpdateBuilder<T>(
//   MationaniSequence<T> oldWidget,
//   MationaniSequence<T> widget,
// ) =>
//     // oldWidget.steps == widget.steps && // already checked in didUpdateWidget
//     oldWidget.styles == widget.styles &&
//     oldWidget.defaultDuration == widget.defaultDuration &&
//     oldWidget.defaultCurve == widget.defaultCurve &&
//     oldWidget.sequencing == widget.sequencing &&
//     oldWidget.ani == widget.ani;
}

///
///
///
/// [_listenerInit], [_listenerUpdate]
/// [_slSequenceForward], [_slSequenceReverse]
/// [_durationNext], [_durationPrevious]
///
///
class _MasionaniState<T> extends State<Masionani<T>>
    with SingleTickerProviderStateMixin<Masionani<T>> {
  late final List<(Duration, Duration, T, T, BiCurve)> _steps;
  late final AnimationController _controller;
  late Widget Function(T, T, BiCurve, Animation<double>) _sequencing;

  ///
  /// Notice that the [_status] here is the status of [Masionani],
  /// not the status of [AnimationController.status]
  ///
  AnimationStatus _status = AnimationStatus.dismissed;
  int _i = 0;

  @override
  void initState() {
    super.initState();
    final widget = this.widget,
        steps = widget.elements,
        step = steps[0],
        controller = AnimationController(
          vsync: this,
          duration: step.$1,
          reverseDuration: step.$2,
        ),
        listener = _listenerInit(controller, widget.aniInit);

    _steps = steps;
    if (listener == null) {
      _controller = controller;
    } else {
      _controller = controller
        ..addStatusListener(listener)
        ..forward();
      _status = AnimationStatus.forward;
    }
    _sequencing = widget.sequencing;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant Masionani<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final widget = this.widget;
    if (widget.steps.isIdentical(oldWidget.steps)) {
      return _listenerUpdate(widget.aniUpdate);
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_i];
    return _sequencing(step.$3, step.$4, step.$5, _controller);
  }

  ///
  ///
  /// [_listenerInit]
  /// [_listenerUpdate]
  ///
  ///
  AnimationStatusListener? _listenerInit(
    AnimationController controller,
    AniSequenceCommandInit? initialize,
  ) =>
      switch (initialize) {
        null => null,
        AniSequenceCommandInit.forward => _slSequenceForward(),
        AniSequenceCommandInit.forwardStep => () {
            controller.forward().then((_) => setState(() => _i++));
            _status = AnimationStatus.forward;
            return null;
          }(),
        AniSequenceCommandInit.forwardReset => _slSequenceForward(
            (_) {
              setState(() => _i = 0);
              controller.reset();
              _status = AnimationStatus.dismissed;
            },
          ),
        AniSequenceCommandInit.forwardRepeat => _slSequenceForward(
            (_) {
              setState(() => _i = 0);
              controller.reset();
              controller.forward();
              _status = AnimationStatus.forward;
            },
          ),
        AniSequenceCommandInit.pulse => _slSequenceForward(
            (completed) {
              controller.addStatusListener(_slSequenceReverse());
              completed ? controller.reverse() : controller.forward();
              _status = AnimationStatus.reverse;
            },
          ),
        AniSequenceCommandInit.pulseRepeat => () {
            AnimationStatusListener slF(status) => _slSequenceForward(
                  (completed) {
                    controller.addStatusListener(
                      _slSequenceReverse(
                        (_) {
                          controller.addStatusListener(slF);
                          controller.forward();
                          _status = AnimationStatus.forward;
                        },
                      ),
                    );
                    completed ? controller.reverse() : controller.forward();
                    _status = AnimationStatus.reverse;
                  },
                );
            return slF;
          }(),
      };

  void _listenerUpdate(AniSequenceCommandUpdate? update) {
    switch (update) {
      case null:
        return;

      //
      case AniSequenceCommandUpdate.stopOrResume:
        final controller = _controller;
        if (controller.isAnimating) {
          controller.stop();
          return;
        }
        switch (controller.status) {
          case AnimationStatus.dismissed || AnimationStatus.completed:
            return;
          case AnimationStatus.forward:
            controller.forward();
            return;
          case AnimationStatus.reverse:
            controller.reverse();
            return;
        }

      //
      case AniSequenceCommandUpdate.forwardIfDismissed:
        if (_status != AnimationStatus.dismissed) return;
        _controller
          ..addStatusListener(_slSequenceForward())
          ..forward();
        _status = AnimationStatus.forward;
        return;

      //
      case AniSequenceCommandUpdate.forwardStepExceptReverse:
        final controller = _controller;
        if (controller.isAnimating) return;
        switch (_status) {
          case AnimationStatus.dismissed:
            controller.forward().then(_thenNext);
            _status = AnimationStatus.forward;
            return;
          case AnimationStatus.forward:
            final i = _i;
            (i % 2 == 0
                ? controller.forward().then
                : controller.reverse().then)(
              i < _steps.length - 1 ? _thenNext : _thenComplete,
            );
            return;
          case AnimationStatus.completed || AnimationStatus.reverse:
            return;
        }

      //
      case AniSequenceCommandUpdate.reverseIfCompleted:
        if (_status != AnimationStatus.completed) return;
        final controller = _controller;
        controller.addStatusListener(_slSequenceReverse());
        controller.status == AnimationStatus.completed
            ? controller.reverse()
            : controller.forward();
        _status = AnimationStatus.reverse;
        return;

      //
      case AniSequenceCommandUpdate.reverseStepExceptForward:
        final controller = _controller;
        if (controller.isAnimating) return;
        switch (_status) {
          case AnimationStatus.completed:
            _i % 2 == 0
                ? controller.reverse().then(_thenPrevious)
                : controller.forward().then(_thenPrevious);
            _status = AnimationStatus.reverse;
            return;
          case AnimationStatus.reverse:
            final i = _i;
            (i % 2 == 0
                ? controller.reverse().then
                : controller.forward().then)(
              i > 0 ? _thenPrevious : _thenDismiss,
            );
            return;
          case AnimationStatus.forward || AnimationStatus.dismissed:
            return;
        }
    }
  }

  ///
  /// [_thenNext]
  /// [_thenPrevious]
  /// [_thenComplete]
  /// [_thenDismiss]
  ///
  void _thenNext(void _) => setState(() => _i++);

  void _thenPrevious(void _) => setState(() => _i--);

  void _thenComplete(void _) => _status = AnimationStatus.completed;

  void _thenDismiss(void _) => _status = AnimationStatus.dismissed;

  ///
  ///
  /// [_slSequenceForward]
  /// [_slSequenceReverse]
  ///
  ///
  AnimationStatusListener _slSequenceForward([
    void Function(bool)? listenFinished,
  ]) {
    final iMax = _steps.length - 1;
    void forward(AnimationStatus status) {
      switch (status) {
        case AnimationStatus.dismissed:
          if (_i >= iMax) {
            _status = AnimationStatus.completed;
            _controller.removeStatusListener(forward);
            return listenFinished?.call(false);
          }
          return _controller.forwardAt(_durationNext.$1);
        case AnimationStatus.completed:
          if (_i >= iMax) {
            _status = AnimationStatus.completed;
            _controller.removeStatusListener(forward);
            return listenFinished?.call(true);
          }
          return _controller.reverseAt(_durationNext.$1);
        case AnimationStatus.forward || AnimationStatus.reverse:
          return;
      }
    }

    return forward;
  }

  AnimationStatusListener _slSequenceReverse([
    void Function(bool)? listenFinished,
  ]) {
    void reverse(AnimationStatus status) {
      switch (status) {
        case AnimationStatus.dismissed:
          if (_i == 0) {
            _status = AnimationStatus.dismissed;
            _controller.removeStatusListener(reverse);
            return listenFinished?.call(false);
          }
          return _controller.forwardAt(_durationPrevious.$2);
        case AnimationStatus.completed:
          if (_i == 0) {
            _status = AnimationStatus.dismissed;
            _controller.removeStatusListener(reverse);
            return listenFinished?.call(true);
          }
          return _controller.reverseAt(_durationPrevious.$2);
        case AnimationStatus.forward || AnimationStatus.reverse:
          return;
      }
    }

    return reverse;
  }

  ///
  /// [_durationNext]
  /// [_durationPrevious]
  ///
  (Duration, Duration, T, T, BiCurve) get _durationNext {
    setState(() => _i++);
    return _steps[_i];
  }

  (Duration, Duration, T, T, BiCurve) get _durationPrevious {
    setState(() => _i--);
    return _steps[_i];
  }
}
