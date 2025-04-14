part of '../../mationani.dart';

///
///
/// [FabExpandable]
///   * [FabElementsInitializer]
///   * [FabExpandableElementsSetup]
///   * [_FabExpandableElements]
///
///

///
///
///
class FabExpandable extends StatefulWidget {
  const FabExpandable({
    super.key,
    this.setup = FabElementsInitializer.setupRadiationCircle,
    this.initialOpen = false,
    this.openIcon = WIconMaterial.create,
    this.closeIcon = WIconMaterial.close,
    this.curve = CurveFR.easeInOut,
    this.fabLocation = FloatingActionButtonLocation.endFloat,
    this.elementsAlign = Alignment.bottomRight,
    this.speedCloseFromOpen = 0.8,
    required this.durationOpen,
    required this.elements,
  });

  final FabExpandableElementsSetup setup;
  final bool initialOpen;
  final Icon openIcon;
  final Icon closeIcon;
  final Duration durationOpen;
  final double speedCloseFromOpen;
  final CurveFR curve;
  final Alignment elementsAlign;
  final FloatingActionButtonLocation fabLocation;
  final List<IconAction> elements;

  DurationFR get duration => DurationFR.rated(durationOpen, speedCloseFromOpen);

  @override
  State<FabExpandable> createState() => _FabExpandableState();
}

class _FabExpandableState extends State<FabExpandable>
    with OverlayStateMixin<FabExpandable> {
  final LayerLink _openButtonLink = LayerLink();

  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    widget.initialOpen ? _isOpen = true : _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.elementsAlign,
      clipBehavior: Clip.none,
      children: [
        _closeButton,
        CompositedTransformTarget(link: _openButtonLink, child: _openButton),
      ],
    );
  }

  Widget get _openButton => IgnorePointer(
        ignoring: _isOpen,
        child: Mationani.mamion(
          ani: Ani.updateForwardOrReverseWhen(_isOpen,
              duration: widget.duration),
          ability: MamionMulti.appear(
            fading: FBetween.double_0From(1, curve: widget.curve),
            scaling: FBetween.double_1To(0.7, curve: widget.curve),
          ),
          builder: (context) => FloatingActionButton(
            onPressed: _onTap,
            child: widget.openIcon,
          ),
        ),
      );

  Widget get _closeButton => IgnorePointer(
        ignoring: !_isOpen,
        child: SizedBoxCenter.fromSize(
          size: KGeometry.size_square_1 * 56,
          child: Material(
            shape: FBorderOutlined.circle(side: BorderSide.none),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: InkWell(
              onTap: _onTap,
              child: Padding(
                padding: KGeometry.edgeInsets_all_1 * 8,
                child: widget.closeIcon,
              ),
            ),
          ),
        ),
      );

  ///
  /// If element buttons built in [Stack] as [Scaffold]'s [FloatingActionButton],
  /// all the children in [Stack] are constrained by initial size, no matter children are 'expanded' or not.
  /// there is no response when user taps on any expanded button translated outside constraints.
  /// It's more flexible to insert a new overlay instead of setting the correct stack constraints at beginning,
  ///
  void _onTap() {
    setState(() => _isOpen = !_isOpen);
    if (overlays.isEmpty) {
      overlayInsert(
        builder: (context) => _FabExpandableElements(
          ignoring: !_isOpen,
          generatorAni: (i) => Ani.update(
            initializer: Ani.initializeForward,
            duration: widget.duration,
            onNotAnimating: Ani.decideForwardOrReverse(_isOpen),
          ),
          setup: widget.setup(
            context: context,
            openButtonOffset: _openButtonLink.leader!.offset,
            openButtonSize: _openButtonLink.leaderSize!,
            openButtonLocation: widget.fabLocation,
            elementsAlign: widget.elementsAlign,
            elements: widget.elements,
          ),
          link: _openButtonLink,
          alignment: widget.elementsAlign,
        ),
      );
    }
    overlays.last.markNeedsBuild();
  }
}

///
///
///
class _FabExpandableElements extends StatelessWidget {
  const _FabExpandableElements({
    required this.ignoring,
    required this.generatorAni,
    required this.setup,
    required this.link,
    required this.alignment,
  });

  final bool ignoring;
  final Generator<Ani> generatorAni;
  final FabElementsInitializer setup;
  final LayerLink link;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: CompositedTransformFollower(
        link: link,
        offset: link.leader!.offset,
        targetAnchor: alignment,
        followerAnchor: alignment,
        child: Stack(
          alignment: Alignment.topLeft,
          children: setup.icons.iterator.mapToListByIndex(
            (iconAction, i) => Mationani.mamion(
              ani: generatorAni(i),
              ability: setup.mationsGenerator(i),
              builder: setup.builder(setup.icons[i]),
            ),
          ),
        ),
      ),
    );
  }
}

