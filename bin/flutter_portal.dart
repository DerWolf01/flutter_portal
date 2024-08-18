import 'dart:io';

import 'package:flutter_portal/flutter_portal.dart';
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
  FlutterPortal.init(host: "localhost", port: 3000);
  final PortalResult<String>? response = await flutterPortal.post<String>(
      "/user/profile-picture/upload", ProfilePicture(f),
      headers: {
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJCaWxhbC5kZW1pcmNpMDAxQGdtYWlsLmNvbSIsIm5hbWUiOiIiLCJsYXN0bmFtZSI6IiIsInVzZXJuYW1lIjoiIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzIyNzE3NDk0fQ.G9-EqBmZRFtdfz13Sq7Pi9XWRHlIjq-G22NE3ctSaT0"
      });
  print(response?.data);
  final data = await flutterPortal.get<UserProfile>("/user/me", headers: {
    "Authorization":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJCaWxhbC5kZW1pcmNpMDAxQGdtYWlsLmNvbSIsIm5hbWUiOiIiLCJsYXN0bmFtZSI6IiIsInVzZXJuYW1lIjoiIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzIyNzE3NDk0fQ.G9-EqBmZRFtdfz13Sq7Pi9XWRHlIjq-G22NE3ctSaT0"
  });
  print(data.data?.profilePicture);
}

@convertable
class ProfilePicture {
  ProfilePicture(this.file);

  late final File file;
}

@convertable
class UserProfile {
  UserProfile(this.email, this.name, this.lastname, this.username, this.role,
      this.profilePicture);

  final String email;
  final String name;
  final String lastname;
  final String username;
  final Role role;
  final File? profilePicture;
}

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
