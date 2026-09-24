import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/library_entry.dart';
import '../domain/library_status.dart';
import '../domain/media_type.dart';

class LibraryRepository {
  LibraryRepository(this._database);

  final AppDatabase _database;

  Future<List<LibraryEntry>> getLibrary() async {
    final query = _database.select(_database.libraryEntriesTable).join([
      innerJoin(
        _database.mediaTable,
        _database.mediaTable.id.equalsExp(
          _database.libraryEntriesTable.mediaId,
        ),
      ),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final libraryEntry = row.readTable(_database.libraryEntriesTable);
      final media = row.readTable(_database.mediaTable);

      return LibraryEntry(
        id: libraryEntry.id,
        mediaId: libraryEntry.mediaId,
        title: media.title,
        type: MediaType.fromValue(media.type),
        status: LibraryStatus.fromValue(libraryEntry.status),
        progress: libraryEntry.progress,
        total: libraryEntry.total,
        favorite: libraryEntry.favorite,
        coverUrl: media.coverUrl,
      );
    }).toList();
  }

  Future<LibraryEntry?> getEntry(int libraryEntryId) async {
    final query = _database.select(_database.libraryEntriesTable).join([
      innerJoin(
        _database.mediaTable,
        _database.mediaTable.id.equalsExp(
          _database.libraryEntriesTable.mediaId,
        ),
      ),
    ])..where(_database.libraryEntriesTable.id.equals(libraryEntryId));

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    final libraryEntry = row.readTable(_database.libraryEntriesTable);
    final media = row.readTable(_database.mediaTable);

    return LibraryEntry(
      id: libraryEntry.id,
      mediaId: libraryEntry.mediaId,
      title: media.title,
      type: MediaType.fromValue(media.type),
      status: LibraryStatus.fromValue(libraryEntry.status),
      progress: libraryEntry.progress,
      total: libraryEntry.total,
      favorite: libraryEntry.favorite,
      coverUrl: media.coverUrl,
    );
  }

  Future<int> addToLibrary({
    required int mediaId,
    required LibraryStatus status,
    int progress = 0,
    int? total,
    bool favorite = false,
  }) {
    final now = DateTime.now();

    return _database
        .into(_database.libraryEntriesTable)
        .insert(
          LibraryEntriesTableCompanion.insert(
            mediaId: mediaId,
            status: status.value,
            progress: Value(progress),
            total: Value(total),
            favorite: Value(favorite),
            addedAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<bool> updateProgress({
    required int libraryEntryId,
    required int progress,
    int? total,
  }) async {
    final updated =
        await (_database.update(
          _database.libraryEntriesTable,
        )..where((table) => table.id.equals(libraryEntryId))).write(
          LibraryEntriesTableCompanion(
            progress: Value(progress),
            total: Value(total),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return updated > 0;
  }

  Future<bool> updateStatus({
    required int libraryEntryId,
    required LibraryStatus status,
  }) async {
    final updated =
        await (_database.update(
          _database.libraryEntriesTable,
        )..where((table) => table.id.equals(libraryEntryId))).write(
          LibraryEntriesTableCompanion(
            status: Value(status.value),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return updated > 0;
  }

  Future<bool> toggleFavorite(int libraryEntryId) async {
    final entry = await (_database.select(
      _database.libraryEntriesTable,
    )..where((table) => table.id.equals(libraryEntryId))).getSingleOrNull();

    if (entry == null) {
      return false;
    }

    final updated =
        await (_database.update(
          _database.libraryEntriesTable,
        )..where((table) => table.id.equals(libraryEntryId))).write(
          LibraryEntriesTableCompanion(
            favorite: Value(!entry.favorite),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return updated > 0;
  }

  Future<bool> removeFromLibrary(int libraryEntryId) {
    return (_database.delete(_database.libraryEntriesTable)
          ..where((table) => table.id.equals(libraryEntryId)))
        .go()
        .then((count) => count > 0);
  }
}
