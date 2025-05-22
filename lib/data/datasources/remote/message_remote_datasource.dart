import 'dart:async';
import 'package:dio/dio.dart';
import 'package:kiwi/data/models/message_model.dart';
import 'package:kiwi/data/models/session_model.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'dart:convert';
import 'package:kiwi/data/models/sse_event_model.dart';

/// 消息远程数据源接口
abstract class MessageRemoteDataSource {
  /// 发送消息并获取流式响应
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
  Future<SessionModel> createSession(int projectId);

  /// 获取会话列表
  ///
  /// [projectId] 可选的项目ID
  Future<List<SessionModel>> getSessions({int? projectId});

  /// 获取指定会话的消息列表
  ///
  /// [sessionKey] 会话唯一标识
  /// [limit] 可选，返回条数限制
  /// [msgPosition] 可选，滚动参考消息位置序号
  /// [scroll] 可选，滚动方向（before或after）
  Future<List<MessageModel>> getMessages({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  });
}

/// 消息远程数据源实现
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final Dio dio;

  /// 构造函数
  MessageRemoteDataSourceImpl({required this.dio});

  @override
  Stream<SSEEventModel> sendMessage({
    required String content,
    required int projectId,
    String? sessionKey,
  }) async* {
    AppLogger.info('MessageRemoteDataSource: 发送消息到项目 $projectId');

    try {
      // 构建请求消息体
      final requestBody = {
        'project_id': projectId,
        'session_key': sessionKey,
        'content': content,
      };

      // 设置选项用于接收SSE流数据
      final options = Options(
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream'},
      );

      // 发送POST请求并获取流响应
      final response = await dio.post(
        '/api/messages',
        data: requestBody,
        options: options,
      );

      // 处理SSE流数据
      final responseStream = response.data.stream as Stream<List<int>>;
      var buffer = '';

      await for (final chunk in responseStream) {
        buffer += utf8.decode(chunk);

        // 按SSE格式处理数据
        final events = buffer.split('\n\n');
        buffer = events.removeLast(); // 保留最后一个可能不完整的事件

        for (final event in events) {
          if (event.trim().isEmpty) continue;

          // 解析SSE事件
          final lines = event.split('\n');
          String? id;
          String? eventType;
          String? data;

          for (final line in lines) {
            if (line.startsWith('id:')) {
              id = line.substring(3).trim();
            } else if (line.startsWith('event:')) {
              eventType = line.substring(6).trim();
            } else if (line.startsWith('data:')) {
              data = line.substring(5).trim();
            }
          }

          // 处理SSE事件，直接yield SSEEventModel
          yield SSEEventModel.fromSseEvent(
            id: id,
            event: eventType,
            data: data,
          );

          // 处理结束事件
          if (eventType == 'done' && id == 'done') {
            AppLogger.info('MessageRemoteDataSource: 消息流接收完成');
            break;
          }
        }
      }
    } catch (e) {
      AppLogger.error('MessageRemoteDataSource: 发送消息错误 - $e');
      throw Exception('发送消息失败: $e');
    }
  }

  @override
  Future<SessionModel> createSession(int projectId) async {
    AppLogger.info('MessageRemoteDataSource: 创建会话 (项目ID: $projectId)');
    try {
      final response = await dio.post(
        '/api/sessions',
        data: {'project_id': projectId},
      );
      return SessionModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('MessageRemoteDataSource: 创建会话失败 - $e');
      throw Exception('创建会话失败: $e');
    }
  }

  @override
  Future<List<SessionModel>> getSessions({int? projectId}) async {
    AppLogger.info(
      'MessageRemoteDataSource: 获取会话列表${projectId != null ? ' (项目ID: $projectId)' : ''}',
    );
    try {
      // 添加查询参数（如果有）
      Map<String, dynamic>? queryParameters;
      if (projectId != null) {
        queryParameters = {'project_id': projectId};
      }

      final response = await dio.get(
        '/api/sessions',
        queryParameters: queryParameters,
      );

      final List<dynamic> sessionsData = response.data['data'] as List<dynamic>;
      return sessionsData
          .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('MessageRemoteDataSource: 获取会话列表失败 - $e');
      throw Exception('获取会话列表失败: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  }) async {
    AppLogger.info('MessageRemoteDataSource: 获取会话消息列表 (会话Key: $sessionKey)');

    // 构建查询参数
    final Map<String, dynamic> queryParams = {'session_key': sessionKey};

    // 添加可选参数
    if (limit != null) queryParams['limit'] = limit;
    if (msgPosition != null) queryParams['msg_position'] = msgPosition;
    if (scroll != null) queryParams['scroll'] = scroll;

    // 发送GET请求获取会话消息列表
    final response = await dio.get(
      '/api/messages',
      queryParameters: queryParams,
    );

    // 处理响应
    final responseData = response.data;
    final List<dynamic> messagesData = responseData['data'];
    return messagesData
        .map(
          (messageData) => MessageModel.fromJson({
            'id': messageData['id'].toString(),
            'content': messageData['content'] as String,
            'role': messageData['message_type'] as String,
            'created_at': messageData['created_at'],
            'status': messageData['status'],
          }),
        )
        .toList();
  }
}
