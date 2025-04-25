part of '../mationani.dart';

///
/// .
///         --[MamableSetTransform]
///     --[MamableSet]
///     |
///     |   --[MamableTransformDelegate]
///     |   --[MamableClipper]
///     |   --[MamablePainter]
///     |   --[MamableTransition]
///     --[MamableSolo]--
///     |               |
///     --[Mamable]     |
/// * [Matable]         * [_MatableDriver]
///     --[Manable]     |
///     |               |                          * [_ManableParent]
///     --[ManableSync]--                          |
///     |   --[_ManableParentSyncAlso]--------------
///     |   --[_ManableParentSyncAnd]---------------
///     |                                          |
///     --[ManableSet]                             |
///         --[_ManableSetSync]                    |
///         |   --[_ManableParentSetSync]-----------
///         |                                      |
///         --[_ManableSetEach]                    |
///         |   --[_ManableParentSetEach]----------|
///         |                                      |
///         --[_ManableSetRespectively]            |
///         |   --[_ManableParentRespectively]------
///         |                                      |
///         --[_ManableSetSelected]                |
///             --[_ManableParentSelected]----------
///
///

///
///
///
abstract final class Matable {
  // ignore: unused_element
  Object _perform(Animation<double> parent, CurveFR? curve, Object child);
}

abstract final class Mamable implements Matable {
  Widget _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant Widget child,
  );
}

abstract final class Manable implements Matable {
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  );
}

///
///
///
final class MamableSolo<T> extends _MatableDriver<T> implements Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      _builder(_drive(parent, curve), child);

  const MamableSolo(super.value, super._builder);
}

final class ManableSync<T> extends _MatableDriver<T> implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    CurveFR? curve,
    covariant List<Widget> children,
  ) {
    final animation = _drive(parent, curve);
    final builder = _builder;
    return children.mapToList((child) => builder(animation, child));
  }

  const ManableSync(super.value, super._builder);

  factory ManableSync.alsoParent(Matalue<T> value, AnimationBuilder builder) =
      _ManableParentSyncAlso<T>;

  factory ManableSync.andParent({
    required Matalue<T> value,
    required AnimationBuilder builder,
    required Mamable mamable,
  }) = _ManableParentSyncAnd<T>;
}

///
///
///
final class MamableSet<A extends MamableSolo> implements Mamable {
  final Iterable<A> ables;

  const MamableSet(this.ables);

  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      ables.fold(
        child,
        (child, able) => able._builder(able._drive(parent, curve), child),
      );
}

///
/// [MamableTransition.fade], ...
/// [MamableTransition.scale], ...
/// [MamableTransition.rotate], ...
/// [MamableTransition.slide], ...
/// [MamableTransition.decoration], ...
///
final class MamableTransition extends MamableSolo {
  MamableTransition.fade(
    Matalue<double> value, {
    bool alwaysIncludeSemantics = false,
  }) : super(value, _fromFade(alwaysIncludeSemantics) as AnimationBuilder);

