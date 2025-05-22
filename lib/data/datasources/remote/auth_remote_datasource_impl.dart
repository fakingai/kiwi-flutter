import 'package:dio/dio.dart';

import '../../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// 远程认证数据源实现
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromApi(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromApi(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
