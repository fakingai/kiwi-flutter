import 'package:flutter/material.dart';

/// 企业风格卡片组件
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double borderRadius;
  final BorderSide? borderSide;
  final VoidCallback? onTap;
  final bool isSelectable;
  final bool isSelected;

  /// 创建一个企业风格卡片
  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 1.0,
    this.borderRadius = 12.0,
    this.borderSide,
    this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 确定实际背景色
    final Color effectiveBackgroundColor =
        backgroundColor ??
        (isSelected
            ? colorScheme.primaryContainer
            : theme.cardTheme.color ?? colorScheme.surface);

    // 确定实际边框
    final BorderSide effectiveBorderSide =
        borderSide ??
        (isSelected
            ? BorderSide(color: colorScheme.primary, width: 1.5)
            : theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).side
            : BorderSide(color: colorScheme.outline, width: 0.5));

    final Widget cardContent = Padding(padding: padding, child: child);

    final card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: effectiveBorderSide,
      ),
      color: effectiveBackgroundColor,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );

    if (onTap != null || isSelectable) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: colorScheme.primary.withOpacity(0.1),
          hoverColor: colorScheme.primary.withOpacity(0.05),
          highlightColor: colorScheme.primary.withOpacity(0.1),
          child: card,
        ),
      );
    } else {
      return card;
    }
  }
}
