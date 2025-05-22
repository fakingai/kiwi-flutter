import 'package:dartz/dartz.dart';
import 'package:kiwi/core/error/api_exception.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

/// 认证仓库实现
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      if (e is ApiException) {
        return Left(Failure(message: e.message ?? e.code.toString()));
      }
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.register(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      if (e is ApiException) {
        return Left(Failure(message: e.message ?? e.code.toString()));
      }
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getLastUser();
      if (userModel != null) {
        // Optionally, you might want to verify the user session with the backend here
        // For now, we assume if it's in local storage, it's valid.
        return Right(userModel); // UserModel is compatible with UserEntity
      }
      return const Right(null); // No user in local storage
    } catch (e) {
      // This catch block might be for unexpected errors from localDataSource
      return Left(
        Failure(
          message: "Error fetching user from local storage: ${e.toString()}",
        ),
      );
    }
  }
}
