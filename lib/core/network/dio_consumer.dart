import 'package:dio/dio.dart';

import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer(this._dio);

  final Dio _dio;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.put(
      path,
      data: body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.delete(
      path,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
