part of '../api.dart';

///
///
/// [MationaniArrow]
/// [MationaniCutting]
///
///

///
///
///
class MationaniArrow extends StatelessWidget {
  const MationaniArrow({
    super.key,
    this.dimension = 40,
    required this.onTap,
    required this.direction,
    required this.child,
  });

  final double dimension;
  final VoidCallback onTap;
  final Direction2DIn4 direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: RotatedBox(
        quarterTurns: direction.index,
        child: InkWell(
          onTap: onTap,
          child: Mationani.mamion(
            ani: Ani.initRepeat(),
            mamable: MamableTransition.slide(
              FMationValue.offset_0To(
                KGeometry.offset_square_1 / 2,
                curve: CurveFR.of(Curving.sinPeriodOf(2)),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

///
///
///
class MationaniCutting extends StatelessWidget {
  const MationaniCutting({
    super.key,
    this.pieces = 2,
    this.direction = Radian.bottomRight,
    this.curveFadeOut,
    this.curve,
    required this.ani,
    required this.rotation,
    required this.distance,
    required this.child,
  }) : assert(pieces == 2 && direction == Radian.bottomRight);

  final int pieces;
  final double direction;
  final double rotation;
  final double distance;
  final Ani ani;
  final CurveFR? curveFadeOut;
  final CurveFR? curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Mationani.manion(
      ani: ani,
      manable: ManableMappingWithParent(
        parent: MamableTransition.fadeOut(curve: curveFadeOut),
        children: List.generate(
          pieces,
          (index) => MamableSet.leave(
            alignment: Alignment.bottomRight,
            rotation: FMationValue.between_double_0To(
              (index == 0 ? -rotation : rotation) / Radian.angle_360,
              curve: curve,
            ),
            sliding: FMationValue.offset_0To(
              index == 0
                  ? KGeometry.offset_bottomLeft * distance
                  : KGeometry.offset_topRight * distance,
              curve: curve,
            ),
          ),
        ),
      ),
      parenting: FWidgetBuilder.parent_stack(),
      children: List.generate(
        pieces,
        (index) => ClipPath(
          clipper: Clipping.reclipNever(
            index == 0
                ? (size) => Path()
                  ..lineToPoint(size.bottomRight(Offset.zero))
                  ..lineToPoint(size.bottomLeft(Offset.zero))
                : (size) => Path()
                  ..lineToPoint(size.bottomRight(Offset.zero))
                  ..lineToPoint(size.topRight(Offset.zero)),
          ),
          child: child,
        ),
      ),
    );
  }
}
