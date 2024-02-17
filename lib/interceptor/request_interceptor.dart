import 'package:dio/dio.dart';
import 'package:network/model/network_result.dart';
import 'package:network/model/unit.dart';
import 'package:network/util/int_util.dart';

class RequestInterceptor extends Interceptor {
  static List<int> CLIENT_ERROR_CODES = IntUtil.range(400, 499);
  static List<int> SERVER_ERROR_CODES = IntUtil.range(500, 599);
  static int SUCCESSFUL_NO_CONTENT_CODE = 204;
  static int SUCCESSFUL_CODE = 200;

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    response.data = _treatResponse(response: response);
    handler.next(response);
  }

  NetworkResult _treatResponse({
    required Response response,
  }) {
    if (response.statusCode == SUCCESSFUL_NO_CONTENT_CODE) {
      return NetworkResultSuccess(data: Unit);
    }

    if (response.data != null && response.statusCode == SUCCESSFUL_CODE) {
      if (response.data is List) {
        return NetworkResultSuccess<List<dynamic>>(data: response.data);
      } else {
        return NetworkResultSuccess<dynamic>(data: response.data);
      }
    }

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

    if (!SERVER_ERROR_CODES.contains(response.statusCode) &&
        !CLIENT_ERROR_CODES.contains(response.statusCode) &&
        response.statusCode != SUCCESSFUL_NO_CONTENT_CODE &&
        response.statusCode != SUCCESSFUL_CODE) {
      return NetworkResultUnknownError(
        code: response.statusCode,
        message: response.statusMessage,
      );
    }

    return NetworkResultSuccess(data: Unit);
  }
}
