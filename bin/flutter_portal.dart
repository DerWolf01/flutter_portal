import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/services/convertable.dart';
import './flutter_portal.reflectable.dart';

@convertable
class SignUpResult {
  const SignUpResult(this.token);

  final String token;
}

@convertable
class SignUpForm {
  const SignUpForm(this.email, this.password);

  final String email;
  final String password;
}

void main(List<String> arguments) async {
  initializeReflectable();
  FlutterPortal.init(host: "0.0.0.0", port: 3000);
  final res = await flutterPortal.post<SignUpResult>(
      "auth/sign-up", SignUpForm("test@mail.com", "asdasda"));

  print("got $res");
}
