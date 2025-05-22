import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// 屏幕工具类
/// 提供跨平台的屏幕尺寸适配功能
class ScreenUtils {
  /// 基准设计尺寸宽度
  static const double designWidth = 375.0;

  /// 基准设计尺寸高度
  static const double designHeight = 812.0;

  /// 获取缩放比例
  static double getScaleFactor(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final double width = size.width;

    // 移动设备使用宽度适配
    if (_isMobileDevice()) {
      return width / designWidth;
    }

    // Web和桌面平台适配 - 通常桌面平台不需要很大的缩放
    if (width < 600) {
      return width / designWidth;
    } else if (width < 1200) {
      return 1.1; // 平板尺寸
    } else {
      return 1.2; // 大屏幕
    }
  }

  /// 响应式尺寸计算
  static double adaptiveSize(BuildContext context, double size) {
    return size * getScaleFactor(context);
  }

  /// 响应式内边距计算
  static EdgeInsets adaptivePadding(
    BuildContext context, {
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    final double factor = getScaleFactor(context);
    return EdgeInsets.symmetric(
      horizontal: horizontal * factor,
      vertical: vertical * factor,
    );
  }

  /// 响应式宽度
  static double adaptiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// 是否为移动设备
  static bool _isMobileDevice() {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// 是否为桌面设备
  static bool isDesktopDevice() {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// 是否为Web平台
  static bool isWebPlatform() {
    return kIsWeb;
  }

  /// 获取当前设备类型描述
  static String getDeviceTypeDescription() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
