/// COS 临时凭证实体，用于存储从服务端获取的临时访问密钥
class CosCredentialsEntity {
  final String bucket;
  final CredentialsEntity credentials;
  final int directoryId;
  final String host;
  final String region;
  final String userPath;

  CosCredentialsEntity({
    required this.bucket,
    required this.credentials,
    required this.directoryId,
    required this.host,
    required this.region,
    required this.userPath,
  });

  /// 检查凭证是否过期
  bool isExpired() {
    // 提前5分钟判断过期，避免使用即将过期的凭证
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= (credentials.expiredTime - 300);
  }
}

/// COS 凭证信息实体
class CredentialsEntity {
  final int expiredTime;
  final String sessionToken;
  final String tmpSecretId;
  final String tmpSecretKey;

  CredentialsEntity({
    required this.expiredTime,
    required this.sessionToken,
    required this.tmpSecretId,
    required this.tmpSecretKey,
  });
}
