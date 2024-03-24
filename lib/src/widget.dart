///
///
/// this file contains:
///
/// [Mationani]
///   [MationaniArrow]
///   [MationaniCutting]
///   ...
///
/// [OverlayFadingStream]
/// * [OverlayMixin]
/// * [OverlayInsertion]
///   * [OverlayInsertionFading]
///   [Leader]
///   * [FollowerInitializer]
///
/// [FabExpandable]
/// * [FabExpandableSetupInitializer]
/// * [AnimationControllerDecider]
///   * [_FabExpandableElements]
///   * [FabExpandableSetup]
///     * [FFabExpandableInitializer]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of mationani;
// ignore_for_file: use_string_in_part_of_directives

///
///
/// [Mationani.mamion], [Mationani.manion]
/// [Mationani.mamionSequence]
///
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
  }) : mation = Manion(parent: parent, ability: ability);

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
      ani: AniUpdateIfNotAnimating.updateSequencingWhen(
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
  }) : builder = builder ?? WWidgetBuilder.of(FlutterLogo(size: dimension));

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
              FBetween.offsetZeroTo(
                KOffset.square_1 / 2,
                curve: CurveFR.of(Curving.sinPeriodOf(2)),
              ),
            ),
            ani: AniUpdateIfNotAnimating(
              duration: DurationFR.second1,
              initializer: Ani.initializeRepeat,
            ),
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
      mation: Manion.stack(
        ability: ManionParentChildren(
          parent: MamionTransition.fadeOut(curve: curveFadeOut),
          children: List.generate(
            pieces,
            (index) => Mamion(
              ability: MamionMulti.leave(
                alignment: Alignment.bottomRight,
                rotation: FBetween.doubleZeroTo(
                  (index == 0 ? -rotation : rotation) / Radian.angle_360,
                  curve: curve,
                ),
                sliding: FBetween.offsetZeroTo(
                  index == 0
                      ? KOffset.bottomLeft * distance
                      : KOffset.topRight * distance,
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
      ),
    );
  }
}

///
///
///
///
///
/// overlay
///
///
///
///

class OverlayFadingStream extends StatefulWidget {
  const OverlayFadingStream({
    super.key,
    this.updateToResetCount = false,
    required this.insert,
    required this.update,
    required this.insertions,
    required this.child,
  });

  final Stream<int> insert;
  final Stream<int> update;
  final Supporter<OverlayInsertionFading> insertions;
  final bool updateToResetCount;
  final Widget child;

  @override
  State<OverlayFadingStream> createState() => _OverlayFadingStreamState();
}

class _OverlayFadingStreamState extends State<OverlayFadingStream>
    with OverlayMixin {
  late final StreamSubscription<int> subscription;
  late final StreamSubscription<int> subscriptionUpdate;
  final List<int> keys = [];
  int key = 0;

  @override
  void initState() {
    subscription = widget.insert.listen(
      (builder) {
        final key = this.key;
        keys.add(key);

        overlayInsertFading(
          widget.insertions(() => keys.indexOf(key)),
          onRemoveEntry: () => keys.remove(key),
        );

        this.key++;
      },
    );

    subscriptionUpdate = widget.update.listen((i) => overlayUpdate(i));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant OverlayFadingStream oldWidget) {
    if (widget.updateToResetCount) {
      key = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    subscription.cancel();
    subscriptionUpdate.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

///
///
///
/// [context]
/// [entries]
/// [_insertEntry], [_updateEntry], [_removeEntry]
///
/// [overlayInsert]
/// [overlayUpdate]
/// [overlayRemove]
/// [overlayInsertFading]
///
///
///
mixin OverlayMixin {
  BuildContext get context;

  final List<OverlayEntry> entries = [];

  OverlayEntry _insertEntry(
    OverlayEntry entry, {
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    Overlay.of(context).insert(entry, below: below, above: above);
    entries.add(entry);
    return entry;
  }

  void _updateEntry(OverlayEntry entry) => entry.markNeedsBuild();

  void _removeEntry(OverlayEntry entry) {
    entry.remove();
    entries.remove(entry);
  }

  OverlayEntry overlayInsert(OverlayInsertion insertion) => _insertEntry(
        insertion.entry,
        below: insertion.below,
        above: insertion.above,
      );

  void overlayUpdate([int? index]) {
    final i = index ?? entries.length - 1;
    assert(i >= 0);
    _updateEntry(entries[i]);
  }

  void overlayRemove([int? index]) {
    final i = index ?? entries.length - 1;
    assert(i >= 0);
    entries[i].remove();
    entries.removeAt(i);
  }

  OverlayEntry overlayInsertFading(
    OverlayInsertionFading insertion, {
    required VoidCallback onRemoveEntry,
  }) {
    late final OverlayEntry entry;
    entry = insertion.entry;
    final onRemove = insertion.onRemoveEntry;
    insertion.onRemoveEntry = () {
      onRemove();
      onRemoveEntry();
      _removeEntry(entry);
    };
    return _insertEntry(entry, below: insertion.below, above: insertion.above);
  }
}

class OverlayInsertion<T extends Widget> {
  final Mapper<BuildContext, T> builder;
  final bool opaque;
  final bool maintainState;
  final OverlayEntry? below;
  final OverlayEntry? above;

  const OverlayInsertion({
    required this.builder,
    this.opaque = false,
    this.maintainState = false,
    this.below,
    this.above,
  });

  OverlayEntry get entry => OverlayEntry(
        builder: builder,
        opaque: opaque,
        maintainState: maintainState,
      );
}

class OverlayInsertionFading<T extends Widget> extends OverlayInsertion<T> {
  final DurationFR duration;
  final Supplier<bool> shouldFadeOut;
  final CurveFR? curveFade;
  VoidCallback onRemoveEntry;

  OverlayInsertionFading.updateToFadeOut({
    super.opaque,
    super.maintainState,
    super.below,
    super.above,
    required super.builder,
    required this.duration,
    required this.shouldFadeOut,
    required this.onRemoveEntry,
    this.curveFade,
  });

  @override
  OverlayEntry get entry => OverlayEntry(
        opaque: opaque,
        maintainState: maintainState,
        builder: (context) => Mationani.mamion(
          ability: MamionTransition.fadeIn(curve: curveFade),
          ani: AniUpdateIfNotAnimating(
            initializer: Ani.initializeForwardWithListener(
              Ani.listenDismissed(onRemoveEntry),
            ),
            duration: duration,
            consumer: Ani.decideReverse(shouldFadeOut()),
          ),
          builder: builder,
        ),
      );
}

///
///
/// leader
///
///

typedef FollowerInitializer
    = Supporter<OverlayInsertionFading<CompositedTransformFollower>> Function(
  LayerLink link,
);

class Leader extends StatelessWidget {
  const Leader({
    super.key,
    this.updateToResetKey = true,
    required this.link,
    required this.following,
    required this.followingUpdate,
    required this.builder,
    required this.child,
  });

  final LayerLink link;
  final Stream<int> following;
  final Stream<int> followingUpdate;
  final FollowerInitializer builder;
  final bool updateToResetKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OverlayFadingStream(
      insert: following,
      update: followingUpdate,
      updateToResetCount: updateToResetKey,
      insertions: builder(link),
      child: CompositedTransformTarget(
        link: link,

        // leader
        child: child,
      ),
    );
  }
}

///
///
///
///
///
///
///
/// fab (floating action button)
///
///
///
///
///
///
///
///

typedef FabExpandableSetupInitializer = FabExpandableSetup Function({
  required BuildContext context,
  required Rect openIconRect,
  required Alignment openIconAlignment,
  required List<IconAction> icons,
});

typedef AnimationControllerDecider = Decider<AnimationController, bool>;

//
class FabExpandable extends StatefulWidget {
  const FabExpandable({
    super.key,
    this.initializer = FFabExpandableInitializer.orbitClockwise,
    this.initialOpen = false,
    this.openIcon = WIconMaterial.create,
    this.closeIcon = WIconMaterial.close,
    this.duration = DurationFR.milli300,
    this.curve = CurveFR.easeInOut,
    this.alignment = Alignment.bottomRight,
    required this.elements,
  });

  final FabExpandableSetupInitializer initializer;
  final bool initialOpen;
  final Icon openIcon;
  final Icon closeIcon;
  final DurationFR duration;
  final CurveFR curve;
  final Alignment alignment;
  final List<IconAction> elements;

  @override
  State<FabExpandable> createState() => _FabExpandableState();
}

class _FabExpandableState extends State<FabExpandable>
    with SingleTickerProviderStateMixin, OverlayMixin {
  final GlobalKey _openIconKey = GlobalKey();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialOpen) {
      _toggle();
    }
  }

  ///
  ///
  /// If included element buttons built in stack, the elements buttons constraint by parent's size of [FabExpandable].
  /// When elements constraint by parent's size, if elements are translated outside of constraints,
  /// they won't be response when user tapping them; therefore,
  /// it's more flexible to use [OverlayEntry] to have more generic 'floating animation, onTap function',
  /// see [Positioned.fromRect] in [_FabExpandableElements] to specify how much space elements need.
  ///
  ///
  void _toggle() => setState(() {
        _isOpen = !_isOpen;
        if (entries.isEmpty) {
          overlayInsert(OverlayInsertion(
            builder: (context) => _FabExpandableElements(
              open: _isOpen,
              duration: widget.duration,
              updateWhen: Ani.decideForwardOrReverse,
              setup: widget.initializer(
                context: context,
                openIconRect: _openIconKey.renderRect,
                openIconAlignment: widget.alignment,
                icons: widget.elements,
              ),
            ),
          ));
        }
        overlayUpdate();
      });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      clipBehavior: Clip.none,
      children: [_closeButton, _openButton],
    );
  }

  Widget get _openButton {
    final fadingCurve = widget.curve;
    return IgnorePointer(
      key: _openIconKey,
      ignoring: _isOpen,
      child: Mationani.mamion(
        ani: AniUpdateIfNotAnimating.updateForwardOrReverseWhen(
          _isOpen,
          duration: widget.duration,
        ),
        ability: MamionMulti.appear(
          fading: FBetween.doubleZeroFrom(1, curve: fadingCurve),
          scaling: FBetween.doubleOneTo(0.7, curve: fadingCurve),
        ),
        builder: (context) => FloatingActionButton(
          onPressed: _toggle,
          child: widget.openIcon,
        ),
      ),
    );
  }

  Widget get _closeButton => SizedBoxCenter.fromSize(
        size: KSize.square_56,
        child: Material(
          shape: FBorderOutlined.circle(side: BorderSide.none),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: KEdgeInsets.all_1 * 8,
              child: widget.closeIcon,
            ),
          ),
        ),
      );
}

