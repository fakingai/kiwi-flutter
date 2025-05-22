import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/app/viewmodels/project_viewmodel.dart';
import 'package:kiwi/app/viewmodels/chat_viewmodel.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/presentation/widgets/main_page/message_bubble.dart';

/// 主聊天区域Widget，包含聊天提示和输入框。
class ChatAreaWidget extends StatelessWidget {
  /// 主聊天区域Widget的构造函数。
  const ChatAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _ChatAreaWithScroll();
  }
}

/// 包含消息自动滚动和回到底部按钮的聊天区域
class _ChatAreaWithScroll extends StatefulWidget {
  @override
  State<_ChatAreaWithScroll> createState() => _ChatAreaWithScrollState();
}

class _ChatAreaWithScrollState extends State<_ChatAreaWithScroll> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;
  String? _lastSessionKey; // 记录上一次的会话Key

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    // 首次进入页面时自动滚动到底部（如果有历史消息）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      if (chatViewModel.messages.isNotEmpty) {
        _scrollToBottom(animated: false);
      }
    });
  }

  void _handleScroll() {
    // 判断是否在底部
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    final atBottom = (maxScroll - current).abs() < 40.0;
    if (_isAtBottom != atBottom) {
      setState(() {
        _isAtBottom = atBottom;
      });
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    if (animated) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;
    final inputBarHeight = isDesktop ? 72.0 : 56.0;
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // 聊天消息区域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: Stack(
                  children: [
                    Consumer<ChatViewModel>(
                      builder: (context, chatViewModel, child) {
                        final currentSessionKey =
                            chatViewModel.currentSession?.sessionKey;
                        if (_lastSessionKey != currentSessionKey) {
                          _lastSessionKey = currentSessionKey;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom(animated: false);
                            if (!_isAtBottom) {
                              setState(() {
                                _isAtBottom = true;
                              });
                            }
                          });
                        }

                        // 没有消息时显示欢迎提示
                        if (chatViewModel.messages.isEmpty) {
                          return Center(
                            child: Text(
                              '我可以帮你分析项目中的文件',
                              style: TextStyle(
                                fontSize: isDesktop ? 32 : 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        // 渲染消息列表
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_isAtBottom) {
                            _scrollToBottom(animated: true);
                          }
                        });
                        return NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            _handleScroll();
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(24),
                            reverse: false,
                            itemCount: chatViewModel.messages.length,
                            itemBuilder: (context, index) {
                              return MessageBubble(
                                message: chatViewModel.messages[index],
                                isStreaming:
                                    chatViewModel.state ==
                                        ChatState.streaming &&
                                    index ==
                                        chatViewModel.messages.length - 1 &&
                                    chatViewModel.messages[index].role ==
                                        'assistant',
                              );
                            },
                          ),
                        );
                      },
                    ),
                    // 回到底部按钮
                    Positioned(
                      right: 16,
                      bottom: 24,
                      child: AnimatedOpacity(
                        opacity: _isAtBottom ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: _isAtBottom,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            onPressed: () => _scrollToBottom(animated: true),
                            child: const Icon(Icons.arrow_downward),
                            tooltip: '回到底部',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 分隔线
          Divider(
            height: 1,
            thickness: 1.2,
            color: Theme.of(context).dividerColor.withOpacity(0.15),
          ),
          // 底部输入栏
          SizedBox(height: inputBarHeight, child: const ChatInputBar()),
        ],
      ),
    );
  }
}

