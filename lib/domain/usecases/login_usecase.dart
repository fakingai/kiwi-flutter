import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// 登录用例
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// 执行登录
  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.login(email, password);
  }
}
