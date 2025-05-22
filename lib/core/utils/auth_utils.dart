import 'package:flutter/material.dart';
import 'package:kiwi/core/navigation/app_routes.dart';
import 'package:kiwi/core/utils/toast_util.dart';

/// 认证相关的工具函数
class AuthUtils {
  /// 处理登录过期的函数，可以在任何地方调用
  static void handleSessionExpired(BuildContext context) {
    // 显示登录过期提示
    ToastUtil.showWarning("登录过期，请重新登录");

    // 延迟2秒后跳转到登录页面
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }
}
