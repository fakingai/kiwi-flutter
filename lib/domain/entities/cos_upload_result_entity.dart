/// COS 上传结果实体
class CosUploadResultEntity {
  /// 对象在 COS 中的完整路径
  final String cosPath;

  /// 对象的 ETag，可用于后续校验
  final String etag;

  const CosUploadResultEntity({required this.cosPath, required this.etag});
}
