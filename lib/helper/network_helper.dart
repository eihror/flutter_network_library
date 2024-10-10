import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class NetworkHelper {
  final Dio dio = Dio();

  // Check if device is connected to any network
  Future<bool> isDeviceConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Check if connected to Wi-Fi or Mobile network
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  // Ping a reliable server to check for internet access
  Future<bool> hasInternetAccess() async {
    try {
      final response = await dio.head(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Ping failed: $e');
    }
    return false;
  }

  // Combined method to check both connection and internet access
  Future<bool> isConnectedAndHasInternet() async {
    bool isConnected = await isDeviceConnected();
    if (isConnected) {
      return await hasInternetAccess();
    }
    return false;
  }
}
