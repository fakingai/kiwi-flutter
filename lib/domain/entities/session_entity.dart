import 'package:equatable/equatable.dart';

/// 会话实体，表示一个对话会话
class SessionEntity extends Equatable {
  /// 会话标题
  final String? sessionName;

  /// 会话创建时间
  final DateTime createdAt;

  /// 会话更新时间
  final DateTime updatedAt;

  ///会话唯一标识，用于持续对话
  final String sessionKey;

  /// 会话关联的项目ID
  final int? projectId;

  /// 会话实体构造函数
  const SessionEntity({
    this.sessionName,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionKey,
    this.projectId,
  });

  @override
  List<Object?> get props => [sessionKey, projectId];
}
