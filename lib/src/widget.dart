///
///
/// this file contains:
///
/// [Mationani]
///   [MationaniSin]
///   [MationaniPenetration]
///   [MationaniArrow]
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
/// [Mationani.sequence]
/// [Mationani.rotateClipping]
/// [Mationani.rotateSemicircleRowClipping]
///
///
///
class Mationani extends StatefulWidget {
  final Mation mation;
  final Ani ani;
  final WidgetBuilder builder;

  Mationani({
    super.key,
    required this.mation,
    required this.ani,
    Widget child = WSizedBox.none,
  }) : builder = WWidgetBuilder.of(child);

  ///
  /// if [step] == null, there is no animation,
  /// if [step] % 2 == 0, there is forward animation,
  /// if [step] % 2 == 1, there is reverse animation,
  ///
  /// see [MationSequenceStyle.sequence] for [mations] creation
  ///
  factory Mationani.sequence(
    int? step, {
    Key? key,
    required MationSequence sequence,
    required Widget child,
    AnimationControllerInitializer? initializer,
    AnimationStatusController? initialStatusController,
    IfAnimating? onAnimating,
    Curve? curve,
  }) {
    final i = step ?? 0;
    return Mationani(
      key: key,
      ani: Ani.updateSequencingWhen(
        step == null ? null : i % 2 == 0,
        duration: sequence.durations[i],
        initializer: initializer,
        initialStatusController: initialStatusController,
        onAnimating: onAnimating,
        curve: curve,
      ),
      mation: sequence.mations[i],
      child: child,
    );
  }

  ///
  ///
  ///
  /// other factories
  ///
  ///
  ///

  factory Mationani.rotateClipping({
    Clip clipBehavior = Clip.antiAlias,
    required Alignment alignment,
    required Ani ani,
    required Between<double> between,
    required SizingPath sizeToPath,
    required Widget child,
  }) =>
      Mationani(
        ani: ani,
        mation: MationTransition.rotate(between, alignment: alignment),
        child: ClipPath(
          clipper: Clipping.reclipNever(sizeToPath),
          clipBehavior: clipBehavior,
          child: child,
        ),
      );

  factory Mationani.rotateSemicircleRowClipping({
    MainAxisAlignment semicircleAlignment = MainAxisAlignment.center,
    required DurationFR duration,
    required Between<double> rotating,
    required Between<double> flipping,
    required AnimationStatusController statusListenerRotate,
    required AnimationStatusController statusListenerFlip,
    required bool isFlipped,
    required Widget childRight,
    required Widget childLeft,
  }) =>
      Mationani(
        ani: Ani(
          duration: duration,
          initializer: Ani.initializeForward,
          initialStatusController: statusListenerRotate,
          updateConsumer: Ani.decideResetForward(isFlipped),
        ),
        mation: MationTransition.rotate(rotating, alignment: Alignment.center),
        child: Row(
          mainAxisAlignment: semicircleAlignment,
          children: [
            Mationani.rotateClipping(
              between: flipping,
              alignment: Alignment.centerRight,
              sizeToPath: FSizingPath.pieOfLeftRight(false),
              ani: Ani(
                duration: duration,
                updateConsumer: Ani.decideResetForward(!isFlipped),
              ),
              child: childLeft,
            ),
            Mationani.rotateClipping(
              ani: Ani(
                duration: duration,
                initialStatusController: statusListenerFlip,
                updateConsumer: Ani.decideResetForward(!isFlipped),
              ),
              between: flipping,
              alignment: Alignment.centerLeft,
              sizeToPath: FSizingPath.pieOfLeftRight(true),
              child: childRight,
            ),
          ],
          // children: [VContainerStyled.gradiantWhitRed],
        ),
      );

  @override
  State<Mationani> createState() => _MationaniState();

  static _MationaniState of(BuildContext context) =>
      context.findAncestorStateOfType<_MationaniState>()!;
}

class _MationaniState extends State<Mationani>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late WidgetBuilder _builder;

  @override
  void initState() {
    final ani = widget.ani;
    controller = ani._initializing(this);
    _builder = ani._plan(controller, widget.mation, widget.builder);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Mationani oldWidget) {
    _builder = widget.ani._updating(
      controller: controller,
      oldWidget: oldWidget,
      mation: widget.mation,
      builder: widget.builder,
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => _builder(context);
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
    required this.updateListener,
    required this.mation,
    required this.child,
  });

  factory MationaniSin.shaker({
    required DurationFR duration,
    required int times,
    required double amplitudeRadian,
    required Widget child,
    Key? key,
    Alignment alignment = Alignment.center,
    bool adjustStart = true,
    AnimationControllerInitializer initializer = Ani.initialize,
    Consumer<AnimationController> updateListener = Ani.consumeNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransition.rotate(
          Between(
            0,
            amplitudeRadian / KRadian.angle_360,
            curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
          ),
          alignment: alignment,
        ),
        child: child,
      );

  factory MationaniSin.flicker({
    required DurationFR duration,
    required int times,
    required double amplitudeOpacity,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = Ani.initialize,
    Consumer<AnimationController> updateListener = Ani.consumeNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration ~/ 2,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransition.fade(Between(
          1.0,
          amplitudeOpacity,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        )),
        child: child,
      );

  factory MationaniSin.slider({
    required DurationFR duration,
    required int times,
    required Offset amplitudePosition,
    required Widget child,
    Key? key,
    AnimationControllerInitializer initializer = Ani.initialize,
    Consumer<AnimationController> updateListener = Ani.consumeNothing,
  }) =>
      MationaniSin._(
        key: key,
        duration: duration,
        initializer: initializer,
        updateListener: updateListener,
        mation: MationTransition.slide(Between(
          Offset.zero,
          amplitudePosition,
          curve: CurveFR.symmetry(Curving.sinPeriodOf(times)),
        )),
        child: child,
      );

  final DurationFR duration;
  final AnimationControllerInitializer initializer;
  final Consumer<AnimationController> updateListener;
  final Mation mation;
  final Widget child;

  @override
  Widget build(BuildContext context) => Mationani(
        ani: Ani(
          duration: duration,
          initializer: initializer,
          updateConsumer: updateListener,
        ),
        mation: mation,
        child: child,
      );
}

class MationaniPenetration extends StatelessWidget {
  const MationaniPenetration({
    required this.ani,
    required this.onTap,
    required this.rect,
    required this.path,
    super.key,
    this.opacityEnd = 1.0,
    this.curveFade,
    this.curveClipper,
    this.clip = Clip.antiAlias,
    this.color = Colors.black54,
    this.child,
  });

  final Ani ani;
  final double opacityEnd;
  final CurveFR? curveFade;
  final CurveFR? curveClipper;
  final Clip clip;
  final Color color;
  final Widget? child;
  final Between<Rect> rect;
  final SizingPathWithRect path;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Mationani(
        ani: ani,
        mation: MationMulti<MationSingle>([
          MationClipper(
            BetweenPath<Rect>(
              rect,
              onAnimate: (t, rect) => (size) => path(rect, size),
              curve: curveClipper,
            ),
            behavior: clip,
          ),
          MationTransition.fade(Between(0.0, opacityEnd, curve: curveFade)),
        ]),
        child: ColoredBox(color: color, child: child),
      ),
    );
  }
}

