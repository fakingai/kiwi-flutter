// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/domain/usecases/get_projects_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/repositories/project_repository.dart';

/// 获取所有项目列表的用例
class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  /// 执行用例，获取所有的项目列表
  Future<Either<Failure, List<ProjectEntity>>> call() async {
    return await repository.getProjects();
    // 如果需要特定的排序或过滤逻辑，可以在这里添加，
    // 例如，按名称排序：
    // final result = await repository.getProjects();
    // return result.fold(
    //   (failure) => Left(failure),
    //   (projects) {
    //     projects.sort((a, b) => a.name.compareTo(b.name));
    //     return Right(projects);
    //   },
    // );
  }
}
