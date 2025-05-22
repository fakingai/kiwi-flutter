import 'dart:convert';

import 'package:kiwi/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_local_datasource.dart';

/// 本地认证数据源实现
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      cachedUserKey,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserModel?> getLastUser() {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(jsonString));
    }
    return Future.value(null);
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(cachedUserKey);
  }
}
