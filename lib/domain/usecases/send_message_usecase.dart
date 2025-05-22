import 'dart:async';
import 'package:kiwi/domain/repositories/message_repository.dart';
import 'package:kiwi/data/models/sse_event_model.dart';

/// 发送消息用例
class SendMessageUseCase {
  final MessageRepository repository;

  /// 构造函数
  SendMessageUseCase(this.repository);

  /// 执行用例，发送消息并获取SSE事件流
  Stream<SSEEventModel> call({
    required String content,
    required int projectId,
    String? sessionKey,
  }) {
    return repository.sendMessage(
      content: content,
      projectId: projectId,
      sessionKey: sessionKey,
    );
  }
}
