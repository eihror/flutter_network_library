import 'package:dio/dio.dart';
import 'package:network/exception/network_exception.dart';
import 'package:network/helper/network_helper.dart';

class RequestResponseInterceptor extends InterceptorsWrapper {
  RequestResponseInterceptor({required this.networkHelper});

  final NetworkHelper networkHelper;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check for network and internet connectivity before sending request
    bool isConnected = await networkHelper.isConnectedAndHasInternet();

    if (isConnected) {
      return handler.next(options); // Continue with the request
    } else {
      return handler.reject(
        NetworkNoConnectionException(requestOptions: options),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
