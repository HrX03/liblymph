import 'package:drift/drift.dart';
import 'package:libleaf/src/database/database.dart';

part 'tag_helper.g.dart';

@DriftAccessor(tables: [Tags])
class TagHelper extends DatabaseAccessor<AppDatabase> with _$TagHelperMixin {
  final AppDatabase db;

  TagHelper(this.db) : super(db);

  Future<List<Tag>> listTags(TagReturnMode returnMode) {
    switch (returnMode) {
      case TagReturnMode.all:
        return select(tags).get();
      case TagReturnMode.synced:
        return (select(tags)..where((table) => table.id.contains("-synced")))
            .get();
      case TagReturnMode.local:
      default:
        return (select(tags)
              ..where((table) => table.id.contains("-synced").not()))
            .get();
    }
  }

  Future<List<Tag>> getTagsById(List<String> ids) {
    final SimpleSelectStatement<$TagsTable, Tag> selectQuery = select(tags);
    selectQuery.where(
      (table) => table.id.contains("-synced").not() & table.id.isIn(ids),
    );
    return selectQuery.get();
  }

  Stream<List<Tag>> watchTags(TagReturnMode returnMode) {
    SimpleSelectStatement<$TagsTable, Tag> selectQuery;
    switch (returnMode) {
      case TagReturnMode.all:
        selectQuery = select(tags);
        break;
      case TagReturnMode.synced:
        selectQuery = select(tags)
          ..where((table) => table.id.contains("-synced"));
        break;
      case TagReturnMode.local:
      default:
        selectQuery = select(tags)
          ..where((table) => table.id.contains("-synced").not());
        break;
    }
    return selectQuery.watch();
  }

  Future<void> saveTag(Tag tag) {
    return into(tags).insert(tag, mode: InsertMode.replace);
  }

  Future<void> deleteTag(Tag tag) => delete(tags).delete(tag);

  Future<void> deleteAllTags() async {
    final List<Tag> tags = await listTags(TagReturnMode.all);
    for (final Tag tag in tags) {
      await deleteTag(tag);
    }
  }
}

enum TagReturnMode { local, synced, all }
