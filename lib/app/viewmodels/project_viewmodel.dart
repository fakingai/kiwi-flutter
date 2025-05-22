import 'package:flutter/foundation.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/usecases/create_project_usecase.dart';
import 'package:kiwi/domain/usecases/get_projects_usecase.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/core/utils/logger.dart';

/// 项目列表页面的视图模型状态
enum ProjectState {
  initial, // 初始状态
  loading, // 加载中
  loaded, // 加载完成
  error, // 加载出错
}

/// 项目列表页面的视图模型
class ProjectViewModel extends ChangeNotifier {
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;

  ProjectViewModel({
    required GetProjectsUseCase getProjectsUseCase,
    required CreateProjectUseCase createProjectUseCase,
  }) : _getProjectsUseCase = getProjectsUseCase,
       _createProjectUseCase = createProjectUseCase {
    AppLogger.debug('ProjectViewModel initialized');
  }

  ProjectState _state = ProjectState.initial;

  /// 当前的项目列表状态
  ProjectState get state => _state;

  List<ProjectEntity> _projects = [];

  /// 获取到的项目列表
  List<ProjectEntity> get projects => _projects;

  String _errorMessage = '';

  /// 错误信息，当 state 为 error 时有效
  String get errorMessage => _errorMessage;

  /// 获取所有项目
  Future<void> fetchProjects() async {
    AppLogger.info('Fetching projects...');
    _state = ProjectState.loading;
    notifyListeners();

    final result = await _getProjectsUseCase();
    AppLogger.debug('Fetch projects result: \$result');

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (projectList) {
        _projects = projectList;
        _state = ProjectState.loaded;
        AppLogger.info(
          'Projects fetched successfully: \${projectList.length} projects',
        );
        notifyListeners();
      },
    );
  }

  /// 创建新项目
  Future<void> createProject(String name) async {
    AppLogger.info('Creating project with name: $name');
    _state = ProjectState.loading;
    notifyListeners();

    final result = await _createProjectUseCase(name: name);
    AppLogger.debug('Create project result: \$result');

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (project) {
        _projects.add(project);
        _state = ProjectState.loaded;
        AppLogger.info('Project created successfully: $project');
        notifyListeners();
      },
    );
  }

  void _handleFailure(Failure failure) {
    _projects = [];
    _state = ProjectState.error;
    _errorMessage = failure.message;
    AppLogger.error('Error fetching projects: $_errorMessage');
    notifyListeners();
  }
}
