part of '../mationani.dart';

///
/// this file contains:
/// [AnimatedOpacityIgnorePointer]
/// [CenterSizedBox], [CenterSizedBoxColored]
/// [SizedBoxCenter]
/// [PositionedTransformOpacity]
///
/// [CardPadding]
/// [RowPadding], [RowPaddingColumn]
/// [ColumnPadding], [ColumnPaddingRow]
///
/// [MaterialIconButton]
/// [MaterialInkWell], [MaterialInkWellPadding]
/// [AnimatedContainerDefaultTextStyleText]
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
///
///
///
///

class AnimatedOpacityIgnorePointer extends StatelessWidget {
  const AnimatedOpacityIgnorePointer({
    super.key,
    this.alwaysIncludeSemantics = false,
    this.curve = Curves.linear,
    this.onEnd,
    required this.duration,
    required this.ignoring,
    required this.child,
  });

  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;
  final bool ignoring;
  final bool alwaysIncludeSemantics;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      curve: curve,
      opacity: ignoring ? 0.0 : 1.0,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      onEnd: onEnd,
      child: IgnorePointer(
        ignoring: ignoring,
        child: child,
      ),
    );
  }
}

class CenterSizedBox extends StatelessWidget {
  const CenterSizedBox({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  const CenterSizedBox.expand({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
  })  : width = double.infinity,
        height = double.infinity;

  CenterSizedBox.fromSize({
    super.key,
    this.widthFactor,
    this.heightFactor,
    required Size size,
    this.child,
  })  : width = size.width,
        height = size.height;

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class CenterSizedBoxColored extends StatelessWidget {
  const CenterSizedBoxColored({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.child,
    required this.color,
  });

  CenterSizedBoxColored.fromSize({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
    required this.color,
    required Size size,
  })  : width = size.width,
        height = size.height;

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CenterSizedBox(
      width: width,
      height: height,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: ColoredBox(
        color: color,
        child: child,
      ),
    );
  }
}

class SizedBoxCenter extends StatelessWidget {
  const SizedBoxCenter({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  const SizedBoxCenter.expand({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
  })  : width = double.infinity,
        height = double.infinity;

  SizedBoxCenter.fromSize({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
    required Size size,
  })  : width = size.width,
        height = size.height;

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: child,
      ),
    );
  }
}

class PositionedTransformOpacity extends StatelessWidget {
  const PositionedTransformOpacity.translated(
    this.translated, {
    super.key,
    this.positionedFrom = Offset.zero,
    this.opacity = 0.3,
    required this.child,
  });

  static List<PositionedTransformOpacity> fromOffsets({
    required int length,
    required Generator<Offset> generator,
    required Widget child,
    Mapper<Offset> translation = FMapper.keep,
    double opacity = 0.3,
  }) =>
      Iterable.generate(length, generator).mapToList(
        (position) => PositionedTransformOpacity.translated(
          translation(position),
          positionedFrom: position,
          opacity: opacity,
          child: child,
        ),
      );

  final double opacity;
  final Offset positionedFrom;
  final Offset translated;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: positionedFrom.dx,
      top: positionedFrom.dy,
      child: Transform.translate(
        offset: translated,
        child: Opacity(
          opacity: opacity,
          child: child,
        ),
      ),
    );
  }
}

class CardPadding extends StatelessWidget {
  const CardPadding({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.margin,
    this.clipBehavior,
    this.borderOnForeground = true,
    this.semanticContainer = true,
    required this.padding,
    required this.child,
  });

  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final bool borderOnForeground;
  final bool semanticContainer;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      margin: margin,
      clipBehavior: clipBehavior,
      borderOnForeground: borderOnForeground,
      semanticContainer: semanticContainer,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class RowPadding extends StatelessWidget {
  const RowPadding({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.childCount = 1,
    required this.padding,
    required this.child,
  });

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int childCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: List.generate(childCount, childGenerator),
    );
  }

  Widget childGenerator(int index) => Padding(padding: padding, child: child);
}

class RowPaddingColumn extends StatelessWidget {
  const RowPaddingColumn({
    super.key,
    this.mainAxisAlignmentRow = MainAxisAlignment.center,
    this.mainAxisAlignmentColumn = MainAxisAlignment.center,
    this.mainAxisSizeRow = MainAxisSize.max,
    this.mainAxisSizeColumn = MainAxisSize.max,
    this.crossAxisAlignmentRow = CrossAxisAlignment.center,
    this.crossAxisAlignmentColumn = CrossAxisAlignment.center,
    this.verticalDirectionRow = VerticalDirection.down,
    this.verticalDirectionColumn = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.columnCount = 1,
    required this.padding,
    required this.children,
  });

