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
    this.openIcon = WIcon.add,
    this.closeIcon = WIcon.close,
    this.curveOpen = Curves.easeInOut,
    this.curveClose = Curves.easeInOut,
    this.elementsAlign = Alignment.bottomRight,
    this.durationCloseRatedByOpen = 0.8,
    // FloatingActionButtonLocation.endFloat by default in Scaffold
    required this.initialLocation,
    this.durationOpen = KCore.durationSecond1,
    required this.elements,
  });

  final FloatingActionButtonLocation initialLocation;
  final bool initialOpen;
  final Duration durationOpen;
  final double durationCloseRatedByOpen;
  final Curve curveOpen;
  final Curve curveClose;
  final Icon openIcon;
  final Icon closeIcon;
  final Alignment elementsAlign;
  final List<IconAction> elements;
  final FabExpandableElementsSetup setup;

  AnimationStyle get style => AnimationStyle(
        duration: durationOpen,
        reverseDuration: durationOpen * durationCloseRatedByOpen,
        curve: curveOpen,
        reverseCurve: curveClose,
      );

  CurveFR get curve => CurveFR(curveOpen, curveClose);

  @override
  State<FabExpandable> createState() => _FabExpandableState();
}

class _FabExpandableState extends State<FabExpandable>
    with OverlayStateNormalMixin<FabExpandable> {
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
          ani: Ani.updateForwardOrReverseWhen(
            _isOpen,
            style: widget.style,
          ),
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
        child: Center(
          child: SizedBox.fromSize(
            size: KGeometry.size_square_1 * 56,
            child: Material(
              shape: FBorderOutlined.circle(side: BorderSide.none),
              clipBehavior: Clip.hardEdge,
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
        ),
      );

  ///
  /// If element buttons built as [StackFit.loose] in [Scaffold.floatingActionButton],
  /// all the children in [Stack] are constrained by initial size;
  /// though, there is no response when user taps on any child translated outside constraints;
  /// ideally, we can update fab parent constraints in [Scaffold] but there is no easy way to do that for now.
  /// It's more flexible to insert a new overlay to require all of fab element buttons to be responsible.
  ///
  void _onTap() {
    setState(() => _isOpen = !_isOpen);
    if (overlays.isEmpty) {
      overlayInsert(
        builder: (context) => _FabExpandableElements(
          ignoring: !_isOpen,
          ani: Ani.update(
            initializer: Ani.initializeForward,
            style: widget.style,
            onNotAnimating: Ani.decideForwardOrReverse(_isOpen),
          ),
          setup: widget.setup(
            context: context,
            openButtonOffset: _openButtonLink.leader!.offset,
            openButtonSize: _openButtonLink.leaderSize!,
            openButtonLocation: widget.initialLocation,
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
    required this.ani,
    required this.setup,
    required this.link,
    required this.alignment,
  });

  final bool ignoring;
  final Ani ani;
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
              ani: ani,
              ability: setup.mationsGenerator(i),
              builder: setup.builder(setup.icons[i]),
            ),
          ),
        ),
      ),
    );
  }
}

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
