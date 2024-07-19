import 'package:flutter_portal/services/convertable.dart';
import 'package:reflectable/mirrors.dart';

InstanceMirror reflect(dynamic object) => convertable.reflect(object);

ClassMirror reflectClass(Type type) =>
    convertable.reflectType(type) as ClassMirror;
