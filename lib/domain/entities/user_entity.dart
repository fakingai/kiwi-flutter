/// 用户实体
class UserEntity {
  /// 用户 ID
  final String id;

  /// 用户邮箱
  final String email;

  /// 用户认证 Token
  final String token;

  UserEntity({required this.id, required this.email, required this.token});
}
