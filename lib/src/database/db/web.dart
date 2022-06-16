import 'package:drift/drift.dart';
import 'package:drift/web.dart';

import 'package:libleaf/src/database/db/stub.dart';
import 'package:path/path.dart' as p;

QueryExecutor constructDb({
  required String databaseFolder,
  required String databaseName,
  required DatabaseKeyCallback getDatabaseKey,
  bool logStatements = false,
  OnPreOpenDatabase? onPreOpenDatabase,
}) {
  onPreOpenDatabase?.call();

  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported(
        p.join(databaseFolder, databaseName),
      ),
      logStatements: logStatements,
    );
  });
}
