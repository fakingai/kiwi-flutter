# 腾讯云COS直接上传实现

本文档介绍了如何在Flutter应用中使用Dio HTTP客户端直接调用腾讯云对象存储(COS)API实现文件上传，无需依赖官方`tencentcloud_cos_sdk_plugin`插件。

## 实现原理

直接使用Dio HTTP客户端调用腾讯云COS的REST API，实现文件上传功能。主要涉及以下几个部分：

1. **腾讯云COS签名生成**：使用`CosSignatureUtil`工具类生成API请求所需的授权签名
2. **数据源实现**：`CosDirectDatasource`类负责与COS服务进行直接交互
3. **仓库层**：`FileRepository`接口及其实现类`FileRepositoryImpl`封装了业务逻辑

## 主要类和功能

### 1. CosDirectDatasource

直接调用COS API的数据源类：

- `updateCredentials(CosCredentialsModel credentials)` - 更新临时凭证
- `uploadFile({File localFile, String cosPath, Function(double) onProgress})` - 上传文件并提供进度回调
- `getFileUrl({String cosPath, bool isHttps})` - 获取已上传文件的URL

### 2. CosSignatureUtil

生成腾讯云COS API请求所需签名的工具类：

- `generateAuthHeaders({credentials, httpMethod, cosPath, headers, params})` - 生成授权头信息

### 3. CosCredentialsModel

临时凭证数据模型：

- 包含临时密钥ID、密钥、会话Token、有效时间等信息
- 提供`isExpired()`方法检查凭证是否过期

## 使用方法

### 1. 初始化和配置

```dart
// 1. 获取临时凭证（通常从服务端获取）
final cosCredentials = await apiClient.fetchCosCredentials(projectId: 123);

// 2. 初始化数据源
final cosDirectDatasource = CosDirectDatasource(dio: Dio());
cosDirectDatasource.updateCredentials(cosCredentials);
```

### 2. 文件上传

```dart
// 上传本地文件
final file = File('/path/to/local/file.jpg');
final cosPath = 'uploads/example/file.jpg';

// 监听上传进度
await cosDirectDatasource.uploadFile(
  localFile: file,
  cosPath: cosPath,
  onProgress: (progress) {
    print('上传进度: ${(progress * 100).toStringAsFixed(2)}%');
  },
);
```

### 3. 获取文件URL

```dart
// 获取文件的URL
final fileUrl = cosDirectDatasource.getFileUrl(cosPath: cosPath);
print('文件URL: $fileUrl');
```

## 依赖项

- `dio: ^5.8.0+1` - HTTP客户端，用于API调用
- `path: ^1.9.0` - 文件路径处理
- `crypto: ^3.0.3` - 用于生成签名

## 相比官方SDK的优势

1. **更轻量**：无需引入额外的原生SDK依赖，减小应用体积
2. **更灵活**：可以完全控制上传流程和参数
3. **自定义错误处理**：可以根据应用需求定制错误处理逻辑
4. **更好的进度监控**：提供细粒度的上传进度回调

## 注意事项

1. **临时密钥安全**：请确保通过安全渠道获取临时凭证，如通过后端服务生成
2. **错误处理**：在生产环境中应完善错误处理逻辑
3. **签名算法**：确保签名算法与腾讯云COS最新规范保持一致

## 参考文档

- [腾讯云COS API文档](https://cloud.tencent.com/document/product/436/7751)
- [腾讯云COS签名算法](https://cloud.tencent.com/document/product/436/7778)
- [腾讯云COS-Flutter直接上传示例](https://github.com/TencentCloud/cos-sdk-flutter-plugin/blob/main/example_direct/lib/upload_dio.dart)
