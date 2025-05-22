// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/domain/usecases/get_recent_projects_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/repositories/project_repository.dart';

/// 获取最近项目列表的用例
class GetRecentProjectsUseCase {
  final ProjectRepository repository;

  GetRecentProjectsUseCase(this.repository);

  /// 执行用例，获取最近的项目列表
  /// [count] 参数指定获取项目的数量，默认为5
  Future<Either<Failure, List<ProjectEntity>>> call({int count = 5}) async {
    final result = await repository.getProjects();
    return result.fold((failure) => Left(failure), (projects) {
      // 按更新时间（其次创建时间）降序排序
      projects.sort((a, b) {
        if (a.updatedAt != null && b.updatedAt != null) {
          return b.updatedAt!.compareTo(a.updatedAt!);
        }
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        }
        // 如果只有一个有updatedAt，则有updatedAt的更近
        if (a.updatedAt != null && b.updatedAt == null) return -1;
        if (a.updatedAt == null && b.updatedAt != null) return 1;
        // 如果只有一个有createdAt，则有createdAt的更近
        if (a.createdAt != null && b.createdAt == null) return -1;
        if (a.createdAt == null && b.createdAt != null) return 1;
        return 0;
      });
      return Right(projects.take(count).toList());
    });
  }
}
