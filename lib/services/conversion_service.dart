import 'dart:convert';
import 'dart:io';
import 'package:flutter_portal/reflection.dart';
import 'package:reflectable/reflectable.dart';

/// A service class for converting objects to maps and vice versa,
/// as well as handling HTTP request conversions.
class ConversionService {
  /// Converts an object to a map by reflecting its fields.
  ///
  /// \param object The object to convert.
  /// \return A map representation of the object.
  static Map<String, dynamic> objectToMap(dynamic object) {
    var mirror = reflect(object);
    var classMirror = mirror.type;

    var map = <String, dynamic>{};

    classMirror.declarations.forEach((name, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        var fieldName = name;
        var fieldValue = mirror.invokeGetter(name);

        map[fieldName] = fieldValue;
      }
    });

    return map;
  }

  /// Converts a map to an object of type T.
  ///
  /// \param map The map to convert.
  /// \param type The type of the object to create (optional).
  /// \return An instance of type T.
  static T mapToObject<T>(Map<String, dynamic> map, {Type? type}) {
    var classMirror = reflectClass(type ?? T);
    Object instance = classMirror.newInstance("", map.values.toList());
    return instance as T;
  }

  /// Converts an HTTP request to a map.
  ///
  /// \param request The HTTP request to convert.
  /// \return A Future that resolves to a map representation of the request body.
  static Future<Map<String, dynamic>> requestToMap(HttpRequest request) async {
    final body = await utf8.decodeStream(request);
    return jsonDecode(body);
  }

  /// Converts an HTTP request to an object of type T.
  ///
  /// \param request The HTTP request to convert.
  /// \param type The type of the object to create (optional).
  /// \return A Future that resolves to an instance of type T.
  static Future<T> requestToObject<T>(HttpRequest request, {Type? type}) async {
    return mapToObject<T>(await streamToMap(request), type: type);
  }

  /// Converts a stream of bytes to a map.
  ///
  /// \param stream The stream to convert.
  /// \return A Future that resolves to a map representation of the stream.
  static streamToMap(Stream<List<int>> stream) async {
    final body = await utf8.decodeStream(stream);
    print(body.split("&").map(
          (e) => MapEntry<String, dynamic>(e.split("=")[0], e.split("=")[1]),
    ));
    return Map<String, dynamic>.fromEntries(body.split("&").map(
          (e) => MapEntry<String, dynamic>(e.split("=")[0], e.split("=")[1]),
    ));
  }

  /// Converts a JSON string to an object of type T.
  ///
  /// \param body The JSON string to convert.
  /// \return An instance of type T.
  static T? convert<T>(String body) {
    if (T == String) {
      return body as T;
    } else if (T == int) {
      return int.parse(body) as T;
    } else if (T == double) {
      return double.parse(body) as T;
    } else if (T is bool) {
      return (body == "true") as T;
    }

    return mapToObject<T>(jsonDecode(body));
  }

  /// Converts an object to a JSON string or its string representation.
  ///
  /// \param object The object to convert.
  /// \return A JSON string or string representation of the object.
  static String convertToStringOrJson(dynamic object) {
    if (object is String || object is num || object is bool) {
      return object.toString();
    }
    try {
      return jsonEncode(objectToMap(object));
    } catch (e) {
      throw Exception(e);
    }
  }
}