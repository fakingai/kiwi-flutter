import 'package:equatable/equatable.dart';

/// 业务实体：项目文件
class FileEntity extends Equatable {
  final int id;
  final int projectId;
  final String mimeType; // 文件类型
  final String name;
  final String type;
  final int size;
  final String? updatedAt;
  final String? status;
  final double? progress;

  const FileEntity({
    required this.id,
    required this.projectId,
    required this.mimeType,
    required this.name,
    required this.type,
    required this.size,
    this.updatedAt,
    this.status,
    this.progress,
  });

  @override
  List<Object?> get props => [
    id,
    projectId,
    name,
    type,
    size,
    updatedAt,
    status,
    progress,
  ];
}
