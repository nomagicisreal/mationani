part of '../mationani.dart';

///
/// .
///     --[MamableSet]
///     |
///     |   --[MamableTransform]
///     |   --[MamableClipper]
///     |   --[MamablePainter]
///     |   --[MamableTransition]
///     --[MamableSingle]--
///     |                 |             * [AnimationBuilder]
///     --[Mamable]       |
/// * [Matable]           * [_MatableDriver]
///     --[Manable]       |
///     |                 |                    * [_ManableParent]
///     --[ManableSync]----                    |
///     |   --[_ManableParentSyncAlso]----------
///     |   --[_ManableParentSyncAnd]-----------
///     |                                      |
///     --[ManableSet]                         |
///         --[_ManableSetSync]                |
///         |   --[_ManableParentSetSync]-------
///         |                                  |
///         --[_ManableSetEach]                |
///         |   --[_ManableParentSetEach]------|
///         |                                  |
///         --[_ManableSetRespectively]        |
///         |   --[_ManableParentRespectively]--
///         |                                  |
///         --[_ManableSetSelected]            |
///             --[_ManableParentSelected]------
///
///

///
///
///
typedef AnimationBuilder<T> = Widget Function(
  Animation<T> animation,
  Widget child,
);

///
///
///
abstract final class Matable {}

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
final class MamableSingle<T> extends _MatableDriver<T> implements Mamable {
  @override
  Widget _perform(Animation<double> parent, CurveFR? curve, Widget child) =>
      ListenableBuilder(
        listenable: parent,
        builder: (_, __) => _builder(_drive(parent, curve), child),
      );

  const MamableSingle(super.value, super._builder);
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
    return List.of(
      children.map((child) => builder(animation, child)),
      growable: false,
    );
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
final class MamableSet<A extends MamableSingle> implements Mamable {
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
final class MamableTransition extends MamableSingle {
  MamableTransition.fade(
    Matalue<double> value, {
    bool alwaysIncludeSemantics = false,
  }) : super(value, _fromFade(alwaysIncludeSemantics));

