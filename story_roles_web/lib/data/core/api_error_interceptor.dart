import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

class ApiErrorInterceptor extends Interceptor {
  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get errors => _controller.stream;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 400 && statusCode != 404) {
      final messages = _parseMessages(response.data);
      if (messages.isNotEmpty) _controller.add(messages);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode ?? 0;
    if (statusCode != 404) {
      final data = err.response?.data;
      if (data != null) {
        final messages = _parseMessages(data);
        if (messages.isNotEmpty) _controller.add(messages);
      }
    }
    handler.next(err);
  }

  List<String> _parseMessages(dynamic data) {
    try {
      final Map<String, dynamic> map;
      if (data is String) {
        map = jsonDecode(data) as Map<String, dynamic>;
      } else if (data is Map<String, dynamic>) {
        map = data;
      } else {
        return [];
      }
      final status = map['status'];
      if (status is Map<String, dynamic>) {
        final message = status['message'];
        if (message is List) {
          return message.map((e) => e.toString()).toList();
        }
        if (message is String) return [message];
      }
    } catch (_) {}
    return [];
  }

  void dispose() => _controller.close();
}
