// 核心功能 - 通用工具类 (Utilities)
// 包含各种辅助函数和工具类，例如日期格式化、字符串处理、验证器等。

/// 格式化字节大小为可读字符串
/// [size] 字节数， [precision] 精度（单位进位，0-B, 1-KB, 2-MB...）
/// 返回如 "1.23 MB" 的字符串
String formatBytes(int size, [int precision = 2]) {
  if (size <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final index = (precision < 0 || precision >= suffixes.length) ? 0 : precision;
  double value = size.toDouble();
  for (int j = 0; j < index; j++) {
    value /= 1024;
  }
  return '${value.toStringAsFixed(2)} ${suffixes[index]}';
}

/// 格式化时间字符串为 "YYYY-MM-DD HH:MM:SS" 格式
/// [dateTimeStr] 支持 ISO8601 字符串或已格式化的时间字符串
/// 若无法解析则原样返回，若为空则返回 "-"
String formatDateTime(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
  final DateTime? parsedDateTime = DateTime.tryParse(dateTimeStr);
  if (parsedDateTime != null) {
    final DateTime localDateTime = parsedDateTime.toLocal();
    return "${localDateTime.year.toString()}-"
        "${localDateTime.month.toString().padLeft(2, '0')}-"
        "${localDateTime.day.toString().padLeft(2, '0')} "
        "${localDateTime.hour.toString().padLeft(2, '0')}:"
        "${localDateTime.minute.toString().padLeft(2, '0')}:"
        "${localDateTime.second.toString().padLeft(2, '0')}";
  }
  return dateTimeStr;
}
