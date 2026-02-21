part of '../mationani.dart';

///
/// .
///     --[MamableSet]
///     |
///     |   --[MamableTransformCompose]
///     |   --[MamableTransform], [Matrix4Extension]
///     |   --[MamableClip]
///     |   --[MamablePaint]
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
typedef BiCurve = (Curve, Curve);

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
    covariant Widget child,
  );
}

abstract final class Manable implements Matable {
  List<Widget> _perform(
    Animation<double> parent,
    covariant List<Widget> children,
  );
}

///
///
///
sealed class MamableSingle<T> extends _MatableDriver<T> implements Mamable {
  @override
  Widget _perform(Animation<double> parent, Widget child) => switch (this) {
        _MamableSingle() => ListenableBuilder(
            listenable: parent,
            builder: (_, __) => _builder(_drive(parent), child),
          ),
        _ => _builder(_drive(parent), child),
      };

  const MamableSingle._(super.matalue, super._builder);

  const factory MamableSingle(Matalue<T>? matalue, AnimationBuilder builder) =
      _MamableSingle;
}

final class _MamableSingle<T> extends MamableSingle<T> {
  const _MamableSingle(super.matalue, super.builder) : super._();
}

final class ManableSync<T> extends _MatableDriver<T> implements Manable {
  @override
  List<Widget> _perform(
    Animation<double> parent,
    covariant List<Widget> children,
  ) {
    final animation = _drive(parent);
    final builder = _builder;
    return List.of(
      children.map((child) => builder(animation, child)),
      growable: false,
    );
  }

  const ManableSync(super.matalue, super._builder);

  factory ManableSync.alsoParent(Matalue<T> matalue, AnimationBuilder builder) =
      _ManableParentSyncAlso<T>;

