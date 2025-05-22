// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/presentation/pages/all_projects_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/app/viewmodels/project_viewmodel.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/core/di/di.dart'; // 用于依赖注入
import 'package:kiwi/presentation/pages/project_file_page.dart';

/// 所有项目页面，负责展示和管理所有项目
class AllProjectsPage extends StatelessWidget {
  const AllProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 通过依赖注入提供 ProjectViewModel，并在创建时拉取项目列表
    return ChangeNotifierProvider<ProjectViewModel>(
      create: (_) => sl<ProjectViewModel>()..fetchProjects(),
      child: const _AllProjectsView(),
    );
  }
}

class _AllProjectsView extends StatefulWidget {
  const _AllProjectsView();

  @override
  State<_AllProjectsView> createState() => _AllProjectsViewState();
}

class _AllProjectsViewState extends State<_AllProjectsView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.info("Navigated to AllProjectsPage");
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }

  /// 打开新建项目弹窗
  void _openNewProjectModal(BuildContext context) {
    _projectNameController.clear();
    final projectViewModel = Provider.of<ProjectViewModel>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDesktop = MediaQuery.of(dialogContext).size.width > 600;
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            '新建项目',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 400 : double.infinity,
              maxHeight: 220,
              minHeight: 220,
              minWidth: 360,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _projectNameController,
                      decoration: InputDecoration(
                        labelText: '项目名称',
                        labelStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.background.withOpacity(
                          0.9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: theme.textTheme.bodyLarge,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入项目名称';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '取消',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                elevation: 2,
              ),
              child: const Text(
                '创建',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AppLogger.info(
                    'Creating new project: ${_projectNameController.text}',
                  );
                  projectViewModel.createProject(_projectNameController.text);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final projectViewModel = Provider.of<ProjectViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          tooltip: '返回',
          onPressed: () {
            Navigator.of(context).maybePop();
            AppLogger.info('Clicked back button on AllProjectsPage');
          },
        ),
        title: const Text('所有项目'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects Management Dashboard',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Central hub for managing your projects.',
                    style: textTheme.titleMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildProjectGrid(context, projectViewModel)),
          ],
        ),
      ),
    );
  }

  /// 构建项目网格视图
  Widget _buildProjectGrid(BuildContext context, ProjectViewModel viewModel) {
    switch (viewModel.state) {
      case ProjectState.loading:
        return const Center(child: CircularProgressIndicator());
      case ProjectState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '获取项目失败: ${viewModel.errorMessage}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => viewModel.fetchProjects(),
                child: const Text('重试'),
              ),
            ],
          ),
        );
      case ProjectState.loaded:
        if (viewModel.projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('没有项目哦，快去创建一个吧！'),
                const SizedBox(height: 20),
                _NewProjectCard(onTap: () => _openNewProjectModal(context)),
              ],
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = _calculateCrossAxisCount(context);
            double cardWidth = 360;
            double cardHeight = 220;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: cardWidth / cardHeight,
              ),
              itemCount: viewModel.projects.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index == viewModel.projects.length) {
                  return SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _NewProjectCard(
                      onTap: () => _openNewProjectModal(context),
                    ),
                  );
                }
                final project = viewModel.projects[index];
                return SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _ProjectCard(project: project),
                );
              },
            );
          },
        );
      case ProjectState.initial:
        return const Center(child: Text('正在初始化...'));
    }
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) return 4;
    if (screenWidth >= 900) return 3;
    if (screenWidth >= 600) return 2;
    if (screenWidth >= 300) return 1;
    return 1;
  }
}

/// 单个项目卡片组件
class _ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.15),
          width: 1.2,
        ),
      ),
      color: theme.colorScheme.background,
      child: InkWell(
        onTap: () {
          AppLogger.info('Tapped on project: ${project.name}');
          // TODO: 跳转到项目详情页
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Icon and Menu button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.more_horiz,
                        size: 24,
                        color: theme.hintColor,
                      ),
                      onSelected: (value) {
                        if (value == 'file_manage') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProjectFilePage(project: project),
                            ),
                          );
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<String>(
                              value: 'file_manage',
                              child: Row(
                                children: const [
                                  Icon(Icons.folder, size: 18),
                                  SizedBox(width: 8),
                                  Text('文件内容管理'),
                                ],
                              ),
                            ),
                            // 可扩展更多菜单项
                          ],
                      tooltip: 'More',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Project Name
              Flexible(
                child: Text(
                  project.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              // Meta Info (Creator & Updated Date)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: Text(
                      project.creator?.email ?? 'Unknown',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 3,
                    child: Text(
                      project.updatedAt != null
                          ? 'Updated ${TimeAgo.format(project.updatedAt!)}'
                          : 'Updated recently',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 新建项目卡片组件
class _NewProjectCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewProjectCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      color: theme.colorScheme.background.withAlpha(220),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 400, // 与项目卡片高度一致
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: theme.colorScheme.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'New Project',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
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

/// 时间格式化工具类
class TimeAgo {
  static String format(DateTime dt) {
    final duration = DateTime.now().difference(dt);
    if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
