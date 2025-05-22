import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/data/models/sse_event_model.dart';
import 'package:kiwi/domain/entities/message_entity.dart';
import 'package:kiwi/domain/entities/session_entity.dart';

/// 消息仓库接口
abstract class MessageRepository {
  /// 发送消息并获取SSE事件流
  ///
  /// [content] 消息内容
  /// [projectId] 项目ID
  /// [sessionKey] 可选的会话Key
  Stream<SSEEventModel> sendMessage({
    required String content,
    required int projectId,
    String? sessionKey,
  });

  /// 创建新会话
  ///
  /// [projectId] 项目ID
  Future<Either<Failure, SessionEntity>> createSession(int projectId);

  /// 获取会话列表
  ///
  /// [projectId] 可选的项目ID，如果提供则只返回该项目的会话
  Future<Either<Failure, List<SessionEntity>>> getSessions({int? projectId});

  /// 获取指定会话的消息列表
  ///
  /// [sessionKey] 会话唯一标识
  /// [limit] 可选，返回条数限制
  /// [msgPosition] 可选，滚动参考消息位置序号
  /// [scroll] 可选，滚动方向（before或after）
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  });
}
