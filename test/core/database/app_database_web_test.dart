import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/core/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('web database can create and read a media item', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final now = DateTime.now();

    final mediaId = await database.into(database.mediaTable).insert(
          MediaTableCompanion.insert(
            title: 'Web Verification',
            type: 'anime',
            description: const Value(
              'Chrome database verification record.',
            ),
            coverUrl: const Value(null),
            sourceId: const Value('web-test'),
            sourceName: const Value('test'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    final media = await (database.select(database.mediaTable)
          ..where((table) => table.id.equals(mediaId)))
        .getSingle();

    expect(media.id, mediaId);
    expect(media.title, 'Web Verification');
    expect(media.type, 'anime');
    expect(media.sourceId, 'web-test');

    await database.close();
  });
}