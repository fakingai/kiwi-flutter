import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../app/viewmodels/session_viewmodel.dart';
import '../../../app/viewmodels/chat_viewmodel.dart'
    show ChatViewModel, ChatState;

/// 侧边栏Widget，包含新建聊天按钮和最近聊天列表。
class SidebarWidget extends StatefulWidget {
  /// 侧边栏Widget的构造函数。
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  @override
  void initState() {
    super.initState();
    // 当组件初始化时加载会话列表
    Future.microtask(() {
      final sessionViewModel = Provider.of<SessionViewModel>(
        context,
        listen: false,
      );
      sessionViewModel.loadSessions();
      // 绑定 ChatViewModel 的 sidebar 刷新回调
      final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      chatViewModel.setSidebarRefreshCallback((String sessionKey) async {
        await sessionViewModel.loadSessions();
        sessionViewModel.selectSession(sessionKey);
      });
    });
  }

  /// 格式化时间为友好显示
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // 使用相对时间描述
    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      // 使用intl包格式化日期
      final formatter = DateFormat('MM-dd');
      return formatter.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.background, // 与 chat_area_widget 匹配
        borderRadius: BorderRadius.circular(16), // 圆角与 chat 区域一致
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.04), // 降低阴影强度
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10), // 统一内边距
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 新建聊天按钮
          Consumer<ChatViewModel>(
            builder: (context, chatViewModel, child) {
              final isLoading = chatViewModel.state == ChatState.loading;
              return MouseRegion(
                cursor:
                    isLoading
                        ? SystemMouseCursors.forbidden
                        : SystemMouseCursors.click,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            chatViewModel.startNewChat();
                            // 新建聊天后取消选中会话
                            Provider.of<SessionViewModel>(
                              context,
                              listen: false,
                            ).clearSelectedSession();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            '新建聊天',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // 项目导航
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/all-projects');
                },
                icon: Icon(
                  Icons.folder_open,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  '所有项目',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.10),
                  minimumSize: const Size(double.infinity, 44),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Divider(
            color: Theme.of(context).dividerColor.withOpacity(0.10),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 14),
          // 最近聊天标签
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                '会话记录',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 最近聊天列表
          Expanded(
            child: Consumer<SessionViewModel>(
              builder: (context, sessionViewModel, child) {
                if (sessionViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (sessionViewModel.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '加载失败',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sessionViewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => sessionViewModel.loadSessions(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  );
                } else if (sessionViewModel.sessions.isEmpty) {
                  return Center(
                    child: Text(
                      '暂无聊天记录',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () => sessionViewModel.loadSessions(),
                    child: ScrollConfiguration(
                      behavior: const _NoScrollbarBehavior(),
                      child: ListView.separated(
                        itemCount: sessionViewModel.sessions.length,
                        separatorBuilder:
                            (context, index) => Divider(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.06),
                              height: 1,
                            ),
                        itemBuilder: (context, index) {
                          final session = sessionViewModel.sessions[index];
                          return RecentChatItem(
                            title: session.sessionName ?? '未命名会话',
                            sessionId: session.sessionKey,
                            time: _formatTime(session.updatedAt),
                            isSelected:
                                session.sessionKey ==
                                sessionViewModel.selectedSessionId,
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 最近聊天列表项Widget。
class RecentChatItem extends StatelessWidget {
  /// 聊天标题。
  final String title;

  /// 聊天时间。
  final String time;

  /// 会话ID
  final String sessionId;

  /// 是否选中。
  final bool isSelected;

  /// 最近聊天列表项Widget的构造函数。
  const RecentChatItem({
    super.key,
    required this.title,
    required this.time,
    required this.sessionId,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color:
            isSelected
                ? theme.colorScheme.primary.withOpacity(0.12) // 更高对比度的选中背景
                : theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Provider.of<SessionViewModel>(
              context,
              listen: false,
            ).selectSession(sessionId);
          },
          borderRadius: BorderRadius.circular(10),
          highlightColor: theme.colorScheme.primary.withOpacity(0.08),
          splashColor: theme.colorScheme.primary.withOpacity(0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 在文件末尾添加自定义 ScrollBehavior
class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
