import 'package:flutter_portal/flutter_portal.dart';

void main(List<String> arguments) async {
  FlutterPortal.init(host: "0.0.0.0", port: 3000);
  final res = await flutterPortal.get<String>(
      "auth/sign-up", {"email": "user@example.com", "password": "password"});

  print("got $res");
}
