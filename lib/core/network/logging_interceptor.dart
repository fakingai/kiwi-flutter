import 'package:dio/dio.dart';
import 'package:kiwi/core/utils/logger.dart';

/// Dio 拦截器，用于记录 HTTP 请求和响应信息
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('HTTP Request: ${options.method} ${options.uri}');
    AppLogger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      AppLogger.debug('Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      'HTTP Response: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    AppLogger.debug('Headers: ${response.headers}');
    AppLogger.debug('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'HTTP Error: ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.error,
      err.stackTrace,
    );
    if (err.response != null) {
      AppLogger.error('Error Response Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
