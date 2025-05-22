import 'package:dio/dio.dart';

/// 业务错误
class ApiException extends DioException {
  /// 错误代码
  final int code;

  /// 是否为授权错误(如401未授权)
  final bool isAuthError;

  /// 构造函数
  ApiException({
    required this.code,
    super.message,
    required super.requestOptions,
    this.isAuthError = false, // 默认不是授权错误
  });

  @override
  String toString() =>
      'BusinessException(code: $code, message: "$message", isAuthError: $isAuthError)';
}
