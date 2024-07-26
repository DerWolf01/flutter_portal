import 'package:flutter_portal/services/conversion_service.dart';
import 'package:flutter_portal/services/convertable.dart';
import './flutter_portal.reflectable.dart';

enum Roles { admin, user }

extension RolesExtension on Roles {
  Role get role {
    switch (this) {
      case Roles.admin:
        return const Role.namedParams(id: 0, name: "admin");
      case Roles.user:
        return const Role.namedParams(id: 1, name: "user");
    }
  }
}

@convertable
class Role {
  const Role.namedParams({required this.id, required this.name});

  const Role(this.id, this.name);

  final int id;

  final String name;
}

@convertable
class User {
  final String email;
  final String name;
  final String lastname;
  final String token;
  final int role;

  Role get getRole => Roles.values[role].role;

  User(this.email, this.name, this.lastname, this.token, this.role);
}

@convertable
class SignInResult extends User {
  SignInResult(this.needsSignUp, super.email, super.name, super.lastname,
      super.token, super.role);

  final bool needsSignUp;
}

void main(List<String> arguments) async {
  initializeReflectable();
  print(ConversionService.mapToObject(
      ConversionService.objectToMap(
          SignInResult(false, "test", "test", "test", "test", 0)),
      type: SignInResult));
  // FlutterPortal.init(host: "0.0.0.0", port: 3000);
  // final res = await flutterPortal.post<SignUpResult>(
  //     "auth/sign-up", SignUpForm("test@mail.com", "asdasda"));
  //
  // print("got $res");
}
