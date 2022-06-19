import 'package:example/generated/preferences.dart';
import 'package:liblymph/providers.dart';

void main(List<String> arguments) {
  final SharedPrefs preferences = SharedPrefs(
    backend: ExamplePreferencesBackend(),
  );
  preferences.accessToken;
}

class ExamplePreferencesBackend extends TypedPreferencesBackend {
  final Map<String, dynamic> _store = {};

  @override
  bool? getBool(String pref) {
    return _store[pref] as bool?;
  }

  @override
  double? getDouble(String pref) {
    return _store[pref] as double?;
  }

  @override
  int? getInt(String pref) {
    return _store[pref] as int?;
  }

  @override
  String? getString(String pref) {
    return _store[pref] as String?;
  }

  @override
  List<String>? getStringList(String pref) {
    return (_store[pref] as List<dynamic>?)?.cast<String>();
  }

  @override
  void setBool(String pref, bool value) {
    _store[pref] = value;
  }

  @override
  void setDouble(String pref, double value) {
    _store[pref] = value;
  }

  @override
  void setInt(String pref, int value) {
    _store[pref] = value;
  }

  @override
  void setString(String pref, String value) {
    _store[pref] = value;
  }

  @override
  void setStringList(String pref, List<String> value) {
    _store[pref] = value;
  }

  @override
  void delete(String key) {
    _store.remove(key);
  }
}
