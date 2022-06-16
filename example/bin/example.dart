import 'package:example/example.dart';
import 'package:libleaf/app.dart';

void main(List<String> arguments) {
  final ExampleLocalPreferences preferences = ExampleLocalPreferences(
    backend: ExamplePreferencesBackend(),
  );

  preferences.testA = 0;
  print(preferences.testA);
  preferences.testB = TestB.two;
  print(preferences.testB);
  preferences.testA = 6;
  print(preferences.testA);
  preferences.testB = null;
  print(preferences.testB);
}
