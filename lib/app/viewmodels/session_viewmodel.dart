import 'package:flutter/material.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/domain/entities/session_entity.dart';
import 'package:kiwi/domain/usecases/get_sessions_usecase.dart';

/// 会话视图模型，管理会话相关状态
class SessionViewModel extends ChangeNotifier {
  final GetSessionsUseCase _getSessionsUseCase;

  /// 所有会话列表
  List<SessionEntity> _sessions = [];
  List<SessionEntity> get sessions => _sessions;

  /// 当前选中的会话ID
  String? _selectedSessionId;
  String? get selectedSessionId => _selectedSessionId;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 构造函数
  SessionViewModel({required GetSessionsUseCase getSessionsUseCase})
    : _getSessionsUseCase = getSessionsUseCase;

  /// 加载会话列表
  Future<void> loadSessions({int? projectId}) async {
    AppLogger.info('SessionViewModel: 加载会话列表');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getSessionsUseCase(projectId: projectId);

    result.fold(
      (failure) {
        AppLogger.error('SessionViewModel: 加载会话失败 - ${failure.message}');
        _errorMessage = failure.message;
        _sessions = [];
      },
      (sessions) {
        AppLogger.info('SessionViewModel: 成功加载 ${sessions.length} 个会话');
        _sessions = sessions;
        // 如果列表为空，清空选中会话
        if (_sessions.isEmpty) {
          _selectedSessionId = null;
        }
        // 不再自动选中第一个会话
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// 选择会话
  void selectSession(String sessionId) {
    if (_selectedSessionId != sessionId) {
      _selectedSessionId = sessionId;
      notifyListeners();
      AppLogger.info('SessionViewModel: 选择会话 $sessionId');

      // 通知聊天视图模型加载该会话的消息
      _notifyChatViewModelToLoadMessages(sessionId);
    }
  }

  /// 清除当前选中的会话
  void clearSelectedSession() {
    if (_selectedSessionId != null) {
      _selectedSessionId = null;
      notifyListeners();
      AppLogger.info('SessionViewModel: 清除选中会话');
    }
  }

  /// 通知聊天视图模型加载指定会话的消息
  void _notifyChatViewModelToLoadMessages(String sessionKey) {
    // 此处可以使用全局的状态管理、事件总线或直接获取ChatViewModel实例
    // 实际代码取决于项目中视图模型间通信方式
    // 这里以一个建议实现为例:

    // 方式1: 如果使用GetIt可以直接获取ChatViewModel实例
    // final chatViewModel = sl<ChatViewModel>();
    // chatViewModel.loadMessages(sessionKey: sessionKey);

    // 方式2: 如果使用Provider，可以在UI层观察SessionViewModel变化后调用ChatViewModel

    // 方式3: 可以定义一个通知回调
    if (_onSessionSelected != null) {
      _onSessionSelected!(sessionKey);
    }
  }

  /// 会话选择回调
  Function(String sessionKey)? _onSessionSelected;

  /// 设置会话选择监听器
  set onSessionSelected(Function(String sessionKey) callback) {
    _onSessionSelected = callback;
  }

  /// 获取选中的会话
  SessionEntity? get selectedSession {
    if (_selectedSessionId == null) return null;
    try {
      return _sessions.firstWhere(
        (session) => session.sessionKey == _selectedSessionId,
      );
    } catch (e) {
      return null;
    }
  }
}
