import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/session_entity.dart';
import 'package:kiwi/domain/repositories/message_repository.dart';

/// 获取会话列表用例
class GetSessionsUseCase {
  final MessageRepository repository;

  /// 构造函数
  GetSessionsUseCase(this.repository);

  /// 执行用例，获取会话列表
  Future<Either<Failure, List<SessionEntity>>> call({int? projectId}) {
    return repository.getSessions(projectId: projectId);
  }
}
