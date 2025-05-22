// COS 临时凭证模型

/// COS 临时凭证模型，用于存储从服务端获取的临时访问密钥
class CosCredentialsModel {
  final String bucket;
  final Credentials credentials;
  final int directoryId;
  final String host;
  final String region;
  final String userPath;

  CosCredentialsModel({
    required this.bucket,
    required this.credentials,
    required this.directoryId,
    required this.host,
    required this.region,
    required this.userPath,
  });

  /// 从 JSON 构造 COS 凭证模型
  factory CosCredentialsModel.fromJson(Map<String, dynamic> json) {
    return CosCredentialsModel(
      bucket: json['bucket'],
      credentials: Credentials.fromJson(json['credentials']),
      directoryId: json['directory_id'],
      host: json['host'],
      region: json['region'],
      userPath: json['user_path'],
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'bucket': bucket,
      'credentials': credentials.toJson(),
      'directory_id': directoryId,
      'host': host,
      'region': region,
      'user_path': userPath,
    };
  }

  /// 检查凭证是否过期
  bool isExpired() {
    // 提前5分钟判断过期，避免使用即将过期的凭证
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= (credentials.expiredTime - 300);
  }
}

/// COS 凭证信息模型
class Credentials {
  final int expiredTime;
  final String sessionToken;
  final String tmpSecretId;
  final String tmpSecretKey;

  Credentials({
    required this.expiredTime,
    required this.sessionToken,
    required this.tmpSecretId,
    required this.tmpSecretKey,
  });

  /// 从 JSON 构造凭证信息
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
      expiredTime: json['expired_time'],
      sessionToken: json['session_token'],
      tmpSecretId: json['tmp_secret_id'],
      tmpSecretKey: json['tmp_secret_key'],
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'expired_time': expiredTime,
      'session_token': sessionToken,
      'tmp_secret_id': tmpSecretId,
      'tmp_secret_key': tmpSecretKey,
    };
  }
}
