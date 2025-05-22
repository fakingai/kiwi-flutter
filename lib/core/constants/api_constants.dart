// 核心功能 - API常量 (API Constants)
// 存放与API相关的常量，如基础URL、端点路径、请求头等。

/// API常量类
/// 包含所有与后端API相关的常量值
class ApiConstants {
  /// 私有构造函数，防止实例化
  ApiConstants._();

  /// API服务器基础URL
  static const String BASE_URL = 'http://82.157.48.188:9999';

  /// API版本
  static const String API_VERSION = '/api';

  /// 完整的API基础URL（组合了BASE_URL和API_VERSION）
  static const String API_BASE_URL = BASE_URL + API_VERSION;

  /// 认证相关端点
  static const String AUTH = '/auth';
  static const String LOGIN = AUTH + '/login';
  static const String REGISTER = AUTH + '/register';
  static const String LOGOUT = AUTH + '/logout';
}
