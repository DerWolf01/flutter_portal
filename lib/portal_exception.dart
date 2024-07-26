import 'dart:io';

import 'package:flutter_portal/services/convertable.dart';

@convertable
class PortalException extends IOException {
  final int statusCode;
  final String message;

  PortalException(this.statusCode, this.message) : super();
}
