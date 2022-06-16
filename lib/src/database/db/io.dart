import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  final LazyDatabase executor = LazyDatabase(() async {
    final File dbFile = File(p.join(databaseFolder, databaseName));
    final String databaseKey = await getDatabaseKey();

    return NativeDatabase(
      dbFile,
      logStatements: logStatements,
      setup: (database) {
        database.execute("PRAGMA key = '$databaseKey';");
      },
    );
  });
  return executor;
}
