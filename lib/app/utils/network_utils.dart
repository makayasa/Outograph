import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class NetworkUtil {
  static NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  Dio _dio = Dio();

  Future<bool> checkConnection() async {
    _dio.options.connectTimeout = 5000;

    var connResult = await (Connectivity().checkConnectivity());

    if (connResult == ConnectivityResult.mobile) {
      // logKey('Connect with mobile');
      return true;
    } else if (connResult == ConnectivityResult.wifi) {
      // logKey('Connect with wifi');
      return true;
    } else {
      return false;
    }
  }

  var defaultHeader = {
    'content-type': 'application/json',
  };

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    String? token,
  }) async {
    bool isConnect = await checkConnection();
    if (isConnect) {
      try {
        Response res = await _dio.get(
          path,
          queryParameters: query,
          options: Options(
            headers: defaultHeader,
          ),
        );
        return res;
      } on DioError catch (err) {
        return err.response;
      }
    }
  }

  Future<dynamic> post(
    String path, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? query,
  }) async {
    bool isConenct = await checkConnection();
    if (isConenct) {
      try {
        Response res = await _dio.post(
          path,
          data: body,
        );
        return res;
      } on DioError catch (err) {
        return err.response;
      }
    }
  }
}
