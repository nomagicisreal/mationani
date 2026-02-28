// ignore_for_file: unused_element_parameter
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

///
///
/// [SampleCutting]
///
///
class SampleCutting extends StatelessWidget {
  const SampleCutting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ScatteredOut.cut2(
          updater: Ani.updateFr,
          child: ColoredBox(
            color: Colors.purple,
            child: SizedBox.square(dimension: 100),
          ),
        ),
        _ScatteredOut.cut3(
          updater: Ani.updateFr,
          child: ColoredBox(
            color: Colors.amber,
            child: SizedBox.square(dimension: 100),
          ),
        ),
      ],
    );
  }
}

///
///
/// [_ScatteredOut]
///
///
class _ScatteredOut extends StatelessWidget {
  const _ScatteredOut({
    super.key,
    this.curveFadeOut,
    this.curveOverlay = const (Interval(0, 0.01), Interval(0, 0.01)),
    required this.initializer,
    required this.updater,
    required this.generatorMamableSet,
    required this.count,
    required this.generatorSizingPath,
    required this.child,
  });

  final AniInitializer initializer;
  final AniUpdater updater;
  final int count;
  final MamableSet Function(int index) generatorMamableSet;
  final Path Function(Size size) Function(int index) generatorSizingPath;
  final BiCurve? curveFadeOut;
  final BiCurve curveOverlay;
  final Widget child;

  ///
  /// cutting 2
  ///
  const _ScatteredOut.cut2({
    super.key,
    this.curveFadeOut,
    this.curveOverlay = const (Interval(0, 0.01), Interval(0, 0.01)),
    this.initializer = Ani.initialize,
    required this.updater,
    required this.child,
  })  : count = 2,
        generatorMamableSet = _generator2Mamable,
        generatorSizingPath = _generator2SizingPath;

  static MamableSet _generator2Mamable(int index) => MamableSet([
        MamableTransition.rotate(
          Between(0, index == 0 ? 1 / 12 : -1 / 12),
          alignment: Alignment.topLeft,
        ),
        MamableTransition.slide(
          Between(
            Offset.zero,
            index == 0 ? const Offset(-0.2, 0) : const Offset(0.2, 0),
          ),
        ),
      ]);

  static Path Function(Size size) _generator2SizingPath(int index) => index == 0
      ? (size) => Path()
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
      : (size) => Path()
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0);

  ///
  /// cutting 3
  ///
  const _ScatteredOut.cut3({
    super.key,
    this.curveFadeOut,
    this.curveOverlay = const (Interval(0, 0.01), Interval(0, 0.01)),
    this.initializer = Ani.initialize,
    required this.updater,
    required this.child,
  })  : count = 3,
        generatorMamableSet = _generator3Mamable,
        generatorSizingPath = _generator3SizingPath;

  static MamableSet _generator3Mamable(int index) => MamableSet([
        MamableTransition.scale(
          Between(1, index == 1 ? 0.8 : 0.3),
          alignment: switch (index) {
            0 => Alignment(-0.2, 0),
            1 => Alignment.center,
            2 => Alignment(0.2, 0),
            int() => throw UnimplementedError(),
          },
        ),
        MamableTransition.slide(
          Between(
            Offset.zero,
            switch (index) {
              0 => const Offset(-0.3, 0),
              1 => Offset.zero,
              2 => const Offset(0.3, 0),
              int() => throw UnimplementedError(),
            },
          ),
        ),
      ]);

  static Path Function(Size size) _generator3SizingPath(int index) =>
      switch (index) {
        0 => (size) => Path()
          ..lineTo(size.width * 0.3, 0)
          ..lineTo(size.width * 0.3, size.height)
          ..lineTo(0, size.height),
        1 => (size) => Path()
          ..moveTo(size.width * 0.3, 0)
          ..lineTo(size.width * 0.7, 0)
          ..lineTo(size.width * 0.7, size.height)
          ..lineTo(size.width * 0.3, size.height),
        2 => (size) => Path()
          ..moveTo(size.width * 0.7, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width * 0.7, size.height),
        int() => throw UnimplementedError(),
      };

  ///
  /// There is some bleeding edge despite [Clip.antiAliasWithSaveLayer] at [Stack] or [ClipPath],
  /// This is why parent [Stack], additional overlay is required.
  ///
  @override
  Widget build(BuildContext context) {
    final initializer = this.initializer,
        updater = this.updater,
        count = this.count,
        generatorSizingPath = this.generatorSizingPath,
        child = this.child;

    return Stack(
      children: [
        Mationani.n(
          initializer: initializer,
          updater: updater,
          manable: ManableSet.respectivelyAndParent(
            parent: MamableTransition.fadeOut(curve: curveFadeOut),
            children: List.generate(count, generatorMamableSet),
          ),
          parenting: (children) => Stack(children: children),
          children: List.generate(
            count,
            (i) => ClipPath(
              clipper: _Clipping.reclipNever(generatorSizingPath(i)),
              child: child,
            ),
          ),
        ),
        Mationani.m(
          initializer: initializer,
          updater: updater,
          mamable: MamableTransition.fadeOut(curve: curveOverlay),
          child: child,
        ),
      ],
    );
  }
}

class _Clipping extends CustomClipper<Path> {
  final Path Function(Size size) sizingPath;

  @override
  Path getClip(Size size) => sizingPath(size);

  @override
  bool shouldReclip(_Clipping oldClipper) => false;

  const _Clipping.reclipNever(this.sizingPath);
}
