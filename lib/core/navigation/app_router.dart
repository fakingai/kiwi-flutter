import 'package:flutter/material.dart';
import 'package:kiwi/core/navigation/app_routes.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/presentation/pages/main_page.dart';
import 'package:kiwi/presentation/pages/login_page.dart';
import 'package:kiwi/presentation/pages/project_file_page.dart';
import 'package:kiwi/presentation/pages/all_projects_page.dart';

/// 路由管理
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': // Default route
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.projectFiles:
        final project = settings.arguments as ProjectEntity;
        return MaterialPageRoute(
          builder: (_) => ProjectFilePage(project: project),
        );
      case AppRoutes.allProjects:
        return MaterialPageRoute(builder: (_) => const AllProjectsPage());
      default:
        // Optionally, handle unknown routes, or redirect to a known page
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
        ); // Fallback to MainPage
    }
  }
}
