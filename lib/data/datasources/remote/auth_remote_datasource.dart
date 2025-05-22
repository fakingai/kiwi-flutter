import '../../models/user_model.dart';

/// 远程认证数据源接口
abstract class AuthRemoteDataSource {
  /// 登录
  Future<UserModel> login(String email, String password);

  /// 注册
  Future<UserModel> register(String email, String password);
}
