// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/domain/repositories/project_repository.dart
import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/project_entity.dart';

/// 数据仓库的抽象接口，定义了项目数据操作的契约
abstract class ProjectRepository {
  /// 获取项目列表
  ///
  /// 返回一个 Future，其中包含一个 Either 类型：
  /// - Left: 如果操作失败，则包含一个 Failure 对象。
  /// - Right: 如果操作成功，则包含一个 ProjectEntity 对象的列表。
  Future<Either<Failure, List<ProjectEntity>>> getProjects();

  // 你可以在这里添加其他与项目相关的仓库方法，例如：
  // Future<Either<Failure, ProjectEntity>> getProjectById(String id);
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project);
  // Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project);
  // Future<Either<Failure, void>> deleteProject(String id);
}
