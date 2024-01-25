///
///
/// this file contains:
///
/// [Mationani]
///   [MationaniArrow]
///   [MationaniSin]
///   [MationaniCutting]
///   ...
///
/// [OverlayFadingStream]
/// * [OverlayMixin]
/// * [OverlayInsertion]
///   * [OverlayInsertionFading]
///   [Leader]
///
/// [FabExpandable]
///   * [_FabExpandableElements]
///   * [FabExpandableSetup]
///     * [FFabExpandableSetupOrbit]
///     * [FFabExpandableSetupLine]
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
  /// see [AniSequenceStyle.sequence] for [motivations] creation
  ///
  factory Mationani.mamionSequence(
    int? step, {
    Key? key,
    required AniSequence sequence,
    required WidgetBuilder builder,
    AnimationControllerInitializer? initializer,
    AnimationStatusController? initialStatusController,
    Consumer<AnimationController>? updateOnAnimating,
    Curve? curve,
  }) {
    final i = step ?? 0;
    return Mationani.mamion(
      key: key,
      ani: AniGeneral.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
        initialStatusController: initialStatusController,
        updateOnAnimating: updateOnAnimating,
        curve: curve,
      ),
      ability: sequence.motivations[i],
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

  @override
  void initState() {
    final ani = widget.ani;
    controller = ani.initializing(this);
    builder = ani.building(controller, widget.mation);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    builder = widget.ani.updating(
      controller: controller,
      oldWidget: oldWidget,
      widget: widget,
    );

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
                curve: CurveFR.symmetry(Curving.sinPeriodOf(2)),
              ),
            ),
            ani: AniGeneral(
              duration: KDurationFR.second1,
              initializer: AniGeneral.initializeRepeat,
            ),
            builder: builder,
          ),
        ),
      ),
    );
  }
}

///
/// [MationaniSin.shaker]
/// [MationaniSin.flicker]
/// [MationaniSin.slider]
///
///

class MationaniSin extends StatelessWidget {
  const MationaniSin._({
    super.key,
    required this.duration,
    required this.initializer,
    required this.updateConsumer,
    required this.mation,
    required this.builder,
  });

