import 'dart:convert';

import '../../domain/entities/user_entity.dart';

/// 用户数据模型
class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, required super.token});

  factory UserModel.fromApi(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] as String,
      email: json['user']['email'] as String,
      token: json['token'] as String? ?? '',
    );
  }

  /// 从 JSON 解析
  factory UserModel.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return UserModel(
      id: data['id'] as String,
      email: data['email'] as String,
      token: data['token'] as String? ?? '',
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }
}
