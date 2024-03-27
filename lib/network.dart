library network;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network/interceptor/network_log_interceptor.dart';
import 'package:network/interceptor/request_interceptor.dart';

class Network {
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
}
