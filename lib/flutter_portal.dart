import 'dart:convert';
import 'package:flutter_portal/portal_exception.dart';
import 'package:flutter_portal/portal_result.dart';
import 'package:flutter_portal/services/conversion_service.dart';
import 'package:flutter_portal/services/convertable.dart';
import 'package:http/http.dart' as http;
export 'package:flutter_portal/portal_exception.dart';
export 'package:flutter_portal/portal_result.dart';
export 'package:flutter_portal/services/conversion_service.dart';
export 'package:flutter_portal/services/convertable.dart';
export 'package:flutter_portal/method_service.dart';
export 'package:flutter_portal/reflection.dart';

/// Singleton class to manage HTTP requests to a specified host and port.
FlutterPortal get flutterPortal => FlutterPortal();

class FlutterPortal {
  final String? host;
  final int? port;
  final Scheme scheme;
  static FlutterPortal? _instance;

  /// Private constructor for internal use.
  FlutterPortal._internal({this.host, this.port, Scheme? scheme})
      : scheme = scheme ?? Scheme.http;

  /// Factory constructor to initialize the singleton instance.
  ///
  /// Throws an exception if the instance is already initialized.
  ///
  /// \param host The host address.
  /// \param port The port number.
  factory FlutterPortal.init({String? host, int? port, Scheme? scheme}) {
    _instance ??=
        FlutterPortal._internal(host: host, port: port, scheme: scheme);
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
  Future<PortalResult<ResponseWith>> get<ResponseWith>(String endPoint,
      {String? host,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      Scheme? scheme}) async {
    try {
      final useScheme = scheme ?? this.scheme;
      final useHost = host ?? this.host;
      if (useHost == null || useHost.isEmpty) {
        throw Exception('Host not specified in FlutterPortal or method call');
      }
      var response = await http.get(
          Uri(
              host: useHost,
              port: port,
              path: endPoint,
              queryParameters: params,
              scheme: useScheme.name),
          headers: headers);
      if (response.statusCode < 200 || response.statusCode > 300) {
        throw PortalException(response.statusCode, response.body);
      }

      return PortalResult(
          response.statusCode,
          ConversionService.primitiveStructureToObject<ResponseWith>(
              value: jsonDecode(response.body),
              type: convertable.reflectType(ResponseWith)));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  /// Sends a POST request to the specified endpoint with the given data.
  ///
  /// \param endPoint The endpoint to send the request to.
  /// \param data The data to include in the request body.
  /// \return A Future that resolves to the response converted to the specified type.
  Future<PortalResult<ResponseWith>?> post<ResponseWith>(
      String endPoint, dynamic data,
      {String? host,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      Scheme? scheme}) async {
    try {
      final useHost = host ?? this.host;
      if (useHost == null || useHost.isEmpty) {
        throw Exception('Host not specified in FlutterPortal or method call');
      }
      final useScheme = scheme ?? this.scheme;
      var response = await http.post(
          Uri(
              host: useHost,
              port: port,
              path: endPoint,
              scheme: useScheme.name,
              queryParameters: queryParameters),
          body: ConversionService.encodeJSON(data),
          headers: headers);
      if (response.statusCode < 200 || response.statusCode > 300) {
        throw PortalException(response.statusCode, response.body);
      }

      return PortalResult(
          response.statusCode,
          ConversionService.primitiveStructureToObject<ResponseWith>(
              value: jsonDecode(response.body)));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}

enum Scheme {
  http,
  https,
}
