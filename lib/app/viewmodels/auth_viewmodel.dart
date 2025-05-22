import 'package:flutter/material.dart';
import 'dart:async'; // Import Completer
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/user_model.dart'; // Ensure UserModel is imported

/// 认证视图模型
class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  UserEntity? user;

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthLocalDataSource localDataSource;
  final Completer<void> _userLoadedCompleter =
      Completer<void>(); // Add Completer

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.localDataSource,
  }) {
    _loadCurrentUser();
  }

  /// Future that completes when the initial user load is finished.
  Future<void> get userLoaded => _userLoadedCompleter.future;

  /// 加载当前用户
  Future<void> _loadCurrentUser() async {
    try {
      user = await localDataSource.getLastUser();
    } catch (e) {
      // Optionally handle or log the error, e.g., print(e);
      user = null; // Ensure user is null if loading fails
    } finally {
      notifyListeners();
      if (!_userLoadedCompleter.isCompleted) {
        _userLoadedCompleter.complete();
      }
    }
  }

  /// 登录
  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await loginUseCase(email, password);
    result.fold(
      (fail) {
        error = fail.message;
      },
      (u) {
        user = u;
        // The entity from use case should be a UserModel instance
        localDataSource.cacheUser(u as UserModel);
      },
    );
    isLoading = false;
    notifyListeners();
  }

  /// 注册
  Future<void> register(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await registerUseCase(email, password);
    result.fold(
      (fail) {
        error = fail.message;
      },
      (u) {
        user = u;
        // The entity from use case should be a UserModel instance
        localDataSource.cacheUser(u as UserModel);
      },
    );
    isLoading = false;
    notifyListeners();
  }

  /// 登出
  Future<void> logout() async {
    await localDataSource.clearUser();
    user = null;
    notifyListeners();
  }
}
