import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiwi/data/models/cos_credentials_model.dart';
import 'package:kiwi/core/utils/logger.dart';

/// COS 凭证本地存储数据源接口
abstract class CosCredentialsLocalDataSource {
  /// 存储 COS 凭证
  Future<void> cacheCosCredentials(
    int projectId,
    CosCredentialsModel credentials,
  );

  /// 获取项目对应的 COS 凭证
  Future<CosCredentialsModel?> getCosCredentials(int projectId);

  /// 清除指定项目的 COS 凭证
  Future<void> clearCosCredentials(int projectId);

  /// 清除所有 COS 凭证
  Future<void> clearAllCosCredentials();
}

/// COS 凭证本地存储数据源实现
class CosCredentialsLocalDataSourceImpl
    implements CosCredentialsLocalDataSource {
  final SharedPreferences sharedPreferences;

  // 构造COS凭证缓存键的前缀
  static const String _cosCredentialKeyPrefix = 'COS_CREDENTIALS_';

  CosCredentialsLocalDataSourceImpl({required this.sharedPreferences});

  /// 为项目ID生成存储键
  String _generateKey(int projectId) {
    return '$_cosCredentialKeyPrefix$projectId';
  }

  @override
  Future<void> cacheCosCredentials(
    int projectId,
    CosCredentialsModel credentials,
  ) async {
    try {
      final String serializedCredentials = json.encode(credentials.toJson());
      final bool result = await sharedPreferences.setString(
        _generateKey(projectId),
        serializedCredentials,
      );

      if (result) {
        AppLogger.info('已缓存项目 $projectId 的 COS 凭证');
      } else {
        AppLogger.warning('缓存项目 $projectId 的 COS 凭证失败');
      }
    } catch (e, s) {
      AppLogger.error('缓存 COS 凭证时发生错误', e, s);
      // 不抛出异常，避免影响主流程
    }
  }

  @override
  Future<CosCredentialsModel?> getCosCredentials(int projectId) async {
    try {
      final String? serializedData = sharedPreferences.getString(
        _generateKey(projectId),
      );
      if (serializedData == null) {
        AppLogger.info('本地未找到项目 $projectId 的 COS 凭证');
        return null;
      }

      final Map<String, dynamic> jsonMap = json.decode(serializedData);
      final credentials = CosCredentialsModel.fromJson(jsonMap);

      // 如果凭证已过期，返回null
      if (credentials.isExpired()) {
        AppLogger.info('项目 $projectId 的 COS 凭证已过期');
        return null;
      }

      AppLogger.info('从本地获取项目 $projectId 的 COS 凭证成功');
      return credentials;
    } catch (e, s) {
      AppLogger.error('获取本地 COS 凭证时发生错误', e, s);
      return null; // 出错时返回null，让调用方从网络重新获取
    }
  }

  @override
  Future<void> clearCosCredentials(int projectId) async {
    try {
      final result = await sharedPreferences.remove(_generateKey(projectId));
      if (result) {
        AppLogger.info('已清除项目 $projectId 的 COS 凭证缓存');
      } else {
        AppLogger.warning('清除项目 $projectId 的 COS 凭证缓存失败');
      }
    } catch (e, s) {
      AppLogger.error('清除 COS 凭证缓存时发生错误', e, s);
    }
  }

  @override
  Future<void> clearAllCosCredentials() async {
    try {
      // 获取所有键
      final allKeys = sharedPreferences.getKeys();

      // 过滤出COS凭证相关的键
      final cosKeys =
          allKeys
              .where((key) => key.startsWith(_cosCredentialKeyPrefix))
              .toList();

      // 删除所有COS凭证
      for (final key in cosKeys) {
        await sharedPreferences.remove(key);
      }

      AppLogger.info('已清除所有 COS 凭证缓存，共 ${cosKeys.length} 项');
    } catch (e, s) {
      AppLogger.error('清除所有 COS 凭证缓存时发生错误', e, s);
    }
  }
}
