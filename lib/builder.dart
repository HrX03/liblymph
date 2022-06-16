import 'package:build/build.dart';
import 'package:libleaf/src/app/preferences_gen.dart';
import 'package:source_gen/source_gen.dart';

Builder preferencesBuilder(BuilderOptions options) => SharedPartBuilder(
      const [LocalPreferencesGenerator()],
      "preferences",
    );
