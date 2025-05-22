import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/usecases/get_recent_projects_usecase.dart';
import 'package:kiwi/core/utils/logger.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

/// BLoC (Business Logic Component) for managing the project list state.
class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final GetRecentProjectsUseCase getRecentProjectsUseCase;

  ProjectListBloc({required this.getRecentProjectsUseCase})
    : super(ProjectListInitial()) {
    on<FetchRecentProjects>(_onFetchRecentProjects);
  }

  /// 处理 FetchRecentProjects 事件
  Future<void> _onFetchRecentProjects(
    FetchRecentProjects event,
    Emitter<ProjectListState> emit,
  ) async {
    AppLogger.info(
      'ProjectListBloc: Received FetchRecentProjects event, count: ${event.count}',
    );
    emit(ProjectListLoading());
    final failureOrProjects = await getRecentProjectsUseCase(
      count: event.count,
    );

    failureOrProjects.fold(
      (failure) {
        AppLogger.error(
          'ProjectListBloc: Error fetching projects - ${failure.message}',
        );
        emit(ProjectListError(message: failure.message));
      },
      (projects) {
        AppLogger.info(
          'ProjectListBloc: Successfully fetched ${projects.length} projects.',
        );
        emit(ProjectListLoaded(projects: projects));
      },
    );
  }
}
