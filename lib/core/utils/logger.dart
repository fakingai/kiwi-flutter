import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// 应用日志记录器
///
/// 提供统一的日志记录功能，支持输出到控制台和文件。
class AppLogger {
  static late final Logger _logger;
  static late final File _logFile;

  static bool _isInitialized = false;

  /// 初始化日志记录器
  ///
  /// [logFileName] 日志文件名，默认为 "app.log"
  /// 应该在应用启动时调用此方法，例如在 `main()` 函数中。
  static Future<void> init({String logFileName = 'app.log'}) async {
    if (_isInitialized) {
      print('Logger already initialized.');
      return;
    }

    try {
      final List<LogOutput> outputs = [ConsoleOutput()];

      // 仅在非 Web 平台且非调试模式下启用文件日志记录
      // 或者在调试模式下，如果明确需要，也可以启用
      if (!kIsWeb) {
        try {
          final directory = await getApplicationDocumentsDirectory();
          _logFile = File('${directory.path}/$logFileName');
          outputs.add(FileOutput(file: _logFile));
          print('Log file initialized at: ${_logFile.path}');
        } catch (e) {
          print('Failed to initialize file logger: $e');
          // 如果文件日志初始化失败，仍然可以继续使用控制台日志
        }
      } else {
        print('File logging is not supported on the web platform.');
      }

      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 1, // 每个日志输出的方法调用堆栈深度
          errorMethodCount: 5, // 错误日志输出的方法调用堆栈深度
          lineLength: 80, // 每行输出的宽度
          colors: true, // 是否启用颜色输出
          printEmojis: true, // 是否打印 Emoji
          printTime: true, // 是否打印时间戳
        ),
        output: MultiOutput(outputs),
        // 根据构建模式设置日志级别
        // 在调试模式下，输出所有级别的日志
        // 在发布模式下，仅输出警告及以上级别的日志
        level: kDebugMode ? Level.verbose : Level.warning,
      );
      _isInitialized = true;
      print('Logger initialized successfully.');
    } catch (e) {
      print('Error initializing logger: $e');
      // 提供一个备用的简单 Logger，以防初始化失败
      _logger = Logger(printer: PrettyPrinter(), output: ConsoleOutput());
      print('Fallback logger initialized.');
    }
  }

  /// 获取日志记录器实例
  ///
  /// 在调用此方法之前，必须先调用 `init()` 方法。
  static Logger get instance {
    if (!_isInitialized) {
      // 自动进行一次初始化尝试，但这通常不应该发生
      // 最佳实践是在应用启动时显式调用 init()
      print(
        'Logger not initialized. Attempting to initialize with default settings...',
      );
      // 注意：这里的 await 会使 getter 变成异步的，这不是我们想要的。
      // 因此，在实际使用中，务必确保在调用 instance 之前 init 已经完成。
      // 或者，将 init 的调用移到更早的阶段，并确保其完成。
      // 为了简单起见，这里我们假设 init 应该已经被调用。
      // 如果在未初始化时调用，将抛出异常。
      throw Exception(
        "Logger has not been initialized. Call AppLogger.init() first.",
      );
    }
    return _logger;
  }

  /// 记录调试信息
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  /// 记录普通信息
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  /// 记录警告信息
  static void warning(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }

  /// 记录错误信息
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  /// 记录严重错误信息
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    instance.f(message, error: error, stackTrace: stackTrace);
  }

  /// 获取日志文件路径 (如果已初始化)
  static String? get logFilePath =>
      _isInitialized && !kIsWeb ? _logFile.path : null;
}

/// 自定义 MultiOutput 以处理不同平台的日志输出
class MultiOutput extends LogOutput {
  final List<LogOutput> outputs;

  MultiOutput(this.outputs);

  @override
  Future<void> init() async {
    for (var output in outputs) {
      await output.init();
    }
  }

  @override
  void output(OutputEvent event) {
    for (var output in outputs) {
      try {
        output.output(event);
      } catch (e) {
        if (kDebugMode) {
          print('Error in custom MultiOutput: \$e');
        }
      }
    }
  }

  @override
  Future<void> destroy() async {
    for (var output in outputs) {
      await output.destroy();
    }
  }
}
