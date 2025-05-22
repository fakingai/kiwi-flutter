import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kiwi/domain/repositories/file_repository.dart';
import 'package:kiwi/core/utils/logger.dart';

/// 文件上传状态ViewModel，支持进度和错误提示
class FileUploadViewModel extends ChangeNotifier {
  final FileRepository fileRepository;
  FileUploadViewModel(this.fileRepository);

  double _progress = 0.0;
  double get progress => _progress;

  bool _uploading = false;
  bool get uploading => _uploading;

  String? _error;
  String? get error => _error;

  Future<void> uploadFile({
    required File localFile,
    required int projectId,
    required String fileName,
  }) async {
    _uploading = true;
    _progress = 0.0;
    _error = null;
    notifyListeners();
    try {
      await for (final p in fileRepository.uploadFile(
        localFile: localFile,
        projectId: projectId,
        fileName: fileName,
      )) {
        _progress = p;
        notifyListeners();
      }
      AppLogger.info('文件上传成功: $fileName');
    } catch (e, s) {
      _error = '上传失败';
      AppLogger.error('文件上传异常', e, s);
    } finally {
      _uploading = false;
      notifyListeners();
    }
  }
}
