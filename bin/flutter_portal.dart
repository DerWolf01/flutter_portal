import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/services/conversion_service.dart';
import 'package:flutter_portal/services/convertable.dart';
import './flutter_portal.reflectable.dart';

@convertable
class SignUpResult {
  const SignUpResult(this.token);

  final String token;
}

@convertable
class User {
  const User(this.name);

  final String name;
}

@convertable
class SignUpForm {
  const SignUpForm(this.user);

  final User user;
}

void main(List<String> arguments) async {
  initializeReflectable();
  print(ConversionService.mapToObject(
      ConversionService.objectToMap(SignUpForm(User("test"))),
      type: SignUpForm));
  // FlutterPortal.init(host: "0.0.0.0", port: 3000);
  // final res = await flutterPortal.post<SignUpResult>(
  //     "auth/sign-up", SignUpForm("test@mail.com", "asdasda"));
  //
  // print("got $res");
}
