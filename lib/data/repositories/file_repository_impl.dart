import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:kiwi/domain/entities/file_entity.dart';
import 'package:kiwi/domain/entities/cos_credentials_entity.dart';
import 'package:kiwi/domain/entities/cos_upload_result_entity.dart';
import 'package:kiwi/domain/repositories/file_repository.dart';
import 'package:kiwi/data/datasources/remote/file_remote_datasource.dart';
import 'package:kiwi/data/datasources/remote/cos_direct_datasource.dart';
import 'package:kiwi/data/datasources/local/cos_credentials_local_datasource.dart';
import 'package:kiwi/data/models/file_model.dart';
import 'package:kiwi/data/models/cos_credentials_model.dart';
import 'package:kiwi/core/utils/logger.dart';

/// 文件仓库实现，负责将数据模型转换为业务实体，并支持COS上传
class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remoteDataSource;
  final CosDirectDatasource cosDirectDatasource;
  final CosCredentialsLocalDataSource localDataSource;

  // 存储最近一次上传结果，格式为：{projectId_fileName: CosUploadResultEntity}
  final Map<String, CosUploadResultEntity> _lastUploadResults = {};

  FileRepositoryImpl(
    this.remoteDataSource,
    this.cosDirectDatasource,
    this.localDataSource,
  );

  @override
  Future<List<FileEntity>> getFileList({
    required int projectId,
    String path = '/',
  }) async {
    final models = await remoteDataSource.fetchFileList(
      projectId: projectId,
      path: path,
    );
    return models
        .map(
          (FileModel m) => FileEntity(
            id: m.id,
            projectId: m.projectId,
            mimeType: m.mimeType,
            name: m.name,
            type: m.type,
            size: m.size,
            updatedAt: m.updatedAt,
            status: m.status,
            progress: m.progress,
          ),
        )
        .toList();
  }

  @override
  Stream<double> uploadFile({
    required PlatformFile localFile,
    required int projectId,
    required String fileName,
  }) async* {
    try {
      AppLogger.info('开始上传文件: fileName=$fileName, projectId=$projectId');

      // 1. 确保COS凭证有效，如果无效则获取新凭证
      CosCredentialsEntity cosCredentialsEntity = await fetchCosCredentials(
        projectId: projectId,
      );

      final cosPath = fileName
          .replaceAll(RegExp(r'[/\\:*?"<>|]'), '_')
          .replaceAll(' ', '_');
      AppLogger.debug('生成的COS路径: $cosPath');

      // 3. 执行上传并返回进度流
      yield* Stream<double>.multi((controller) async {
        CosUploadResultEntity cosUploadResultEntity = await cosDirectDatasource
            .uploadFile(
              credentials: cosCredentialsEntity,
              localFile: localFile,
              cosPath: cosPath,
              onProgress: (progress) {
                controller.add(progress);
              },
            );

        // 4. 上传完成后，上报上传结果
        try {
          // 获取文件大小和类型
          final fileSize = localFile.size;
          final fileType = fileName.split('.').last.toLowerCase();

          // 上报上传结果
          await remoteDataSource.reportUploadCompletion(
            projectId: projectId,
            fileName: fileName,
            fileType: fileType,
            fileSize: fileSize,
            ossObjectKey: cosUploadResultEntity.cosPath,
            etag: cosUploadResultEntity.etag,
          );

          // 保存最近的上传结果
          final key = '${projectId}_$fileName';
          _lastUploadResults[key] = cosUploadResultEntity;

          AppLogger.info('文件上传并上报成功: $fileName');
        } catch (reportError, reportStack) {
          AppLogger.error('上传成功但上报失败', reportError, reportStack);
        }

        controller.close();
      });
    } catch (e, s) {
      AppLogger.error('文件上传失败', e, s);
      rethrow;
    }
  }

  Future<CosCredentialsEntity> fetchCosCredentials({
    required int projectId,
  }) async {
    try {
      AppLogger.info('获取COS凭证: projectId=$projectId');

      // 1. 尝试从本地获取凭证
      final localCredentials = await localDataSource.getCosCredentials(
        projectId,
      );

      // 2. 如果本地凭证存在且未过期，直接使用
      if (localCredentials != null && !localCredentials.isExpired()) {
        AppLogger.info('使用本地缓存的COS凭证');

        // 将Model转换为Entity
        return _convertModelToEntity(localCredentials);
      }

      // 3. 本地凭证不存在或已过期，从远程获取
      AppLogger.info('从服务器获取新的COS凭证');
      final remoteCredentials = await remoteDataSource.fetchCosCredentials(
        projectId: projectId,
      );

      // 4. 缓存新凭证到本地
      await localDataSource.cacheCosCredentials(projectId, remoteCredentials);

      // 5. 将Model转换为Entity
      return _convertModelToEntity(remoteCredentials);
    } catch (e, s) {
      AppLogger.error('获取COS凭证失败', e, s);
      rethrow;
    }
  }

  // 将COS凭证模型转换为实体
  CosCredentialsEntity _convertModelToEntity(CosCredentialsModel model) {
    return CosCredentialsEntity(
      bucket: model.bucket,
      region: model.region,
      host: model.host,
      userPath: model.userPath,
      directoryId: model.directoryId,
      credentials: CredentialsEntity(
        expiredTime: model.credentials.expiredTime,
        sessionToken: model.credentials.sessionToken,
        tmpSecretId: model.credentials.tmpSecretId,
        tmpSecretKey: model.credentials.tmpSecretKey,
      ),
    );
  }
}
