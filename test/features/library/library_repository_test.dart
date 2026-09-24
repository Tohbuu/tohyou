import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/core/database/app_database.dart';
import 'package:tohyou/features/library/data/library_repository.dart';
import 'package:tohyou/features/library/domain/library_status.dart';
import 'package:tohyou/features/library/domain/media_type.dart';

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

  Future<int> createTestMedia({
    String title = 'Test Media',
    String type = 'anime',
  }) {
    final now = DateTime.now();

    return database
        .into(database.mediaTable)
        .insert(
          MediaTableCompanion.insert(
            title: title,
            type: type,
            description: const Value('Test media'),
            coverUrl: const Value('https://example.com/test.jpg'),
            sourceId: const Value('test-source'),
            sourceName: const Value('test'),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  test('adds and reads a library entry', () async {
    final mediaId = await createTestMedia(
      title: 'Frieren: Beyond Journey\'s End',
    );

    await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.watching,
      progress: 5,
      total: 28,
    );

    final library = await repository.getLibrary();

    expect(library, hasLength(1));
    expect(library.first.mediaId, mediaId);
    expect(library.first.title, 'Frieren: Beyond Journey\'s End');
    expect(library.first.type, MediaType.anime);
    expect(library.first.status, LibraryStatus.watching);
    expect(library.first.progress, 5);
    expect(library.first.total, 28);
    expect(library.first.favorite, isFalse);
  });

  test('gets a single library entry by id', () async {
    final mediaId = await createTestMedia();

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.watching,
      progress: 3,
      total: 12,
    );

    final entry = await repository.getEntry(entryId);

    expect(entry, isNotNull);
    expect(entry!.id, entryId);
    expect(entry.mediaId, mediaId);
    expect(entry.progress, 3);
    expect(entry.total, 12);
  });

  test('returns null when library entry does not exist', () async {
    final entry = await repository.getEntry(999);

    expect(entry, isNull);
  });

  test('updates library progress', () async {
    final mediaId = await createTestMedia();

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.watching,
      progress: 3,
      total: 12,
    );

    final updated = await repository.updateProgress(
      libraryEntryId: entryId,
      progress: 7,
      total: 12,
    );

    expect(updated, isTrue);

    final entry = await repository.getEntry(entryId);

    expect(entry!.progress, 7);
    expect(entry.total, 12);
  });

  test('updates library status', () async {
    final mediaId = await createTestMedia();

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.planToWatch,
    );

    final updated = await repository.updateStatus(
      libraryEntryId: entryId,
      status: LibraryStatus.watching,
    );

    expect(updated, isTrue);

    final entry = await repository.getEntry(entryId);

    expect(entry!.status, LibraryStatus.watching);
  });

  test('toggles favorite', () async {
    final mediaId = await createTestMedia();

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.watching,
    );

    final firstToggle = await repository.toggleFavorite(entryId);

    expect(firstToggle, isTrue);

    var entry = await repository.getEntry(entryId);

    expect(entry!.favorite, isTrue);

    final secondToggle = await repository.toggleFavorite(entryId);

    expect(secondToggle, isTrue);

    entry = await repository.getEntry(entryId);

    expect(entry!.favorite, isFalse);
  });

  test('returns false when updating a missing entry', () async {
    final updatedProgress = await repository.updateProgress(
      libraryEntryId: 999,
      progress: 5,
    );

    final updatedStatus = await repository.updateStatus(
      libraryEntryId: 999,
      status: LibraryStatus.completed,
    );

    final toggledFavorite = await repository.toggleFavorite(999);

    expect(updatedProgress, isFalse);
    expect(updatedStatus, isFalse);
    expect(toggledFavorite, isFalse);
  });

  test('removes a library entry', () async {
    final mediaId = await createTestMedia(title: 'Test Manga', type: 'manga');

    final entryId = await repository.addToLibrary(
      mediaId: mediaId,
      status: LibraryStatus.reading,
    );

    expect(await repository.getLibrary(), hasLength(1));

    final removed = await repository.removeFromLibrary(entryId);

    expect(removed, isTrue);
    expect(await repository.getLibrary(), isEmpty);
  });

  test('returns false when removing a missing entry', () async {
    final removed = await repository.removeFromLibrary(999);

    expect(removed, isFalse);
  });
}
