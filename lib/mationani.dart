///
///
/// this library shows my opinion of animated widget in dart.
///
///
library;

import 'package:vector_math/vector_math_64.dart' as v64;
import 'package:damath/damath.dart';
import 'package:datter/datter.dart';
import 'package:flutter/material.dart';

part 'src/_impl.dart';
part 'src/animation.dart';
part 'src/matable.dart';
part 'src/matalue.dart';

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
