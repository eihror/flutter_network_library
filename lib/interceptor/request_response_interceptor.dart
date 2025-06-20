import 'package:dio/dio.dart';
import 'package:network/exception/network_exception.dart';
import 'package:network/helper/network_helper.dart';

class RequestResponseInterceptor extends InterceptorsWrapper {
  RequestResponseInterceptor({required this.networkHelper});

  final NetworkHelper networkHelper;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.badResponse:
        handler.next(
          NetworkApiException(
            error: err.response?.data,
            requestOptions: err.requestOptions,
          ),
        );
        break;
      case DioExceptionType.connectionError:
        handler.next(
          NetworkNoConnectionException(
            requestOptions: err.requestOptions,
          ),
        );
        break;
      default:
        handler.next(
          NetworkUnknownException(
            message: err.message,
            requestOptions: err.requestOptions,
          ),
        );
        break;
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