/// 聊天输入栏Widget。
class ChatInputBar extends StatefulWidget {
  /// 聊天输入栏Widget的构造函数。
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  ProjectEntity? _selectedProject;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 在初始化时加载项目列表
    Future.microtask(() async {
      final projectViewModel = Provider.of<ProjectViewModel>(
        context,
        listen: false,
      );
      final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      AppLogger.info('initState: 自动加载项目列表...');
      await projectViewModel.fetchProjects();
      // 监听会话变化，自动同步选中项目
      chatViewModel.addListener(_syncSelectedProjectWithSession);
    });
  }

  void _syncSelectedProjectWithSession() {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    final projectViewModel = Provider.of<ProjectViewModel>(
      context,
      listen: false,
    );
    if (chatViewModel.currentSession != null &&
        projectViewModel.projects.isNotEmpty) {
      final sessionProjectId =
          chatViewModel.currentSession!.projectId?.toString();
      ProjectEntity? match;
      try {
        match = projectViewModel.projects.firstWhere(
          (p) => p.id.toString() == sessionProjectId,
        );
      } catch (_) {
        match = null;
      }
      if (match != null && _selectedProject?.id != match.id) {
        setState(() {
          _selectedProject = match;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    final projectViewModel = Provider.of<ProjectViewModel>(
      context,
      listen: false,
    );
    if (chatViewModel.currentSession != null &&
        projectViewModel.projects.isNotEmpty) {
      final sessionProjectId =
          chatViewModel.currentSession?.projectId?.toString();
      ProjectEntity? match;
      try {
        match = projectViewModel.projects.firstWhere(
          (p) => p.id.toString() == sessionProjectId,
        );
      } catch (_) {
        match = null;
      }
      if (match != null && _selectedProject?.id != match.id) {
        setState(() {
          _selectedProject = match;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;
    final inputFontSize = isDesktop ? 18.0 : 16.0;
    final buttonHeight = isDesktop ? 48.0 : 40.0;
    final buttonPadding =
        isDesktop
            ? EdgeInsets.symmetric(horizontal: 24)
            : EdgeInsets.symmetric(horizontal: 16);
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: isDesktop ? 12 : 8,
        ),
        child: Row(
          children: [
            // 项目选择器
            Consumer<ProjectViewModel>(
              builder: (context, projectViewModel, child) {
                // 根据状态显示不同的内容
                if (projectViewModel.state == ProjectState.loading) {
                  // 加载中显示加载指示器
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '加载项目中...',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (projectViewModel.state == ProjectState.error) {
                  // 错误状态显示错误图标
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '加载失败',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox(
                  width: isDesktop ? 220 : 160,
                  child: Consumer<ChatViewModel>(
                    builder: (context, chatViewModel, _) {
                      return DropdownButtonFormField<ProjectEntity>(
                        value: _selectedProject,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                        ),
                        hint: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '选择项目',
                              style: TextStyle(
                                fontSize: inputFontSize,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.expand_more,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        isDense: true,
                        borderRadius: BorderRadius.circular(8),
                        elevation: 4,
                        dropdownColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        isExpanded: false,
                        selectedItemBuilder: (context) {
                          if (projectViewModel.projects.isEmpty ||
                              projectViewModel.state != ProjectState.loaded) {
                            return [Container()];
                          }
                          return projectViewModel.projects.map<Widget>((
                            ProjectEntity project,
                          ) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.folder,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  project.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                        items:
                            projectViewModel.state == ProjectState.loaded
                                ? (projectViewModel.projects.isEmpty
                                    ? [
                                      DropdownMenuItem<ProjectEntity>(
                                        value: null,
                                        enabled: false,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '暂无项目，请先创建',
                                                style: TextStyle(
                                                  fontSize: inputFontSize,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                    : projectViewModel.projects.map<
                                      DropdownMenuItem<ProjectEntity>
                                    >((ProjectEntity project) {
                                      return DropdownMenuItem<ProjectEntity>(
                                        value: project,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.folder,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                project.name,
                                                style: TextStyle(
                                                  fontSize: inputFontSize,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList())
                                : [],
                        onChanged:
                            (chatViewModel.currentSession != null)
                                ? null
                                : (ProjectEntity? newValue) {
                                  setState(() {
                                    _selectedProject = newValue;
                                  });
                                  AppLogger.info(
                                    'Selected project: \\${newValue?.name ?? 'None'} (ID: \\${newValue?.id ?? 'None'})',
                                  );
                                },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            // 输入框
            Expanded(
              child: Focus(
                focusNode: _focusNode,
                child: TextField(
                  controller: _textController,
                  style: TextStyle(
                    fontSize: inputFontSize,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '开始对话...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 发送按钮
            Consumer<ChatViewModel>(
              builder: (context, chatViewModel, child) {
                final bool isLoading =
                    chatViewModel.state == ChatState.loading ||
                    chatViewModel.state == ChatState.streaming;
                return SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 2,
                      padding: buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyle(
                        fontSize: inputFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () => _sendMessage(_textController.text),
                    icon:
                        isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                            : Icon(Icons.send, size: 22),
                    label: isLoading ? const Text('发送中...') : const Text('发送'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 发送消息
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    if (_selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择项目'), duration: Duration(seconds: 2)),
      );
      return;
    }

    // 获取ChatViewModel并发送消息
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);

    chatViewModel.sendMessage(_selectedProject!.id, text.trim());
    _textController.clear();
  }

  @override
  void dispose() {
    // final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    // chatViewModel.removeListener(_syncSelectedProjectWithSession);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