  MamableTransition.fadeIn({
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(0.0, 1.0, curve: curve));

  MamableTransition.fadeInTo(
    double opacity, {
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(0.0, opacity, curve: curve));

  MamableTransition.fadeOut({
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(1.0, 0.0, curve: curve));

  MamableTransition.silverFade(
    Matalue<double> value, {
    bool alwaysIncludeSemantics = false,
  }) : super(
          value,
          _fromFadeSliver(alwaysIncludeSemantics) as AnimationBuilder,
        );

  ///
  ///
  ///
  MamableTransition.scale(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super(value,
            _fromFadeScale(alignment, filterQuality) as AnimationBuilder);

  MamableTransition.size(
    Matalue<double> value, {
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
    double? fixedCrossAxisSizeFactor,
  }) : super(
          value,
          _fromSize(axis, axisAlignment, fixedCrossAxisSizeFactor)
              as AnimationBuilder,
        );

  ///
  ///
  ///
  MamableTransition.rotate(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super(value, _fromRotate(alignment, filterQuality) as AnimationBuilder);

  MamableTransition.rotateInRadian(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : this.rotate(Matalue.doubleToRadian(value), alignment: alignment);

  ///
  ///
  ///
  MamableTransition.slide(
    Matalue<Offset> value, {
    bool transformHitTests = true,
    TextDirection? textDirection,
  }) : super(
          value,
          _fromSlide(transformHitTests, textDirection) as AnimationBuilder,
        );

  MamableTransition.positioned(Matalue<RelativeRect> value)
      : super(value, _fromPositioned as AnimationBuilder);

  MamableTransition.relativePositioned(
    Matalue<double> value, {
    required Size size,
  }) : super(value, _fromPositionedRelative(size) as AnimationBuilder);

  MamableTransition.align(
    Matalue<AlignmentGeometry> value, {
    double? widthFactor,
    double? heightFactor,
  }) : super(value, _fromAlign(widthFactor, heightFactor) as AnimationBuilder);

  ///
  ///
  ///
  MamableTransition.decoration(
    Matalue<Decoration> value, {
    DecorationPosition position = DecorationPosition.background,
  }) : super(value, _fromDecoration(position) as AnimationBuilder);

  MamableTransition.defaultTextStyle(
    Matalue<TextStyle> value, {
    TextAlign? textAlign,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
  }) : super(
          value,
          _fromTextStyle(textAlign, softWrap, overflow, maxLines)
              as AnimationBuilder,
        );

  ///
  ///
  ///
  static AnimationBuilder<double> _fromFade(bool alwaysIncludeSemantics) =>
      (animation, child) => FadeTransition(
            opacity: animation,
            alwaysIncludeSemantics: alwaysIncludeSemantics,
            child: child,
          );

  static AnimationBuilder<double> _fromFadeSliver(
    bool alwaysIncludeSemantics,
  ) =>
      (animation, child) => SliverFadeTransition(
            opacity: animation,
            alwaysIncludeSemantics: alwaysIncludeSemantics,
            sliver: child,
          );

  static AnimationBuilder<double> _fromFadeScale(
    Alignment alignment,
    FilterQuality? filterQuality,
  ) =>
      (animation, child) => ScaleTransition(
            scale: animation,
            alignment: alignment,
            filterQuality: filterQuality,
            child: child,
          );

  static AnimationBuilder<double> _fromSize(
    Axis axis,
    double axisAlignment,
    double? fixedCrossAxisSizeFactor,
  ) =>
      (animation, child) => SizeTransition(
            sizeFactor: animation,
            axis: axis,
            axisAlignment: axisAlignment,
            fixedCrossAxisSizeFactor: fixedCrossAxisSizeFactor,
            child: child,
          );

  static AnimationBuilder<double> _fromRotate(
    Alignment alignment,
    FilterQuality? filterQuality,
  ) =>
      (animation, child) => RotationTransition(
            turns: animation,
            alignment: alignment,
            filterQuality: filterQuality,
            child: child,
          );

  static AnimationBuilder<Offset> _fromSlide(
    bool transformHitTests,
    TextDirection? textDirection,
  ) =>
      (animation, child) => SlideTransition(
            position: animation,
            transformHitTests: transformHitTests,
            textDirection: textDirection,
            child: child,
          );

  static Widget _fromPositioned(
    Animation<RelativeRect> animation,
    Widget child,
  ) =>
      PositionedTransition(
        rect: animation,
        child: child,
      );

  static AnimationBuilder<Rect> _fromPositionedRelative(Size size) =>
      (animation, child) => RelativePositionedTransition(
            rect: animation,
            size: size,
            child: child,
          );

  static AnimationBuilder<AlignmentGeometry> _fromAlign(
    double? widthFactor,
    double? heightFactor,
  ) =>
      (animation, child) => AlignTransition(
            alignment: animation,
            heightFactor: heightFactor,
            widthFactor: widthFactor,
            child: child,
          );

  static AnimationBuilder<Decoration> _fromDecoration(DecorationPosition p) =>
      (animation, child) => DecoratedBoxTransition(
            decoration: animation,
            position: p,
            child: child,
          );

  static AnimationBuilder<TextStyle> _fromTextStyle(
    TextAlign? textAlign,
    bool softWrap,
    TextOverflow overflow,
    int? maxLines,
  ) =>
      (animation, child) => DefaultTextStyleTransition(
            style: animation,
            child: child,
            textAlign: textAlign,
            softWrap: softWrap,
            overflow: overflow,
            maxLines: maxLines,
          );
}

///
///
///
final class MamableClipper extends MamableSolo<SizingPath> {
  final Clip clipBehavior;

  MamableClipper(
    Between<SizingPath> value, {
    this.clipBehavior = Clip.antiAlias,
  }) : super(
          value,
          (animation, child) => ClipPath(
            clipper: Clipping.reclipWhenUpdate(animation.value),
            clipBehavior: clipBehavior,
            child: child,
          ),
        );
}

///
///
///
final class MamablePainter extends MamableSolo<SizingPath> {
  final bool isComplex;
  final CustomPainter? foreground;
  final Size size;
  final Painter painter;

  MamablePainter(
    Between<SizingPath> value, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.foreground,
    required this.painter,
  }) : super(
          value,
          (animation, child) => CustomPaint(
            willChange: true,
            painter: painter(animation.value),
            foregroundPainter: foreground,
            size: size,
            isComplex: isComplex,
            child: child,
          ),
        );

  MamablePainter.paintFrom(
    Between<SizingPath> value, {
    required PaintFrom paintFrom,
  }) : this(
          value,
          isComplex: false,
          size: Size.zero,
          foreground: null,
          painter: FPainter.of(paintFrom),
        );
}

///
///
/// the coordinate system of [MamableTransformDelegate] is same as [Transform] widget's direction, translation.
/// the 'axis' below is from 'coordinate-axis-negative' to 'coordinate-axis-positive'.
/// it's easier to understand them with animated [Transform] widget with [Matrix4] instance continued setState,
/// or just using [MamableTransformDelegate] wrapped in [Mationani] widget with [Ani.initRepeat].
///
/// translation x axis comes from [Direction3DIn6.left] to [Direction3DIn6.right]
/// translation y axis comes from [Direction3DIn6.top] to [Direction3DIn6.bottom]
/// translation z axis comes from [Direction3DIn6.front] to [Direction3DIn6.back]
/// direction x axis is [Direction3DIn6.left] -> [Direction3DIn6.right] ([Matrix4.rotationX]),
/// direction y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom] ([Matrix4.rotationY]),
/// direction z axis is [Direction3DIn6.front] -> [Direction3DIn6.back] ([Matrix4.rotationZ], [Offset.direction]),
///
///
final class MamableTransformDelegate extends MamableSolo<Point3> {
  final OnAnimateMatrix4 onAnimate;
  final AlignmentGeometry? alignment;
  Matrix4 host;

  MamableTransformDelegate._(
    Matalue<Point3> value, {
    required this.alignment,
    required this.host,
    required this.onAnimate,
  }) : super(
          value,
          (animation, child) => Transform(
            transform: onAnimate(host, animation.value),
            alignment: alignment,
            child: child,
          ),
        );

  ///
  ///
  ///
  MamableTransformDelegate.translation(
    Matalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransformDelegate.translating,
        );

  MamableTransformDelegate.rotation(
    Matalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransformDelegate.rotating,
        );

  MamableTransformDelegate.scale(
    Matalue<Point3> value, {
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this._(
          value,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransformDelegate.scaling,
        );

  static Matrix4 translating(Matrix4 matrix4, Point3 value) =>
      matrix4.perspectiveIdentity..translateOf(value);

  static Matrix4 rotating(Matrix4 matrix4, Point3 value) =>
      matrix4..setRotation((Matrix4.identity()..rotateOf(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Point3 value) =>
      matrix4.scaledOf(value);

  ///
  ///
  ///
  void link(Matrix4 host) => this.host = host;

  bool isSameTypeWith(MamableTransformDelegate another) =>
      onAnimate == another.onAnimate;

  MamableTransformDelegate align(AlignmentGeometry? alignment) =>
      MamableTransformDelegate._(
        value,
        onAnimate: onAnimate,
        alignment: alignment,
        host: host,
      );
}

///
/// [orderTRS], ...
/// [MamableSetTransform._sort]
/// [MamableSetTransform.fromDelegates], ...
///
final class MamableSetTransform extends MamableSet<MamableTransformDelegate> {
  ///
  ///
  ///
  static const List<OnAnimateMatrix4> orderTRS = [
    MamableTransformDelegate.translating,
    MamableTransformDelegate.rotating,
    MamableTransformDelegate.scaling,
  ];
  static const List<OnAnimateMatrix4> orderTSR = [
    MamableTransformDelegate.translating,
    MamableTransformDelegate.scaling,
    MamableTransformDelegate.rotating,
  ];
  static const List<OnAnimateMatrix4> orderSTR = [
    MamableTransformDelegate.scaling,
    MamableTransformDelegate.translating,
    MamableTransformDelegate.rotating,
  ];
  static const List<OnAnimateMatrix4> orderSRT = [
    MamableTransformDelegate.scaling,
    MamableTransformDelegate.rotating,
    MamableTransformDelegate.translating,
  ];
  static const List<OnAnimateMatrix4> orderRTS = [
    MamableTransformDelegate.rotating,
    MamableTransformDelegate.translating,
    MamableTransformDelegate.scaling,
  ];
  static const List<OnAnimateMatrix4> orderRST = [
    MamableTransformDelegate.rotating,
    MamableTransformDelegate.scaling,
    MamableTransformDelegate.translating,
  ];

  ///
  ///
  ///
  static Iterable<MamableTransformDelegate> _sort(
    Iterable<MamableTransformDelegate> delegates,
    List<OnAnimateMatrix4> order,
  ) {
    final map =
        Map.fromIterable(order, value: (_) => <MamableTransformDelegate>[]);
    for (var delegate in delegates) {
      map[delegate.onAnimate]!.add(delegate);
    }
    return order.expand((onAnimate) => map[onAnimate]!);
  }

  ///
  ///
  ///
  MamableSetTransform.fromDelegates(
    Iterable<MamableTransformDelegate> delegates, {
    Matrix4? host,
    List<OnAnimateMatrix4> order = MamableSetTransform.orderTRS,
  })  : assert(order.length == 3 && !order.iterator.existEqual),
        super(_sort(
          delegates.map((d) => d..link(host ?? Matrix4.identity())),
          order,
        ));

  factory MamableSetTransform({
    double? distanceToObserver,
    Matrix4? host,
    Between<Point3>? translateBetween,
    Between<Point3>? rotateBetween,
    Between<Point3>? scaleBetween,
    AlignmentGeometry? translateAlignment,
    AlignmentGeometry? rotateAlignment,
    AlignmentGeometry? scaleAlignment,
    List<OnAnimateMatrix4> order = MamableSetTransform.orderTRS,
  }) {
    final matrix = (host ?? Matrix4.identity())
      ..setDistance(distanceToObserver);
    return MamableSetTransform.fromDelegates([
      if (translateBetween != null)
        MamableTransformDelegate.translation(
          translateBetween,
          alignment: translateAlignment,
          host: matrix,
        ),
      if (rotateBetween != null)
        MamableTransformDelegate.rotation(
          rotateBetween,
          alignment: rotateAlignment,
          host: matrix,
        ),
      if (scaleBetween != null)
        MamableTransformDelegate.scale(
          scaleBetween,
          alignment: scaleAlignment,
          host: matrix,
        ),
    ]);
  }

  MamableSetTransform alignAll({
    AlignmentGeometry? translation,
    AlignmentGeometry? rotation,
    AlignmentGeometry? scaling,
  }) =>
      MamableSetTransform.fromDelegates(ables.map(
        (delegate) => delegate.align(switch (delegate.onAnimate) {
          MamableTransformDelegate.translating =>
            translation ?? delegate.alignment,
          MamableTransformDelegate.rotating => rotation ?? delegate.alignment,
          MamableTransformDelegate.scaling => scaling ?? delegate.alignment,
          _ => throw UnimplementedError(),
        }),
      ));
}

///
///
///
abstract final class ManableSet implements Manable {
  const ManableSet();

  const factory ManableSet.sync(MamableSet model) = _ManableSetSync;

  const factory ManableSet.syncAlsoParent(MamableSet model) =
      _ManableParentSetSync.also;

  const factory ManableSet.each(Iterable<MamableSolo> each) = _ManableSetEach;

  const factory ManableSet.respectively(Iterable<MamableSet> children) =
      _ManableSetRespectively;

  const factory ManableSet.selected(Map<int, MamableSet> selected) =
      _ManableSetSelected;

  //
  const factory ManableSet.syncAndParent({
    required Mamable parent,
    required MamableSet model,
  }) = _ManableParentSetSync;

  const factory ManableSet.eachAndParent({
    required Mamable parent,
    required Iterable<MamableSolo> each,
  }) = _ManableParentSetEach;

  const factory ManableSet.respectivelyAndParent({
    required Mamable parent,
    required Iterable<MamableSet> children,
  }) = _ManableParentRespectively;

  const factory ManableSet.selectedAndParent({
    required Mamable parent,
    required Map<int, MamableSet> selected,
  }) = _ManableParentSelected;
}
