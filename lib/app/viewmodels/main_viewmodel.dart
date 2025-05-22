import 'package:flutter/material.dart';
import '../../../domain/usecases/get_auth_user_info_usecase.dart';

/// 视图模型 - 主界面
class MainViewModel extends ChangeNotifier {
  final GetAuthUserInfoUseCase _getAuthUserInfoUseCase;

  bool _isLoadingAuth = true;
  bool get isLoadingAuth => _isLoadingAuth;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // 新增：当前选择的页面，默认为聊天页面
  String _selectedPage = 'chat';
  String get selectedPage => _selectedPage;

  MainViewModel({required GetAuthUserInfoUseCase getAuthUserInfoUseCase})
    : _getAuthUserInfoUseCase = getAuthUserInfoUseCase;

  /// 检查用户认证状态
  /// 通常在 MainPage 的 initState 中调用
  Future<void> checkAuthStatus() async {
    _isLoadingAuth = true;
    notifyListeners();

    final result = await _getAuthUserInfoUseCase();

    result.fold(
      (failure) {
        // Handle failure, e.g., log error, show a message, or set isAuthenticated to false
        print('Error checking auth status: ${failure.message}');
        _isAuthenticated = false;
      },
      (userEntity) {
        _isAuthenticated = userEntity != null;
      },
    );

    _isLoadingAuth = false;
    notifyListeners();
  }

  /// 更新选择的页面
  void selectPage(String pageName) {
    _selectedPage = pageName;
    notifyListeners();
  }
}
