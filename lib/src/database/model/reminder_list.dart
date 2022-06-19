import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:libleaf/src/utils/utils.dart';

class ReminderListConverter extends TypeConverter<List<DateTime>, String> {
  const ReminderListConverter();
  @override
  List<DateTime>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final List<String> decoded = Utils.asList<String>(json.decode(fromDb));
    return List.generate(
      decoded.length,
      (index) => DateTime.fromMillisecondsSinceEpoch(
        json.decode(decoded[index]) as int,
      ),
    );
  }

  @override
  String? mapToSql(List<DateTime>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(
      List.generate(
        value.length,
        (index) => value[index].millisecondsSinceEpoch,
      ),
    );
  }
}
