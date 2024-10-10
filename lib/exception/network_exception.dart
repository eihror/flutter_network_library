import 'package:dio/dio.dart';

class NetworkException extends DioException {
  final String? message;

  NetworkException({
    this.message,
    required RequestOptions requestOptions,
  }) : super(requestOptions: requestOptions);

  @override
  String toString() {
    return message ?? 'NetworkException';
  }
}

class NetworkApiException extends NetworkException {
  final dynamic error;

  NetworkApiException({
    required this.error,
    required RequestOptions requestOptions,
  }) : super(message: error.toString(), requestOptions: requestOptions);

  @override
  String toString() {
    return 'API Errors:\n${super.message}';
  }
}

class NetworkNoConnectionException extends NetworkException {
  NetworkNoConnectionException({
    required RequestOptions requestOptions,
  }) : super(
          message:
              'No connection available. Please check your network settings and try again.',
          requestOptions: requestOptions,
        );
}

class NetworkUnknownException extends NetworkException {
  NetworkUnknownException({
    String? message,
    required RequestOptions requestOptions,
  }) : super(message: message, requestOptions: requestOptions);
}
