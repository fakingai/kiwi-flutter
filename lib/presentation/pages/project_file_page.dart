import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/app/viewmodels/file_viewmodel.dart';
import 'package:kiwi/domain/entities/file_entity.dart';
import 'package:kiwi/domain/entities/project_entity.dart';
import 'package:kiwi/core/di/di.dart';
import 'package:kiwi/core/utils/utils.dart';
import 'package:kiwi/presentation/widgets/file_upload_dialog.dart';

/// 项目内容管理页面
class ProjectFilePage extends StatefulWidget {
  final ProjectEntity project;
  const ProjectFilePage({super.key, required this.project});

  @override
  State<ProjectFilePage> createState() => _ProjectFilePageState();
}

class _ProjectFilePageState extends State<ProjectFilePage> {
  String _selectedType = 'all';
  String _searchText = '';

  void _onTabSelected(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<FileViewModel>(
      create:
          (_) =>
              sl<FileViewModel>()..loadFiles(
                projectId: int.tryParse(widget.project.id.toString()) ?? 1,
              ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Column(
          children: [
            // 顶部导航栏
            _Header(project: widget.project),
            // 主体内容
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // 工具栏（标签、搜索、添加按钮）
                    _Toolbar(
                      selectedType: _selectedType,
                      onTabSelected: _onTabSelected,
                      searchText: _searchText,
                      onSearchChanged: _onSearchChanged,
                    ),
                    const SizedBox(height: 16),
                    // 文件表格头
                    _TableHeader(),
                    // 文件列表
                    Expanded(
                      child: _FileList(
                        selectedType: _selectedType,
                        searchText: _searchText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 顶部导航栏组件
class _Header extends StatelessWidget {
  final ProjectEntity project;
  const _Header({required this.project});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 返回上一级按钮
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  '所有项目',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                project.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '内容管理',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              side: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {},
            icon: const Icon(Icons.settings, size: 20),
            label: const Text('设置', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

/// 工具栏（标签、搜索、添加按钮）
class _Toolbar extends StatelessWidget {
  final String selectedType;
  final void Function(String type) onTabSelected;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  const _Toolbar({
    this.selectedType = 'all',
    required this.onTabSelected,
    this.searchText = '',
    required this.onSearchChanged,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 标签
        Row(
          children: [
            _TabButton(
              label: '全部',
              selected: selectedType == 'all',
              onTap: () => onTabSelected('all'),
            ),
            _TabButton(
              label: '文档',
              selected: selectedType == 'file',
              onTap: () => onTabSelected('file'),
            ),
            _TabButton(
              label: '图片',
              selected: selectedType == 'image',
              onTap: () => onTabSelected('image'),
            ),
            _TabButton(
              label: '代码',
              selected: selectedType == 'code',
              onTap: () => onTabSelected('code'),
            ),
          ],
        ),
        // 搜索框 + 添加按钮
        Row(
          children: [
            Container(
              width: 230,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(
                  color:
                      FocusScope.of(context).hasFocus
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: FocusScope(
                child: Builder(
                  builder:
                      (ctx) => Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.search,
                              color: theme.iconTheme.color?.withOpacity(0.35),
                              size: 18,
                            ),
                          ),
                          Expanded(
                            child: Focus(
                              child: TextField(
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: '搜索内容...',
                                  hintStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(color: theme.hintColor),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                onChanged: onSearchChanged,
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: searchText,
                                    selection: TextSelection.collapsed(
                                      offset: searchText.length,
                                    ),
                                  ),
                                ),
                              ),
                              onFocusChange: (hasFocus) {
                                // 触发外层 Container 重新 build 以更新边框色
                                (ctx as Element).markNeedsBuild();
                              },
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 0,
              ),
              onPressed: () async {
                final project =
                    context
                        .findAncestorWidgetOfExactType<ProjectFilePage>()
                        ?.project;
                if (project == null) return;
                final result = await showDialog(
                  context: context,
                  builder:
                      (ctx) => ChangeNotifierProvider.value(
                        value: Provider.of<FileViewModel>(
                          context,
                          listen: false,
                        ),
                        child: FileUploadDialog(
                          projectId: int.tryParse(project.id.toString()) ?? 1,
                        ),
                      ),
                );
                if (result == true) {
                  // 上传成功后刷新文件列表
                  Provider.of<FileViewModel>(context, listen: false).loadFiles(
                    projectId: int.tryParse(project.id.toString()) ?? 1,
                  );
                }
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('添加内容', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _TabButton({required this.label, this.selected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              selected
                  ? theme.colorScheme.primary.withOpacity(0.08)
                  : Colors.transparent,
          foregroundColor:
              selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
          side:
              selected
                  ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                  : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// 文件表格头
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '文件名',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '类型',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '更新时间',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '大小',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '向量化状态',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 40), // 操作按钮宽度
        ],
      ),
    );
  }
}

/// 文件列表（通过FileViewModel管理）
class _FileList extends StatelessWidget {
  final String selectedType;
  final String searchText;
  const _FileList({this.selectedType = 'all', this.searchText = ''});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<FileViewModel>(
      builder: (context, vm, _) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(
            child: Text(
              vm.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        var files =
            selectedType == 'all'
                ? vm.files
                : vm.files.where((f) => f.type == selectedType).toList();
        if (searchText.isNotEmpty) {
          files =
              files
                  .where(
                    (f) =>
                        f.name.toLowerCase().contains(searchText.toLowerCase()),
                  )
                  .toList();
        }
        if (files.isEmpty) {
          return Center(
            child: Text(
              '暂无文件',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.85),
                fontWeight: FontWeight.w500,
                fontSize: 15,
                shadows: [Shadow(color: Colors.black26, blurRadius: 1)],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.separated(
          itemCount: files.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder:
              (context, i) => _FileRow(data: _FileRowData.fromEntity(files[i])),
        );
      },
    );
  }
}

/// 文件行数据结构（支持从FileEntity转换）
class _FileRowData {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String type;
  final String updated;
  final String size;
  final _FileStatus status;
  final double? progress;
  _FileRowData({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.type,
    required this.updated,
    required this.size,
    required this.status,
    this.progress,
  });

  /// 从FileEntity转换
  factory _FileRowData.fromEntity(FileEntity entity) {
    // 图标和颜色可根据类型自定义
    IconData icon;
    Color iconColor;
    switch (entity.type.toLowerCase()) {
      case 'code':
        icon = Icons.code;
        iconColor = Colors.yellow;
        break;
      case 'file':
        icon = Icons.description_outlined;
        iconColor = Colors.blue;
        break;
      case 'image':
        icon = Icons.image_outlined;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }
    // 状态映射
    _FileStatus status;
    switch (entity.status) {
      case 'completed':
        status = _FileStatus.completed;
        break;
      case 'in_progress':
        status = _FileStatus.inProgress;
        break;
      case 'pending':
        status = _FileStatus.pending;
        break;
      case 'failed':
        status = _FileStatus.failed;
        break;
      default:
        status = _FileStatus.completed;
    }
    // 更新时间、大小格式化可根据实际API调整
    return _FileRowData(
      icon: icon,
      iconColor: iconColor,
      name: entity.name,
      type: entity.mimeType,
      updated: formatDateTime(entity.updatedAt), // 使用工具方法格式化时间
      size: formatBytes(entity.size, 2),
      status: status,
      progress: entity.progress,
    );
  }
}

enum _FileStatus { completed, inProgress, pending, failed }

/// 单行文件展示
class _FileRow extends StatelessWidget {
  final _FileRowData data;
  const _FileRow({required this.data});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(6),
      hoverColor: theme.colorScheme.primary.withOpacity(0.04),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            // 文件名及图标
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(data.icon, color: data.iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      data.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 类型
            Expanded(
              flex: 1,
              child: Text(
                data.type,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ),
            // 更新时间
            Expanded(
              flex: 3,
              child: Text(
                data.updated,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
            // 大小
            Expanded(
              flex: 1,
              child: Text(
                data.size,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
            // 向量化状态
            Expanded(flex: 2, child: _buildStatus(theme)),
            // 操作按钮
            SizedBox(
              width: 40,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: theme.iconTheme.color?.withOpacity(0.3),
                ),
                onPressed: () {},
                tooltip: '更多',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建向量化状态区域
  Widget _buildStatus(ThemeData theme) {
    switch (data.status) {
      case _FileStatus.completed:
        return Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.secondary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '已完成',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        );
      case _FileStatus.inProgress:
        return Row(
          children: [
            Icon(Icons.autorenew, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              '处理中',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: data.progress ?? 0.0,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${((data.progress ?? 0.0) * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        );
      case _FileStatus.pending:
        return Row(
          children: [
            Icon(
              Icons.access_time,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '待处理',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        );
      case _FileStatus.failed:
        return Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: theme.colorScheme.error,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '失败',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        );
    }
  }
}
