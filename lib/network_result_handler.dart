import 'package:dio/dio.dart';
import 'package:network/model/network_result.dart';
import 'package:network/model/unit.dart';

import 'util/int_util.dart';

abstract class NetworkResultHandler<T> {
  static int SUCCESSFUL_NO_CONTENT_CODE = 204;
  static int SUCCESSFUL_CODE = 200;

  static List<int> CLIENT_ERROR_CODES = IntUtil.range(400, 499);
  static List<int> SERVER_ERROR_CODES = IntUtil.range(500, 599);
  static List<int> SUCCESS_CODES = [
    SUCCESSFUL_CODE,
    SUCCESSFUL_NO_CONTENT_CODE,
  ];

  static NetworkResult<T> handleResult<T>({
    required Response<T> response,
  }) {
    if ((CLIENT_ERROR_CODES.contains(response.statusCode) ||
            SERVER_ERROR_CODES.contains(response.statusCode)) &&
        !SUCCESS_CODES.contains(response.statusCode)) {
      return _treatFailure(response: response);
    }

    return _treatSuccess<T>(response: response);
  }

  static NetworkResult<T> handleException<T>({
    required DioException exception,
  }) {
    late NetworkResult<T> result;

    switch (exception.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        result = NetworkResultNoInternetConnectionException(
          exception: exception,
        );
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        result = NetworkResultSocketTimeoutException(
          exception: exception,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        result = NetworkResultUnknownException(
          exception: exception,
        );
    }

    return result;
  }

  static NetworkResult<T> _treatSuccess<T>({
    required Response<T> response,
  }) {
    if (response.statusCode == SUCCESSFUL_NO_CONTENT_CODE) {
      return NetworkResultSuccess<T>(data: Unit as T);
    }

    return NetworkResultSuccess<T>(data: response.data as T);
  }

  static NetworkResult<T> _treatFailure<T>({
    required Response<dynamic> response,
  }) {
    if (CLIENT_ERROR_CODES.contains(response.statusCode)) {
      return NetworkResultClientError(
        code: response.statusCode,
        message: response.statusMessage,
      );
    }

    if (SERVER_ERROR_CODES.contains(response.statusCode)) {
      return NetworkResultServerError(
        code: response.statusCode,
        message: response.statusMessage,
      );
    }

    return NetworkResultUnknownError(
      code: response.statusCode,
      message: response.statusMessage,
    );
  }
}
