import 'package:drift/drift.dart';
import 'package:liblymph/src/database/db/stub.dart';

QueryExecutor constructDb({
  required AsyncStringCallback databaseFolder,
  required String databaseName,
  required AsyncStringCallback databaseKey,
  bool logStatements = false,
  OnPreOpenDatabase? onPreOpenDatabase,
}) {
  throw UnimplementedError('Platform not supported');
}
