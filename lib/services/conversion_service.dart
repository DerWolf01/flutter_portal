import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_portal/method_service.dart';
import 'package:flutter_portal/reflection.dart';
import 'package:flutter_portal/services/convertable.dart';
import 'package:reflectable/reflectable.dart';

//TODO Implement json service in order to avoid converting Files to int list in the conversion service
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

    for (final entry in declarations(classMirror).entries) {
      final declaration = entry.value;
      final name = entry.key;
      if (declaration is VariableMirror && !declaration.isStatic) {
        var fieldValue = mirror.invokeGetter(name);
        if (isPrimitive(fieldValue)) {
          map[name] = fieldValue;
        } else if (fieldValue is List) {
          map[name] = fieldValue.map((e) => objectToMap(e)).toList();
        } else if (fieldValue is File) {
          map[name] = base64.encode(fieldValue.readAsBytesSync());
        } else {
          map[name] = objectToMap(fieldValue);
        }
      }
    }
    ;

    return map;
  }

  static Map<String, DeclarationMirror> declarations(ClassMirror classMirror) {
    final Map<String, DeclarationMirror> declerations = {
      ...classMirror.declarations
    };
    ClassMirror? superClass = classMirror.superclass;
    while (superClass != null) {
      declerations.addAll(superClass.declarations);
      superClass = superClass.superclass;
    }
    return Map.fromEntries(declerations.entries.where(
      (entry) => entry.value is VariableMirror,
    ));
  }

  /// Converts a map to an object of type T.
  ///
  /// \param map The map to convert.
  /// \param type The type of the object to create (optional).
  /// \return An instance of type T.
  static T mapToObject<T>(Map<String, dynamic> map, {Type? type}) {
    final classMirror = convertable.reflectType(type ?? T);
    final decs = declarations(classMirror as ClassMirror);
    print(decs);
    final constructor = classMirror.declarations.values.firstWhere(
      (element) => element is MethodMirror && element.isConstructor,
    ) as MethodMirror;
    final MethodParameters methodParameters =
        MethodService().methodArgumentsByMap(
      methodMirror: constructor,
      argumentsMap: map,
    );
    Object instance = classMirror.newInstance(
        "",
        methodParameters.args,
        methodParameters.namedArgs.map(
          (key, value) => MapEntry(Symbol(key), value),
        ));
    return instance as T;
  }

  static Future<T> requestToObject<T>(HttpRequest request, {Type? type}) async {
    return mapToObject<T>(await requestToRequestDataMap(request), type: type);
  }

  static Future<Map<String, dynamic>> requestToRequestDataMap(
      HttpRequest request,
      {Type? type}) async {
    return request.method == "GET"
        ? request.uri.queryParameters
        : jsonDecode(await utf8.decodeStream(request));
  }

  /// Converts a JSON string to an object of type T.
  ///
  /// \param body The JSON string to convert.
  /// \return An instance of type T.
  static dynamic convert<T>({Type? type, dynamic value}) {
    final t = type ?? T;

    print("type: $t  valueType: ${value.runtimeType}");

    if (value == null && isNullable(convertable.reflectType(t))) {
      print("isNull");
      return null;
    } else if (t is File || t == File) {
      print("isFile: $value to map ");
      final f = File("random.file");
      f.writeAsBytesSync(base64.decode(value));

      return f;
    } else if (isPrimitive(t)) {
      print("isPrimitive: $value to map ");
      if (value.runtimeType == t) {
        return value;
      }
      return convertPrimitive(value, t);
    } else if (value is List) {
      print("isList: $value to map ");
      return value.map((e) => mapToObject(e, type: t)).toList();
    } else if (value is Map<String, dynamic>) {
      print("isMap: $value to map ");
      if (t == dynamic || t is Map || t == Map) {
        return value;
      } else {
        return mapToObject(value, type: t);
      }
    } else {
      print("is${value.runtimeType}: $value to map ");

      if (value.runtimeType == t) {
        return value;
      }
      print("isObject: $value to map ");

      return objectToMap(value);
    }
  }

  /// Converts an object to a JSON string or its string representation.
  ///
  /// \param object The object to convert.
  /// \return A JSON string or string representation of the object.
  static String encodeJSON(dynamic object) {
    if (isPrimitive(object)) {
      return jsonEncode(object);
    }
    final map = objectToMap(object);
    print("map: $map");
    late final String json;

    try {
      json = jsonEncode(map);
    } catch (e, s) {
      print(e);
      print(s);
    }
    return json;
  }

  static dynamic convertPrimitive(dynamic body, Type T) {
    if (T == dynamic) {
      return jsonDecode(body);
    }
    if (T == File) {
      return File.fromRawPath(Uint8List.fromList(jsonDecode(body)));
    }
    if (T == String) {
      return body;
    } else if (T == int) {
      return int.parse(body);
    } else if (T == double) {
      return double.parse(body);
    } else if (T == bool) {
      return (body == "true");
    }
  }

  static isNullable(TypeMirror type) =>
      (reflect(null).type.isSubtypeOf(type)) ||
      (reflect(null).type.isAssignableTo(type)) ||
      (type.reflectedType == Null) ||
      (type.reflectedType == dynamic);

  static bool isPrimitive(dynamic object) => (object is String ||
      object is num ||
      object is int ||
      object is double ||
      object is bool ||
      object is List<String> ||
      object is List<int> ||
      object is List<bool> ||
      object == String ||
      object == num ||
      object == int ||
      object == double ||
      object == bool ||
      object == (List<String>) ||
      object == (List<int>) ||
      object == (List<double>) ||
      object == (List<num>) ||
      object == null ||
      object == (List<bool>));
}
