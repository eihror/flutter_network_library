class Result<T> {
  const Result({this.data, this.exception});

  final T? data;
  final Exception? exception;

  bool get isSuccess => this is Successful<T>;

  bool get isFailure => this is Failure;

  void onSuccess(Function(T data) call) {
    if (isSuccess) {
      call(data as T);
    }
  }

  void onFailure(Function(Exception exception) call) {
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
  Failure({required Exception exception}) : super(exception: exception);
}