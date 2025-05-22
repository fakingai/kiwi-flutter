// filepath: lib/core/network/auth_interceptor.dart
// JWT 认证拦截器：仅对 /api 开头的请求自动加上 Authorization: Bearer [usertoken]
// usertoken 从 SharedPreferences 获取

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiwi/core/di/di.dart';
import 'package:kiwi/data/models/user_model.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.startsWith('/api')) {
      final prefs = sl<SharedPreferences>();
      final cachedUserJson = prefs.getString('CACHED_USER');
      if (cachedUserJson != null && cachedUserJson.isNotEmpty) {
        final user = UserModel.fromJson(cachedUserJson);
        final token = user.token;
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    }
    handler.next(options);
  }
}