  MamableTransition.fadeIn({
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(begin: 0.0, end: 1.0, curve: curve));

  MamableTransition.fadeInTo(
    double opacity, {
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(begin: 0.0, end: opacity, curve: curve));

  MamableTransition.fadeOut({
    CurveFR? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(begin: 1.0, end: 0.0, curve: curve));

  MamableTransition.silverFade(
    Matalue<double> value, {
    bool alwaysIncludeSemantics = false,
  }) : super(value, _fromFadeSliver(alwaysIncludeSemantics));

  ///
  ///
  ///
  MamableTransition.scale(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super(value, _fromFadeScale(alignment, filterQuality));

  MamableTransition.size(
    Matalue<double> value, {
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
    double? fixedCrossAxisSizeFactor,
  }) : super(value, _fromSize(axis, axisAlignment, fixedCrossAxisSizeFactor));

  ///
  ///
  ///
  MamableTransition.rotate(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super(value, _fromRotate(alignment, filterQuality));

  MamableTransition.rotateInRadian(
    Matalue<double> value, {
    Alignment alignment = Alignment.topLeft,
  }) : this.rotate(Matalue.doubleRadianFromRound(value), alignment: alignment);

  ///
  ///
  ///
  MamableTransition.slide(
    Matalue<Offset> value, {
    bool transformHitTests = true,
    TextDirection? textDirection,
  }) : super(value, _fromSlide(transformHitTests, textDirection));

  MamableTransition.positioned(Matalue<RelativeRect> value)
      : super(value, _fromPositioned);

  MamableTransition.relativePositioned(
    Matalue<double> value, {
    required Size size,
  }) : super(value, _fromPositionedRelative(size));

  MamableTransition.align(
    Matalue<AlignmentGeometry> value, {
    double? widthFactor,
    double? heightFactor,
  }) : super(value, _fromAlign(widthFactor, heightFactor));

  ///
  ///
  ///
  MamableTransition.decoration(
    Matalue<Decoration> value, {
    DecorationPosition position = DecorationPosition.background,
  }) : super(value, _fromDecoration(position));

  MamableTransition.defaultTextStyle(
    Matalue<TextStyle> value, {
    TextAlign? textAlign,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
  }) : super(value, _fromTextStyle(textAlign, softWrap, overflow, maxLines));

  ///
  ///
  ///
  static AnimationBuilder _fromFade(bool alwaysIncludeSemantics) =>
      (animation, child) => FadeTransition(
            opacity: animation as Animation<double>,
            alwaysIncludeSemantics: alwaysIncludeSemantics,
            child: child,
          );

  static AnimationBuilder _fromFadeSliver(
    bool alwaysIncludeSemantics,
  ) =>
      (animation, child) => SliverFadeTransition(
            opacity: animation as Animation<double>,
            alwaysIncludeSemantics: alwaysIncludeSemantics,
            sliver: child,
          );

  static AnimationBuilder _fromFadeScale(
    Alignment alignment,
    FilterQuality? filterQuality,
  ) =>
      (animation, child) => ScaleTransition(
            scale: animation as Animation<double>,
            alignment: alignment,
            filterQuality: filterQuality,
            child: child,
          );

  static AnimationBuilder _fromSize(
    Axis axis,
    double axisAlignment,
    double? fixedCrossAxisSizeFactor,
  ) =>
      (animation, child) => SizeTransition(
            sizeFactor: animation as Animation<double>,
            axis: axis,
            axisAlignment: axisAlignment,
            fixedCrossAxisSizeFactor: fixedCrossAxisSizeFactor,
            child: child,
          );

  static AnimationBuilder _fromRotate(
    Alignment alignment,
    FilterQuality? filterQuality,
  ) =>
      (animation, child) => RotationTransition(
            turns: animation as Animation<double>,
            alignment: alignment,
            filterQuality: filterQuality,
            child: child,
          );

  static AnimationBuilder _fromSlide(
    bool transformHitTests,
    TextDirection? textDirection,
  ) =>
      (animation, child) => SlideTransition(
            position: animation as Animation<Offset>,
            transformHitTests: transformHitTests,
            textDirection: textDirection,
            child: child,
          );

  static Widget _fromPositioned(
    Animation animation,
    Widget child,
  ) =>
      PositionedTransition(
        rect: animation as Animation<RelativeRect>,
        child: child,
      );

  static AnimationBuilder _fromPositionedRelative(Size size) =>
      (animation, child) => RelativePositionedTransition(
            rect: animation as Animation<Rect>,
            size: size,
            child: child,
          );

  static AnimationBuilder _fromAlign(
    double? widthFactor,
    double? heightFactor,
  ) =>
      (animation, child) => AlignTransition(
            alignment: animation as Animation<AlignmentGeometry>,
            heightFactor: heightFactor,
            widthFactor: widthFactor,
            child: child,
          );

  static AnimationBuilder _fromDecoration(DecorationPosition p) =>
      (animation, child) => DecoratedBoxTransition(
            decoration: animation as Animation<Decoration>,
            position: p,
            child: child,
          );

  static AnimationBuilder _fromTextStyle(
    TextAlign? textAlign,
    bool softWrap,
    TextOverflow overflow,
    int? maxLines,
  ) =>
      (animation, child) => DefaultTextStyleTransition(
            style: animation as Animation<TextStyle>,
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
final class MamableClipper<T> extends MamableSingle<Path Function(Size size)> {
  final Clip clipBehavior;

  MamableClipper(
    BetweenPath<T> value, {
    this.clipBehavior = Clip.antiAlias,
  }) : super(
          value,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) => ClipPath(
              clipper: Clipping.reclipWhenUpdate(animation.value),
              clipBehavior: clipBehavior,
              child: child,
            ),
          ),
        );
}

///
///
///
final class MamablePainter<T> extends MamableSingle<Path Function(Size size)> {
  final bool isComplex;
  final CustomPainter? background;
  final Size size;
  final CustomPainter Function(Path Function(Size size)) painter;

  MamablePainter(
    BetweenPath<T> value, {
    this.isComplex = false,
    this.size = Size.zero,
    required this.background,
    required this.painter,
  }) : super(
          value,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) => CustomPaint(
              willChange: true,
              painter: background,
              foregroundPainter: painter(animation.value),
              size: size,
              isComplex: isComplex,
              child: child,
            ),
          ),
        );

  MamablePainter.paintFrom(
    BetweenPath<T> value, {
    required PaintFrom paintFrom,
  }) : this(
          value,
          isComplex: false,
          size: Size.zero,
          background: null,
          painter: FPainter.of(paintFrom),
        );
}

///
///
///
final class MamableTransform extends MamableSingle<Point3> {
  final Companion<Matrix4, Point3> onAnimate;
  AlignmentGeometry? alignment;
  Matrix4 host;

  MamableTransform(
    Matalue<Point3> value, {
    required this.alignment,
    required this.host,
    required this.onAnimate,
  }) : super(
          value,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) => Transform(
              transform: onAnimate(host, animation.value),
              alignment: alignment,
              child: child,
            ),
          ),
        );

  ///
  ///
  ///
  MamableTransform.translation({
    required Matalue<Point3> translate,
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this(
          translate,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransform._translating,
        );

  MamableTransform.rotation({
    required Matalue<Point3> rotate,
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this(
          rotate,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransform._rotating,
        );

  MamableTransform.scale({
    required Matalue<Point3> scale,
    AlignmentGeometry? alignment,
    Matrix4? host,
  }) : this(
          scale,
          alignment: alignment,
          host: host ?? Matrix4.identity(),
          onAnimate: MamableTransform._scaling,
        );

  static Matrix4 _translating(Matrix4 matrix4, Point3 p) =>
      matrix4..translate(v64.Vector3(p.x, p.y, p.z));

  static Matrix4 _rotating(Matrix4 matrix4, Point3 p) => matrix4
    ..setRotation((Matrix4.identity()
          ..rotateX(p.x)
          ..rotateY(p.y)
          ..rotateZ(p.z))
        .getRotation());

  static Matrix4 _scaling(Matrix4 matrix4, Point3 p) =>
      matrix4.scaled(p.x, p.y, p.z);
}

///
///
///
abstract final class ManableSet implements Manable {
  const ManableSet();

  const factory ManableSet.sync(MamableSet model) = _ManableSetSync;

  const factory ManableSet.syncAlsoParent(MamableSet model) =
      _ManableParentSetSync.also;

  const factory ManableSet.each(Iterable<MamableSingle> each) = _ManableSetEach;

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
    required Iterable<MamableSingle> each,
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
