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
  print(ConversionService.mapToObject<UserProfile>(
      ConversionService.objectToMap(UserProfile.named(
          id: 1,
          username: "username",
          email: "email",
          name: "name",
          lastname: "lastname",
          profilePicture: null))));
}

@convertable
class UserProfile {
  UserProfile(
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.username,
    this.profilePicture,
  );
  UserProfile.named({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.lastname,
    this.profilePicture,
  });
  final int id;
  final String email;
  final String name;
  final String lastname;
  final String username;
  final File? profilePicture;

  String get fullName => "$name $lastname";
}
