import 'package:kiwi/data/models/sse_event_model.dart';
import 'package:kiwi/domain/entities/message_entity.dart';

/// 工具类：将SSEEventModel转换为MessageEntity（仅当event/data为消息内容时）
class SSEEventToMessageEntity {
  /// 尝试从SSE事件中提取消息内容，返回MessageEntity或null
  static MessageEntity? tryConvert(SSEEventModel event) {
    if (event.event == 'message' && event.data is SSEMessageData) {
      final v = (event.data as SSEMessageData).v;
      return MessageEntity(
        content: v,
        role: 'assistant',
        createdAt: DateTime.now(),
      );
    }
    return null;
  }
}
