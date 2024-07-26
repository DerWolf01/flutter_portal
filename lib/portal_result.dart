import 'package:flutter_portal/services/convertable.dart';

@convertable
class PortalResult<ShouldHave> {
  PortalResult(this.statusCode, this.data);

  final int statusCode;
  final ShouldHave? data;
}
