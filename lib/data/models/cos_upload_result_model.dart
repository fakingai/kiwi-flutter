import 'package:equatable/equatable.dart';

/// COS 上传结果数据模型
class CosUploadResultModel extends Equatable {
  /// 对象在 COS 中的完整路径
  final String cosPath;

  /// 对象的 ETag，可用于后续校验
  final String etag;

  const CosUploadResultModel({required this.cosPath, required this.etag});

  @override
  List<Object?> get props => [cosPath, etag];

  /// 转为 JSON
  Map<String, dynamic> toJson() => {'cosPath': cosPath, 'etag': etag};

  /// 从 JSON 构造
  factory CosUploadResultModel.fromJson(Map<String, dynamic> json) {
    return CosUploadResultModel(
      cosPath: json['cosPath'] as String,
      etag: json['etag'] as String,
    );
  }
}
