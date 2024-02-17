abstract class NetworkResult<T> {}

final class NetworkResultSuccess<T> extends NetworkResult<T> {
  NetworkResultSuccess({
    required this.data,
  });

  final T data;
}

abstract class NetworkResultError<T> extends NetworkResult<T> {
  NetworkResultError({
    this.code = -1,
    this.message,
  });

  final int? code;
  final String? message;
}

final class NetworkResultClientError<T> extends NetworkResultError<T> {
  NetworkResultClientError({
    super.code,
    super.message,
  });
}

final class NetworkResultServerError<T> extends NetworkResultError<T> {
  NetworkResultServerError({
    super.code,
    super.message,
  });
}

final class NetworkResultCustomError<T> extends NetworkResultError<T> {
  NetworkResultCustomError({
    super.code,
    super.message,
    //ApiError? apiError,
  });
}

final class NetworkResultUnknownError<T> extends NetworkResultError<T> {
  NetworkResultUnknownError({
    super.code,
    super.message,
  });
}

abstract class NetworkResultException<T> extends NetworkResult<T> {
  NetworkResultException({
    required this.exception,
  });

  final Exception exception;
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

final class NetworkResultUnknownException<T> extends NetworkResultException<T> {
  NetworkResultUnknownException({
    required super.exception,
  });
}
