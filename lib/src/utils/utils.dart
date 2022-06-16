import 'package:uuid/uuid.dart';

abstract class Utils {
  const Utils._();

  static List<T> asList<T>(dynamic obj) {
    return List<T>.from(obj as List<dynamic>);
  }

  static Map<K, V> asMap<K, V>(dynamic obj) {
    return Map<K, V>.from(obj as Map<dynamic, dynamic>);
  }

  static String generateId() {
    return const Uuid().v4();
  }

  static const bool isWeb = identical(0, 0.0);
}
