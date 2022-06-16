import 'package:libleaf/app.dart';

part 'example.g.dart';

int calculate() {
  return 6 * 7;
}

@BuildLocalPreferences('data/preferences.json')
class ExampleLocalPreferences extends LocalPreferences
    with _$LocalPreferencesGenerated {
  const ExampleLocalPreferences({required super.backend});
}
