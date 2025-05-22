import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 企业风格输入框组件
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final double? borderRadius;

  /// 创建一个企业风格输入框
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveBorderRadius = borderRadius ?? 8.0;

    final InputDecoration decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon:
          prefixIcon != null
              ? Icon(
                prefixIcon,
                color:
                    enabled
                        ? colorScheme.onSurfaceVariant
                        : theme.disabledColor,
              )
              : null,
      prefix: prefix,
      suffix: suffix,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
      ),
      filled: true,
      fillColor:
          enabled
              ? (colorScheme.brightness == Brightness.light
                  ? colorScheme.surface
                  : colorScheme.surfaceVariant.withOpacity(0.5))
              : (colorScheme.brightness == Brightness.light
                  ? theme.disabledColor.withOpacity(0.05)
                  : colorScheme.onSurface.withOpacity(0.05)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      helperStyle: theme.textTheme.bodySmall,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: enabled ? colorScheme.onSurfaceVariant : theme.disabledColor,
      ),
      floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: enabled ? colorScheme.primary : theme.disabledColor,
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
    );

    return TextField(
      controller: controller,
      decoration: decoration,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: enabled ? colorScheme.onSurface : theme.disabledColor,
      ),
      cursorColor: colorScheme.primary,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(1),
    );
  }
}
