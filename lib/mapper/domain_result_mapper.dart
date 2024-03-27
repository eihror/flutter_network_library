import 'package:network/model/network_result.dart';
import 'package:network/model/result.dart';

extension ResultMapperExtensions on NetworkResult<dynamic> {
  Result<R> toDomainResult<T, R>(R Function(T networkData) dataMapper) {
    if (this is NetworkResultClientError) {
      return ClientError(
        code: (this as NetworkResultClientError).code,
        message: (this as NetworkResultClientError).message,
      );
    } else if (this is NetworkResultCustomError) {
      return NetworkCustom(
        code: (this as NetworkResultCustomError).code,
        message: (this as NetworkResultCustomError).message,
        apiError: (this as NetworkResultCustomError).apiError,
      );
    } else if (this is NetworkResultServerError) {
      return ServerError(
        code: (this as NetworkResultServerError).code,
        message: (this as NetworkResultServerError).message,
      );
    } else if (this is NetworkResultUnknownError) {
      return NetworkUnknown(
        code: (this as NetworkResultUnknownError).code,
        message: (this as NetworkResultUnknownError).message,
      );
    } else if (this is NetworkResultNoInternetConnectionException) {
      return NoInternetConnection();
    } else if (this is NetworkResultSocketTimeoutException) {
      return Timeout();
    } else if (this is NetworkResultUnknownException) {
      return FailureUnknown(
        exception: (this as NetworkResultUnknownException).exception,
      );
    } else {
      return Successful(
        data: dataMapper(
          (this as NetworkResultSuccess).data as T,
        ),
      );
    }
  }
}
