import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'core/navigation/app_router.dart';
import 'core/di/di.dart';
import 'app/viewmodels/auth_viewmodel.dart';
import 'app/viewmodels/main_viewmodel.dart'; // Import MainViewModel
import 'package:kiwi/core/utils/logger.dart'; // 导入日志记录器
import 'package:kiwi/core/error/auth_error_handler.dart'; // 导入认证错误处理器
import 'package:kiwi/core/error/api_exception.dart'; // 导入API异常

Future<void> main() async {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志记录器
  await AppLogger.init();

  await setupDependencies(); // 设置依赖注入 //确保依赖注入完成

  // 全局捕获未处理的异常
  runZonedGuarded<Future<void>>(
    () async {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      // 如果是API认证异常，则特殊处理
      if (error is ApiException && error.isAuthError) {
        // 使用 AuthErrorHandler 处理认证错误
        AuthErrorHandler().handleAuthError(null, error);
      } else {
        // 其他未处理异常，记录到日志
        AppLogger.error('Unhandled exception', error, stackTrace);
      }
    },
  );

  // 捕获 Flutter 框架本身的错误
  FlutterError.onError = (FlutterErrorDetails details) {
    // 如果是API认证异常，则特殊处理
    if (details.exception is ApiException &&
        (details.exception as ApiException).isAuthError) {
      // 使用 AuthErrorHandler 处理认证错误
      AuthErrorHandler().handleAuthError(
        null,
        details.exception as ApiException,
      );
    } else {
      // 其他 Flutter 框架错误，记录到日志
      AppLogger.error(
        'Flutter framework error',
        details.exception,
        details.stack,
      );
    }
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthViewModel>()),
        ChangeNotifierProvider(
          create: (_) => sl<MainViewModel>(),
        ), // Add MainViewModel to providers
      ],
      child: MaterialApp(
        title: 'RAG PRO',
        theme: lightTheme, // 明亮主题
        darkTheme: darkTheme, // 暗黑主题
        themeMode: ThemeMode.system, // 跟随系统
        navigatorKey: AuthErrorHandler().navigatorKey, // 使用全局 Navigator Key
        onGenerateRoute: AppRouter.generateRoute,
        // Set initialRoute to '/' which should lead to MainPage
        // MainPage will then handle redirection to LoginPage if not authenticated.
        initialRoute: '/',
        // home: const LoginPage(), // Remove direct home to LoginPage
      ),
    );
  }
}
