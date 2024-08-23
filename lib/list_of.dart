import 'package:flutter_portal/flutter_portal.dart';

@convertable
class ListOf<T> {
  const ListOf({required this.type});

  final Type type;
}
