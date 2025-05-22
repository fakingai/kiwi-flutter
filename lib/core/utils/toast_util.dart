import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast 工具类，用于显示提示信息
class ToastUtil {
  /// 显示短时间 Toast
  static void showShort(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// 显示长时间 Toast
  static void showLong(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// 显示错误 Toast
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// 显示成功 Toast
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// 显示警告 Toast
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.orange.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
