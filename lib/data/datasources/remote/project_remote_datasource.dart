import 'package:dio/dio.dart';
import 'package:kiwi/core/error/exceptions.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/data/models/project_model.dart';

/// 远程项目数据源接口
abstract class ProjectRemoteDataSource {
  /// 获取项目列表
  ///
  /// 返回一个 Future，其中包含一个 Either 类型：
  /// - Left: 如果操作失败，则包含一个 Failure 对象。
  /// - Right: 如果操作成功，则包含一个 ProjectModel 对象的列表。
  Future<List<ProjectModel>> getProjects();

  // 你可以在这里添加其他与项目相关的远程数据源方法，例如：
  // Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> createProject(ProjectModel project);
  // Future<ProjectModel> updateProject(ProjectModel project);
  // Future<void> deleteProject(String id);
}

/// 远程项目数据源实现
class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final Dio dio; // Changed from ApiClient

  ProjectRemoteDataSourceImpl({
    required this.dio,
  }); // Changed constructor parameter

  @override
  Future<List<ProjectModel>> getProjects() async {
    AppLogger.info(
      'ProjectRemoteDataSource: Fetching projects from API using Dio.',
    );
    // API端点参考Postman文档: GET /api/projects
    final response = await dio.get('/api/projects');
    final List<dynamic> dataList = response.data['data'] as List<dynamic>;
    final projects =
        dataList.map((json) {
          if (json is Map<String, dynamic>) {
            return ProjectModel.fromJson(json);
          } else {
            AppLogger.error(
              'ProjectRemoteDataSource: Encountered non-map item in project list: $json',
            );
            throw ServerException(
              message: 'Invalid item format in project list from API.',
            );
          }
        }).toList();
    AppLogger.info(
      'ProjectRemoteDataSource: Successfully fetched ${projects.length} projects.',
    );
    return projects;
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    AppLogger.info('ProjectRemoteDataSource: Creating project using Dio.');
    // API端点参考Postman文档: POST /api/projects
    final response = await dio.post('/api/projects', data: project.toJson());
    return ProjectModel.fromJson(response.data);
  }
}
