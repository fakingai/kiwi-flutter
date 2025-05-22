// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/domain/entities/project_entity.dart
import 'package:equatable/equatable.dart';
import 'package:kiwi/domain/entities/user_entity.dart';

/// 业务实体，代表核心业务对象 - 项目
class ProjectEntity extends Equatable {
  final int id;
  final String name;
  final String? ossPathPrefix;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? creator; // 关联的用户实体

  const ProjectEntity({
    required this.id,
    required this.name,
    this.creator,
    this.ossPathPrefix,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    ossPathPrefix,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
