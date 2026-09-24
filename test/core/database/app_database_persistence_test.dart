import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:tohyou/core/database/app_database.dart';

void main() {
  late Directory temporaryDirectory;
  late File databaseFile;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'tohyou_database_test_',
    );

    databaseFile = File(
      p.join(
        temporaryDirectory.path,
        'tohyou_test.sqlite',
      ),
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('database persists data after closing and reopening', () async {
    final now = DateTime.now();

    // Open database instance #1.
    final database1 = AppDatabase(
      NativeDatabase(databaseFile),
    );

    // Insert a record.
    final mediaId = await database1.into(database1.mediaTable).insert(
          MediaTableCompanion.insert(
            title: 'Persistence Test',
            type: 'anime',
            description: const Value(
              'This record should survive database reopening.',
            ),
            coverUrl: const Value(null),
            sourceId: const Value('persistence-test'),
            sourceName: const Value('test'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    expect(mediaId, greaterThan(0));

    // Close the first database connection.
    await database1.close();

    // Open the SAME database file again.
    final database2 = AppDatabase(
      NativeDatabase(databaseFile),
    );

    // Read the record back.
    final media = await (database2.select(database2.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .getSingle();

    expect(media.id, mediaId);
    expect(media.title, 'Persistence Test');
    expect(media.type, 'anime');
    expect(media.sourceId, 'persistence-test');

    await database2.close();
  });
}