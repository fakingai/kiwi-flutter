import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/viewmodels/main_viewmodel.dart'; // Import MainViewModel
import '../../app/viewmodels/project_viewmodel.dart'; // Import ProjectViewModel
import '../../app/viewmodels/chat_viewmodel.dart'; // Import ChatViewModel
import '../../app/viewmodels/session_viewmodel.dart'; // Import SessionViewModel
import '../../core/di/di.dart'; // 导入依赖注入模块
import '../widgets/main_page/sidebar_widget.dart';
import '../widgets/main_page/chat_area_widget.dart';
import '../widgets/main_page/chat_session_bridge.dart'; // 导入会话和聊天的桥接组件

/// 主界面Page，包含侧边栏和主聊天区域。
class MainPage extends StatefulWidget {
  /// 主界面Page的构造函数。
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // 使用 MainViewModel 检查认证状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // It's important that MainViewModel is already provided when MainPage is built.
      // This typically happens in your main.dart or a higher-level widget.
      final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
      mainViewModel.checkAuthStatus().then((_) {
        if (mounted && !mainViewModel.isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Optionally, listen to MainViewModel's isLoadingAuth to show a loading indicator
    // final isLoading = context.watch<MainViewModel>().isLoadingAuth;
    // if (isLoading) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    // 监听 MainViewModel 的 selectedPage 变化
    final selectedPage = context.watch<MainViewModel>().selectedPage;

    return MultiProvider(
      providers: [
        // 提供ProjectViewModel，用于项目列表的获取和管理
        ChangeNotifierProvider<ProjectViewModel>(
          create: (_) => sl<ProjectViewModel>(),
        ),
        // 提供ChatViewModel，用于聊天功能
        ChangeNotifierProvider<ChatViewModel>(
          create: (_) => sl<ChatViewModel>(),
        ),
        // 提供SessionViewModel，用于会话列表的获取和管理
        ChangeNotifierProvider<SessionViewModel>(
          create: (_) => sl<SessionViewModel>(),
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            // 侧边栏
            const SidebarWidget(),
            // 根据 selectedPage 显示不同的主内容区域
            Expanded(
              child: switch (selectedPage) {
                'chat' => ChatSessionBridge(
                  child: const ChatAreaWidget(),
                ), // 使用桥接组件连接会话和聊天
                // 移除 'projects' 分支，所有项目页面应为独立页面/路由
                _ => ChatSessionBridge(
                  child: const ChatAreaWidget(),
                ), // 默认显示聊天区域
              },
            ),
          ],
        ),
      ),
    );
  }
}
