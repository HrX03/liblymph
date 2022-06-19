import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  final LazyDatabase executor = LazyDatabase(() async {
    final File dbFile = File(p.join(await databaseFolder(), databaseName));
    final String key = await databaseKey();

    return NativeDatabase(
      dbFile,
      logStatements: logStatements,
      setup: (database) {
        database.execute("PRAGMA key = '$key';");
      },
    );
  });
  return executor;
}
