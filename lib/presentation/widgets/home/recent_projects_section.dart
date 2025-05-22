import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/presentation/bloc/project_list/project_list_bloc.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/core/navigation/app_routes.dart'; // Corrected import

/// 显示最近项目列表的区块组件
class RecentProjectsSection extends StatelessWidget {
  const RecentProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保在Widget构建时，如果状态是初始状态，则触发加载事件
    // 这通常在BlocProvider创建时或页面初始化时完成。
    // 如果Bloc是由父级提供的，并且此Widget是首次显示，可以在这里触发。
    // 为确保只触发一次，可以检查当前状态。
    final projectListBloc = BlocProvider.of<ProjectListBloc>(context);
    if (projectListBloc.state is ProjectListInitial) {
      AppLogger.info(
        'RecentProjectsSection: Initial state, dispatching FetchRecentProjects.',
      );
      projectListBloc.add(const FetchRecentProjects());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近项目列表', // Section Title
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  AppLogger.info('More projects button tapped.');
                  Navigator.pushNamed(context, AppRoutes.allProjects);
                },
                child: const Text('更多'),
              ),
            ],
          ),
        ),
        BlocBuilder<ProjectListBloc, ProjectListState>(
          builder: (context, state) {
            AppLogger.debug(
              'RecentProjectsSection: BlocBuilder received state: ${state.runtimeType}',
            );
            if (state is ProjectListLoading || state is ProjectListInitial) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is ProjectListLoaded) {
              if (state.projects.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('暂无最近项目'),
                  ),
                );
              }
              return _buildProjectList(context, state.projects);
            } else if (state is ProjectListError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('加载项目失败: ${state.message}'),
                ),
              );
            }
            return const SizedBox.shrink(); // Should ideally not be reached
          },
        ),
      ],
    );
  }

  Widget _buildProjectList(BuildContext context, List<ProjectEntity> projects) {
    // 可以根据需要调整为水平或垂直列表，以及项目的显示样式
    return ListView.builder(
      shrinkWrap: true, // Important for Column nesting
      physics:
          const NeverScrollableScrollPhysics(), // If nested in another scrollable
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(
              project.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:
                project.updatedAt != null
                    ? Text(
                      '更新于: ${project.updatedAt!.toLocal().toString().substring(0, 16)}', // Simple date format
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                    : (project.createdAt != null
                        ? Text(
                          '创建于: ${project.createdAt!.toLocal().toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                        : null),
            leading: CircleAvatar(
              child: Text(
                project.name.isNotEmpty ? project.name[0].toUpperCase() : '?',
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppLogger.info(
                'Tapped on project: ${project.name} (ID: ${project.id})',
              );
              Navigator.pushNamed(
                context,
                AppRoutes.projectDetails,
                arguments: project.id,
              );
            },
          ),
        );
      },
    );
  }
}
