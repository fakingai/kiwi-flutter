import 'package:kiwi/domain/entities/message_entity.dart';

/// 消息数据模型，用于处理API数据
class MessageModel extends MessageEntity {
  /// 消息模型构造函数
  const MessageModel({
    super.id,
    required super.content,
    required super.role,
    super.createdAt,
    super.sessionId,
  });

  /// 从API响应JSON创建模型实例
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString(),
      content: json['content'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      sessionId: json['session_id']?.toString(),
    );
  }

  /// 从SSE流数据创建模型实例
  factory MessageModel.fromSseEvent(Map<String, dynamic> json) {
    return MessageModel(content: json['v'] as String? ?? '', role: 'assistant');
  }

  /// 将模型转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (sessionId != null) 'session_id': sessionId,
    };
  }
}
