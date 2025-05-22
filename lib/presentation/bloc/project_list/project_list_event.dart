part of 'project_list_bloc.dart';

/// 项目列表事件的基类
abstract class ProjectListEvent extends Equatable {
  const ProjectListEvent();

  @override
  List<Object> get props => [];
}

/// 事件：获取最近的项目列表
class FetchRecentProjects extends ProjectListEvent {
  /// 需要获取的项目数量，默认为5
  final int count;

  const FetchRecentProjects({this.count = 5});

  @override
  List<Object> get props => [count];
}
