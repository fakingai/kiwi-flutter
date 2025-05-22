import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user_entity.dart';

/// 认证仓库接口
abstract class AuthRepository {
  /// 登录
  Future<Either<Failure, UserEntity>> login(String email, String password);

  /// 注册
  Future<Either<Failure, UserEntity>> register(String email, String password);

  /// 获取当前登录的用户
  /// 如果用户未登录，则返回 Right(null)
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
