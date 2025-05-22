// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/data/models/project_model.dart
import 'package:kiwi/data/models/user_model.dart';
import 'package:kiwi/domain/entities/project_entity.dart'; // Ensure ProjectEntity is correctly defined and imported

/// 项目数据模型，用于数据传输，继承自ProjectEntity
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    super.creator,
    super.ossPathPrefix,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  });

  /// 从JSON数据创建ProjectModel实例
  /// 返回一个 ProjectModel 实例。
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0, // API可能返回int或string, 做兼容处理
      name: json['name'] as String? ?? '',
      ossPathPrefix: json['oss_path_prefix'] as String?,
      createdBy: json['created_by'] as String?,
      creator:
          json['creator'] != null
              ? UserModel(
                id: json['creator']['id'] as String,
                email: json['creator']['email'] as String,
                token: '',
              )
              : null,
      createdAt:
          json['created_at'] != null && json['created_at'] is String
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null && json['updated_at'] is String
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  }

  /// 将ProjectModel实例转换为JSON数据
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'oss_path_prefix': ossPathPrefix,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
