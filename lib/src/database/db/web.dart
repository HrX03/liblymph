import 'package:drift/drift.dart';
import 'package:drift/web.dart';

import 'package:liblymph/src/database/db/stub.dart';
import 'package:path/path.dart' as p;

QueryExecutor constructDb({
  required AsyncStringCallback databaseFolder,
  required String databaseName,
  required AsyncStringCallback databaseKey,
  bool logStatements = false,
  OnPreOpenDatabase? onPreOpenDatabase,
}) {
  onPreOpenDatabase?.call();

  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported(
        p.join(await databaseFolder(), databaseName),
      ),
      logStatements: logStatements,
    );
  });
}
