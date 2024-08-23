import 'dart:io';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/list_of.dart';
import 'package:reflectable/reflectable.dart';
import './flutter_portal.reflectable.dart';

typedef NullableString = String?;
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
  print(ConversionService.mapToObject<SignUpResult>(
      ConversionService.objectToMap(SignUpResult.init("", [
    SignUpStrings.init("asd"),
    SignUpStrings.init("asd"),
    SignUpStrings.init("asd")
  ]))));
}

@convertable
class SignUpResult {
  SignUpResult.init(this.token, @ListOf(type: SignUpStrings) this.list);
  SignUpResult(this.token, @ListOf(type: SignUpStrings) this.list);

  late final String token;

  @ListOf(type: SignUpStrings)
  late final List<dynamic> list;
}

@convertable
class SignUpStrings {
  SignUpStrings.init(this.value);
  SignUpStrings(this.value);

  late final String value;
}

class User {
  User();

  User.init(this.name, this.file);

  late final File file;
  late final String name;
}

class SignUpForm {
  SignUpForm.init(this.user);

  late final User user;
}
