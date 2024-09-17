import 'dart:async';

import 'package:flutter_portal/reflection.dart';
import 'package:flutter_portal/services/conversion_service.dart';
import 'package:reflectable/reflectable.dart';

MethodService get methodService => MethodService();

typedef OnParameterAnotations = List<OnParameterAnotation>;

class MethodParameters {
  final List<dynamic> args;
  final Map<String, dynamic> namedArgs;

  MethodParameters(this.args, this.namedArgs);
}

class MethodService {
  static MethodService? _instance;

  factory MethodService() => (_instance ??= MethodService._());

  MethodService._();

  Object? invoke(
      {required InstanceMirror holderMirror,
      required MethodMirror methodMirror,
      required Map<String, dynamic> argumentsMap,
      OnParameterAnotations? onParameterAnotation}) {
    final methodParameters = methodArgumentsByMap(
        methodMirror: methodMirror,
        argumentsMap: argumentsMap,
        onParameterAnotation: onParameterAnotation);

    return holderMirror.invoke(
        methodMirror.simpleName,
        methodParameters.args,
        methodParameters.namedArgs.map(
          (key, value) => MapEntry(Symbol(key), value),
        ));
  }

  Future<dynamic> invokeAsync(
      {required InstanceMirror holderMirror,
      required MethodMirror methodMirror,
      required Map<String, dynamic> argumentsMap,
      OnParameterAnotations? onParameterAnotation}) async {
    final methodParameters = methodArgumentsByMap(
        methodMirror: methodMirror,
        argumentsMap: argumentsMap,
        onParameterAnotation: onParameterAnotation);
    final Object? res = await (holderMirror.invoke(
        methodMirror.simpleName,
        methodParameters.args,
        methodParameters.namedArgs.map(
          (key, value) => MapEntry(Symbol(key), value),
        )) as FutureOr<Object?>);

    return res;
  }

  MethodParameters methodArgumentsByMap(
      {required MethodMirror methodMirror,
      required Map<String, dynamic> argumentsMap,
      OnParameterAnotations? onParameterAnotation}) {
    List<dynamic> args = [];
    Map<String, dynamic> namedArgs = {};

    for (final param in methodMirror.parameters) {
      final name = param.simpleName;
      final anotation = onParameterAnotation
          ?.where(
            (element) => element.checkAnotation(param) != null,
          )
          .firstOrNull;

      if (anotation != null) {
        final anotationInstance = param.metadata
            .where(
              (element) =>
                  reflect(element).type.reflectedType ==
                  anotation.anotationType,
            )
            .first;

        if (param.isNamed) {
          namedArgs[name] = anotation.generateValue(
              name, argumentsMap[name], anotationInstance);
          continue;
        }

        args.add(anotation.generateValue(
            name, argumentsMap[name], anotationInstance));
        continue;
      }

      final containsKey = argumentsMap.keys.where(
            (element) {
              return element == name;
            },
          ).firstOrNull !=
          null;

      if (containsKey) {
        if (param.isNamed) {
          namedArgs[name] = ConversionService.primitiveStructureToObject(
              param: param, value: argumentsMap[name]);

          continue;
        }

        args.add(ConversionService.primitiveStructureToObject(
            param: param, value: argumentsMap[name]));
      } else {
        if (ConversionService.isNullable(param.type)) {
          args.add(null);
          continue;
        } else {
          throw ArgumentError('Missing argument $name');
        }
      }
    }
    return MethodParameters(args, namedArgs);
  }
}

class OnParameterAnotation<AnotationType> {
  final dynamic Function(String key, dynamic value, dynamic anotation)
      generateValue;

  const OnParameterAnotation(this.generateValue);
  Type get anotationType => AnotationType;
  AnotationType? checkAnotation(ParameterMirror parameterMirror) {
    return parameterMirror.metadata.where((element) {
      final elemenetType = reflect(element).type;
      final anotationTypeMirror = reflectClass(anotationType);
      return elemenetType.isAssignableTo(anotationTypeMirror) ||
          elemenetType.isSubtypeOf(anotationTypeMirror);
    }).firstOrNull as AnotationType?;
  }
}
