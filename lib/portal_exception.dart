import 'package:flutter_portal/services/convertable.dart';
import 'package:http/http.dart';

@convertable
class PortalException extends ClientException {
  final int statusCode;

  PortalException(this.statusCode, super.message) : super();

  @override
  String toString() {
    return 'PortalException: statusCode:$statusCode got messages: "$message"';
  }
}
