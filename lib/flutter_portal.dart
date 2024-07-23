import 'package:flutter_portal/services/conversion_service.dart';
import 'package:http/http.dart' as http;

/// Singleton class to manage HTTP requests to a specified host and port.
FlutterPortal get flutterPortal => FlutterPortal();

class FlutterPortal {
  final String host;
  final int port;

  static FlutterPortal? _instance;

  /// Private constructor for internal use.
  FlutterPortal._internal({required this.host, required this.port});

  /// Factory constructor to initialize the singleton instance.
  ///
  /// Throws an exception if the instance is already initialized.
  ///
  /// \param host The host address.
  /// \param port The port number.
  factory FlutterPortal.init({required String host, required int port}) {
    _instance ??= FlutterPortal._internal(host: host, port: port);
    return _instance!;
  }

  /// Factory constructor to get the singleton instance.
  ///
  /// Throws an exception if the instance is not initialized.
  factory FlutterPortal() {
    if (_instance == null) {
      throw Exception('FlutterPortal not initialized');
    }
    return _instance!;
  }

  /// Sends a GET request to the specified endpoint with the given parameters.
  ///
  /// \param endPoint The endpoint to send the request to.
  /// \param params The query parameters for the request.
  /// \return A Future that resolves to the response converted to the specified type.
  Future<dynamic> get<ResponseWith>(
      String endPoint, Map<String, dynamic> params,
      {Map<String, String>? headers}) async {
    var response = await http.get(
        Uri(
            host: host,
            port: port,
            path: endPoint,
            queryParameters: params,
            scheme: 'http'),
        headers: headers);
    if (response.statusCode < 200 || response.statusCode > 300) {
      print("got status code ${response.statusCode} from $endPoint");
    }

    return ConversionService.convert<ResponseWith>(response.body);
  }

  /// Sends a POST request to the specified endpoint with the given data.
  ///
  /// \param endPoint The endpoint to send the request to.
  /// \param data The data to include in the request body.
  /// \return A Future that resolves to the response converted to the specified type.
  Future<ResponseWith?> post<ResponseWith>(String endPoint, dynamic data,
      {Map<String, String>? headers}) async {
    var response = await http.post(
        Uri(host: host, port: port, path: endPoint, scheme: 'http'),
        body: ConversionService.convertToStringOrJson(data),
        headers: headers);
    if (response.statusCode < 200 || response.statusCode > 300) {
      print("got status code ${response.statusCode} from $endPoint");
    }
    print(response.body);

    return ConversionService.convert<ResponseWith>(response.body);
  }
}
