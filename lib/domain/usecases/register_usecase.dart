import 'package:dartz/dartz.dart';
import 'package:kiwi/domain/entities/user_entity.dart';
import '../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

/// 注册用例
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// 执行注册
  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.register(email, password);
  }
}
