import 'dart:convert';
import 'dart:io';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_portal/list_of.dart';
import 'package:reflectable/reflectable.dart';
import './flutter_portal.reflectable.dart';
import './jobs.dart';

void main() async {
  initializeReflectable();
  FlutterPortal.init(host: "localhost", port: 3000);
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
    print(await flutterPortal.get<JobsListsWithUserProfile>("/job/all",
        headers: {"Authorization": ""}));
  } catch (e, s) {
    print(e);
    print(s);
  }
}
