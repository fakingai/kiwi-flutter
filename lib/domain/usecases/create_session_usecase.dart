import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/session_entity.dart';
import 'package:kiwi/domain/repositories/message_repository.dart';

/// 创建会话用例
class CreateSessionUseCase {
  final MessageRepository repository;

  /// 构造函数
  CreateSessionUseCase(this.repository);

  /// 执行用例，创建新会话
  Future<Either<Failure, SessionEntity>> call(int projectId) {
    return repository.createSession(projectId);
  }
}
