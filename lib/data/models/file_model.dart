import 'package:equatable/equatable.dart';

/// 文件数据模型，对应后端 /api/files/list 接口返回的文件信息
class FileModel extends Equatable {
  final int id; // 文件ID
  final int projectId; // 项目ID
  final String name;
  final String type;
  final String mimeType; // 文件类型
  final int size;
  final String? updatedAt;
  final String? status; // 向量化状态，可选
  final double? progress; // 进度，可选

  const FileModel({
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

  /// 从 JSON 构造 FileModel
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      mimeType: json['mime_type'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
      updatedAt: json['updated_at'] as String?,
      status: json['status'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': projectId,
    'mime_type': mimeType,
    'name': name,
    'type': type,
    'size': size,
    'updated_at': updatedAt,
    if (status != null) 'status': status,
    if (progress != null) 'progress': progress,
  };

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
