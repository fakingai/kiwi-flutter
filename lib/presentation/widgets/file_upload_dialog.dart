import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/app/viewmodels/file_viewmodel.dart';
import 'package:kiwi/core/utils/logger.dart';

/// 文件上传弹窗，支持多文件选择和上传
class FileUploadDialog extends StatefulWidget {
  final int projectId;
  const FileUploadDialog({super.key, required this.projectId});

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  List<PlatformFile> _selectedFiles = [];
  String? _error;

  /// 选择文件
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFiles = result.files;
          _error = null;
        });
        AppLogger.info('选择文件: ${_selectedFiles.map((e) => e.name).join(", ")}');
      }
    } catch (e, s) {
      setState(() {
        _error = '文件选择失败';
      });
      AppLogger.error('文件选择异常', e, s);
    }
  }

  /// 上传文件
  Future<void> _uploadFiles(FileViewModel vm) async {
    if (_selectedFiles.isEmpty) {
      setState(() {
        _error = '请先选择文件';
      });
      return;
    }
    setState(() {
      _error = null;
    });
    await vm.uploadFiles(projectId: widget.projectId, files: _selectedFiles);
    if (vm.error == null && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<FileViewModel>.value(
      value: context.read<FileViewModel>(),
      child: Consumer<FileViewModel>(
        builder: (context, vm, _) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.upload_file, size: 22),
                        const SizedBox(width: 8),
                        Text('上传文件', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('选择文件'),
                      onPressed: vm.uploading ? null : _pickFiles,
                    ),
                    const SizedBox(height: 12),
                    if (_selectedFiles.isNotEmpty)
                      SizedBox(
                        height: 120,
                        child: ListView(
                          children:
                              _selectedFiles.asMap().entries.map((entry) {
                                final i = entry.key;
                                final f = entry.value;
                                final progress = vm.fileProgress[f.name] ?? 0.0;
                                final error = vm.fileError[f.name];
                                return ListTile(
                                  leading: const Icon(Icons.insert_drive_file),
                                  title: Text(f.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${(f.size / 1024).toStringAsFixed(1)} KB',
                                      ),
                                      if (vm.uploading)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 4,
                                          ),
                                        ),
                                      if (error != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            error,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.redAccent,
                                    ),
                                    tooltip: '移除',
                                    onPressed:
                                        vm.uploading
                                            ? null
                                            : () {
                                              setState(() {
                                                _selectedFiles.removeAt(i);
                                              });
                                            },
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    if (_error != null || vm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error ?? vm.error ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (vm.uploading && _selectedFiles.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          '正在上传 ${vm.fileProgress.values.where((p) => p >= 1.0).length}/${_selectedFiles.length} 个文件',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    if (vm.uploading)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: LinearProgressIndicator(
                          value: vm.uploadProgress,
                          minHeight: 6,
                        ),
                      ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              vm.uploading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                          child: const Text('取消'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed:
                              vm.uploading ? null : () => _uploadFiles(vm),
                          child:
                              vm.uploading
                                  ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text('上传'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
