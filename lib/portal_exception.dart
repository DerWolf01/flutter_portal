import 'dart:io';

import 'package:flutter_portal/services/convertable.dart';

@convertable
class PortalException extends HttpException {
  final int statusCode;
  final String message;

  PortalException(this.statusCode, this.message) : super(message);
}
