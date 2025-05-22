import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/app/viewmodels/session_viewmodel.dart';
import 'package:kiwi/app/viewmodels/chat_viewmodel.dart';

/// Chat视图与Session视图连接桥接组件
/// 用于监听会话选择并加载消息历史
class ChatSessionBridge extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 构造函数
  const ChatSessionBridge({super.key, required this.child});

  @override
  State<ChatSessionBridge> createState() => _ChatSessionBridgeState();
}

class _ChatSessionBridgeState extends State<ChatSessionBridge> {
  @override
  void initState() {
    super.initState();

    // 在初始化后添加监听
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupSessionListener();
    });
  }

  /// 设置会话监听器
  void _setupSessionListener() {
    final sessionViewModel = Provider.of<SessionViewModel>(
      context,
      listen: false,
    );
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);

    // 设置会话选择回调
    sessionViewModel.onSessionSelected = (String sessionKey) {
      final found = sessionViewModel.sessions.any(
        (session) => session.sessionKey == sessionKey,
      );
      if (!found || sessionKey.isEmpty) {
        // 没有会话，重置聊天状态
        chatViewModel.startNewChat();
        return;
      }
      final selectedSession = sessionViewModel.sessions.firstWhere(
        (session) => session.sessionKey == sessionKey,
      );
      chatViewModel.selectSession(selectedSession);
    };

    // 如果已有选中的会话，立即加载消息
    if (sessionViewModel.selectedSession != null) {
      chatViewModel.selectSession(sessionViewModel.selectedSession!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
