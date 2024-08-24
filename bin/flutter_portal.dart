import 'dart:io';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/list_of.dart';
import 'package:reflectable/reflectable.dart';
import './flutter_portal.reflectable.dart';

void main() async {
  initializeReflectable();
  // print((reflectClass(SignUpResult)
  //         .declarations
  //         .values
  //         .whereType<MethodMirror>()
  //         .where((element) =>
  //             element.isConstructor && element.constructorName == "init")
  //         .toList()[0])
  //     .parameters
  //     .where(
  //       (element) => element.simpleName == "list",
  //     )
  //     .firstOrNull
  //     ?.metadata);
  print(ConversionService.mapToObject<UserChild>(
      ConversionService.objectToMap(UserChild(
    1,
    "email",
    "name",
    "lastname",
    "token",
  ))));
}

@convertable
class User {
  final int id;
  final String email;
  final String name;
  final String lastname;
  final String token;

  User(
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.token,
  );
}

@convertable
class UserChild extends User {
  UserChild(super.id, super.email, super.name, super.lastname, super.token);
}
