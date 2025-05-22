import 'package:dio/dio.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:kiwi/data/models/file_model.dart';
import 'package:kiwi/data/models/cos_credentials_model.dart';

/// 远程数据源接口
abstract class FileRemoteDataSource {
  /// 获取文件列表
  Future<List<FileModel>> fetchFileList({
    required int projectId,
    String path = '/',
  });

  /// 获取COS上传凭证
  Future<CosCredentialsModel> fetchCosCredentials({required int projectId});

  /// 上报文件上传完成结果
  Future<void> reportUploadCompletion({
    required int projectId,
    required String fileName,
    required String fileType,
    required int fileSize,
    required String ossObjectKey,
    required String etag,
  });
}

/// 远程数据源实现
class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final Dio dio;
  FileRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<FileModel>> fetchFileList({
    required int projectId,
    String path = '/',
  }) async {
    try {
      AppLogger.info('请求文件列表: projectId=$projectId, path=$path');
      final response = await dio.get(
        '/api/files',
        queryParameters: {'project_id': projectId, 'path': path},
      );
      if (response.data['data'] == null) {
        return [];
      }
      return (response.data['data'] as List)
          .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      AppLogger.error('获取文件列表失败', e, s);
      rethrow;
    }
  }

  @override
  Future<CosCredentialsModel> fetchCosCredentials({
    required int projectId,
  }) async {
    try {
      AppLogger.info('获取COS上传凭证: projectId=$projectId');
      final response = await dio.get(
        '/api/files/upload/credentials',
        queryParameters: {'project_id': projectId},
      );

      return CosCredentialsModel.fromJson(response.data['data']);
    } catch (e, s) {
      AppLogger.error('获取COS上传凭证失败', e, s);
      rethrow;
    }
  }

  @override
  Future<void> reportUploadCompletion({
    required int projectId,
    required String fileName,
    required String fileType,
    required int fileSize,
    required String ossObjectKey,
    required String etag,
  }) async {
    try {
      AppLogger.info('上报文件上传完成: fileName=$fileName, projectId=$projectId');

      await dio.post(
        '/api/files/upload/complete',
        queryParameters: {'project_id': projectId},
        data: {
          'file_name': fileName,
          'file_size': fileSize,
          'file_type': fileType,
          'oss_object_key': ossObjectKey,
          'etag': etag,
        },
      );
      AppLogger.info('成功上报文件上传完成: $fileName');
    } catch (e, s) {
      AppLogger.error('上报文件上传完成失败', e, s);
      rethrow;
    }
  }
}
