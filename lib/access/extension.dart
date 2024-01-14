part of '../mationani.dart';

///
/// this file contains:
/// [NumExtension], [DoubleExtension], [IntExtension]
/// [SizeExtension], [OffsetExtension], [RectExtension]
/// [AlignmentExtension]
/// [DurationExtension], [CurveExtension]
/// [ColorExtension]
/// [FocusManagerExtension], [FocusNodeExtension]
///
/// [PathExtension]
///
/// [GlobalKeyExtension]
/// [RenderBoxExtension]
///
/// [ImageExtension]
/// [PositionedExtension]
///
/// [BuildContextExtension]
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
///

extension NumExtension on num {
  num get square => math.pow(this, 2);

  bool isSmallerOrEqualTo(int value) => this == value || this < value;

  bool isLessOneOrEqualTo(int value) => this == value || this + 1 == value;

  bool isHigherOrEqualTo(int value) => this == value || this > value;

  bool isHigherOneOrEqualTo(int value) => this == value || this == value + 1;
}

extension DoubleExtension on double {
  static final double infinity2_31 = DoubleExtension.proximateInfinityOf(2.31);
  static final double infinity3_2 = DoubleExtension.proximateInfinityOf(3.2);
  static const double sqrt2 = math.sqrt2;
  static const double sqrt3 = 1.7320508075688772;
  static const double sqrt5 = 2.23606797749979;
  static const double sqrt6 = 2.44948974278317;
  static const double sqrt7 = 2.6457513110645907;
  static const double sqrt8 = 2.8284271247461903;
  static const double sqrt10 = 3.1622776601683795;
  static const double sqrt1_2 = math.sqrt1_2;
  static const double sqrt1_3 = 0.5773502691896257;
  static const double sqrt1_5 = 0.4472135954999579;
  static const double sqrt1_6 = 0.408248290463863;
  static const double sqrt1_7 = 0.3779644730092272;
  static const double sqrt1_8 = 0.3535533905932738;
  static const double sqrt1_10 = 0.31622776601683794;

  Radius get toCircularRadius => Radius.circular(this);

  bool get isNearlyInt => (ceil() - this) <= 0.01;

  ///
  /// infinity usages
  ///

  static double proximateInfinityOf(double precision) =>
      1.0 / math.pow(0.1, precision);

  static double proximateNegativeInfinityOf(double precision) =>
      -1.0 / math.pow(0.1, precision);

  double filterInfinity(double precision) => switch (this) {
    double.infinity => proximateInfinityOf(precision),
    double.negativeInfinity => proximateNegativeInfinityOf(precision),
    _ => this,
  };
}

extension IntExtension on int {
  int get accumulate {
    assert(!isNegative && this != 0, 'invalid accumulate integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator += i;
    }
    return accelerator;
  }

  int get factorial {
    assert(!isNegative && this != 0, 'invalid factorial integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator *= i;
    }
    return accelerator;
  }

  static List<int> accumulationTo(int end, {int start = 0}) {
    final list = <int>[];
    for (int i = start; i <= end; i++) {
      list.add(i.accumulate);
    }
    return list;
  }
}

extension SizeExtension on Size {
  double get diagonal => math.sqrt(width * width + height * height);

  Radius get toRadiusEllipse => Radius.elliptical(width, height);

  Size extrudeHeight(double ratio) => Size(width, width * ratio);

  Size extrudeWidth(double ratio) => Size(height * ratio, height);
}

extension OffsetExtension on Offset {
  Coordinate get toCoordinate => Coordinate.ofXY(dx, dy);

  ///
  ///
  /// instance methods
  ///
  ///
  String toStringAsFixed1() =>
      '(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';

  double directionTo(Offset p) => (p - this).direction;

  double distanceTo(Offset p) => (p - this).distance;

  double distanceHalfTo(Offset p) => (p - this).distance / 2;

  Offset middleWith(Offset p) => (p + this) / 2;

  Offset direct(double direction, [double distance = 1]) =>
      this + Offset.fromDirection(direction, distance);

  double directionPerpendicular({bool isCounterclockwise = true}) =>
      direction + math.pi / 2 * (isCounterclockwise ? 1 : -1);

  Offset get toPerpendicularUnit =>
      Offset.fromDirection(directionPerpendicular());

  Offset get toPerpendicular =>
      Offset.fromDirection(directionPerpendicular(), distance);

  bool isAtBottomRightOf(Offset offset) => this > offset;

  bool isAtTopLeftOf(Offset offset) => this < offset;

  bool isAtBottomLeftOf(Offset offset) => dx < offset.dx && dy > offset.dy;

