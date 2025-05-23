import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/core/utils/cos_signature_util.dart';
import 'package:kiwi/domain/entities/cos_credentials_entity.dart';
import 'package:kiwi/domain/entities/cos_upload_result_entity.dart';

/// 腾讯云 COS 远程数据源，使用 Dio 直接调用 API 实现文件上传
class CosDirectDatasource {
  final Dio dio;

  CosDirectDatasource({required this.dio});

  /// 上传文件到 COS
  /// [localFile] 本地文件
  /// [cosPath] COS 目标路径 (对象键)
  /// [onProgress] 上传进度回调 (0.0~1.0)
  Future<CosUploadResultEntity> uploadFile({
    required CosCredentialsEntity credentials,
    required PlatformFile localFile,
    required String cosPath,
    required void Function(double progress) onProgress,
  }) async {
    try {
      // 确保cosPath不以/开头，符合COS路径规则
      var normalizedCosPath =
          credentials.userPath.startsWith('/')
              ? credentials.userPath
              : "/${credentials.userPath}";
      normalizedCosPath +=
          cosPath.startsWith('/') ? cosPath.substring(1) : cosPath;

      // COS相关参数
      final url = credentials.host + normalizedCosPath;

      // 获取文件信息
      final fileSize = localFile.size;
      final contentType = _getContentType(localFile.name);

      // 构建自定义请求头
      final customHeaders = {'Content-Type': contentType};

      // 使用工具类生成授权头信息
      final authHeaders = CosSignatureUtil.generateAuthHeaders(
        credentials: credentials.credentials,
        httpMethod: 'PUT',
        cosPath: normalizedCosPath,
      );

      // 合并所有请求头
      final headers = {
        'Content-Length': fileSize.toString(),
        ...customHeaders,
        ...authHeaders,
      };

      // 构建请求选项
      final options = Options(
        method: 'PUT',
        headers: headers,
        responseType: ResponseType.json,
        followRedirects: false,
      );

      // 创建上传监听器，以报告进度
      AppLogger.info(
        '开始上传文件到 COS: $normalizedCosPath (大小: ${_formatFileSize(fileSize)})',
      );

      AppLogger.debug('上传URL: $url');

      // 准备上传数据
      dynamic uploadData;

      if (localFile.readStream == null &&
          localFile.bytes == null &&
          localFile.path != null) {
        if (localFile.path!.startsWith('data:')) {
          // 解析 data URL
          final dataUrl = localFile.path!;
          final isBase64 = dataUrl.contains('base64');

          if (isBase64) {
            // 分离数据部分和头部
            final commaIndex = dataUrl.indexOf(',');
            if (commaIndex != -1) {
              final base64Data = dataUrl.substring(commaIndex + 1);
              // 将base64转换为Uint8List
              final bytes = base64Decode(base64Data);
              uploadData = bytes;
              AppLogger.debug('Web平台：已从base64解析文件数据，大小: ${bytes.length} bytes');
            } else {
              throw Exception('无法解析base64数据URL');
            }
          } else {
            throw Exception('不支持非base64编码的数据URL');
          }
        } else {
          // 读取本地文件
          final file = File(localFile.path!);
          uploadData = file.openRead();
        }
      }

      // 执行上传
      final response = await dio.put(
        url,
        data: localFile.readStream ?? localFile.bytes ?? uploadData,
        options: options,
        onSendProgress: (count, total) {
          if (total > 0) {
            final progress = count / total;
            onProgress(progress);
            if (count % max(1, total ~/ 10) == 0 || count == total) {
              AppLogger.debug(
                '上传进度: ${(progress * 100).toStringAsFixed(2)}% ($count/$total bytes)',
              );
            }
          }
        },
      );

      // 检查响应
      if (response.statusCode == 200) {
        String? etag = response.headers.value('ETag');
        if (etag != null &&
            etag.startsWith('"') &&
            etag.endsWith('"') &&
            etag.length >= 2) {
          etag = etag.substring(1, etag.length - 1);
        }
        AppLogger.info('COS 上传成功: $normalizedCosPath, ETag: ${etag ?? "未知"}');
        return CosUploadResultEntity(
          etag: etag ?? '',
          cosPath: normalizedCosPath,
        );
      } else {
        throw Exception(
          'COS 上传失败: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } catch (e, s) {
      AppLogger.error('COS 上传失败', e, s);
      rethrow;
    }
  }

  /// 获取文件的内容类型
  String _getContentType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'html':
      case 'htm':
        return 'text/html';
      case 'css':
        return 'text/css';
      case 'js':
        return 'application/javascript';
      case 'json':
        return 'application/json';
      case 'xml':
        return 'application/xml';
      case 'mp3':
        return 'audio/mpeg';
      case 'mp4':
        return 'video/mp4';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      default:
        return 'application/octet-stream';
    }
  }

  /// 格式化文件大小为人类可读的形式
  String _formatFileSize(int sizeInBytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    if (sizeInBytes == 0) return '0 B';

    final i = (log(sizeInBytes) / log(1024)).floor();
    final size = sizeInBytes / pow(1024, i);

    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
