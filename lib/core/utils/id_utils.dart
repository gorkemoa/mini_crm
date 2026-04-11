import 'package:uuid/uuid.dart';

abstract class IdUtils {
  static const _uuid = Uuid();
  static String generate() => _uuid.v4();
}
