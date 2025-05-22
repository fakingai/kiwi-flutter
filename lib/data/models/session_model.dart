import 'package:kiwi/domain/entities/session_entity.dart';

/// 会话数据模型，用于处理API数据
class SessionModel extends SessionEntity {
  /// 会话模型构造函数
  const SessionModel({
    super.sessionName,
    required super.createdAt,
    required super.updatedAt,
    required super.sessionKey,
    super.projectId,
  });

  /// 从API响应JSON创建模型实例
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionName: json['session_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sessionKey: json['session_key'] as String,
      projectId: json['project_id'] as int?,
    );
  }

  /// 将模型转换为JSON
  Map<String, dynamic> toJson() {
    return {
      if (sessionName != null) 'session_name': sessionName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'session_key': sessionKey,
      if (projectId != null) 'project_id': projectId,
    };
  }
}
