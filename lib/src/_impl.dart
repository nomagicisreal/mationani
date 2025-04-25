part of '../mationani.dart';


///
///
/// * [AnimationControllerExtension]
/// * [AnimationStyleExtension]
/// * [AnimationControllerInitializer]
/// * [AnimationUpdater]
/// * [AnimationBuilder]
///
/// * [OnAnimate]
/// * [OnAnimatePath]
/// * [OnAnimateMatrix4]
/// * [FOnAnimateMatrix4]
///
///
/// there are also some private implementation showed in the graph begin in matable.dart
/// see [_MatableDriver], ...
///
///


///
///
///
extension AnimationControllerExtension on AnimationController {
  void addStatusListenerIfNotNull(AnimationStatusListener? statusListener) {
    if (statusListener != null) addStatusListener(statusListener);
  }

  void addListenerIfNotNull(VoidCallback? listener) {
    if (listener != null) addListener(listener);
  }

  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);

  void updateDurationIfNew(Mationani oldWidget, Mationani widget) {
    final style = widget.ani.style;
    final styleOld = oldWidget.ani.style;
    if (styleOld?.duration != style?.duration) duration = style?.duration;
    if (styleOld?.reverseDuration != style?.reverseDuration) {
      reverseDuration = style?.reverseDuration;
    }
  }
}

///
///
///
extension AnimationStyleExtension on AnimationStyle? {
  bool isCurveEqualTo(AnimationStyle? another) {
    final style = this;
    if (style == null) return another == null;
    if (another == null) return false;
    return style.curve == another.curve &&
        style.reverseCurve == another.reverseCurve;
  }
}

///
///
///
typedef AnimationControllerInitializer = AnimationController Function(
    TickerProvider vsync,
    Duration forward,
    Duration reverse,
    );
typedef AnimationUpdater = void Function(
    AnimationController controller,
    Mationani oldWidget,
    Mationani widget,
    );
typedef AnimationBuilder<T> = Widget Function(
    Animation<T> animation,
    Widget child,
    );

///
///
///
typedef OnAnimate<T, S> = S Function(double t, T value);
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Point3>;

///
/// static methods, constants:
/// [mapTranslating], ...
/// [fixedTranslating], ...
/// [transformFromDirection]
///
/// instance methods, getters:
/// [setPerspective], ...
/// [getPerspective], ...
/// [perspectiveIdentity], ...
///
extension FOnAnimateMatrix4 on Matrix4 {
  ///
  ///
  ///
  static OnAnimateMatrix4 mapTranslating(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(mapping(value));

  static OnAnimateMatrix4 mapRotating(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(mapping(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4.scaledOf(mapping(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Point3 fixed) =>
          (matrix4, value) => matrix4
        ..perspectiveIdentity
        ..translateOf(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Point3 fixed) =>
          (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Point3 fixed) =>
          (matrix4, value) => matrix4.scaledOf(value + fixed);

  ///
  ///
  ///
  static Transform transformFromDirection({
    double zDeep = 100,
    required Direction3DIn6 direction,
    required Widget child,
  }) =>
      switch (direction) {
        Direction3DIn6.front => Transform(
          transform: Matrix4.identity(),
          alignment: Alignment.center,
          child: child,
        ),
        Direction3DIn6.back => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..translateOf(Point3.ofZ(-zDeep)),
          child: child,
        ),
        Direction3DIn6.left => Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()..rotateY(Radian.angle_90),
          child: child,
        ),
        Direction3DIn6.right => Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()..rotateY(-Radian.angle_90),
          child: child,
        ),
        Direction3DIn6.top => Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()..rotateX(-Radian.angle_90),
          child: child,
        ),
        Direction3DIn6.bottom => Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()..rotateX(Radian.angle_90),
          child: child,
        ),
      };

  ///
  /// instance methods
  ///
  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  void translateOf(Point3 point3) =>
      translate(v64.Vector3(point3.x, point3.y, point3.z));

  void translateFor(Offset offset) =>
      translate(v64.Vector3(offset.dx, offset.dy, 0));

  void rotateOf(Point3 point3) => this
    ..rotateX(point3.x)
    ..rotateY(point3.y)
    ..rotateZ(point3.z);

