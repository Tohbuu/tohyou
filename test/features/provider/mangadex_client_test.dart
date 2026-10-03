import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mangadex_client.dart';

class FakeMangaDexClient implements MangaDexClient {
  @override
  Future<Map<String, dynamic>> getManga(String id) async {
    return <String, dynamic>{'id': id};
  }

  @override
  Future<Map<String, dynamic>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    return <String, dynamic>{'query': query};
  }

  @override
  Future<Map<String, dynamic>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) async {
    return <String, dynamic>{'mangaId': mangaId};
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) async {
    return <String, dynamic>{'chapterId': chapterId};
  }
}

void main() {
  group('MangaDexClient', () {
    test('can be implemented by a concrete client', () async {
      final client = FakeMangaDexClient();

      expect(await client.getManga('manga-1'), {'id': 'manga-1'});
      expect(await client.searchManga('One Piece'), {'query': 'One Piece'});
      expect(await client.getChapters('manga-1'), {'mangaId': 'manga-1'});
      expect(await client.getChapterPages('chapter-1'), {
        'chapterId': 'chapter-1',
      });
    });
  });
}
