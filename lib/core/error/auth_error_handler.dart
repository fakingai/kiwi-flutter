import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiwi/core/error/api_exception.dart';
import 'package:kiwi/core/navigation/app_routes.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/core/utils/toast_util.dart';
import 'package:kiwi/core/utils/auth_utils.dart';

/// 认证错误处理器
/// 用于统一处理认证相关错误，如登录过期等
class AuthErrorHandler {
  static final AuthErrorHandler _instance = AuthErrorHandler._internal();

  /// 私有构造函数
  AuthErrorHandler._internal();

  /// 获取单例
  factory AuthErrorHandler() {
    return _instance;
  }

  /// 全局 NavigatorKey，用于在任何地方直接获取 navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 处理认证错误
  Future<void> handleAuthError(
    BuildContext? context,
    ApiException exception,
  ) async {
    // 记录错误日志
    AppLogger.error('认证错误', exception, StackTrace.current);

    // 如果不是认证错误，则不处理
    if (!exception.isAuthError) {
      return;
    }

    // 获取上下文，优先使用传入的 context，如果没有则使用 navigatorKey
    if (context != null && context.mounted) {
      // 使用 AuthUtils 中的函数处理登录过期
      AuthUtils.handleSessionExpired(context);
    } else {
      // 如果没有可用的上下文，则使用全局 navigatorKey
      BuildContext? globalContext = navigatorKey.currentContext;
      if (globalContext != null) {
        // 使用 AuthUtils 中的函数处理登录过期
        AuthUtils.handleSessionExpired(globalContext);
      } else {
        // 如果没有可用的上下文，则只显示 Toast
        ToastUtil.showWarning('登录过期，请重新登录');
        AppLogger.error('无法获取上下文，无法跳转到登录页面', null, StackTrace.current);

        // 尝试使用 navigatorKey 跳转
        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          await Future.delayed(const Duration(seconds: 2));
          if (navigator.mounted) {
            navigator.pushReplacementNamed(AppRoutes.login);
          }
        }
      }
    }
  }
}
