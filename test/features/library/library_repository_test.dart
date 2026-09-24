import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/core/database/app_database.dart';
import 'package:tohyou/features/library/data/library_repository.dart';

void main() {
  late AppDatabase database;
  late LibraryRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LibraryRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('adds and reads a library entry', () async {
    final now = DateTime.now();

    final mediaId = await database.into(database.mediaTable).insert(
          MediaTableCompanion.insert(
            title: 'Frieren: Beyond Journey\'s End',
            type: 'anime',
            description: const Value('Test media'),
            coverUrl: const Value('https://example.com/frieren.jpg'),
            sourceId: const Value('test-frieren'),
            sourceName: const Value('test'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    await repository.addToLibrary(
      mediaId: mediaId,
      status: 'watching',
      progress: 5,
      total: 28,
    );

    final library = await repository.getLibrary();

    expect(library, hasLength(1));
    expect(library.first.mediaId, mediaId);
    expect(library.first.title, 'Frieren: Beyond Journey\'s End');
    expect(library.first.type, 'anime');
    expect(library.first.status, 'watching');
    expect(library.first.progress, 5);
    expect(library.first.total, 28);
  });

  test('removes a library entry', () async {
    final now = DateTime.now();

    final mediaId = await database.into(database.mediaTable).insert(
          MediaTableCompanion.insert(
            title: 'Test Manga',
            type: 'manga',
            createdAt: now,
            updatedAt: now,
          ),
        );

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: 'reading',
    );

    expect(await repository.getLibrary(), hasLength(1));

    final removed = await repository.removeFromLibrary(entryId);

    expect(removed, isTrue);
    expect(await repository.getLibrary(), isEmpty);
  });
}