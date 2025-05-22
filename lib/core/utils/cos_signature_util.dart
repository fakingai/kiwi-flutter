import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/domain/entities/cos_credentials_entity.dart';

/// 腾讯云COS签名工具类
/// 用于生成COS上传所需的签名信息
/// 参考文档: https://cloud.tencent.com/document/product/436/7778
class CosSignatureUtil {
  /// 生成授权头信息
  /// 注意：实际应用中，签名最好由服务端生成，以避免密钥泄露
  /// 参考：https://cloud.tencent.com/document/product/436/7778
  static Map<String, String> generateAuthHeaders({
    required CredentialsEntity credentials,
    required String httpMethod,
    required String cosPath,
    Map<String, String> headers = const {},
    Map<String, String> params = const {},
  }) {
    try {
      // 1. 获取当前时间戳
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch ~/ 1000;
      final signTime = '$timestamp;${credentials.expiredTime}';
      final keyTime = signTime;

      // 1. 构建 HeaderList 和 UrlParamList
      final headerKeys =
          headers.keys.map((key) => key.toLowerCase()).toList()..sort();
      final headerList = headerKeys.join(';');

      final paramKeys = params.keys.toList()..sort();
      final paramList = paramKeys.join(';');

      // 2. 构建 HttpString
      final httpString = [
        httpMethod.toLowerCase(),
        _getCanonicalPath(cosPath),
        _getCanonicalQueryString(params),
        _getCanonicalHeaders(headers),
        '',
      ].join('\n');

      AppLogger.debug('生成签名 HttpString: $httpString');

      // 3. 计算 StringToSign
      final sha1HttpString = _sha1(httpString);
      final stringToSign = ['sha1', signTime, sha1HttpString, ''].join('\n');

      AppLogger.debug('生成签名 StringToSign: $stringToSign');

      // 4. 计算签名
      final signKey = _hmacSha1(credentials.tmpSecretKey, keyTime);
      final signature = _hmacSha1(signKey, stringToSign);

      AppLogger.debug('生成签名 SignKey: $signKey, Signature: $signature');

      // 5. 构建授权头
      final authorization = [
        'q-sign-algorithm=sha1',
        'q-ak=${credentials.tmpSecretId}',
        'q-sign-time=$signTime',
        'q-key-time=$keyTime',
        'q-header-list=$headerList',
        'q-url-param-list=$paramList',
        'q-signature=$signature',
      ].join('&');

      // 6. 添加临时密钥 Token
      return {
        'Authorization': authorization,
        'x-cos-security-token': credentials.sessionToken,
      };
    } catch (e, s) {
      AppLogger.error('生成COS授权头失败', e, s);
      throw Exception('生成COS授权头失败: $e');
    }
  }

  /// 获取规范化的URI路径
  static String _getCanonicalPath(String cosPath) {
    if (!cosPath.startsWith('/')) {
      cosPath = '/$cosPath';
    }
    return cosPath;
  }

  /// 获取规范化的查询参数字符串
  static String _getCanonicalQueryString(Map<String, String> params) {
    if (params.isEmpty) return '';

    final queryParams = <String>[];
    final sortedKeys = params.keys.toList()..sort();

    for (final key in sortedKeys) {
      final value = params[key];
      if (value != null && value.isNotEmpty) {
        queryParams.add('${_urlEncode(key)}=${_urlEncode(value)}');
      } else {
        queryParams.add('${_urlEncode(key)}=');
      }
    }

    return queryParams.join('&');
  }

  /// 获取规范化的头部信息
  static String _getCanonicalHeaders(Map<String, String> headers) {
    if (headers.isEmpty) return '';

    final canonicalHeaders = <String>[];
    final sortedKeys =
        headers.keys.map((key) => key.toLowerCase()).toList()..sort();

    for (final key in sortedKeys) {
      final value =
          headers.entries
              .firstWhere(
                (entry) => entry.key.toLowerCase() == key,
                orElse: () => MapEntry(key, ''),
              )
              .value;

      canonicalHeaders.add('${_urlEncode(key)}=${_urlEncode(value.trim())}');
    }

    return canonicalHeaders.join('&');
  }

  /// 将请求字符串进行URL编码
  static String _urlEncode(String input) {
    final encoded = Uri.encodeComponent(input);
    return encoded
        .replaceAll('+', '%20')
        .replaceAll('*', '%2A')
        .replaceAll('%7E', '~');
  }

  /// 使用SHA1算法对字符串进行哈希
  static String _sha1(String input) {
    final bytes = utf8.encode(input);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  /// 使用HMAC-SHA1对字符串进行签名
  /// [key] 密钥
  /// [message] 要签名的消息
  static String _hmacSha1(String key, String message) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);
    final hmac = Hmac(sha1, keyBytes);
    final digest = hmac.convert(messageBytes);
    return digest.toString();
  }
}
