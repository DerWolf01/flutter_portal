import 'package:flutter_portal/services/convertable.dart';
import 'package:http/http.dart';

@convertable
class PortalException extends ClientException {
  final int statusCode;
  final String reasonPhrase;
  PortalException(this.statusCode, super.message, this.reasonPhrase) : super();

  @override
  String toString() {
    return 'PortalException: statusCode:$statusCode, message: "$message", reasonPhrase: "$reasonPhrase"';
  }
}