  bool isAtTopRightOf(Offset offset) => dx > offset.dx && dy < offset.dy;

  ///
  ///
  /// instance getters
  ///
  ///

  Size get toSize => Size(dx, dy);

  Offset get toReciprocal => Offset(1 / dx, 1 / dy);

  ///
  ///
  /// static methods:
  ///
  ///
  static Offset square(double value) => Offset(value, value);

  ///
  /// [parallelUnitOf]
  /// [parallelVectorOf]
  /// [parallelOffsetOf]
  /// [parallelOffsetUnitOf]
  /// [parallelOffsetUnitOnCenterOf]
  ///
  static Offset parallelUnitOf(Offset a, Offset b) {
    final offset = b - a;
    return offset / offset.distance;
  }

  static Offset parallelVectorOf(Offset a, Offset b, double t) => (b - a) * t;

  static Offset parallelOffsetOf(Offset a, Offset b, double t) =>
      a + parallelVectorOf(a, b, t);

  static Offset parallelOffsetUnitOf(Offset a, Offset b, double t) =>
      a + parallelUnitOf(a, b) * t;

  static Offset parallelOffsetUnitOnCenterOf(Offset a, Offset b, double t) =>
      a.middleWith(b) + parallelUnitOf(a, b) * t;

  ///
  /// [perpendicularUnitOf]
  /// [perpendicularVectorOf]
  /// [perpendicularOffsetOf]
  /// [perpendicularOffsetUnitOf]
  /// [perpendicularOffsetUnitFromCenterOf]
  ///
  static Offset perpendicularUnitOf(Offset a, Offset b) =>
      (b - a).toPerpendicularUnit;

  static Offset perpendicularVectorOf(Offset a, Offset b, double t) =>
      (b - a).toPerpendicular * t;

  static Offset perpendicularOffsetOf(Offset a, Offset b, double t) =>
      a + perpendicularVectorOf(a, b, t);

  static Offset perpendicularOffsetUnitOf(Offset a, Offset b, double t) =>
      a + perpendicularUnitOf(a, b) * t;

  static Offset perpendicularOffsetUnitFromCenterOf(
      Offset a,
      Offset b,
      double t,
      ) =>
      a.middleWith(b) + perpendicularUnitOf(a, b) * t;
}


extension RectExtension on Rect {
  static Rect fromZeroTo(Size size) => Offset.zero & size;

  static Rect fromLTSize(double left, double top, Size size) =>
      Rect.fromLTWH(left, top, size.width, size.height);

  static Rect fromOffsetSize(Offset zero, Size size) =>
      Rect.fromLTWH(zero.dx, zero.dy, size.width, size.height);

  static Rect fromCenterSize(Offset center, Size size) =>
      Rect.fromCenter(center: center, width: size.width, height: size.height);

  static Rect fromCircle(Offset center, double radius) =>
      Rect.fromCircle(center: center, radius: radius);



  double get distanceDiagonal => size.diagonal;

  Offset offsetFromAlignment(Alignment value) => switch (value) {
    Alignment.topLeft => topLeft,
    Alignment.topCenter => topCenter,
    Alignment.topRight => topRight,
    Alignment.centerLeft => centerLeft,
    Alignment.center => center,
    Alignment.centerRight => centerRight,
    Alignment.bottomLeft => bottomLeft,
    Alignment.bottomCenter => bottomCenter,
    Alignment.bottomRight => bottomRight,
    _ => throw UnimplementedError(),
  };

  ///
  ///
  /// my usages ------------------------------------------------------------------------------------------------------
  ///
  Offset offsetFromDirection(Direction2DIn8 value) => switch (value) {
    Direction2DIn8.topLeft => topLeft,
    Direction2DIn8.top => topCenter,
    Direction2DIn8.topRight => topRight,
    Direction2DIn8.left => centerLeft,
    Direction2DIn8.right => centerRight,
    Direction2DIn8.bottomLeft => bottomLeft,
    Direction2DIn8.bottom => bottomCenter,
    Direction2DIn8.bottomRight => bottomRight,
  };

