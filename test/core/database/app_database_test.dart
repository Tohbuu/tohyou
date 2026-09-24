import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('media CRUD works', () async {
    final now = DateTime.now();

    // CREATE
    final mediaId = await database.into(database.mediaTable).insert(
          MediaTableCompanion.insert(
            title: 'Frieren: Beyond Journey\'s End',
            type: 'anime',
            description: const Value(
              'Database verification record.',
            ),
            coverUrl: const Value(null),
            sourceId: const Value('test-frieren'),
            sourceName: const Value('test'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    expect(mediaId, greaterThan(0));

    // READ
    var media = await (database.select(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .getSingle();

    expect(media.title, 'Frieren: Beyond Journey\'s End');
    expect(media.type, 'anime');

    // UPDATE
    await (database.update(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .write(
          MediaTableCompanion(
            title: const Value('Frieren'),
            updatedAt: Value(DateTime.now()),
          ),
        );

    // READ UPDATED RECORD
    media = await (database.select(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .getSingle();

    expect(media.title, 'Frieren');

    // DELETE
    await (database.delete(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .go();

    // VERIFY DELETION
    final deletedMedia = await (database.select(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .get();

    expect(deletedMedia, isEmpty);
  });
}