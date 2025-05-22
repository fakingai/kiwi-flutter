import 'package:equatable/equatable.dart';

/// 消息实体，表示对话中的一条消息
class MessageEntity extends Equatable {
  /// 消息唯一标识
  final String? id;

  /// 消息内容
  final String content;

  /// 消息发送者类型（user: 用户, assistant: AI助手）
  final String role;

  /// 消息创建时间
  final DateTime? createdAt;

  /// 消息所属的会话ID
  final String? sessionId;

  /// 消息实体构造函数
  const MessageEntity({
    this.id,
    required this.content,
    required this.role,
    this.createdAt,
    this.sessionId,
  });

  @override
  List<Object?> get props => [id, content, role, createdAt, sessionId];
}
