import 'dart:convert';

/// SSE事件数据基类
abstract class SSEEventData {}

/// 消息内容类型 {"v": string}
class SSEMessageData extends SSEEventData {
  final String v;
  SSEMessageData(this.v);
}

/// 新会话类型 {"session_key": string, "session_name": string}
class SSESessionData extends SSEEventData {
  final String sessionKey;
  final String sessionName;
  SSESessionData({required this.sessionKey, required this.sessionName});
}

/// SSE事件类型
enum SSEEventType { data, message }

/// SSE事件数据模型，用于表示SSE流中的单帧数据
class SSEEventModel {
  /// 事件ID
  final String? id;

  /// 事件类型（data/message）
  final SSEEventType? event;

  /// 事件数据
  final SSEEventData? data;

  /// 构造函数
  const SSEEventModel({this.id, this.event, this.data});

  /// 从SSE事件解析
  factory SSEEventModel.fromSseEvent({
    String? id,
    String? event,
    String? data,
  }) {
    SSEEventData? parsedData;
    if (data != null && data.isNotEmpty) {
      try {
        final jsonMap = jsonDecode(data) as Map<String, dynamic>;
        if (jsonMap.containsKey('v')) {
          parsedData = SSEMessageData(jsonMap['v'] as String? ?? '');
        } else if (jsonMap.containsKey('session_key') &&
            jsonMap.containsKey('session_name')) {
          parsedData = SSESessionData(
            sessionKey: jsonMap['session_key'] as String? ?? '',
            sessionName: jsonMap['session_name'] as String? ?? '',
          );
        }
      } catch (_) {
        parsedData = SSEMessageData(data);
      }
    }
    // 事件类型映射
    SSEEventType? eventType;
    if (event == 'data') {
      eventType = SSEEventType.data;
    } else if (event == 'message') {
      eventType = SSEEventType.message;
    }
    return SSEEventModel(id: id, event: eventType, data: parsedData);
  }
}