  factory ManableSync.andParent({
    required Matalue<T> matalue,
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
  Widget _perform(Animation<double> parent, Widget child) => ables.fold(
        child,
        (child, able) => able._builder(able._drive(parent), child),
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
    Matalue<double> matalue, {
    bool alwaysIncludeSemantics = false,
  }) : super._(matalue, _fromFade(alwaysIncludeSemantics));

  MamableTransition.fadeIn({
    BiCurve? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(0.0, 1.0, curve));

  MamableTransition.fadeInTo(
    double opacity, {
    BiCurve? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(0.0, opacity, curve));

  MamableTransition.fadeOut({
    BiCurve? curve,
    bool alwaysIncludeSemantics = false,
  }) : this.fade(Between(1.0, 0.0, curve));

  MamableTransition.silverFade(
    Matalue<double> matalue, {
    bool alwaysIncludeSemantics = false,
  }) : super._(matalue, _fromFadeSliver(alwaysIncludeSemantics));

  ///
  ///
  ///
  MamableTransition.scale(
    Matalue<double> matalue, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super._(matalue, _fromFadeScale(alignment, filterQuality));

  MamableTransition.size(
    Matalue<double> matalue, {
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
    double? fixedCrossAxisSizeFactor,
  }) : super._(
            matalue, _fromSize(axis, axisAlignment, fixedCrossAxisSizeFactor));

  ///
  ///
  ///
  MamableTransition.rotate(
    Matalue<double> matalue, {
    Alignment alignment = Alignment.topLeft,
    FilterQuality? filterQuality,
  }) : super._(matalue, _fromRotate(alignment, filterQuality));

  MamableTransition.rotateInRadian(
    Matalue<double> matalue, {
    Alignment alignment = Alignment.topLeft,
  }) : this.rotate(Matalue.doubleRadianFromRound(matalue),
            alignment: alignment);

  ///
  ///
  ///
  MamableTransition.slide(
    Matalue<Offset> matalue, {
    bool transformHitTests = true,
    TextDirection? textDirection,
  }) : super._(matalue, _fromSlide(transformHitTests, textDirection));

  MamableTransition.positioned(Matalue<RelativeRect> matalue)
      : super._(matalue, _fromPositioned);

  MamableTransition.relativePositioned(
    Matalue<double> matalue, {
    required Size size,
  }) : super._(matalue, _fromPositionedRelative(size));

  MamableTransition.align(
    Matalue<AlignmentGeometry> matalue, {
    double? widthFactor,
    double? heightFactor,
  }) : super._(matalue, _fromAlign(widthFactor, heightFactor));

  ///
  ///
  ///
  MamableTransition.decoration(
    Matalue<Decoration> matalue, {
    DecorationPosition position = DecorationPosition.background,
  }) : super._(matalue, _fromDecoration(position));

  MamableTransition.defaultTextStyle(
    Matalue<TextStyle> matalue, {
    TextAlign? textAlign,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
  }) : super._(
            matalue, _fromTextStyle(textAlign, softWrap, overflow, maxLines));

  ///
  ///
  ///
  static AnimationBuilder _fromFade(bool alwaysIncludeSemantics) =>
      (animation, child) => FadeTransition(
            opacity: animation as Animation<double>,
            alwaysIncludeSemantics: alwaysIncludeSemantics,
            child: child,
          );

  static AnimationBuilder _fromFadeSliver(bool alwaysIncludeSemantics) =>
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

  static Widget _fromPositioned(Animation animation, Widget child) =>
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
final class MamableClip extends MamableSingle {
  MamableClip._(
    CustomClipper<Path> Function(dynamic) clipping,
    Clip clipBehavior, {
    required Matalue<dynamic>? matalue,
  }) : super._(
          matalue,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) => ClipPath(
              clipper: clipping(animation.value),
              clipBehavior: clipBehavior,
              child: child,
            ),
          ),
        );

  MamableClip(Path path, [Clip clipBehavior = Clip.antiAlias])
      : this._(
          () {
            final metric = path.computeMetrics().first,
                extract = metric.extractPath,
                length = metric.length;
            return (value) => _Clipper(extract(0.0, length * value));
          }(),
          clipBehavior,
          matalue: null,
        );

  MamableClip.path(Matalue<Path> matalue, [Clip clipBehavior = Clip.antiAlias])
      : this._((path) => _Clipper(path), clipBehavior, matalue: matalue);

  MamableClip.pathAdjust(
    Matalue<Path Function(Size)> matalue, [
    Clip clipBehavior = Clip.antiAlias,
  ]) : this._(
          (adjust) => _ClipperAdjust(adjust),
          clipBehavior,
          matalue: matalue,
        );
}

///
///
///
final class MamablePaint extends MamableSingle {
  MamablePaint._(
    CustomPainter Function(dynamic) painting, {
    required Matalue<dynamic>? matalue,
    bool isComplex = false,
    Size size = Size.zero,
    CustomPainter? background,
  }) : super._(
          matalue,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) => CustomPaint(
              willChange: true,
              painter: background,
              foregroundPainter: painting(animation.value),
              size: size,
              isComplex: isComplex,
              child: child,
            ),
          ),
        );

  MamablePaint(Path path, Paint pen)
      : this._(
          () {
            final matric = path.computeMetrics().first,
                extract = matric.extractPath,
                length = matric.length;
            return (value) => _Painter(
                  path: extract(0.0, length * value),
                  painting: _E._draw,
                  pen: pen,
                );
          }(),
          matalue: null,
        );

  MamablePaint.path(
    Matalue<Path> matalue, {
    void Function(Canvas, Paint, Path) painting = _E._draw,
    required Paint pen,
  }) : this._(
          (path) => _Painter(path: path, painting: painting, pen: pen),
          matalue: matalue,
        );

  MamablePaint.pathAdjust(
    Matalue<Path Function(Size)> matalue, {
    void Function(Canvas, Paint, Path) painting = _E._draw,
    required Paint pen,
  }) : this._(
          (adjust) => _PainterAdjust(
            adjust: adjust,
            painting: painting,
            pen: pen,
          ),
          matalue: matalue,
        );
}

///
///
///
final class MamableTransform extends MamableSingle {
  final Matrix4 Function(Matrix4 m, (double, double, double) vector) onAnimate;
  AlignmentGeometry? alignment;
  Matrix4 host;

  MamableTransform(
    Matalue<(double, double, double)> matalue, {
    required this.alignment,
    required this.host,
    required this.onAnimate,
  }) : super._(
          matalue,
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
  MamableTransform.rotating(
    Matalue<(double, double, double)> rotate,
    Matrix4 host, {
    AlignmentGeometry? alignment,
  }) : this(
          rotate,
          alignment: alignment,
          host: host,
          onAnimate: MamableTransform._setRotation,
        );

  static Matrix4 _setRotation(Matrix4 matrix4, (double, double, double) p) =>
      matrix4
        ..setRotation(v64.Matrix3.rotationX(p.$1)
          ..setRotationY(p.$2)
          ..setRotationZ(p.$3));
}

final class MamableTransformCompose extends MamableSingle {
  AlignmentGeometry? alignment;

  MamableTransformCompose(
    Matalue<TransformTarget> matalue, {
    this.alignment,
  }) : super._(
          matalue,
          (animation, child) => ListenableBuilder(
            listenable: animation,
            builder: (_, __) {
              final h = animation.value as TransformTarget;
              return Transform(
                transform: Matrix4.compose(h._t, h._r, h._s),
                alignment: alignment,
                child: child,
              );
            },
          ),
        );
}

///
///
///
extension Matrix4Extension on Matrix4 {
  ///
  /// [perspective] = 1 / distance
  ///
  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setIdentityPerspective() {
    final p = getPerspective();
    this
      ..setIdentity()
      ..setEntry(3, 2, p);
  }

  void rotateOn(double vx, double vy, double vz, double r) =>
      rotate(v64.Vector3(vx, vy, vz), r);

  double getPerspective() => entry(3, 2);
}

///
///
///
abstract final class ManableSet implements Manable {
  const ManableSet();

  const factory ManableSet.sync(MamableSet model) = _ManableSetSync;

  const factory ManableSet.syncAlsoParent(MamableSet model) =
      _ManableParentSetSync.also;

  const factory ManableSet.each(List<MamableSingle> each) = _ManableSetEach;

  const factory ManableSet.respectively(List<MamableSet> children) =
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
    required List<MamableSingle> each,
  }) = _ManableParentSetEach;

  const factory ManableSet.respectivelyAndParent({
    required Mamable parent,
    required List<MamableSet> children,
  }) = _ManableParentRespectively;

  const factory ManableSet.selectedAndParent({
    required Mamable parent,
    required Map<int, MamableSet> selected,
  }) = _ManableParentSelected;
}
