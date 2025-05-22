import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiwi/domain/entities/message_entity.dart';
import 'package:kiwi/domain/entities/session_entity.dart';
import 'package:kiwi/domain/usecases/send_message_usecase.dart';
import 'package:kiwi/domain/usecases/get_messages_usecase.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/data/models/sse_event_model.dart';

/// 聊天状态枚举
enum ChatState {
  /// 初始状态
  initial,

  /// 加载中
  loading,

  /// 接收流式消息中
  streaming,

  /// 已加载完成
  loaded,

  /// 错误状态
  error,
}

/// 聊天视图模型
class ChatViewModel extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;

  /// 当前状态
  ChatState _state = ChatState.initial;
  ChatState get state => _state;

  /// 错误信息
  String? _error;
  String? get error => _error;

  /// 消息列表
  final List<MessageEntity> _messages = [];
  List<MessageEntity> get messages => List.unmodifiable(_messages);

  /// 当前会话
  SessionEntity? _currentSession;
  SessionEntity? get currentSession => _currentSession;

  /// 流式接收的当前消息（正在生成中）
  String _streamingContent = '';

  /// 消息流订阅
  StreamSubscription? _messageSubscription;

  /// 构造函数
  ChatViewModel({
    required SendMessageUseCase sendMessageUseCase,
    required GetMessagesUseCase getMessagesUseCase,
  }) : _sendMessageUseCase = sendMessageUseCase,
       _getMessagesUseCase = getMessagesUseCase;

  /// 准备新的聊天界面
  void startNewChat() {
    AppLogger.info('ChatViewModel: 准备新聊天界面');

    // 清空当前会话（会在发送消息时由服务端创建）
    _currentSession = null;
    // 清空消息列表
    _messages.clear();
    _streamingContent = '';
    _state = ChatState.loaded;
    _error = null;

    notifyListeners();
  }

  /// 切换到指定会话
  Future<void> selectSession(SessionEntity session) async {
    _currentSession = session;
    // 清空当前消息
    _messages.clear();
    _streamingContent = '';

    _state = ChatState.loading;
    notifyListeners();

    // 从后端加载该会话的历史消息
    await loadMessages(sessionKey: session.sessionKey);

    AppLogger.info('ChatViewModel: 切换到会话 - ${session.sessionKey}');
  }

  /// 加载指定会话的历史消息
  Future<void> loadMessages({
    required String sessionKey,
    int? limit,
    int? msgPosition,
    String? scroll,
  }) async {
    AppLogger.info('ChatViewModel: 加载会话消息 (会话Key: $sessionKey)');

    try {
      final result = await _getMessagesUseCase(
        sessionKey: sessionKey,
        limit: limit,
        msgPosition: msgPosition,
        scroll: scroll,
      );

      result.fold(
        (failure) {
          _state = ChatState.error;
          _error = failure.message;
          AppLogger.error('ChatViewModel: 加载消息失败 - ${failure.message}');
        },
        (messages) {
          _messages.clear();
          _messages.addAll(messages);
          _state = ChatState.loaded;
          AppLogger.info('ChatViewModel: 成功加载 ${messages.length} 条消息');
        },
      );
    } catch (e) {
      _state = ChatState.error;
      _error = '加载消息失败: $e';
      AppLogger.error('ChatViewModel: 加载消息异常 - $e');
    }

    notifyListeners();
  }

  /// 发送消息
  Future<void> sendMessage(int projectId, String content) async {
    AppLogger.info('ChatViewModel: 发送消息 - "$content"');

    // 添加用户消息到列表
    final userMessage = MessageEntity(
      content: content,
      role: 'user',
      createdAt: DateTime.now(),
    );
    _messages.add(userMessage);

    // 更新状态为流式接收中
    _state = ChatState.streaming;
    _error = null;
    _streamingContent = '';
    notifyListeners();

    // 取消之前的订阅（如果有）
    await _messageSubscription?.cancel();

    // 创建临时Message来存储流式内容
    final tempAssistantMessage = MessageEntity(
      content: '',
      role: 'assistant',
      createdAt: DateTime.now(),
    );
    _messages.add(tempAssistantMessage);

    try {
      // 直接监听SSE事件流
      final eventStream = _sendMessageUseCase(
        content: content,
        projectId: projectId,
        sessionKey: _currentSession?.sessionKey,
      );

      _messageSubscription = eventStream.listen(
        (event) {
          // 只处理event为message且为SSEMessageData类型的帧，拼接内容
          if (event.event == SSEEventType.message &&
              event.data is SSEMessageData) {
            final v = (event.data as SSEMessageData).v;
            _streamingContent += v;
            if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
              _messages.last = MessageEntity(
                content: _streamingContent,
                role: 'assistant',
                createdAt: DateTime.now(),
              );
            }
            notifyListeners();
          }
          // 处理新会话事件
          if (event.data is SSESessionData) {
            final sessionData = event.data as SSESessionData;
            _pendingSessionKey = sessionData.sessionKey;
          }
        },
        onDone: () async {
          AppLogger.info('ChatViewModel: 消息流接收完成');
          _state = ChatState.loaded;
          // 通知 Sidebar 刷新并选中新会话
          if (_pendingSessionKey != null) {
            await notifySidebarRefreshAndSelect(_pendingSessionKey!);
            _pendingSessionKey = null;
          }
          notifyListeners();
          _messageSubscription = null;
        },
        onError: (e) {
          _state = ChatState.error;
          _error = '接收消息失败: $e';
          if (_messages.isNotEmpty &&
              _messages.last.role == 'assistant' &&
              _messages.last.content.isEmpty) {
            _messages.removeLast();
          }
          notifyListeners();
          AppLogger.error('ChatViewModel: 发送消息失败 - $e');
        },
        cancelOnError: true,
      );
    } catch (e) {
      _state = ChatState.error;
      _error = '发送消息异常: $e';
      if (_messages.isNotEmpty &&
          _messages.last.role == 'assistant' &&
          _messages.last.content.isEmpty) {
        _messages.removeLast();
      }
      notifyListeners();
      AppLogger.error('ChatViewModel: 发送消息异常 - $e');
    }
  }

  /// 通知 Sidebar(SessionViewModel) 刷新会话并选中指定 session
  Future<void> notifySidebarRefreshAndSelect(String sessionKey) async {
    // 通过全局事件或回调解耦 ChatViewModel 与 SessionViewModel
    _onSidebarRefreshAndSelect?.call(sessionKey);
  }

  /// 由外部（如 SidebarWidget）注册的刷新回调
  void setSidebarRefreshCallback(
    Future<void> Function(String sessionKey) callback,
  ) {
    _onSidebarRefreshAndSelect = callback;
  }

  /// 清空消息
  void clearMessages() {
    _messages.clear();
    _streamingContent = '';
    notifyListeners();
    AppLogger.info('ChatViewModel: 清空消息');
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  String? _pendingSessionKey;
  Future<void> Function(String sessionKey)? _onSidebarRefreshAndSelect;
}
