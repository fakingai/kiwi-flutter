import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/failure.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/domain/repositories/project_repository.dart';
import 'package:kiwi/core/utils/logger.dart';

/// 创建新项目的用例
class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  /// 执行用例，创建一个新项目
  ///
  /// [name] 项目名称 (必填)
  /// [description] 项目描述 (可选)
  Future<Either<Failure, ProjectEntity>> call({required String name}) async {
    AppLogger.info('CreateProjectUseCase called with name: $name');
    if (name.isEmpty) {
      AppLogger.warning(
        'Project name cannot be empty for CreateProjectUseCase',
      );
      return Left(ValidationFailure('项目名称不能为空'));
    }
    // 在实际应用中，这里可能还会有其他业务规则校验
    // 创建时不传id，由后端生成
    final project = ProjectEntity(
      id: 0, // 创建时无id，后端生成
      name: name,
    );
    return await repository.createProject(project);
  }
}

/// 特定于参数验证的 Failure 类型
class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message: message);
}