  void rotateOn(Point3 point3, double radian) =>
      rotate(v64.Vector3(point3.x, point3.y, point3.z), radian);

  double getPerspective() => entry(3, 2);

  Matrix4 get perspectiveIdentity => Matrix4.identity()..copyPerspective(this);

  Matrix4 scaledOf(Point3 point3) => scaled(point3.x, point3.y, point3.z);

  Matrix4 scaledFor(Offset offset) => scaled(offset.dx, offset.dy, 1);
}


///
///
///
abstract final class _MatableDriver<T> {
  final Matalue<T> value;

  final AnimationBuilder _builder;

  const _MatableDriver(this.value, this._builder);

  Animation _drive(Animation<double> parent, CurveFR? curve) =>
      curve.mapNotNullOr(
            (curve) => value.animate(CurvedAnimation(
            parent: parent, curve: curve.forward, reverseCurve: curve.reverse)),
            () => value.animate(parent),
      );
}

abstract interface class _ManableParent {
  Mamable get parent;
}


///
///
///
final class _ManableSetSync extends ManableSet {
  final MamableSet matable;

  const _ManableSetSync(this.matable);

  @override
  List<Widget> _perform(
      Animation<double> parent,
      CurveFR? curve,
      covariant List<Widget> children,
      ) =>
      children.mapToList(
            (child) => matable.ables.fold(
          child,
              (child, able) => able._builder(able._drive(parent, curve), child),
        ),
      );
}

final class _ManableSetEach extends ManableSet {
  final Iterable<MamableSolo> each;

  const _ManableSetEach(this.each);

  @override
  List<Widget> _perform(
      Animation<double> parent,
      CurveFR? curve,
      covariant List<Widget> children,
      ) =>
      children.foldWith(
        each,
        [],
            (output, child, solo) => output
          ..add(
            solo._builder(solo._drive(parent, curve), child),
          ),
      );
}

///
///
///
final class _ManableSetRespectively extends ManableSet {
  final Iterable<MamableSet> children;

  const _ManableSetRespectively(this.children);

  @override
  List<Widget> _perform(
      Animation<double> parent,
      CurveFR? curve,
      covariant List<Widget> children,
      ) =>
      children.foldWith(
        this.children,
        [],
            (output, child, matable) => output
          ..add(
            matable.ables.fold(
              child,
                  (child, able) => able._builder(able._drive(parent, curve), child),
            ),
          ),
      );
}

final class _ManableSetSelected extends ManableSet {
  final Map<int, MamableSet> selected;

  const _ManableSetSelected(this.selected);

  @override
  List<Widget> _perform(
      Animation<double> parent,
      CurveFR? curve,
      covariant List<Widget> children,
      ) =>
      children.iterator.mapToListByIndex(
            (child, i) => selected[i]!.ables.fold(
          child,
              (child, able) => able._builder(able._drive(parent, curve), child),
        ),
      );
}

///
///
///
final class _ManableParentSyncAlso<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  Mamable get parent => MamableSolo(value, _builder);

  const _ManableParentSyncAlso(super.value, super.builder);
}

final class _ManableParentSyncAnd<T> extends ManableSync<T>
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSyncAnd({
    required Matalue<T> value,
    required AnimationBuilder builder,
    required Mamable mamable,
  })  : parent = mamable,
        super(value, builder);
}

//
final class _ManableParentSetSync extends _ManableSetSync
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSetSync({required this.parent, required MamableSet model})
      : super(model);

  const _ManableParentSetSync.also(super.matable) : parent = matable;
}

//
final class _ManableParentSetEach extends _ManableSetEach
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSetEach(
      {required this.parent, required Iterable<MamableSolo> each})
      : super(each);
}

//
final class _ManableParentRespectively extends _ManableSetRespectively
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentRespectively({
    required this.parent,
    required Iterable<MamableSet> children,
  }) : super(children);
}

final class _ManableParentSelected extends _ManableSetSelected
    implements _ManableParent {
  @override
  final Mamable parent;

  const _ManableParentSelected({
    required this.parent,
    required Map<int, MamableSet> selected,
  }) : super(selected);
}
