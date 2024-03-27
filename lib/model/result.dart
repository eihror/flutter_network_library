import 'package:dio/dio.dart';

class Result<T> {
  const Result({this.data, this.exception});

  final T? data;
  final DioException? exception;

  bool get isSuccess => this is Successful<T>;

  bool get isFailure => this is Failure;

  void onSuccess(Function(T data) call) {
    if (isSuccess) {
      call(data as T);
    }
  }

  void onFailure(Function(DioException exception) call) {
    if (isFailure) {
      call(exception!);
    }
  }

  T getOrThrow() {
    if (isFailure) {
      throw exception!;
    }
    return data!;
  }

  T? getOrNull() {
    if (isFailure) {
      return null;
    }
    return data!;
  }
}

class Successful<T> extends Result<T> {
  Successful({required this.data});

  final T data;
}

class Failure<T> extends Result<T> {
  Failure({
    this.code = -1,
    this.message,
    this.errorBody,
  });

  final int? code;
  final String? message;
  final dynamic errorBody;
}

class NoInternetConnection<T> extends Failure<T> {
  NoInternetConnection({super.code = -1});
}

class Timeout<T> extends Failure<T> {
  Timeout({super.code = -2});
}

class ClientError<T> extends Failure<T> {
  ClientError({super.code, super.message});
}

class ServerError<T> extends Failure<T> {
  ServerError({super.code, super.message});
}

class NetworkCustom<T> extends Failure<T> {
  NetworkCustom({super.code, super.message});
}

class NetworkUnknown<T> extends Failure<T> {
  NetworkUnknown({super.code, super.message});
}

class FailureUnknown<T> extends Failure<T> {
  FailureUnknown({this.exception});

  final DioException? exception;
}

class FailureCustom<T> extends Failure<T> {
  FailureCustom({this.exception});

  final DioException? exception;
}
