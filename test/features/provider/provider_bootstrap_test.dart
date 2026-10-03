import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/provider_bootstrap.dart';

void main() {
  group('Provider bootstrap', () {
    test('createRegistry contains the two built-in mock providers', () {
      final registry = createRegistry();

      expect(registry.all, hasLength(2));
      expect(registry.all.map((provider) => provider.id), containsAll(['mock-anime', 'mock-manga']));

      expect(registry.anime, hasLength(1));
      expect(registry.anime.single.id, 'mock-anime');

      expect(registry.manga, hasLength(1));
      expect(registry.manga.single.id, 'mock-manga');
    });

    test('createProviderService can actually use both provider types', () async {
      final service = createProviderService();

      final animeResults = await service.searchAnime('mock-anime', 'One');
      final mangaResults = await service.searchManga('mock-manga', 'One');

      expect(animeResults, hasLength(1));
      expect(animeResults.single.title, 'Mock Anime One');

      expect(mangaResults, hasLength(1));
      expect(mangaResults.single.title, 'Mock Manga One');
    });

    test('the shared providerService is usable', () async {
      final animeResults = await providerService.searchAnime('mock-anime', 'One');
      final mangaResults = await providerService.searchManga('mock-manga', 'One');

      expect(animeResults, hasLength(1));
      expect(animeResults.single.id, 'mock-anime-1');

      expect(mangaResults, hasLength(1));
      expect(mangaResults.single.id, 'mock-manga-1');
    });
  });
}
