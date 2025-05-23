import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kiwi/domain/entities/file_entity.dart';
import 'package:kiwi/domain/repositories/file_repository.dart';
import 'package:kiwi/core/utils/logger.dart';
import 'package:file_picker/file_picker.dart';

/// 文件列表视图模型，负责管理文件数据的加载和状态
class FileViewModel extends ChangeNotifier {
  final FileRepository fileRepository;
  FileViewModel(this.fileRepository);

  List<FileEntity> _files = [];
  List<FileEntity> get files => _files;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;
  bool _uploading = false;
  bool get uploading => _uploading;

  /// 多文件上传进度与状态
  final Map<String, double> _fileProgress = {}; // 文件名->进度
  final Map<String, String?> _fileError = {}; // 文件名->错误
  Map<String, double> get fileProgress => _fileProgress;
  Map<String, String?> get fileError => _fileError;

  /// 加载文件列表
  Future<void> loadFiles({required int projectId, String path = '/'}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {

      AppLogger.info('FileViewModel: 加载文件列表 projectId=$projectId, path=$path');
      final result = await fileRepository.getFileList(
        projectId: projectId,
        path: path,
      );
      _files = result;
      AppLogger.debug('FileViewModel: 文件加载成功, count=${_files.length}');
    } catch (e, s) {
      _error = '加载文件失败: $e';
      AppLogger.error('FileViewModel: 加载文件失败', e, s);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// 上传文件列表到服务器（多文件并发上传，分别记录进度）
  Future<void> uploadFiles({
    required int projectId,
    required List<PlatformFile> files,
  }) async {
    if (files.isEmpty) return;
    _uploading = true;
    _error = null;
    _fileProgress.clear();
    _fileError.clear();
    notifyListeners();
    try {
      await Future.wait(
        files.map((f) async {
          if (f.path == null) {
            _fileError[f.name] = '文件路径无效';
            notifyListeners();
            return;
          }
          _fileProgress[f.name] = 0.0;
          _fileError[f.name] = null;
          notifyListeners();
          try {
            await for (final progress in fileRepository.uploadFile(
              localFile: f,
              projectId: projectId,
              fileName: f.name,
            )) {
              _fileProgress[f.name] = progress;
              notifyListeners();
            }
          } catch (e, s) {
            _fileError[f.name] = '上传失败: $e';
            AppLogger.error('FileViewModel: 文件上传异常', e, s);
            notifyListeners();
          }
        }),
      );
      AppLogger.info('FileViewModel: 文件全部上传完成');
      await loadFiles(projectId: projectId);
    } catch (e, s) {
      _error = '文件上传失败: $e';
      AppLogger.error('FileViewModel: 文件上传异常', e, s);
    } finally {
      _uploading = false;
      notifyListeners();
    }
  }
}
