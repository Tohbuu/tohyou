import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mangadex_http_client.dart';
import 'package:tohyou/features/provider/data/mangadex_provider.dart';
import 'package:tohyou/features/provider/provider_bootstrap.dart';

void main() {
  group('Provider bootstrap', () {
    test('createRegistry contains the built-in providers', () {
      final registry = createRegistry();

      expect(registry.all, hasLength(3));
      expect(
        registry.all.map((provider) => provider.id),
        containsAll(['mock-anime', 'mock-manga', 'mangadex']),
      );

      expect(registry.anime, hasLength(1));
      expect(registry.anime.single.id, 'mock-anime');

      expect(registry.manga, hasLength(2));
      expect(
        registry.manga.map((provider) => provider.id),
        containsAll(['mock-manga', 'mangadex']),
      );
    });

    test(
      'createProviderService can actually use both provider types',
      () async {
        final service = createProviderService();

        final animeResults = await service.searchAnime('mock-anime', 'One');
        final mangaResults = await service.searchManga('mock-manga', 'One');

        expect(animeResults, hasLength(1));
        expect(animeResults.single.title, 'Mock Anime One');

        expect(mangaResults.items, hasLength(1));
        expect(mangaResults.items.single.title, 'Mock Manga One');
      },
    );

    test('createProviderService includes MangaDex', () {
      final service = createProviderService();

      final provider = service.registry.getById('mangadex');

      expect(provider, isA<MangaDexProvider>());
    });

    test('createRegistry wires MangaDex with an HTTP client', () {
      final registry = createRegistry();

      final provider = registry.getById('mangadex');

      expect(provider, isA<MangaDexProvider>());
      expect((provider! as MangaDexProvider).client, isA<MangaDexHttpClient>());
    });

    test('the shared providerService is usable', () async {
      final animeResults = await providerService.searchAnime(
        'mock-anime',
        'One',
      );
      final mangaResults = await providerService.searchManga(
        'mock-manga',
        'One',
      );

      expect(animeResults, hasLength(1));
      expect(animeResults.single.id, 'mock-anime-1');

      expect(mangaResults.items, hasLength(1));
      expect(mangaResults.items.single.id, 'mock-manga-1');
    });
  });
}
