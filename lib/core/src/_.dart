part of '../mationani.dart';

///
///
/// [Mationani]
///
///
/// * [AnimationControllerExtension]
/// * [AnimationStyleExtension]
/// * [AnimationControllerInitializer]
/// * [AnimationUpdater]
/// * [AniSequencer]
///
/// * [OnAnimate]
/// * [OnAnimatePath]
/// * [OnAnimateMatrix4]
/// * [AnimationBuilder]
///
///
///
final class Mationani extends StatefulWidget {
  final Ani ani;
  final Mation mation;

  const Mationani({
    super.key,
    required this.ani,
    required this.mation,
  });

  // create animation for a child
  Mationani.mamion({
    super.key,
    required this.ani,
    required Mamable mamable,
    required Widget child,
  }) : mation = Mamion(mamable: mamable, child: child);

  // create animation for children
  Mationani.manion({
    super.key,
    required this.ani,
    required Manable manable,
    required Parenting parenting,
    required List<Widget> children,
  }) : mation = _Manion(
            manable: manable, child: parenting, grandChildren: children);



  ///
  ///
  ///
  @override
  State<Mationani> createState() => _MationaniState();

  static bool dismissUpdateBuilder(Mationani oldWidget, Mationani widget) =>
      oldWidget.mation == widget.mation &&
      oldWidget.ani.style.isCurveEqualTo(widget.ani.style);
}

class _MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late Widget child;

  Widget get planForChild => widget.mation.plan(
        controller,
        widget.ani.curve,
      );

  @override
  void initState() {
    super.initState();
    widget.ani.initialConsumeSetStateCallback?.call(() => setState(() {}));
    controller = widget.ani.initializing(this);
    child = planForChild;
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
  /// we can also received [_MationaniState.setState] callback by [Ani.initialConsumeSetStateCallback] in parent,
  ///
  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.ani.updating(controller, oldWidget, widget);
    if (Mationani.dismissUpdateBuilder(widget, oldWidget)) return;
    child = planForChild;
  }

  @override
  Widget build(BuildContext context) => child;
}

///
///
///
extension AnimationControllerExtension on AnimationController {
  ///
  ///
  ///
  void addStatusListenerIfNotNull(AnimationStatusListener? statusListener) {
    if (statusListener != null) addStatusListener(statusListener);
  }

  void addListenerIfNotNull(VoidCallback? listener) {
    if (listener != null) addListener(listener);
  }

  ///
  ///
  ///
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void updateDurationIfNew(Mationani oldWidget, Mationani widget) {
    final style = widget.ani.style;
    final styleOld = oldWidget.ani.style;
    if (styleOld?.duration != style?.duration) duration = style?.duration;
    if (styleOld?.reverseDuration != style?.reverseDuration) {
      reverseDuration = style?.reverseDuration;
    }
  }
}

extension AnimationStyleExtension on AnimationStyle? {
  bool isCurveEqualTo(AnimationStyle? another) {
    final style = this;
    if (style == null) return another == null;
    if (another == null) return false;
    return style.curve == another.curve &&
        style.reverseCurve == another.reverseCurve;
  }
}

///
///
///
typedef AnimationControllerInitializer = AnimationController Function(
  TickerProvider vsync,
  Duration forward,
  Duration reverse,
);
typedef AnimationUpdater = void Function(
  AnimationController controller,
  Mationani oldWidget,
  Mationani widget,
);

///
///
///
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Point3>;
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);
