import 'package:kiwi/data/models/user_model.dart';

/// 本地认证数据源接口
abstract class AuthLocalDataSource {
  /// 缓存用户数据
  Future<void> cacheUser(UserModel userToCache);

  /// 获取缓存的用户数据
  Future<UserModel?> getLastUser();

  /// 清除缓存的用户数据
  Future<void> clearUser();
}