  final MainAxisAlignment mainAxisAlignmentRow;
  final MainAxisAlignment mainAxisAlignmentColumn;
  final MainAxisSize mainAxisSizeRow;
  final MainAxisSize mainAxisSizeColumn;
  final CrossAxisAlignment crossAxisAlignmentRow;
  final CrossAxisAlignment crossAxisAlignmentColumn;
  final VerticalDirection verticalDirectionRow;
  final VerticalDirection verticalDirectionColumn;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int columnCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RowPadding(
      mainAxisAlignment: mainAxisAlignmentRow,
      mainAxisSize: mainAxisSizeRow,
      crossAxisAlignment: crossAxisAlignmentRow,
      textDirection: textDirection,
      verticalDirection: verticalDirectionRow,
      textBaseline: textBaseline,
      childCount: columnCount,
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignmentColumn,
        mainAxisSize: mainAxisSizeColumn,
        crossAxisAlignment: crossAxisAlignmentColumn,
        textDirection: textDirection,
        verticalDirection: verticalDirectionColumn,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

class ColumnPadding extends StatelessWidget {
  const ColumnPadding({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.childCount = 1,
    required this.padding,
    required this.child,
  });

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int childCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: List.generate(childCount, childGenerator),
    );
  }

  Widget childGenerator(int index) => Padding(padding: padding, child: child);
}

class ColumnPaddingRow extends StatelessWidget {
  const ColumnPaddingRow({
    super.key,
    this.textDirection,
    this.textBaseline,
    this.rowCount = 1,
    this.mainAxisAlignmentRow = MainAxisAlignment.center,
    this.mainAxisAlignmentColumn = MainAxisAlignment.center,
    this.mainAxisSizeRow = MainAxisSize.max,
    this.mainAxisSizeColumn = MainAxisSize.max,
    this.crossAxisAlignmentRow = CrossAxisAlignment.center,
    this.crossAxisAlignmentColumn = CrossAxisAlignment.center,
    this.verticalDirectionRow = VerticalDirection.down,
    this.verticalDirectionColumn = VerticalDirection.down,
    required this.padding,
    required this.children,
  });

  final MainAxisAlignment mainAxisAlignmentRow;
  final MainAxisAlignment mainAxisAlignmentColumn;
  final MainAxisSize mainAxisSizeRow;
  final MainAxisSize mainAxisSizeColumn;
  final CrossAxisAlignment crossAxisAlignmentRow;
  final CrossAxisAlignment crossAxisAlignmentColumn;
  final VerticalDirection verticalDirectionRow;
  final VerticalDirection verticalDirectionColumn;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int rowCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColumnPadding(
      mainAxisAlignment: mainAxisAlignmentColumn,
      mainAxisSize: mainAxisSizeColumn,
      crossAxisAlignment: crossAxisAlignmentColumn,
      textDirection: textDirection,
      verticalDirection: verticalDirectionColumn,
      textBaseline: textBaseline,
      childCount: rowCount,
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignmentRow,
        mainAxisSize: mainAxisSizeRow,
        crossAxisAlignment: crossAxisAlignmentRow,
        textDirection: textDirection,
        verticalDirection: verticalDirectionRow,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

class ColumnText extends StatelessWidget {
  const ColumnText(
    this.text, {
    super.key,
    this.interval = WSizedBox.h10,
    this.lineBuilder = none,
    this.alignment = MainAxisAlignment.center,
  });

  static Text none(String line) => Text(line);

  final String text;
  final Widget interval;
  final Text Function(String line) lineBuilder;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      children: text.split('\n').fold(
        [],
        (list, line) => list
          ..add(lineBuilder(line))
          ..add(interval),
      )..removeLast(),
    );
  }
}

class MaterialIconButton extends StatelessWidget {
  const MaterialIconButton({
    super.key,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.durationAnimation = kThemeChangeDuration,
    this.shape,
    this.styleText,
    this.styleButton,
    this.radiusBorder,
    this.colorBackground,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.radiusSplash,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.sizeIcon,
    this.colorShadow,
    this.colorSurfaceTint,
    this.colorIconButton,
    this.colorFocus,
    this.colorHover,
    this.colorHighlight,
    this.colorSplash,
    this.colorDisabled,
    this.isSelected,
    this.selectedIcon,
    required this.onPressed,
    required this.child,
  });

