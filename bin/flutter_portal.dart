import 'dart:io';

import 'package:flutter_portal/services/conversion_service.dart';
import 'package:flutter_portal/services/convertable.dart';
import './flutter_portal.reflectable.dart';

@convertable
class SignUpResult {
  late final String token;
}

@convertable
class User {
  User(this.name, this.file);

  late final File file;
  late final String name;
}

@convertable
class SignUpForm {
  SignUpForm(this.user);

  SignUpForm.init(this.user);

  late final User user;
}

void main(List<String> arguments) async {
  initializeReflectable();

  final f = await File("./hello.txt").create();
  await f.writeAsString("Hello World");
  print(ConversionService.mapToObject(
      ConversionService.objectToMap(SignUpForm.init(User("test", f))),
      type: SignUpForm));
}
