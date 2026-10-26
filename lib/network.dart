library network;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network/helper/network_helper.dart';
import 'package:network/interceptor/request_response_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Network {
  Network._({
    required this.options,
    this.interceptorList,
    this.cacheInterceptor,
    this.enableLogs = false,
    this.enableDefaultErrorHandler = true,
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
    int sendTimeoutInMilliseconds = 10000,
    bool? enableLogs,
    bool? enableDefaultErrorHandler,
    List<Interceptor>? interceptorList,
    Interceptor? cacheInterceptor,
  }) {
    return Network._(
      options: BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType,
        connectTimeout: Duration(milliseconds: connectTimeoutInMilliseconds),
        receiveTimeout: Duration(milliseconds: receiveTimeoutInMilliseconds),
        sendTimeout: Duration(milliseconds: sendTimeoutInMilliseconds),
      ),
      interceptorList: interceptorList,
      cacheInterceptor: cacheInterceptor,
      enableLogs: enableLogs ?? false,
      enableDefaultErrorHandler: enableDefaultErrorHandler ?? true,
    );
  }

  late Dio _dio;
  late NetworkHelper networkHelper;

  final List<Interceptor>? interceptorList;
  final Interceptor? cacheInterceptor;
  final BaseOptions options;
  final bool enableLogs;

  /// When false, [RequestResponseInterceptor] is not registered, so the
  /// consuming project can handle errors with its own interceptor.
  final bool enableDefaultErrorHandler;

  @visibleForTesting
  set client(Dio dio) {
    _dio = dio;
  }

  Dio get client => _dio;

  void _setupInterceptorList({
    List<Interceptor>? value,
  }) {
    networkHelper = NetworkHelper();

    if (cacheInterceptor != null) {
      _dio.interceptors.add(cacheInterceptor!);
    }

    if (!kReleaseMode && enableLogs) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    if (enableDefaultErrorHandler) {
      _dio.interceptors.add(
        RequestResponseInterceptor(networkHelper: networkHelper),
      );
    }

    if (value != null) {
      for (var element in value) {
        _dio.interceptors.add(element);
      }
    }
  }
}
