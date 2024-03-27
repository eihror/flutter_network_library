library network;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network/interceptor/network_log_interceptor.dart';
import 'package:network/interceptor/request_interceptor.dart';
import 'package:network/model/network_result.dart';
import 'package:network/network_rest_api.dart';
import 'package:network/network_result_handler.dart';

class Network extends NetworkRestApi {
  Network._({
    required this.options,
    this.interceptorList,
  }) {
    _dio = Dio(
      options,
    );

    _setupInterceptorList(
      value: interceptorList,
    );
  }

  factory Network.createNetwork({
    required String baseUrl,
    String contentType = "application/json; charset=utf-8",
    int connectTimeoutInMilliseconds = 10000,
    int receiveTimeoutInMilliseconds = 10000,
    List<Interceptor>? interceptorList,
  }) {
    return Network._(
      options: BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType,
        connectTimeout: Duration(milliseconds: connectTimeoutInMilliseconds),
        receiveTimeout: Duration(milliseconds: receiveTimeoutInMilliseconds),
      ),
      interceptorList: interceptorList,
    );
  }

  late Dio _dio;

  final List<Interceptor>? interceptorList;
  final BaseOptions options;

  Dio get client => _dio;

  void _setupInterceptorList({
    List<Interceptor>? value,
  }) {
    _dio.interceptors.add(RequestInterceptor());

    if (!kReleaseMode) {
      _dio.interceptors.add(
        NetworkLogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    if (value != null) {
      for (var element in value) {
        _dio.interceptors.add(element);
      }
    }
  }

  @override
  Future<NetworkResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResultHandler.handleResult<T>(response: response);
    } on DioException catch (e) {
      return NetworkResultHandler.handleException<T>(exception: e);
    }
  }

  @override
  Future<NetworkResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResultHandler.handleResult<T>(response: response);
    } on DioException catch (e) {
      return NetworkResultHandler.handleException<T>(exception: e);
    }
  }

  @override
  Future<NetworkResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResultHandler.handleResult<T>(response: response);
    } on DioException catch (e) {
      return NetworkResultHandler.handleException<T>(exception: e);
    }
  }

  @override
  Future<NetworkResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResultHandler.handleResult<T>(response: response);
    } on DioException catch (e) {
      return NetworkResultHandler.handleException<T>(exception: e);
    }
  }

  @override
  Future<NetworkResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResultHandler.handleResult<T>(response: response);
    } on DioException catch (e) {
      return NetworkResultHandler.handleException<T>(exception: e);
    }
  }
}
