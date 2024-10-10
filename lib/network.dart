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
  late NetworkHelper networkHelper;

  final List<Interceptor>? interceptorList;
  final BaseOptions options;

  Dio get client => _dio;

  void _setupInterceptorList({
    List<Interceptor>? value,
  }) {
    networkHelper = NetworkHelper();
    _dio.interceptors.add(
      RequestResponseInterceptor(networkHelper: networkHelper),
    );

    if (!kReleaseMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
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