///
/// TODO: accomplish fab expandable implementation
/// 1. define possible styles of expandable fab elements
/// 2. define variables related to expandable elements
/// 3. define a private class helps to translate from 1 to 2
/// 4. update [FabElementsInitializer]
/// 5. make it work
///
typedef FabExpandableElementsSetup = FabElementsInitializer Function({
  required BuildContext context,
  required Offset openButtonOffset,
  required Size openButtonSize,
  required FloatingActionButtonLocation openButtonLocation,
  required Alignment elementsAlign,
  required List<IconAction> elements,
});

///
///
/// [positioned], [alignment], [mationsGenerator], [icons], ...
///
///
class FabElementsInitializer {
  final Alignment alignment;
  final Generator<Mamionability> mationsGenerator;
  final List<IconAction> icons;
  final Mapper<IconAction, WidgetBuilder> builder;

  FabElementsInitializer({
    this.builder = FabElementsInitializer.builderMaterial,
    required this.alignment,
    required this.mationsGenerator,
    required this.icons,
  });

  ///
  /// builder
  ///
  static WidgetBuilder builderMaterial(IconAction iconAction) => (context) =>
      Material(
        shape: FBorderOutlined.continuousRectangle(
          side: FBorderSide.solidCenter(),
          borderRadius: KGeometry.borderRadius_circularAll_1 * 10,
        ),
        child: IconButton(icon: iconAction.icon, onPressed: iconAction.action),
      );

  ///
  ///
  ///
  factory FabElementsInitializer.radiationCircle({
    required BuildContext context,
    required Offset from,
    required Generator<double> direction,
    required List<IconAction> elements,
    double distance = 2,
    double maxSize = 24,
    CurveFR curve = CurveFR.fastOutSlowIn,
  }) =>
      FabElementsInitializer(
        // positioned: RectExtension.fromCircle(
        //   from,
        //   (1 + 2 * distance) * IconAction.maxSize(elements, context, maxSize),
        // ),
        alignment: Alignment.center,
        mationsGenerator: MamionMulti.generateSpill(
          direction,
          distance,
          curve: curve,
          total: elements.length,
        ),
        icons: elements,
      );

  factory FabElementsInitializer.lineOut({
    double distance = 1.2,
    double maxSize = 24,
    CurveFR curve = CurveFR.ease,
    required BuildContext context,
    required Rect openIconRect,
    required Direction2DIn8 direction,
    required List<IconAction> elements,
  }) {
    final total = elements.length;
    final d = distance * direction.scaleOnGrid;
    final alignment = AlignmentExtension.fromDirection(direction.flipped);
    return FabElementsInitializer(
      // positioned: FExtruding2D.directByDimension(
      //   rect: openIconRect,
      //   direction: direction,
      //   dimension: IconAction.maxSize(elements, context, maxSize) * 2,
      // )(d * total),
      alignment: alignment,
      mationsGenerator: MamionMulti.generateShoot(
        OffsetExtension.unitFromDirection(direction) * d,
        curve: curve,
        total: total,
        alignmentScale: alignment,
      ),
      icons: elements,
    );
  }

  ///
  /// setup
  ///
  static FabElementsInitializer setupRadiationCircle({
    bool isClockwise = false,
    required BuildContext context,
    required Offset openButtonOffset,
    required Size openButtonSize,
    required FloatingActionButtonLocation openButtonLocation,
    required Alignment elementsAlign,
    required List<IconAction> elements,
  }) =>
      FabElementsInitializer.radiationCircle(
        context: context,
        from: openButtonOffset,
        direction: elementsAlign.directionOfSideSpace(
          isClockwise,
          elements.length,
        ),
        elements: elements,
      );

  static FabExpandableElementsSetup setupLineOutFrom(
    Direction2DIn8 direction,
  ) =>
      ({
        required BuildContext context,
        required Offset openButtonOffset,
        required Size openButtonSize,
        required FloatingActionButtonLocation openButtonLocation,
        required Alignment elementsAlign,
        required List<IconAction> elements,
      }) =>
          FabElementsInitializer.lineOut(
            context: context,
            openIconRect: openButtonOffset & openButtonSize,
            direction: direction,
            elements: elements,
          );

// line on
}