class _FabExpandableElements extends StatelessWidget {
  const _FabExpandableElements({
    required this.open,
    required this.duration,
    required this.updateWhen,
    required this.setup,
  });

  final bool open;
  final DurationFR duration;
  final AnimationControllerDecider updateWhen;
  final FabExpandableSetup setup;

  @override
  Widget build(BuildContext context) {
    final icons = setup.icons;
    return Positioned.fromRect(
      rect: setup.positioned,
      child: IgnorePointer(
        ignoring: !open,
        child: Stack(
          alignment: setup.alignment,
          children: icons.build(
            (icon, action, index) => Mationani.mamion(
              ani: AniUpdateIfAnimating.backOr(
                initializer: Ani.initializeForward,
                duration: duration,
                onNotAnimating: updateWhen(open),
              ),
              ability: setup.mationsGenerator(index),
              builder: (context) => Material(
                  shape: FBorderOutlined.continuousRectangle(
                    side: FBorderSide.solidCenter(),
                    borderRadius: KBorderRadius.allCircular_10 * 2,
                  ),
                child: IconButton(
                  onPressed: action,
                  icon: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///
///
/// [positioned], [alignment], [mationsGenerator], [icons], ...
///
///
class FabExpandableSetup {
  final Rect positioned;
  final Alignment alignment;
  final Generator<Mamionability> mationsGenerator;
  final List<IconAction> icons;

  FabExpandableSetup._({
    required this.positioned,
    required this.alignment,
    required this.mationsGenerator,
    required this.icons,
  });

  factory FabExpandableSetup.radiationOnOpenIcon({
    required BuildContext context,
    required Rect openIconRect,
    required Generator<double> direction,
    required List<IconAction> icons,
    double distance = 2,
    double maxElementsIconSize = 24,
    CurveFR curve = CurveFR.fastOutSlowIn,
  }) =>
      FabExpandableSetup._(
        positioned: RectExtension.fromCircle(
          openIconRect.center,
          icons.maxRadiusFrom(context) * (1 + 2 * distance),
        ),
        alignment: Alignment.center,
        mationsGenerator: MamionMulti.generateCover(
          direction,
          distance,
          curve: curve,
          total: icons.length,
        ),
        icons: icons,
      );

  factory FabExpandableSetup.line({
    required BuildContext context,
    required Rect openIconRect,
    required Direction2DIn8 direction,
    required List<IconAction> icons,
    double distance = 1.2,
    CurveFR curve = CurveFR.ease,
  }) {
    final total = icons.length;
    final d = distance * direction.scaleOnGrid;
    final alignment = AlignmentExtension.fromDirection(direction.flipped);
    return FabExpandableSetup._(
      positioned: FExtruding2D.directByDimension(
        rect: openIconRect,
        direction: direction,
        dimension: icons.maxRadiusFrom(context) * 2,
      )(d * total),
      alignment: alignment,
      mationsGenerator: MamionMulti.generateShoot(
        OffsetExtension.unitFromDirection(direction) * d,
        curve: curve,
        total: total,
        alignmentScale: alignment,
      ),
      icons: icons,
    );
  }
}

extension FFabExpandableInitializer on FabExpandableSetupInitializer {
  static FabExpandableSetup orbitClockwise({
    required BuildContext context,
    required Rect openIconRect,
    required Alignment openIconAlignment,
    required List<IconAction> icons,
  }) =>
      FabExpandableSetup.radiationOnOpenIcon(
        context: context,
        openIconRect: openIconRect,
        direction: openIconAlignment.directionOfSideSpace(true, icons.length),
        icons: icons,
      );

  static FabExpandableSetup orbitClockwiseCounter({
    required DurationFR duration,
    required BuildContext context,
    required Rect openIconRect,
    required Alignment openIconAlignment,
    required List<IconAction> icons,
  }) =>
      FabExpandableSetup.radiationOnOpenIcon(
        context: context,
        openIconRect: openIconRect,
        direction: openIconAlignment.directionOfSideSpace(false, icons.length),
        icons: icons,
      );

  static FabExpandableSetupInitializer lineOn(Direction2DIn8 direction) => ({
        required BuildContext context,
        required Rect openIconRect,
        required Alignment openIconAlignment,
        required List<IconAction> icons,
      }) =>
          FabExpandableSetup.line(
            context: context,
            openIconRect: openIconRect,
            direction: direction,
            icons: icons,
          );
}
