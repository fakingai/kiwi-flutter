import 'package:file_picker/file_picker.dart';

import '../entities/file_entity.dart';

/// 文件仓库接口，定义文件相关数据操作
abstract class FileRepository {
  /// 获取项目下指定路径的文件列表
  Future<List<FileEntity>> getFileList({
    required int projectId,
    String path = '/',
  });

  /// 上传文件，返回上传进度流和最终的上传结果
  /// projectId 用于获取上传凭证，内部会自动处理凭证的获取和更新
  ///
  /// 返回的 Stream<double> 表示上传进度 (0.0~1.0)
  Stream<double> uploadFile({
    required PlatformFile localFile,
    required int projectId,
    required String fileName,
  });
}