  final MaterialType type;
  final double elevation;
  final Color? colorBackground;
  final Color? colorShadow;
  final Color? colorSurfaceTint;
  final BorderRadius? radiusBorder;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final Duration durationAnimation;
  final double? sizeIcon;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? radiusSplash;
  final Color? colorIconButton;
  final Color? colorFocus;
  final Color? colorHover;
  final Color? colorHighlight;
  final Color? colorSplash;
  final Color? colorDisabled;
  final VoidCallback onPressed;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? styleButton;
  final TextStyle? styleText;
  final bool? isSelected;
  final Widget? selectedIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: type,
      elevation: elevation,
      color: colorBackground,
      shadowColor: colorShadow,
      surfaceTintColor: colorSurfaceTint,
      textStyle: styleText,
      borderRadius: radiusBorder,
      shape: shape,
      borderOnForeground: borderOnForeground,
      clipBehavior: clipBehavior,
      animationDuration: durationAnimation,
      child: IconButton(
        iconSize: sizeIcon,
        visualDensity: visualDensity,
        padding: padding,
        alignment: alignment,
        splashRadius: radiusSplash,
        color: colorIconButton,
        focusColor: colorFocus,
        hoverColor: colorHover,
        highlightColor: colorHighlight,
        splashColor: colorSplash,
        disabledColor: colorDisabled,
        onPressed: onPressed,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        autofocus: autofocus,
        tooltip: tooltip,
        enableFeedback: enableFeedback,
        constraints: constraints,
        style: styleButton,
        isSelected: isSelected,
        selectedIcon: selectedIcon,
        icon: child,
      ),
    );
  }
}

class MaterialInkWell extends StatelessWidget {
  const MaterialInkWell({
    super.key,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.durationAnimation = kThemeChangeDuration,
    this.excludeFromSemantics = false,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.colorBackground,
    this.colorShadow,
    this.colorSurfaceTint,
    this.styleText,
    this.radiusBorder,
    this.shape,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.colorFocus,
    this.colorHover,
    this.colorHighlight,
    this.colorOverlay,
    this.colorSplash,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback,
    this.focusNode,
    this.onFocusChange,
    this.statesController,
    this.child,
  });

  final MaterialType type;
  final double elevation;
  final Color? colorBackground;
  final Color? colorShadow;
  final Color? colorSurfaceTint;
  final TextStyle? styleText;
  final BorderRadius? radiusBorder;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final Duration durationAnimation;
  final VoidCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final MouseCursor? mouseCursor;
  final Color? colorFocus;
  final Color? colorHover;
  final Color? colorHighlight;
  final MaterialStateProperty<Color?>? colorOverlay;
  final Color? colorSplash;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool? enableFeedback;
  final bool excludeFromSemantics;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final MaterialStatesController? statesController;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: type,
      elevation: elevation,
      color: colorBackground,
      shadowColor: colorShadow,
      surfaceTintColor: colorSurfaceTint,
      textStyle: styleText,
      borderRadius: radiusBorder,
      shape: shape,
      borderOnForeground: borderOnForeground,
      clipBehavior: clipBehavior,
      animationDuration: durationAnimation,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onSecondaryTap: onSecondaryTap,
        onSecondaryTapUp: onSecondaryTapUp,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onHighlightChanged: onHighlightChanged,
        onHover: onHover,
        mouseCursor: mouseCursor,
        focusColor: colorFocus,
        hoverColor: colorHover,
        highlightColor: colorHighlight,
        overlayColor: colorOverlay,
        splashColor: colorSplash,
        splashFactory: splashFactory,
        radius: radius,
        borderRadius: borderRadius,
        customBorder: customBorder,
        enableFeedback: enableFeedback,
        excludeFromSemantics: excludeFromSemantics,
        focusNode: focusNode,
        canRequestFocus: canRequestFocus,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        statesController: statesController,
        child: child,
      ),
    );
  }
}

class MaterialInkWellPadding extends StatelessWidget {
  const MaterialInkWellPadding({
    super.key,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.durationAnimation = kThemeChangeDuration,
    this.excludeFromSemantics = false,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.colorBackground,
    this.colorShadow,
    this.colorSurfaceTint,
    this.styleText,
    this.radiusBorder,
    this.shape,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.colorFocus,
    this.colorHover,
    this.colorHighlight,
    this.colorOverlay,
    this.colorSplash,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback,
    this.focusNode,
    this.onFocusChange,
    this.statesController,
    required this.padding,
    required this.child,
  });

