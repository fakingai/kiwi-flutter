// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/data/repositories/project_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/data/datasources/remote/project_remote_datasource.dart';
import 'package:kiwi/data/models/project_model.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/repositories/project_repository.dart';

/// 项目仓库的实现
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final remoteProjects = await remoteDataSource.getProjects();
      return Right(remoteProjects);
    } catch (e) {
      return Left(Failure(message: 'Server error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(
    ProjectEntity project,
  ) async {
    try {
      final remoteProject = await remoteDataSource.createProject(
        ProjectModel(
          id: project.id,
          name: project.name,
          createdAt: project.createdAt,
          updatedAt: project.updatedAt,
        ),
      );
      return Right(remoteProject);
    } catch (e) {
      return Left(Failure(message: 'Server error: ${e.toString()}'));
    }
  }

  // 其他方法的实现...
}
