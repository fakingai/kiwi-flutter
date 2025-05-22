import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

/// 用例 - 获取当前登录用户的详细信息
class GetAuthUserInfoUseCase {
  final AuthRepository repository;

  GetAuthUserInfoUseCase(this.repository);

  /// 调用用例
  /// 返回 UserEntity 如果已登录，否则返回 null
  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