class MationaniCutting extends StatelessWidget {
  const MationaniCutting({
    super.key,
    this.pieces = 2,
    this.direction = Direction.radian2D_bottomRight,
    this.curveFadeOut,
    this.curve,
    Ani? aniFadeOut,
    required this.ani,
    required this.rotation,
    required this.distance,
    required this.child,
  })  : aniFadeOut = aniFadeOut ?? ani,
        assert(pieces == 2 && direction == Direction.radian2D_bottomRight);

  final int pieces;
  final double direction;
  final double rotation;
  final double distance;
  final Ani aniFadeOut;
  final Ani ani;
  final CurveFR? curveFadeOut;
  final CurveFR? curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Mationani(
      mation: MationTransition.fadeOut(curve: curveFadeOut),
      ani: aniFadeOut,
      child: Stack(
        children: List.generate(
          pieces,
          (index) => Mationani(
            mation: MationMulti<MationSingle>([
              MationTransition.rotate(
                FBetween.doubleZeroTo(
                  (index == 0 ? -rotation : rotation) / KRadian.angle_360,
                  curve: curve,
                ),
                alignment: Alignment.bottomRight,
              ),
              MationTransition.slide(FBetween.offsetZeroTo(
                index == 0
                    ? Direction.offset_bottomLeft * distance
                    : Direction.offset_topRight * distance,
                curve: curve,
              )),
            ]),
            ani: ani,
            child: ClipPath(
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
    );
  }
}

class MationaniArrow extends StatelessWidget {
  const MationaniArrow({
    super.key,
    this.dimension = 40,
    required this.onTap,
    required this.direction,
    this.child = const FlutterLogo(size: 40),
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
          child: Mationani(
            mation: MationTransition.slide(
              FBetween.offsetZeroTo(
                KOffset.square_1 / 2,
                curve: CurveFR.symmetry(Curving.sinPeriodOf(2)),
              ),
            ),
            ani: Ani(
              duration: KDurationFR.second1,
              initializer: Ani.initializeRepeat,
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
/// [_insertEntry]
/// [_updateEntry]
/// [_removeEntry]
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
  final IfAnimating onAnimating;
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
    this.onAnimating = Ani.animatingNothing,
    this.curveFade,
    this.curveAni,
  });

  @override
  OverlayEntry get entry => OverlayEntry(
        opaque: opaque,
        maintainState: maintainState,
        builder: (context) => Mationani(
          mation: MationTransition.fadeIn(curve: curveFade),
          ani: Ani.initForwardAndUpdateReverseWhen(
            shouldFadeOut(),
            curve: curveAni,
            duration: duration,
            onAnimating: onAnimating,
            initialStatusController: Ani.listenDismissed(onRemoveEntry),
          ),
          child: builder(context),
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
        child: Mationani(
          ani: Ani(
            duration: DurationFR.constant(widget.durationFadeOut),
            updateConsumer: Ani.decideForwardOrReverse(_isOpen),
          ),
          mation: MationMulti([
            MationTransition.fadeOut(),
            MationTransition.scale(
              FBetween.doubleOneTo(0.7, curve: widget.curveFadeOut),
              alignment: Alignment.center,
            ),
          ]),
          child: FloatingActionButton(
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
              return Mationani(
                ani: setup.aniDecider(isOpen),
                mation: setup.mationsGenerator(index),
                child: MaterialIconButton(
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
/// [positioned]
/// [alignment]
/// [duration]
/// [updateHear]
/// [mationsGenerator]
/// [icons]
/// [aniOf]
///
/// [_maxIconRadiusOf]
///
///
///
class FabExpandableSetup {
  final Rect positioned;
  final Alignment alignment;
  final AniDecider<bool> aniDecider;
  final Generator<Mation> mationsGenerator;
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
      (open) => Ani(
            duration: duration,
            initializer: Ani.initializeForward,
            updateConsumer: updateHear(open),
            onAnimating: Ani.animatingBack,
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
    AnimationControllerDecider updateHear = Ani.decideForwardOrReverse,
    MationsGenerator? mations,
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
    AnimationControllerDecider updateHear = Ani.decideForwardOrReverse,
    MationsGenerator? mations,
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
