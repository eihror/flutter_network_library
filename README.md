# network

A Flutter abstraction library over [Dio](https://pub.dev/packages/dio) that provides a preconfigured HTTP client with timeouts, logging, cache support, custom interceptors and standardized error handling.

## Features

- Preconfigured `Dio` client (base URL, content type and timeouts)
- Optional request/response logging via `pretty_dio_logger` (debug builds only)
- Optional cache interceptor
- Support for custom interceptors
- Default error handler that maps `DioException` into typed `NetworkException`s, which can be disabled
- `NetworkHelper` to check device connectivity and internet access

## Getting started

Add the dependency to your `pubspec.yaml`, pointing to the desired version tag:

```yaml
dependencies:
  network:
    git:
      url: https://github.com/eihror/flutter_network_library.git
      ref: v1.1.15
```

Requirements: Dart `>=3.2.6 <4.0.0`. The library is developed with Flutter 3.27.3 (see `.fvmrc`).

## Usage

### Creating the client

```dart
import 'package:network/network.dart';

final network = Network.createNetwork(
  baseUrl: 'https://api.github.com/',
  enableLogs: true,
);

final response = await network.client.get<dynamic>('users/eihror');
```

### Configuration

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseUrl` | `String` | required | Base URL for all requests |
| `contentType` | `String` | `application/json; charset=utf-8` | Default content type |
| `connectTimeoutInMilliseconds` | `int` | `10000` | Connection timeout |
| `receiveTimeoutInMilliseconds` | `int` | `10000` | Receive timeout |
| `sendTimeoutInMilliseconds` | `int` | `10000` | Send timeout |
| `enableLogs` | `bool?` | `false` | Logs requests and responses (ignored in release mode) |
| `enableDefaultErrorHandler` | `bool?` | `true` | Registers the library's default error handler |
| `interceptorList` | `List<Interceptor>?` | `null` | Additional interceptors |
| `cacheInterceptor` | `Interceptor?` | `null` | Cache interceptor, registered first |

Interceptors are registered in this order: `cacheInterceptor`, logger, default error handler, `interceptorList`.

### Error handling

By default, errors are converted into subclasses of `NetworkException`:

| Exception | When |
| --- | --- |
| `NetworkApiException` | The server returned an error status (`error` holds the response body) |
| `NetworkNoConnectionException` | Connection error |
| `NetworkTimeoutException` | Connect, send or receive timeout |
| `NetworkUnknownException` | Any other error |

```dart
import 'package:network/exception/network_exception.dart';

try {
  await network.client.get<dynamic>('users/eihror');
} on NetworkApiException catch (e) {
  print(e.error);
} on NetworkException catch (e) {
  print(e.message);
}
```

### Using your own error handler

If your project needs a different error format, disable the default handler and provide your own interceptor:

```dart
class MyErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(err); // map to your own exception here
  }
}

final network = Network.createNetwork(
  baseUrl: 'https://api.example.com',
  enableDefaultErrorHandler: false,
  interceptorList: [MyErrorInterceptor()],
);
```

The default handler rejects the error, so error interceptors in `interceptorList` won't receive `onError` while it is enabled. Disable it whenever you want to handle errors yourself.

### Checking connectivity

```dart
final hasInternet = await network.networkHelper.isConnectedAndHasInternet();
```

## Example

See the [`example`](example) folder for a complete app.