  Rect expandToIncludeDirection({
    required Direction2DIn8 direction,
    required double width,
    required double length,
  }) {
    final start = offsetFromDirection(direction);
    return expandToInclude(
      switch (direction) {
        Direction2DIn8.top => Rect.fromPoints(
          start + Offset(width / 2, 0),
          start + Offset(-width / 2, -length),
        ),
        Direction2DIn8.bottom => Rect.fromPoints(
          start + Offset(width / 2, 0),
          start + Offset(-width / 2, length),
        ),
        Direction2DIn8.left => Rect.fromPoints(
          start + Offset(0, width / 2),
          start + Offset(-length, -width / 2),
        ),
        Direction2DIn8.right => Rect.fromPoints(
          start + Offset(0, width / 2),
          start + Offset(length, -width / 2),
        ),
        Direction2DIn8.topLeft => Rect.fromPoints(
          start,
          start + Offset(-length, -length) * DoubleExtension.sqrt1_2,
        ),
        Direction2DIn8.topRight => Rect.fromPoints(
          start,
          start + Offset(length, -length) * DoubleExtension.sqrt1_2,
        ),
        Direction2DIn8.bottomLeft => Rect.fromPoints(
          start,
          start + Offset(-length, length) * DoubleExtension.sqrt1_2,
        ),
        Direction2DIn8.bottomRight => Rect.fromPoints(
          start,
          start + Offset(length, length) * DoubleExtension.sqrt1_2,
        ),
      },
    );
  }

///
/// ------------------------------------------------------------------------------------------------------
///
///
}

extension AlignmentExtension on Alignment {
  double get radianRangeForSide {
    final boundary = radianBoundaryForSide;
    return boundary.$2 - boundary.$1;
  }

  (double, double) get radianBoundaryForSide => switch (this) {
    Alignment.center => (0, KRadian.angle_360),
    Alignment.centerLeft => (-KRadian.angle_90, KRadian.angle_90),
    Alignment.centerRight => (KRadian.angle_90, KRadian.angle_270),
    Alignment.topCenter => (0, KRadian.angle_180),
    Alignment.topLeft => (0, KRadian.angle_90),
    Alignment.topRight => (KRadian.angle_90, KRadian.angle_180),
    Alignment.bottomCenter => (KRadian.angle_180, KRadian.angle_360),
    Alignment.bottomLeft => (KRadian.angle_270, KRadian.angle_360),
    Alignment.bottomRight => (KRadian.angle_180, KRadian.angle_270),
    _ => throw UnimplementedError(),
  };

  double radianRangeForSideStepOf(int count) =>
      radianRangeForSide / (this == Alignment.center ? count : count - 1);

  Mapper<Widget> get deviateBuilder {
    Row rowOf(List<Widget> children) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );

    final rowBuilder = switch (x) {
      0 => (child) => rowOf([child]),
      1 => (child) => rowOf([child, WSizedBox.expand]),
      -1 => (child) => rowOf([WSizedBox.expand, child]),
      _ => throw UnimplementedError(),
    };

    Column columnOf(List<Widget> children) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );

    final columnBuilder = switch (y) {
      0 => (child) => columnOf([child]),
      1 => (child) => columnOf([rowBuilder(child), WSizedBox.expand]),
      -1 => (child) => columnOf([WSizedBox.expand, rowBuilder(child)]),
      _ => throw UnimplementedError(),
    };

    return (child) => columnBuilder(child);
  }

  Generator<double> directionOfSideSpace(bool isClockwise, int count) {
    final boundary = radianBoundaryForSide;
    final origin = isClockwise ? boundary.$1 : boundary.$2;
    final step = radianRangeForSideStepOf(count);

    return isClockwise
        ? (index) => origin + step * index
        : (index) => origin - step * index;
  }

///
/// ------------------------------------------------------------------------------------------------------
///
///
}

extension DurationExtension on Duration {
  DurationFR get toDurationFR => DurationFR.constant(this);
}

extension CurveExtension on Curve {
  CurveFR get toCurveFR => CurveFR(this, this);
}

extension ColorExtension on Color {
  static Color get randomPrimary => Colors.primaries[math.Random().nextInt(18)];

  Color plusARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha + alpha,
    this.red + red,
    this.green + green,
    this.blue + blue,
  );

  Color minusARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha - alpha,
    this.red - red,
    this.green - green,
    this.blue - blue,
  );

  Color multiplyARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha * alpha,
    this.red * red,
    this.green * green,
    this.blue * blue,
  );

  Color divideARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha ~/ alpha,
    this.red ~/ red,
    this.green ~/ green,
    this.blue ~/ blue,
  );

  Color operateWithValue(Operator operator, int value) => switch (operator) {
    Operator.plus => plusARGB(0, value, value, value),
    Operator.minus => minusARGB(0, value, value, value),
    Operator.multiply => multiplyARGB(1, value, value, value),
    Operator.divide => divideARGB(1, value, value, value),
    Operator.modulus => throw UnimplementedError(),
  };
}