  final MaterialType type;
  final double elevation;
  final Color? colorBackground;
  final Color? colorShadow;
  final Color? colorSurfaceTint;
  final TextStyle? styleText;
  final BorderRadius? radiusBorder;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final Duration durationAnimation;
  final VoidCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final MouseCursor? mouseCursor;
  final Color? colorFocus;
  final Color? colorHover;
  final Color? colorHighlight;
  final MaterialStateProperty<Color?>? colorOverlay;
  final Color? colorSplash;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool? enableFeedback;
  final bool excludeFromSemantics;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final MaterialStatesController? statesController;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: type,
      elevation: elevation,
      color: colorBackground,
      shadowColor: colorShadow,
      surfaceTintColor: colorSurfaceTint,
      textStyle: styleText,
      borderRadius: radiusBorder,
      shape: shape,
      borderOnForeground: borderOnForeground,
      clipBehavior: clipBehavior,
      animationDuration: durationAnimation,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onSecondaryTap: onSecondaryTap,
        onSecondaryTapUp: onSecondaryTapUp,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onHighlightChanged: onHighlightChanged,
        onHover: onHover,
        mouseCursor: mouseCursor,
        focusColor: colorFocus,
        hoverColor: colorHover,
        highlightColor: colorHighlight,
        overlayColor: colorOverlay,
        splashColor: colorSplash,
        splashFactory: splashFactory,
        radius: radius,
        borderRadius: borderRadius,
        customBorder: customBorder,
        enableFeedback: enableFeedback,
        excludeFromSemantics: excludeFromSemantics,
        focusNode: focusNode,
        canRequestFocus: canRequestFocus,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        statesController: statesController,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class AnimatedContainerDefaultTextStyle extends StatelessWidget {
  const AnimatedContainerDefaultTextStyle({
    super.key,
    this.curve = Curves.fastOutSlowIn,
    this.duration = KDuration.second1,
    this.clipBehavior = Clip.antiAlias,
    this.textOverflow = TextOverflow.clip,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textSoftWrap = true,
    this.textHeightBehavior,
    this.textAlign,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.decorationForeground,
    this.width,
    this.height,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.onEnd,
    this.maxLines,
    required this.textStyle,
    required this.child,
  });

  final Curve curve;
  final Duration duration;
  final Clip clipBehavior;
  final TextOverflow textOverflow;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final TextAlign? textAlign;
  final bool textSoftWrap;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final Decoration? decorationForeground;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final Alignment? transformAlignment;
  final VoidCallback? onEnd;
  final int? maxLines;
  final TextStyle textStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: curve,
      duration: duration,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: decorationForeground,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: AnimatedDefaultTextStyle(
        curve: curve,
        duration: duration,
        softWrap: textSoftWrap,
        overflow: textOverflow,
        textWidthBasis: textWidthBasis,
        textAlign: textAlign,
        maxLines: maxLines,
        textHeightBehavior: textHeightBehavior,
        onEnd: onEnd,
        style: textStyle,
        // child: child,
        child: child,
      ),
    );
  }
}

class AnimatedContainerDefaultTextStyleText extends StatelessWidget {
  const AnimatedContainerDefaultTextStyleText({
    super.key,
    this.curve = Curves.fastOutSlowIn,
    this.duration = KDuration.second1,
    this.clipBehavior = Clip.antiAlias,
    this.textOverflow = TextOverflow.clip,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textSoftWrap = true,
    this.textHeightBehavior,
    this.textAlign,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.decorationForeground,
    this.width,
    this.height,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.onEnd,
    this.maxLines,
    this.strutStyle,
    this.textDirection,
    this.textScaler,
    this.locale,
    this.semanticsLabel,
    this.selectionColor,
    required this.textStyle,
    required this.child,
  });

  final Curve curve;
  final Duration duration;
  final Clip clipBehavior;
  final TextOverflow textOverflow;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final TextAlign? textAlign;
  final bool textSoftWrap;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final Decoration? decorationForeground;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final Alignment? transformAlignment;
  final VoidCallback? onEnd;
  final int? maxLines;
  final TextStyle textStyle;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final Color? selectionColor;
  final String child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: curve,
      duration: duration,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: decorationForeground,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: AnimatedDefaultTextStyle(
        curve: curve,
        duration: duration,
        softWrap: textSoftWrap,
        overflow: textOverflow,
        textWidthBasis: textWidthBasis,
        textAlign: textAlign,
        maxLines: maxLines,
        textHeightBehavior: textHeightBehavior,
        onEnd: onEnd,
        style: textStyle,
        // child: child,
        child: Text(
          child,
          strutStyle: strutStyle,
          textDirection: textDirection,
          locale: locale,
          textScaler: textScaler,
          semanticsLabel: semanticsLabel,
          selectionColor: selectionColor,
        ),
      ),
    );
  }
}
