part of 'project_list_bloc.dart';

/// 项目列表状态的基类
abstract class ProjectListState extends Equatable {
  const ProjectListState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class ProjectListInitial extends ProjectListState {}

/// 加载中状态
class ProjectListLoading extends ProjectListState {}

/// 加载成功状态
class ProjectListLoaded extends ProjectListState {
  final List<ProjectEntity> projects;

  const ProjectListLoaded({required this.projects});

  @override
  List<Object> get props => [projects];
}

/// 加载失败状态
class ProjectListError extends ProjectListState {
  final String message;

  const ProjectListError({required this.message});

  @override
  List<Object> get props => [message];
}
