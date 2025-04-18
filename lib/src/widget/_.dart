part of '../../mationani.dart';

///
///
/// [Mationani]
///   [MationaniArrow]
///   [MationaniCutting]
///
///


///
/// [Mationani.mamion], [Mationani.manion]
/// [Mationani.mamionSequence]
///
class Mationani extends StatefulWidget {
  final Mation mation;
  final Ani ani;

  const Mationani({
    super.key,
    required this.ani,
    required this.mation,
  });

  Mationani.mamion({
    super.key,
    required this.ani,
    required Mamionability ability,
    required WidgetBuilder builder,
  }) : mation = Mamion(ability: ability, builder: builder);

  Mationani.manion({
    super.key,
    required this.ani,
    required WidgetParentBuilder parent,
    required Manionability ability,
  }) : mation = Manion(builder: parent, ability: ability);

  ///
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  /// see [AniSequenceStyle.sequence] for [abilities] creation
  ///
  factory Mationani.mamionSequence(
    int? step, {
    Key? key,
    required AniSequence sequence,
    required WidgetBuilder builder,
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
      ability: sequence.abilities[i],
      builder: builder,
    );
  }

  @override
  State<Mationani> createState() => _MationaniState();
}

class _MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late WidgetBuilder builder;

  WidgetBuilder get planForBuilder => widget.mation.planning(controller);

  @override
  void initState() {
    controller = widget.ani.initializing(this);
    builder = planForBuilder;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    widget.ani.updater(controller, oldWidget, widget);
    builder = planForBuilder;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => builder(context);
}

class MationaniArrow extends StatelessWidget {
  MationaniArrow({
    super.key,
    this.dimension = 40,
    required this.onTap,
    required this.direction,
    WidgetBuilder? builder,
  }) : builder = builder ?? FWidgetBuilder.of(FlutterLogo(size: dimension));

  final double dimension;
  final VoidCallback onTap;
  final Direction2DIn4 direction;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: RotatedBox(
        quarterTurns: direction.index,
        child: InkWell(
          onTap: onTap,
          child: Mationani.mamion(
            ability: MamionTransition.slide(
              FBetween.offset_0To(
                KGeometry.offset_square_1 / 2,
                curve: CurveFR.of(Curving.sinPeriodOf(2)),
              ),
            ),
            ani: Ani.initRepeat(duration: DurationFR.second1),
            builder: builder,
          ),
        ),
      ),
    );
  }
}

class MationaniCutting extends StatelessWidget {
  const MationaniCutting({
    super.key,
    this.pieces = 2,
    this.direction = Radian.bottomRight,
    this.curveFadeOut,
    this.curve,
    Ani? aniFadeOut,
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
    return Mationani(
      ani: ani,
      mation: Manion(
        ability: ManionParentChildren(
          parent: MamionTransition.fadeOut(curve: curveFadeOut),
          children: List.generate(
            pieces,
            (index) => Mamion(
              ability: MamionMulti.leave(
                alignment: Alignment.bottomRight,
                rotation: FBetween.double_0To(
                  (index == 0 ? -rotation : rotation) / Radian.angle_360,
                  curve: curve,
                ),
                sliding: FBetween.offset_0To(
                  index == 0
                      ? KGeometry.offset_bottomLeft * distance
                      : KGeometry.offset_topRight * distance,
                  curve: curve,
                ),
              ),
              builder: (context) => ClipPath(
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
          ),
        ),
        builder: FWidgetBuilder.parent_stack(),
      ),
    );
  }
}
