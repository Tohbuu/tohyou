import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mock_anime_provider.dart';
import 'package:tohyou/features/provider/data/mock_manga_provider.dart';
import 'package:tohyou/features/provider/domain/provider_registry.dart';
import 'package:tohyou/features/provider/domain/provider_type.dart';

void main() {
  group('ProviderRegistry integration', () {
    late ProviderRegistry registry;

    setUp(() {
      registry = ProviderRegistry(
        providers: const [MockAnimeProvider(), MockMangaProvider()],
      );
    });

    test('contains all built-in providers', () {
      expect(registry.all, hasLength(2));
      expect(registry.all[0].id, 'mock-anime');
      expect(registry.all[1].id, 'mock-manga');
    });

    test('separates anime and manga providers', () {
      expect(registry.anime, hasLength(1));
      expect(registry.anime.single.type, ProviderType.anime);

      expect(registry.manga, hasLength(1));
      expect(registry.manga.single.type, ProviderType.manga);
    });

    test('finds built-in providers by id', () {
      expect(registry.getById('mock-anime'), isA<MockAnimeProvider>());

      expect(registry.getById('mock-manga'), isA<MockMangaProvider>());
    });

    test('unknown provider id returns null', () {
      expect(registry.getById('unknown'), isNull);
    });

    test('anime provider can execute through registry', () async {
      final provider = registry.getById('mock-anime');

      expect(provider, isA<MockAnimeProvider>());

      final animeProvider = provider! as MockAnimeProvider;
      final results = await animeProvider.search('One');

      expect(results, hasLength(1));
      expect(results.single.title, 'Mock Anime One');
    });

    test('manga provider can execute through registry', () async {
      final provider = registry.getById('mock-manga');

      expect(provider, isA<MockMangaProvider>());

      final mangaProvider = provider! as MockMangaProvider;
      final results = await mangaProvider.search('Two');

      expect(results, hasLength(1));
      expect(results.single.title, 'Mock Manga Two');
    });
  });
}
