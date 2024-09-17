import 'package:flutter_portal/flutter_portal.dart';

import './flutter_portal.reflectable.dart';

void main() async {
  initializeReflectable();
  FlutterPortal.init(host: "watcher-test.de", scheme: Scheme.https);
  final json = ConversionService.encodeJSON(DaeHolder());

  print(json);

  final object = ConversionService.jsonToObject<DaeHolder>(json);
  print(object);
  try {
    print(await flutterPortal.post("/e/marketplace-closure", {}));
  } catch (e, s) {
    print(e);
    print(s);
  }
}

@convertable
class DaeHolder {
  DateTime date = DateTime.now();
  DaeHolder();
}
