import 'package:flutter/material.dart';

/// 企业风格按钮组件
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final IconData? iconData;
  final bool showIconOnly;
  final bool isFullWidth;
  final bool isSmall;

  /// 创建一个企业风格按钮
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 8.0,
    this.iconData,
    this.showIconOnly = false,
    this.isFullWidth = false,
    this.isSmall = false,
  });

  /// 创建一个主要风格按钮
  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double borderRadius = 8.0,
    IconData? iconData,
    bool showIconOnly = false,
    bool isFullWidth = false,
    bool isSmall = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.primary,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      iconData: iconData,
      showIconOnly: showIconOnly,
      isFullWidth: isFullWidth,
      isSmall: isSmall,
    );
  }

  /// 创建一个次要风格按钮
  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double borderRadius = 8.0,
    IconData? iconData,
    bool showIconOnly = false,
    bool isFullWidth = false,
    bool isSmall = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.secondary,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      iconData: iconData,
      showIconOnly: showIconOnly,
      isFullWidth: isFullWidth,
      isSmall: isSmall,
    );
  }

  /// 创建一个文本风格按钮
  factory AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double borderRadius = 8.0,
    IconData? iconData,
    bool showIconOnly = false,
    bool isFullWidth = false,
    bool isSmall = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.text,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      iconData: iconData,
      showIconOnly: showIconOnly,
      isFullWidth: isFullWidth,
      isSmall: isSmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Widget buttonContent = _buildButtonContent(context);

    final Size defaultSize = isSmall ? const Size(0, 36) : const Size(0, 44);

    final EdgeInsetsGeometry defaultPadding =
        isSmall
            ? const EdgeInsets.symmetric(horizontal: 12)
            : const EdgeInsets.symmetric(horizontal: 16);

    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: defaultSize,
              padding: padding ?? defaultPadding,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.primary.withOpacity(0.4),
              disabledForegroundColor: colorScheme.onPrimary.withOpacity(0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black.withOpacity(0.1);
                }
                if (states.contains(MaterialState.hovered)) {
                  return Colors.black.withOpacity(0.05);
                }
                return Colors.transparent;
              }),
            ),
            child: buttonContent,
          ),
        );
      case ButtonType.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: defaultSize,
              padding: padding ?? defaultPadding,
              foregroundColor: colorScheme.primary,
              backgroundColor: Colors.transparent,
              side: BorderSide(color: colorScheme.primary),
              disabledForegroundColor: colorScheme.primary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.primary.withOpacity(0.1);
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.primary.withOpacity(0.05);
                }
                return Colors.transparent;
              }),
            ),
            child: buttonContent,
          ),
        );
      case ButtonType.text:
        return SizedBox(
          width: isFullWidth ? double.infinity : width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              minimumSize: defaultSize,
              padding: padding ?? defaultPadding,
              foregroundColor: colorScheme.primary,
              backgroundColor: Colors.transparent,
              disabledForegroundColor: colorScheme.primary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorScheme.primary.withOpacity(0.1);
                }
                if (states.contains(MaterialState.hovered)) {
                  return colorScheme.primary.withOpacity(0.05);
                }
                return Colors.transparent;
              }),
            ),
            child: buttonContent,
          ),
        );
    }
  }

  Widget _buildButtonContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary
                ? colorScheme.onPrimary
                : colorScheme.primary,
          ),
        ),
      );
    }

    final TextStyle textStyle =
        isSmall ? theme.textTheme.labelMedium! : theme.textTheme.labelLarge!;

    if (showIconOnly && iconData != null) {
      return Icon(
        iconData,
        size: isSmall ? 16 : 18,
        color:
            type == ButtonType.primary
                ? colorScheme.onPrimary
                : colorScheme.primary,
      );
    }

    if (iconData != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: isSmall ? 16 : 18,
            color:
                type == ButtonType.primary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle, textAlign: TextAlign.center);
  }
}

/// 按钮类型枚举
enum ButtonType {
  /// 主要按钮
  primary,

  /// 次要按钮
  secondary,

  /// 文本按钮
  text,
}
