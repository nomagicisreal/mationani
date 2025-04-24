part of '../mationani.dart';

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

///
///
/// See Also:
///   * [MationaniArrow], [MationaniCutting], ... are stateless widgets implemented [Mationani] as parent
///   * [FabExpandable] is expandable version of material [FloatingActionButton] in [Scaffold]
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
  }) : mation = _Mamion(mamable: mamable, child: child);

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
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  factory Mationani.mamionSequence(
    int? step, {
    Key? key,
    required AniSequence sequence,
    required Widget child,
    required AnimationControllerInitializer initializer,
  }) {
    final i = step ?? 0;
    return Mationani.mamion(
      key: key,
      ani: Ani.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
      ),
      mamable: sequence.abilities[i],
      child: child,
    );
  }

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
    controller = widget.ani.initializing(this);
    widget.ani.initialConsumeSetStateCallback?.call(() => setState(() {}));
    child = planForChild;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  ///
  /// In parent widget, if we directly call to [setState] function triggering [_MationaniState.didUpdateWidget],
  /// whenever widget configuration changed or not.
  /// if it's expensive to [setState] or update widget cause some unwanted behavior,
  /// we can also received [_MationaniState.setState] callback by [Ani.initialConsumeSetStateCallback],
  /// by calling [_MationaniState.setState], [_MationaniState.didUpdateWidget] won't be called.
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

typedef AniSequencer<M extends Matable>
    = Sequencer<AniSequenceStep, AniSequenceInterval, M>;

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
