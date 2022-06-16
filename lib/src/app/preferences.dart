abstract class LocalPreferences {
  final LocalPreferencesBackend backend;

  const LocalPreferences({required this.backend});
}

abstract class LocalPreferencesBackend {
  const LocalPreferencesBackend();

  int? getInt(String pref);
  double? getDouble(String pref);
  bool? getBool(String pref);
  String? getString(String pref);
  List<String>? getStringList(String pref);

  void setInt(String pref, int? value);
  void setDouble(String pref, double? value);
  void setBool(String pref, bool? value);
  void setString(String pref, String? value);
  void setStringList(String pref, List<String>? value);
}

class ExamplePreferencesBackend implements LocalPreferencesBackend {
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
  void setBool(String pref, bool? value) {
    _store[pref] = value;
  }

  @override
  void setDouble(String pref, double? value) {
    _store[pref] = value;
  }

  @override
  void setInt(String pref, int? value) {
    _store[pref] = value;
  }

  @override
  void setString(String pref, String? value) {
    _store[pref] = value;
  }

  @override
  void setStringList(String pref, List<String>? value) {
    _store[pref] = value;
  }
}
