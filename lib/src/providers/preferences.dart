abstract class LocalPreferences<T extends PreferencesBackend> {
  final T backend;

  const LocalPreferences({required this.backend});
}

abstract class PreferencesBackend {
  const PreferencesBackend();

  T? read<T>(String key);
  void write<T>(String key, T value);
  void delete(String key);
}

abstract class TypedPreferencesBackend extends PreferencesBackend {
  const TypedPreferencesBackend();

  @override
  T? read<T>(String key) {
    // Small hack to check for T actual type
    final List<T> tValue = <T>[];

    final Object? value;

    if (tValue is List<int>) {
      value = getInt(key);
    } else if (tValue is List<double>) {
      value = getDouble(key);
    } else if (tValue is List<bool>) {
      value = getBool(key);
    } else if (tValue is List<String>) {
      value = getString(key);
    } else if (tValue is List<List<String>>) {
      value = getStringList(key);
    } else {
      throw UnsupportedPreferenceTypeException<T>();
    }

    return value as T;
  }

  @override
  void write<T>(String key, T value) {
    if (value is int) {
      return setInt(key, value);
    } else if (value is double) {
      return setDouble(key, value);
    } else if (value is bool) {
      return setBool(key, value);
    } else if (value is String) {
      return setString(key, value);
    } else if (value is List<String>) {
      return setStringList(key, value);
    } else {
      throw UnsupportedPreferenceTypeException<T>();
    }
  }

  int? getInt(String key);
  double? getDouble(String key);
  bool? getBool(String key);
  String? getString(String key);
  List<String>? getStringList(String key);

  void setInt(String key, int value);
  void setDouble(String key, double value);
  void setBool(String key, bool value);
  void setString(String key, String value);
  void setStringList(String key, List<String> value);
}

class UnsupportedPreferenceTypeException<T> implements Exception {
  const UnsupportedPreferenceTypeException();

  @override
  String toString() {
    return "The $T type isn' supported, expected int, double, bool, String or List<String>";
  }
}
