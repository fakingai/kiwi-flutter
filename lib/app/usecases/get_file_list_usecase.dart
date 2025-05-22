import 'package:kiwi/domain/entities/file_entity.dart';
import 'package:kiwi/domain/repositories/file_repository.dart';

/// 获取文件列表用例
class GetFileListUseCase {
  final FileRepository repository;
  GetFileListUseCase(this.repository);

  Future<List<FileEntity>> call({required int projectId, String path = '/'}) {
    return repository.getFileList(projectId: projectId, path: path);
  }
}
