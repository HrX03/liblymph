import 'package:drift/drift.dart';
import 'package:liblymph/src/database/database.dart';

part 'tag_helper.g.dart';

@DriftAccessor(tables: [Tags])
class TagHelper extends DatabaseAccessor<AppDatabase> with _$TagHelperMixin {
  final AppDatabase db;

  TagHelper(this.db) : super(db);

  Future<List<Tag>> listTags() {
    return select(tags).get();
  }

  Future<List<Tag>> getTagsById(List<String> ids) {
    final SimpleSelectStatement<$TagsTable, Tag> selectQuery = select(tags);
    selectQuery.where(
      (table) => table.id.isIn(ids),
    );
    return selectQuery.get();
  }

  Stream<List<Tag>> watchTags() {
    return select(tags).watch();
  }

  Future<void> saveTag(Tag tag) {
    return into(tags).insert(tag, mode: InsertMode.replace);
  }

  Future<void> deleteTag(Tag tag) => delete(tags).delete(tag);

  Future<void> deleteAllTags() async {
    final List<Tag> tags = await listTags();
    for (final Tag tag in tags) {
      await deleteTag(tag);
    }
  }
}

