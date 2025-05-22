import 'package:flutter/material.dart';

/// 状态类型枚举
enum StatusType {
  /// 成功
  success,

  /// 处理中
  processing,

  /// 等待中
  pending,

  /// 失败
  error,
}

/// 企业风格状态指示器组件
class StatusIndicator extends StatelessWidget {
  final StatusType type;
  final String? label;
  final double? progress;
  final double size;

  /// 创建一个企业风格状态指示器
  const StatusIndicator({
    super.key,
    required this.type,
    this.label,
    this.progress,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final IconData icon;
    final Color color;
    final String statusText;

    switch (type) {
      case StatusType.success:
        icon = Icons.check_circle_outline;
        color = colorScheme.primary; // 使用主色表示成功
        statusText = label ?? 'Completed';
        break;
      case StatusType.processing:
        icon = Icons.autorenew;
        color = colorScheme.secondary; // 使用辅助色表示处理中
        statusText = label ?? 'In Progress';
        break;
      case StatusType.pending:
        icon = Icons.access_time;
        color = colorScheme.onSurfaceVariant; // 使用次要文本色表示等待
        statusText = label ?? 'Pending';
        break;
      case StatusType.error:
        icon = Icons.error_outline;
        color = colorScheme.error; // 使用错误色表示失败
        statusText = label ?? 'Failed';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: size),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (type == StatusType.processing && progress != null) ...[
          const SizedBox(width: 12),
          Expanded(child: ProgressBar(progress: progress!, color: color)),
          const SizedBox(width: 8),
          Text(
            '${(progress! * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// 进度条组件
class ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: colorScheme.surfaceVariant,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