extension FocusManagerExtension on FocusManager {
  void unFocus() => primaryFocus?.unfocus();
}

extension FocusNodeExtension on FocusNode {
  VoidCallback addFocusChangedListener(VoidCallback listener) =>
      hasFocus ? listener : kVoidCallback;
}

///
///
///
/// path
///
///
///

extension PathExtension on Path {
  ///
  /// move, line, arc
  ///
  void moveToPoint(Offset point) => moveTo(point.dx, point.dy);

  void lineToPoint(Offset point) => lineTo(point.dx, point.dy);

  void moveOrLineToPoint(Offset point, bool shouldMove) =>
      shouldMove ? moveToPoint(point) : lineTo(point.dx, point.dy);

  void lineFromAToB(Offset a, Offset b) => this
    ..moveToPoint(a)
    ..lineToPoint(b);

  void lineFromAToAll(Offset a, Iterable<Offset> points) => points.fold<Path>(
    this..moveToPoint(a),
        (path, point) => path..lineToPoint(point),
  );

  void arcFromStartToEnd(
      Offset arcStart,
      Offset arcEnd, {
        Radius radius = Radius.zero,
        bool clockwise = true,
        double rotation = 0.0,
        bool largeArc = false,
      }) =>
      this
        ..moveToPoint(arcStart)
        ..arcToPoint(
          arcEnd,
          radius: radius,
          clockwise: clockwise,
          rotation: rotation,
          largeArc: largeArc,
        );

  // see https://www.youtube.com/watch?v=aVwxzDHniEw for explanation of cubic bezier
  void quadraticBezierToPoint(Offset controlPoint, Offset endPoint) =>
      quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void quadraticBezierToRelativePoint(Offset controlPoint, Offset endPoint) =>
      relativeQuadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToPoint(
      Offset controlPoint1,
      Offset controlPoint2,
      Offset endPoint,
      ) =>
      cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToRelativePoint(
      Offset controlPoint1,
      Offset controlPoint2,
      Offset endPoint,
      ) =>
      relativeCubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  /// [points] should be treated as [controlPointA, controlPointB, endPoint]
  void cubicToPointsList(List<Offset> points) =>
      cubicToPoint(points[0], points[1], points[2]);

  ///
  ///
  ///
  /// shape
  ///
  ///
  ///
  void addOvalFromCircle(Offset center, double radius) =>
      addOval(Rect.fromCircle(center: center, radius: radius));

  void addRectFromPoints(Offset a, Offset b) => addRect(Rect.fromPoints(a, b));

  void addRectFromCenter(Offset center, double width, double height) =>
      addRect(Rect.fromCenter(center: center, width: width, height: height));

  void addRectFromLTWH(double left, double top, double width, double height) =>
      addRect(Rect.fromLTWH(left, top, width, height));
}

extension GlobalKeyExtension on GlobalKey {
  RenderBox get renderBox => currentContext?.findRenderObject() as RenderBox;

  Rect get renderRect => renderBox.fromLocalToGlobalRect;

  Offset adjustScaffoldOf(Offset offset) {
    final translation = currentContext
        ?.findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();

    return translation == null
        ? offset
        : Offset(
      offset.dx - translation.x,
      offset.dy - translation.y,
    );
  }
}

extension RenderBoxExtension on RenderBox {
  Rect get fromLocalToGlobalRect =>
      RectExtension.fromOffsetSize(localToGlobal(Offset.zero), size);
}

extension ImageExtension on Image {
  static assetsInDimension(
      String path,
      double dimension, {
        Alignment alignment = Alignment.center,
        FilterQuality filterQuality = FilterQuality.medium,
      }) =>
      Image.asset(
        path,
        height: dimension,
        width: dimension,
        alignment: alignment,
        filterQuality: filterQuality,
      );
}

extension PositionedExtension on Positioned {
  Rect? get rect =>
      (left == null || top == null || width == null || height == null)
          ? null
          : Rect.fromLTWH(left!, top!, width!, height!);
}

///
/// [theme], [textTheme], [colorScheme], [appBarTheme]
/// [mediaSize], [mediaViewInsets]
/// [isKeyboardShowing]
///
/// [renderBox]
/// [scaffold], [scaffoldMessenger]
/// [navigator]
///
/// [closeKeyboardIfShowing]
/// [showSnackbar], [showSnackbarWithMessage]
/// [showDialogGenericStyle1], [showDialogGenericStyle2], [showDialogListAndGetItem], [showDialogDecideTureOfFalse]
///
extension BuildContextExtension on BuildContext {
  // AppLocalizations get loc => AppLocalizations.of(this)!;

