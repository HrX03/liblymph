import 'package:drift/drift.dart';
import 'package:libleaf/src/database/db/stub.dart';

QueryExecutor constructDb({
  required String databaseFolder,
  required String databaseName,
  required DatabaseKeyCallback getDatabaseKey,
  bool logStatements = false,
  OnPreOpenDatabase? onPreOpenDatabase,
}) {
  throw UnimplementedError('Platform not supported');
}
