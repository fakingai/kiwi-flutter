import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/api_exception.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/data/datasources/remote/message_remote_datasource.dart';
import 'package:kiwi/data/models/sse_event_model.dart';
import 'package:kiwi/domain/entities/message_entity.dart';
import 'package:kiwi/domain/entities/session_entity.dart';
import 'package:kiwi/domain/repositories/message_repository.dart';

/// 消息仓库实现
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  /// 构造函数
  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<SSEEventModel> sendMessage({
    required String content,
    required int projectId,
    String? sessionKey,
  }) async* {
    AppLogger.info('MessageRepository: 发送消息到项目 $projectId');
    try {
      final eventStream = remoteDataSource.sendMessage(
        content: content,
        projectId: projectId,
        sessionKey: sessionKey,
      );
      await for (final event in eventStream) {
        yield event;
      }
    } on ApiException catch (e) {
      AppLogger.error('MessageRepository: API错误 - ${e.message}');
      rethrow;
    } catch (e) {
      AppLogger.error('MessageRepository: 未知错误 - $e');
      rethrow;
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> createSession(int projectId) async {
    AppLogger.info('MessageRepository: 创建会话 (项目ID: $projectId)');
    try {
      final session = await remoteDataSource.createSession(projectId);
      return Right(session);
    } on ApiException catch (e) {
      AppLogger.error('MessageRepository: API错误 - ${e.message}');
      return Left(Failure(message: e.message ?? '创建会话失败'));
    } catch (e) {
      AppLogger.error('MessageRepository: 未知错误 - $e');
      return Left(Failure(message: '创建会话失败: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SessionEntity>>> getSessions({
    int? projectId,
  }) async {
    AppLogger.info(
      'MessageRepository: 获取会话列表${projectId != null ? ' (项目ID: $projectId)' : ''}',
    );
    try {
      final sessions = await remoteDataSource.getSessions(projectId: projectId);
      return Right(sessions);
    } on ApiException catch (e) {
      AppLogger.error('MessageRepository: API错误 - ${e.message}');
      return Left(Failure(message: e.message ?? '获取会话列表失败'));
    } catch (e) {
      AppLogger.error('MessageRepository: 未知错误 - $e');
      return Left(Failure(message: '获取会话列表失败: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  }) async {
    AppLogger.info('MessageRepository: 获取会话消息列表 (会话Key: $sessionKey)');
    try {
      final messages = await remoteDataSource.getMessages(
        sessionKey: sessionKey,
        limit: limit,
        msgPosition: msgPosition,
        scroll: scroll,
      );
      return Right(messages);
    } on ApiException catch (e) {
      AppLogger.error('MessageRepository: API错误 - ${e.message}');
      return Left(Failure(message: e.message ?? '获取会话消息列表失败'));
    } catch (e) {
      AppLogger.error('MessageRepository: 未知错误 - $e');
      return Left(Failure(message: '获取会话消息列表失败: $e'));
    }
  }
}