  ///
  /// theme
  ///

  TargetPlatform get platform => Theme.of(this).platform;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppBarTheme get appBarTheme => theme.appBarTheme;

  ///
  /// material
  ///

  Size get mediaSize => MediaQuery.sizeOf(this);

  Size get renderBoxSize => renderBox.size;

  EdgeInsets get mediaViewInsets => MediaQuery.viewInsetsOf(this);

  double get mediaViewInsetsBottom => mediaViewInsets.bottom;

  bool get isKeyboardShowing => mediaViewInsetsBottom > 0;

  RenderBox get renderBox => findRenderObject() as RenderBox;

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  NavigatorState get navigator => Navigator.of(this);

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  TextDirection get textDirection => Directionality.of(this);

  TextStyle defaultTextStyleMerge(TextStyle? other) {
    final style = defaultTextStyle.style;
    return style.inherit ? style.merge(other) : style;
  }

  void pop() => Navigator.pop(this);

  void closeKeyboardIfShowing() {
    if (isKeyboardShowing) {
      FocusScopeNode currentFocus = FocusScope.of(this);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  ///
  ///
  ///
  /// insert overlay, show snackbar, material banner, dialog
  ///
  ///
  ///

  /// snackbar
  void showSnackbar(SnackBar snackBar) =>
      scaffoldMessenger.showSnackBar(snackBar);

  void showSnackbarWithMessage(
      String? message, {
        bool isCenter = true,
        bool showWhetherMessageIsNull = false,
        Duration duration = KDuration.second1,
        Color? backgroundColor,
        SnackBarBehavior behavior = SnackBarBehavior.floating,
      }) {
    if (showWhetherMessageIsNull || message != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor ?? theme.cardColor,
          behavior: behavior,
          duration: duration,
          content: isCenter
              ? Center(child: Text(message ?? ''))
              : Text(message ?? ''),
        ),
      );
    }
  }

  /// material banner
  void showMaterialBanner(MaterialBanner banner) =>
      ScaffoldMessenger.of(this).showMaterialBanner(banner);

  void hideMaterialBanner({
    MaterialBannerClosedReason reason = MaterialBannerClosedReason.dismiss,
  }) =>
      ScaffoldMessenger.of(this).hideCurrentMaterialBanner(reason: reason);

  /// dialog
  Future<T?> showDialogGenericStyle1<T>({
    required String title,
    required String content,
    required Supplier<Map<String, T>> optionsBuilder,
  }) {
    final options = optionsBuilder();
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys
            .map((optionTitle) => TextButton(
          onPressed: () => context.navigator.pop(
            options[optionTitle],
          ),
          child: Text(optionTitle),
        ))
            .toList(),
      ),
    );
  }

  Future<T?> showDialogGenericStyle2<T>({
    required String title,
    required String? content,
    required Map<String, T Function()> actionTitleAndActions,
  }) async {
    final actions = <Widget>[];
    T? returnValue;
    actionTitleAndActions.forEach((label, action) {
      actions.add(TextButton(
        onPressed: () {
          navigator.pop();
          returnValue = action();
        },
        child: Text(label),
      ));
    });
    await showDialog(
        context: this,
        builder: (context) => content == null
            ? SimpleDialog(title: Text(title), children: actions)
            : AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ));
    return returnValue;
  }

  void showDialogStyle3(
      String text,
      VoidCallback? onEnsure, {
        Widget? content,
        String messageEnsure = '確認',
      }) {
    showDialog<void>(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: content ?? Text(text),
          actions: [
            if (onEnsure != null)
              TextButton(
                onPressed: onEnsure,
                child: Text(messageEnsure),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  Future<T?> showDialogListAndGetItem<T>({
    required String title,
    required List<T> itemList,
  }) async {
    late final T? selectedItem;
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 200,
          width: 100,
          child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return Center(
                child: TextButton(
                  onPressed: () {
                    selectedItem = item;
                    context.navigator.pop();
                  },
                  child: Text(item.toString()),
                ),
              );
            },
          ),
        ),
      ),
    );
    return selectedItem;
  }

  Future<bool?> showDialogDecideTureOfFalse() async {
    bool? result;
    await showDialog(
        context: this,
        builder: (context) => SimpleDialog(
          children: [
            TextButton(
              onPressed: () {
                result = true;
                context.navigator.pop();
              },
              child: WIconMaterial.check,
            ),
            TextButton(
              onPressed: () {
                result = false;
                context.navigator.pop();
              },
              child: WIconMaterial.cross,
            ),
          ],
        ));
    return result;
  }
}
