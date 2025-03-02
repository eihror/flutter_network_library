import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network/exception/network_exception.dart';

class RequestResponseInterceptor extends InterceptorsWrapper {
  RequestResponseInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is SocketException) {
      throw NetworkNoConnectionException(
        requestOptions: err.requestOptions,
      );
    }

    switch (err.type) {
      case DioExceptionType.badResponse:
        throw NetworkApiException(
          error: err.response?.data,
          requestOptions: err.requestOptions,
        );
      default:
        throw NetworkUnknownException(
          message: err.message,
          requestOptions: err.requestOptions,
        );
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    return handler.next(response); // Continue with the response
  }
}
