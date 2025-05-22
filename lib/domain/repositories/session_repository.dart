import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/session_entity.dart';

/// 会话仓库接口，定义会话相关的数据操作
abstract class SessionRepository {
  /// 获取所有会话列表
  Future<Either<Failure, List<SessionEntity>>> getSessions();

  /// 创建新会话
  Future<Either<Failure, SessionEntity>> createSession(int projectId);

  /// 获取特定会话详情
  Future<Either<Failure, SessionEntity>> getSessionById(String sessionId);
}
