import 'package:dio/dio.dart';

abstract class NetworkResult<T> {}

final class NetworkResultSuccess<T> extends NetworkResult<T> {
  NetworkResultSuccess({
    required this.data,
  });

  final T data;
}

abstract class NetworkResultError<T> extends NetworkResult<T> {
  NetworkResultError({
    this.statusCode,
    this.code,
    this.message,
    this.errorResponse,
  });

  final int? statusCode;
  final String? code;
  final String? message;
  final dynamic errorResponse;
}

final class NetworkResultClientError<T> extends NetworkResultError<T> {
  NetworkResultClientError({
    super.statusCode,
    super.message,
  });
}

final class NetworkResultServerError<T> extends NetworkResultError<T> {
  NetworkResultServerError({
    super.statusCode,
    super.message,
  });
}

final class NetworkResultCustomError<T> extends NetworkResultError<T> {
  NetworkResultCustomError({
    super.statusCode,
    super.code,
    super.message,
    super.errorResponse,
  });
}

final class NetworkResultUnknownError<T> extends NetworkResultError<T> {
  NetworkResultUnknownError({
    super.statusCode,
    super.message,
  });
}

abstract class NetworkResultException<T> extends NetworkResult<T> {
  NetworkResultException({
    required this.exception,
  });

  final DioException exception;
}

final class NetworkResultNoInternetConnectionException<T>
    extends NetworkResultException<T> {
  NetworkResultNoInternetConnectionException({
    required super.exception,
  });
}

final class NetworkResultSocketTimeoutException<T>
    extends NetworkResultException<T> {
  NetworkResultSocketTimeoutException({
    required super.exception,
  });
}

final class NetworkResultCustomException<T> extends NetworkResultException<T> {
  NetworkResultCustomException({
    required super.exception,
  });
}