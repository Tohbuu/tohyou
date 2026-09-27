import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mock_manga_provider.dart';
import 'package:tohyou/features/provider/domain/provider_type.dart';

void main() {
  const provider = MockMangaProvider();

  group('MockMangaProvider', () {
    test('exposes manga provider metadata', () {
      expect(provider.id, 'mock-manga');
      expect(provider.name, 'Mock Manga');
      expect(provider.type, ProviderType.manga);

      expect(provider.capabilities.search, isTrue);
      expect(provider.capabilities.details, isTrue);
      expect(provider.capabilities.episodes, isFalse);
      expect(provider.capabilities.streaming, isFalse);
      expect(provider.capabilities.chapters, isTrue);
      expect(provider.capabilities.pages, isTrue);
    });

    test('search returns matching manga', () async {
      final results = await provider.search('One');

      expect(results, hasLength(1));
      expect(results.single.id, 'mock-manga-1');
      expect(results.single.title, 'Mock Manga One');
    });

    test('search is case insensitive', () async {
      final results = await provider.search('mock manga two');

      expect(results, hasLength(1));
      expect(results.single.id, 'mock-manga-2');
    });

    test('empty search returns all manga', () async {
      final results = await provider.search('');

      expect(results, hasLength(2));
    });

    test('getDetails returns matching manga', () async {
      final result = await provider.getDetails('mock-manga-1');

      expect(result, isNotNull);
      expect(result!.title, 'Mock Manga One');
    });

    test('getDetails returns null for unknown manga', () async {
      final result = await provider.getDetails('missing');

      expect(result, isNull);
    });

    test('getChapters returns chapters for known manga', () async {
      final chapters = await provider.getChapters('mock-manga-1');

      expect(chapters, hasLength(3));
      expect(chapters[0].number, 1);
      expect(chapters[1].number, 2);
      expect(chapters[2].number, 3);
    });

    test('getChapters returns empty list for unknown manga', () async {
      final chapters = await provider.getChapters('missing');

      expect(chapters, isEmpty);
    });

    test('getPages returns chapter pages', () async {
      final pages = await provider.getPages('mock-manga-1-chapter-1');

      expect(pages, hasLength(3));
      expect(pages[0].index, 0);
      expect(pages[1].index, 1);
      expect(pages[2].index, 2);
    });

    test('getPages returns empty list for unknown chapter', () async {
      final pages = await provider.getPages('missing');

      expect(pages, isEmpty);
    });
  });
}
