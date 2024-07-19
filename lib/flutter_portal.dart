import 'package:flutter_portal/services/conversion_service.dart';
import 'package:http/http.dart' as http;

FlutterPortal get flutterPortal => FlutterPortal();

class FlutterPortal {
  final String host;
  final int port;

  static FlutterPortal? _instance;

  FlutterPortal._internal({required this.host, required this.port});

  factory FlutterPortal.init({required String host, required int port}) {
    _instance ??= FlutterPortal._internal(host: host, port: port);
    return _instance!;
  }

  factory FlutterPortal() {
    if (_instance == null) {
      throw Exception('FlutterPortal not initialized');
    }
    return _instance!;
  }

  Future<dynamic> get<T>(String endPoint, Map<String, dynamic> params) async {
    var response = await http.get(
      Uri(
          host: host,
          port: port,
          path: endPoint,
          queryParameters: params,
          scheme: 'http'),
    );
    if (response.statusCode < 200 || response.statusCode > 300) {
      print("got status code ${response.statusCode} from $endPoint");
    }
    return response.body;
  }
}
