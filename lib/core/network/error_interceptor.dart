import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kiwi/core/error/api_exception.dart'; // Contains BusinessException

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 检查是否为未授权401错误及API路径
    if (response.statusCode == 401 &&
        response.requestOptions.path.startsWith('/api')) {
      throw ApiException(
        code: 401,
        message: '无效登录凭证',
        requestOptions: response.requestOptions,
        isAuthError: true,
      );
    }

    // 检查响应体是否为空或者响应数据是否为空
    if (response.data == null || response.data.toString().isEmpty) {
      // 如果响应体为空，并且 HTTP 状态码不是成功状态 (2xx)，则抛出异常
      if (response.statusCode != null &&
          (response.statusCode! < 200 || response.statusCode! >= 300)) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: "Http status code: ${response.statusCode}, no response body",
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
      // 如果响应体为空，但 HTTP 状态码是成功的，则直接传递响应
      super.onResponse(response, handler);
      return;
    }

    // 尝试解析响应数据
    // 服务端返回的可能是JSON字符串，也可能是已经解析过的Map
    Map<String, dynamic> data;
    if (response.data is String) {
      try {
        data = jsonDecode(response.data);
      } catch (e) {
        // 如果JSON解析失败，并且 HTTP 状态码不是成功状态，则抛出异常
        if (response.statusCode != null &&
            (response.statusCode! < 200 || response.statusCode! >= 300)) {
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              error:
                  "Http status code: ${response.statusCode}, failed to parse response body: ${e.toString()}",
              type: DioExceptionType.badResponse,
            ),
          );
          return;
        }
        // 如果JSON解析失败，但 HTTP 状态码是成功的，则直接传递响应 (可能是不规范的成功响应)
        super.onResponse(response, handler);
        return;
      }
    } else if (response.data is Map<String, dynamic>) {
      data = response.data;
    } else {
      // 如果响应数据类型未知，并且 HTTP 状态码不是成功状态，则抛出异常
      if (response.statusCode != null &&
          (response.statusCode! < 200 || response.statusCode! >= 300)) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error:
                "Http status code: ${response.statusCode}, unknown response body type: ${response.data.runtimeType}",
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
      // 如果响应数据类型未知，但 HTTP 状态码是成功的，则直接传递响应
      super.onResponse(response, handler);
      return;
    }

    // 检查业务状态码
    final int? code = data['code'] as int?;
    final String? message = data['msg'] as String?;

    if (code != null && code != 200) {
      // 直接抛出业务异常，而不是通过 handler.reject 包装的 DioException
      throw ApiException(
        code: code,
        message: message ?? 'No error message',
        requestOptions: response.requestOptions,
      );
    } else {
      // 业务状态码为200或没有code字段（视为成功），正常传递响应
      super.onResponse(response, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 检查是否为未授权401错误及API路径
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path.startsWith('/api')) {
      throw ApiException(
        code: 401,
        message: '无效登录凭证',
        requestOptions: err.requestOptions,
        isAuthError: true,
      );
    }

    // 如果错误没有响应体 (例如网络错误、超时等)
    if (err.response == null ||
        err.response!.data == null ||
        err.response!.data.toString().isEmpty) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error:
              "Http status code: ${err.response?.statusCode}, error: ${err.message ?? err.error.toString()}",
          type: err.type,
        ),
      );
      return;
    }
    // 对于有响应体的错误，也尝试按业务错误格式解析
    // 服务端返回的可能是JSON字符串，也可能是已经解析过的Map
    Map<String, dynamic> data;
    if (err.response!.data is String) {
      try {
        data = jsonDecode(err.response!.data);
      } catch (e) {
        // 解析失败，直接传递原始DioError
        super.onError(err, handler);
        return;
      }
    } else if (err.response!.data is Map<String, dynamic>) {
      data = err.response!.data;
    } else {
      // 未知类型，直接传递原始DioError
      super.onError(err, handler);
      return;
    }

    final int? code = data['code'] as int?;
    final String? message = data['msg'] as String?;

    if (code != null && code != 200) {
      // 直接抛出业务异常
      throw ApiException(
        code: code,
        message: message ?? 'No error message',
        requestOptions: err.requestOptions,
      );
    } else {
      // 如果解析出的code是200或者没有code字段，但它仍然是个DioError，
      // 这可能意味着HTTP层面的错误被包装在了成功的业务结构里，或者业务结构不规范
      // 此时，我们应该传递原始的DioError，或者根据HTTP状态码决定
      // 保守起见，传递原始DioError
      super.onError(err, handler);
    }
  }
}
