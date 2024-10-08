import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_portal/list_of.dart';
import 'package:flutter_portal/method_service.dart';
import 'package:flutter_portal/reflection.dart';
import 'package:flutter_portal/services/convertable.dart';
import 'package:reflectable/reflectable.dart';

//TODO Implement json service in order to avoid converting Files to int list in the conversion service
/// A service class for converting objects to maps and vice versa,
/// as well as handling HTTP request conversions.
class ConversionService {
  static dynamic convertPrimitive(dynamic body, Type T) {
    if (T == List<String>) {
      return (body as List).map((e) => e.toString()).toList();
    }
    if (T == List<int>) {
      return (body as List).map((e) => int.parse(e.toString())).toList();
    }
    if (T == List<double>) {
      return (body as List).map((e) => double.parse(e.toString())).toList();
    }
    if (T == List<num>) {
      return (body as List).map((e) => num.parse(e.toString())).toList();
    }
    if (T == List<bool>) {
      return (body as List).map((e) => e == "true").toList();
    }
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

  /// Converts an object to a JSON string or its string representation.
  ///
  /// \param object The object to convert.
  /// \return A JSON string or string representation of the object.
  static String encodeJSON(dynamic object) {
    if (isPrimitive(object)) {
      return jsonEncode(object);
    }
    final map = objectToMap(object, json: true);

    late final String json;

    try {
      json = jsonEncode(map);
    } catch (e, s) {
      print(e);
      print(s);
    }
    return json;
  }

  static bool isNullable(TypeMirror type) {
    return type.isNullable;
  }

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

  /// Converts a JSON string to an object of type T.
  ///
  /// \param body The JSON string to convert.
  /// \return An instance of type T.

  static T? jsonToObject<T>(dynamic body) {
    if (T == dynamic) {
      return jsonDecode(body) as T;
    }
    if (T == String) {
      return body as T;
    } else if (T == int) {
      return int.parse(body) as T;
    } else if (T == double) {
      return double.parse(body) as T;
    } else if (T == bool) {
      return (body == "true") as T;
    }

    return mapToObject<T>(jsonDecode(body));
  }

  /// Converts a map to an object of type T.
  ///
  /// \param map The map to convert.
  /// \param type The type of the object to create (optional).
  /// \return An instance of type T.
  static T mapToObject<T>(Map<String, dynamic> map, {Type? type}) {
    final classMirror = convertable.reflectType(type ?? T);
    final decs = declarations(classMirror as ClassMirror);

    final constructor = classMirror.declarations.values.firstWhere(
      (element) =>
          element is MethodMirror &&
          element.isConstructor &&
          element.constructorName == "",
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

  /// Converts an object to a map by reflecting its fields.
  ///
  /// \param object The object to convert.
  /// \return A map representation of the object.
  static Map<String, dynamic> objectToMap(dynamic object, {bool json = false}) {
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
          continue;
        } else if (fieldValue is List) {
          map[name] = fieldValue.map((e) => objectToMap(e)).toList();
          continue;
        } else if (fieldValue is DateTime) {
          if (json) {
            map[name] = fieldValue.toIso8601String();
            continue;
          } else {
            map[name] = fieldValue;
            continue;
          }
        } else if (fieldValue is File) {
          map[name] = fieldValue.readAsBytesSync().toList();
          continue;
        }
        map[name] = objectToMap(fieldValue);
        continue;
      }
    }

    return map;
  }

  static dynamic primitiveStructureToObject<T>({
    TypeMirror? type,
    ParameterMirror? param,
    required dynamic value,
  }) {
    final Type t = ((param?.type ?? type)?.reflectedType ?? (T));

    final typeMirror = param?.type ?? type ?? convertable.reflectType(T);
    final nullable = typeMirror.isNullable;

    final List metadata = param?.metadata ?? typeMirror.metadata;
    final listOfAnotation = metadata.whereType<ListOf>().firstOrNull;

    if (value.runtimeType == t && listOfAnotation == null) {
      return value;
    } else if (value == null && nullable) {
      return null;
    } else if (t == DateTime || t is DateTime) {
      if (value is DateTime) {
        return value;
      } else if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        throw Exception("Invalid date format $value: ${value.runtimeType}");
      }
    } else if (t is File || t == File) {
      final f = File("random.file");
      f.writeAsBytesSync(value.whereType<int>().toList());

      return f;
    } else if (isPrimitive(t) && listOfAnotation == null) {
      if (value.runtimeType == t) {
        return value;
      }
      final result = convertPrimitive(value, t);

      return result;
    } else if (value is List) {
      if (value.isEmpty) {
        return [];
      }

      if (listOfAnotation == null) {
        throw Exception(
            "Field ${typeMirror.simpleName} of type ${typeMirror.reflectedType} in class ${typeMirror.reflectedType} has to be anotated with @ListOf(type) to ensure conversion");
      }

      final listEntries =
          value.map((e) => mapToObject(e, type: listOfAnotation.type)).toList();

      return listEntries;
    }

    return mapToObject(value, type: t);
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
}
