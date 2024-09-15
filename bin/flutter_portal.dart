import 'dart:convert';
import 'dart:io';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/list_of.dart';
import 'package:reflectable/reflectable.dart';
import './flutter_portal.reflectable.dart';

void main() async {
  initializeReflectable();
  FlutterPortal.init(host: "watcher-test.de", scheme: Scheme.https);
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
  try {
    print(await flutterPortal.post("/e/marketplace-closure", {}));
  } catch (e, s) {
    print(e);
    print(s);
  }
}
