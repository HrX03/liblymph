import 'package:drift/drift.dart';
import 'package:libleaf/src/database/dao/folder_helper.dart';
import 'package:libleaf/src/database/database.dart';
import 'package:libleaf/src/utils/logger.dart';

part 'note_helper.g.dart';

@DriftAccessor(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase>
    with _$NoteHelperMixin, LoggerProvider {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes(Folder folder) async {
    if (folder != BuiltInFolders.all) {
      return (select(notes)
            ..where(
              (table) => table.folder.equals(folder.id),
            ))
          .get();
    } else {
      return select(notes).get();
    }
  }

  Stream<Note> watchNote(Note note) {
    return (select(notes)..where((table) => table.id.equals(note.id)))
        .watchSingle();
  }

  Stream<List<Note>> watchNotes(Folder folder) {
    SimpleSelectStatement<$NotesTable, Note> selectQuery;

    if (folder != BuiltInFolders.all) {
      selectQuery = select(notes)
        ..where(
          (table) => table.folder.equals(folder.id),
        );
    } else {
      selectQuery = select(notes);
    }

    return (selectQuery
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.creationDate,
                  mode: OrderingMode.desc,
                )
          ]))
        .watch();
  }

  Future<void> saveNote(Note note) {
    //logger.d("The note id is: ${note.id}");
    return into(notes).insert(note, mode: InsertMode.replace);
  }

  Future<bool> noteExists(Note note) async {
    final SimpleSelectStatement<$NotesTable, Note> selectQuery = select(notes)
      ..whereSamePrimaryKey(note);
    final Note? match = await selectQuery.getSingleOrNull();
    return match != null;
  }

  Future<void> deleteNote(Note note) {
    //logger.d("The note id to delete: ${note.id}");
    return delete(notes).delete(note);
  }

  Future<void> deleteAllNotes() async {
    final List<Note> notes = await listNotes(BuiltInFolders.all);

    for (final Note note in notes) {
      await deleteNote(note);
    }
  }
}

class SearchQuery {
  bool caseSensitive;
  int? color;
  DateTime? date;
  DateFilterMode dateMode;
  Set<String> tags = {};
  bool onlyFavourites;
  Set<Folder> folders = {};

  SearchQuery({
    this.caseSensitive = false,
    this.color,
    this.date,
    this.dateMode = DateFilterMode.only,
    this.onlyFavourites = false,
    this.folders = const {},
  });

  void reset() {
    caseSensitive = false;
    color = null;
    date = null;
    dateMode = DateFilterMode.only;
    tags = {};
    onlyFavourites = false;
    folders = {};
  }

  List<Note> filterNotes(
    String textQuery,
    List<Note> notes, {
    bool returnNothingOnEmptyQuery = true,
  }) {
    final List<Note> results = [];

    if (textQuery.trim().isEmpty &&
        !onlyFavourites &&
        date == null &&
        tags.isEmpty &&
        color == null) {
      if (returnNothingOnEmptyQuery) {
        return [];
      } else {
        return notes;
      }
    }

    for (final Note note in notes) {
      final bool titleMatch = _getTextBool(textQuery, note.title);
      final bool contentMatch =
          !note.hideContent && _getTextBool(textQuery, note.content);
      final bool dateMatch = _getDateBool(note.creationDate);
      final bool colorMatch = _getColorBool(note.color);
      final bool tagMatch = _getTagBool(note.tags);
      final bool favouriteMatch = _getFavouriteBool(note.starred);
      final bool folderMatch = _getFoldersBool(note.folder);
      final bool match = tagMatch &&
          colorMatch &&
          dateMatch &&
          favouriteMatch &&
          (titleMatch || contentMatch) &&
          folderMatch;

      if (match) results.add(note);
    }

    return results;
  }

  // Kinda dumb method but this way lint doesn't complain + it's consistent
  bool _getFavouriteBool(bool starred) {
    if (!onlyFavourites) return true;
    return starred;
  }

  bool _getColorBool(int noteColor) {
    if (color == null) return true;
    return noteColor == color;
  }

  bool _getDateBool(DateTime noteDate) {
    if (date == null) return true;

    final DateTime sanitizedNoteDate = DateTime(
      noteDate.year,
      noteDate.month,
      noteDate.day,
    );

    final DateTime sanitizedQueryDate = DateTime(
      date!.year,
      date!.month,
      date!.day,
    );

    switch (dateMode) {
      case DateFilterMode.after:
        return sanitizedNoteDate.isAfter(sanitizedQueryDate);
      case DateFilterMode.before:
        return sanitizedNoteDate.isBefore(sanitizedQueryDate);
      case DateFilterMode.only:
      default:
        return sanitizedNoteDate.isAtSameMomentAs(sanitizedQueryDate);
    }
  }

  bool _getTextBool(String textQuery, String text) {
    final String sanitizedQuery =
        caseSensitive ? textQuery : textQuery.toLowerCase();

    final String sanitizedText = caseSensitive ? text : text.toLowerCase();

    return sanitizedText.contains(sanitizedQuery);
  }

  bool _getTagBool(List<String> tags) {
    if (tags.isEmpty) return true;

    bool? matchResult;

    for (final String tag in tags) {
      if (matchResult != null) {
        matchResult = matchResult && this.tags.any((element) => element == tag);
      } else {
        matchResult = this.tags.any((element) => element == tag);
      }
    }

    return matchResult ?? false;
  }

  bool _getFoldersBool(String folder) {
    if (folders.isEmpty) return true;

    return folders.any((f) => f.id == folder);
  }
}

class SearchReturnMode {
  final bool fromNormal;
  final bool fromArchive;
  final bool fromTrash;

  const SearchReturnMode({
    this.fromNormal = false,
    this.fromArchive = false,
    this.fromTrash = false,
  });

  List<bool> get values => [
        fromNormal,
        fromArchive,
        fromTrash,
      ];

  SearchReturnMode copyWith({
    bool? fromNormal,
    bool? fromArchive,
    bool? fromTrash,
  }) {
    return SearchReturnMode(
      fromNormal: fromNormal ?? this.fromNormal,
      fromArchive: fromArchive ?? this.fromArchive,
      fromTrash: fromTrash ?? this.fromTrash,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is SearchReturnMode) {
      return fromNormal == other.fromNormal &&
          fromArchive == other.fromArchive &&
          fromTrash == other.fromTrash;
    }
    return false;
  }

  @override
  int get hashCode =>
      fromNormal.hashCode ^ fromArchive.hashCode ^ fromTrash.hashCode;
}

enum DateFilterMode {
  after,
  before,
  only,
}

@Deprecated("Prefer Folder instead of ReturnMode")
enum ReturnMode {
  all,
  normal,
  archive,
  trash,
  favourites,
  tag,
  synced,
  local,
}
