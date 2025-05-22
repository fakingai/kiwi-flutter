import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/message_entity.dart';
import 'package:kiwi/domain/repositories/message_repository.dart';

/// 获取会话消息列表用例
class GetMessagesUseCase {
  final MessageRepository repository;

  /// 构造函数
  GetMessagesUseCase(this.repository);

  /// 执行用例，获取指定会话的消息列表
  ///
  /// [sessionKey] 会话唯一标识
  /// [limit] 可选，返回条数限制
  /// [msgPosition] 可选，滚动参考消息位置序号
  /// [scroll] 可选，滚动方向（before或after）
  Future<Either<Failure, List<MessageEntity>>> call({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  }) {
    return repository.getMessages(
      sessionKey: sessionKey,
      limit: limit,
      msgPosition: msgPosition,
      scroll: scroll,
    );
  }
}
