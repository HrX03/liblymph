import 'package:example/generated/preferences.dart';
import 'package:liblymph/providers.dart';

void main(List<String> arguments) {
  final SharedPrefs preferences = SharedPrefs(
    backend: ExamplePreferencesBackend(),
  );
}