  factory MationaniSin.shaker({
    required DurationFR duration,
    required int times,
    required double amplitudeRadian,
    required Consumer<AnimationController> updateConsumer,
    required Widget child,
    Key? key,
    Alignment alignment = Alignment.center,
    AnimationControllerInitializer initializer = AniGeneral.initialize,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateConsumer: updateConsumer,
        mation: MamionTransition.rotate(
          Between(
            0,
            amplitudeRadian / KRadian.angle_360,
            curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
          ),
          alignment: alignment,
        ),
        builder: (context) => child,
      );

  factory MationaniSin.flicker({
    required DurationFR duration,
    required int times,
    required double amplitudeOpacity,
    required Consumer<AnimationController> updateConsumer,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = AniGeneral.initialize,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateConsumer: updateConsumer,
        mation: MamionTransition.fade(Between(
          1.0,
          amplitudeOpacity,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        )),
        builder: (context) => child,
      );

  factory MationaniSin.slider({
    required DurationFR duration,
    required int times,
    required Offset amplitudePosition,
    required Consumer<AnimationController> updateConsumer,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = AniGeneral.initialize,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration,
        initializer: initializer,
        updateConsumer: updateConsumer,
        mation: MamionTransition.slide(Between(
          Offset.zero,
          amplitudePosition,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        )),
        builder: (context) => child,
      );

  final DurationFR duration;
  final AnimationControllerInitializer initializer;
  final Consumer<AnimationController> updateConsumer;
  final Mamionability mation;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Mationani.mamion(
        ani: AniGeneral(
          duration: duration,
          initializer: initializer,
          updateConsumer: updateConsumer,
        ),
        ability: mation,
        builder: builder,
      );
}

class MationaniCutting extends StatelessWidget {
  const MationaniCutting({
    super.key,
    this.pieces = 2,
    this.direction = Direction.radian2D_bottomRight,
    this.curveFadeOut,
    this.curve,
    AniGeneral? aniFadeOut,
    required this.ani,
    required this.rotation,
    required this.distance,
    required this.child,
  }) : assert(pieces == 2 && direction == Direction.radian2D_bottomRight);

  final int pieces;
  final double direction;
  final double rotation;
  final double distance;
  final AniGeneral ani;
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
              ability: MamionMulti.leaving(
                alignment: Alignment.bottomRight,
                rotation: FBetween.doubleZeroTo(
                  (index == 0 ? -rotation : rotation) / KRadian.angle_360,
                  curve: curve,
                ),
                sliding: FBetween.offsetZeroTo(
                  index == 0
                      ? Direction.offset_bottomLeft * distance
                      : Direction.offset_topRight * distance,
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
    insertion.onRemoveEntry = (controller) {
      onRemove(controller);
      onRemoveEntry();
      _removeEntry(entry);
    };
    return _insertEntry(entry, below: insertion.below, above: insertion.above);
  }
}

class OverlayInsertion<T extends Widget> {
  final Translator<BuildContext, T> builder;
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
  final Consumer<AnimationController>? updateOnAnimating;
  final CurveFR? curveFade;
  final Curve? curveAni;
  Consumer<AnimationController> onRemoveEntry;

  OverlayInsertionFading({
    super.opaque,
    super.maintainState,
    super.below,
    super.above,
    required super.builder,
    required this.duration,
    required this.shouldFadeOut,
    required this.onRemoveEntry,
    this.updateOnAnimating,
    this.curveFade,
    this.curveAni,
  });

  @override
  OverlayEntry get entry => OverlayEntry(
        opaque: opaque,
        maintainState: maintainState,
        builder: (context) => Mationani.mamion(
          ability: MamionTransition.fadeIn(curve: curveFade),
          ani: AniGeneral.initForwardAndUpdateReverseWhen(
            shouldFadeOut(),
            curve: curveAni,
            duration: duration,
            updateOnAnimating: updateOnAnimating ?? AniGeneral.consumeNothing,
            initialStatusController: AniGeneral.listenDismissed(onRemoveEntry),
          ),
          builder: builder,
        ),
      );
}

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

///
///
/// TODO: layout every elements no matter size
///
///
class FabExpandable extends StatefulWidget {
  const FabExpandable({
    super.key,
    this.initialOpen = false,
    this.openIcon = WIconMaterial.create,
    this.closeIcon = WIconMaterial.close,
    this.durationFadeOut = KDuration.milli250,
    this.curveFadeOut = KCurveFR.easeInOut,
    this.alignment = Alignment.bottomRight,
    this.initializer = FFabExpandableSetupOrbit.clockwise_2,
    required this.elements,
  });

  final bool initialOpen;
  final Icon openIcon;
  final Icon closeIcon;
  final Duration durationFadeOut;
  final CurveFR curveFadeOut;
  final Alignment alignment;
  final List<IconAction> elements;
  final FabExpandableSetupInitializer initializer;

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
              isOpen: _isOpen,
              setup: widget.initializer(
                duration: KDuration.second1.toDurationFR,
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
    return SizedBox.expand(
      child: Stack(
        alignment: widget.alignment,
        clipBehavior: Clip.none,
        children: [_closeButton, _openButton],
      ),
    );
  }

  Widget get _openButton => IgnorePointer(
        key: _openIconKey,
        ignoring: _isOpen,
        child: Mationani.mamion(
          ani: AniGeneral(
            duration: DurationFR.constant(widget.durationFadeOut),
            updateConsumer: AniGeneral.decideForwardOrReverse(_isOpen),
          ),
          ability: MamionMulti([
            MamionTransition.fadeOut(),
            MamionTransition.scale(
              FBetween.doubleOneTo(0.7, curve: widget.curveFadeOut),
              alignment: Alignment.center,
            ),
          ]),
          builder: (context) => FloatingActionButton(
            onPressed: _toggle,
            child: widget.openIcon,
          ),
        ),
      );

  Widget get _closeButton => SizedBoxCenter.fromSize(
        size: KSize.square_56,
        child: MaterialInkWellPadding(
          shape: FBorderOutlined.circle(side: BorderSide.none),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          onTap: _toggle,
          padding: KEdgeInsets.all_1 * 8,
          child: widget.closeIcon,
        ),
      );
}

class _FabExpandableElements extends StatelessWidget {
  const _FabExpandableElements({
    required this.isOpen,
    required this.setup,
  });

  final bool isOpen;
  final FabExpandableSetup setup;

  @override
  Widget build(BuildContext context) {
    final icons = setup.icons;
    return Positioned.fromRect(
      rect: setup.positioned,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: Stack(
          alignment: setup.alignment,
          children: List.generate(
            icons.length,
            (index) {
              final element = icons[index];
              return Mationani.mamion(
                ani: setup.aniDecider(isOpen),
                ability: setup.mationsGenerator(index),
                builder: (context) => MaterialIconButton(
                  onPressed: element.action,
                  child: element.icon,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

///
///
/// [positioned], [alignment], [mationsGenerator], [icons], ...
/// [_maxIconRadiusOf]
///
///
class FabExpandableSetup {
  final Rect positioned;
  final Alignment alignment;
  final AniDecider<bool> aniDecider;
  final Generator<Mamionability> mationsGenerator;
  final List<IconAction> icons;

  FabExpandableSetup._({
    required this.positioned,
    required this.alignment,
    required this.aniDecider,
    required this.mationsGenerator,
    required this.icons,
  });

  static double _maxIconRadiusOf(BuildContext context, List<IconAction> icons) {
    final size = context.themeIcon.size ?? 24.0;
    return icons.reduceToNum(
      reducer: math.max,
      translator: (i) => i.icon.size ?? size,
    );
  }

  static AniDecider<bool> _decider(
    DurationFR duration,
    AnimationControllerDecider updateHear,
  ) =>
      (open) => AniGeneral(
            duration: duration,
            initializer: AniGeneral.initializeForward,
            updateConsumer: updateHear(open),
            updateOnAnimating: AniGeneral.consumeBack,
          );

  factory FabExpandableSetup.radiationOnOpenIcon({
    required DurationFR duration,
    required BuildContext context,
    required Rect openIconRect,
    required Generator<double> direction,
    required List<IconAction> icons,
    double distance = 2,
    double maxElementsIconSize = 24,
    CurveFR curve = KCurveFR.fastOutSlowIn,
    AnimationControllerDecider updateHear = AniGeneral.decideForwardOrReverse,
    MationMultiGenerator? mations,
  }) =>
      FabExpandableSetup._(
        positioned: RectExtension.fromCircle(
          openIconRect.center,
          _maxIconRadiusOf(context, icons) * (1 + 2 * distance),
        ),
        alignment: Alignment.center,
        aniDecider: _decider(duration, updateHear),
        mationsGenerator: mations ??
            FMationsGenerator.fadeInRadiationStyle1(
              direction,
              distance,
              curve: curve,
            ),
        icons: icons,
      );

  factory FabExpandableSetup.line({
    required DurationFR duration,
    required BuildContext context,
    required Rect openIconRect,
    required Direction2DIn8 direction,
    required List<IconAction> icons,
    double distance = 1.2,
    CurveFR curve = KCurveFR.ease,
    AnimationControllerDecider updateHear = AniGeneral.decideForwardOrReverse,
    MationMultiGenerator? mations,
  }) {
    final maxIconRadius = _maxIconRadiusOf(context, icons);
    return FabExpandableSetup._(
      // positioned: openIconRect.expandToIncludeDirection(
      //   direction: direction,
      //   width: maxIconRadius * 2,
      //   length: maxIconRadius * 2 * distance * icons.length,
      // ),
      positioned: openIconRect.expandToInclude(
        direction.sizingExtrudingOfDimension(maxIconRadius * 2)(
          distance * icons.length,
        ),
      ),
      alignment: direction.flipped.toAlignment,
      aniDecider: _decider(duration, updateHear),
      mationsGenerator: mations ??
          FMationsGenerator.lineAndScale(
            direction.toOffset * distance,
            curve: curve,
          ),
      icons: icons,
    );
  }
}

extension FFabExpandableSetupOrbit on FabExpandableSetupInitializer {
  static const clockwise_2 = _clockwise_2;
  static const counterClockwise_2 = _counterClockwise_2;

  static FabExpandableSetup _clockwise_2({
    required DurationFR duration,
    required BuildContext context,
    required Rect openIconRect,
    required Alignment openIconAlignment,
    required List<IconAction> icons,
  }) =>
      FabExpandableSetup.radiationOnOpenIcon(
        duration: duration,
        context: context,
        openIconRect: openIconRect,
        direction: openIconAlignment.directionOfSideSpace(
          true,
          icons.length,
        ),
        icons: icons,
      );

  static FabExpandableSetup _counterClockwise_2({
    required DurationFR duration,
    required BuildContext context,
    required Rect openIconRect,
    required Alignment openIconAlignment,
    required List<IconAction> icons,
  }) =>
      FabExpandableSetup.radiationOnOpenIcon(
        duration: duration,
        context: context,
        openIconRect: openIconRect,
        direction: openIconAlignment.directionOfSideSpace(false, icons.length),
        icons: icons,
      );
}

extension FFabExpandableSetupLine on FabExpandableSetupInitializer {
  static FabExpandableSetupInitializer line1d2Of(Direction2DIn8 direction) => ({
        required DurationFR duration,
        required BuildContext context,
        required Rect openIconRect,
        required Alignment openIconAlignment,
        required List<IconAction> icons,
      }) =>
          FabExpandableSetup.line(
            duration: duration,
            context: context,
            openIconRect: openIconRect,
            direction: direction,
            icons: icons,
          );
}
