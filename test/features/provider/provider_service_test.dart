import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/features/provider/data/mock_anime_provider.dart';
import 'package:tohyou/features/provider/data/mock_manga_provider.dart';
import 'package:tohyou/features/provider/domain/provider_registry.dart';
import 'package:tohyou/features/provider/domain/provider_selection.dart';
import 'package:tohyou/features/provider/domain/provider_service.dart';

void main() {
  late ProviderService service;

  setUp(() {
    service = ProviderService(
      ProviderRegistry(providers: [MockAnimeProvider(), MockMangaProvider()]),
    );
  });

  group('ProviderService', () {
    test('searches anime through selected provider', () async {
      final results = await service.searchAnime('mock-anime', 'One');

      expect(results, hasLength(1));
      expect(results.first.id, 'mock-anime-1');
    });

    test('gets anime details through selected provider', () async {
      final anime = await service.getAnimeDetails('mock-anime', 'mock-anime-1');

      expect(anime, isNotNull);
      expect(anime!.title, 'Mock Anime One');
    });

    test('gets anime episodes through selected provider', () async {
      final episodes = await service.getEpisodes('mock-anime', 'mock-anime-1');

      expect(episodes, hasLength(3));
      expect(episodes.first.number, 1);
    });

    test('gets anime streams through selected provider', () async {
      final streams = await service.getStreams(
        'mock-anime',
        'mock-anime-1-episode-1',
      );

      expect(streams, hasLength(2));
    });

    test('searches manga through selected provider', () async {
      final results = await service.searchManga('mock-manga', 'One');

      expect(results, hasLength(1));
      expect(results.first.id, 'mock-manga-1');
    });

    test('gets manga details through selected provider', () async {
      final manga = await service.getMangaDetails('mock-manga', 'mock-manga-1');

      expect(manga, isNotNull);
      expect(manga!.title, 'Mock Manga One');
    });

    test('gets manga chapters through selected provider', () async {
      final chapters = await service.getChapters('mock-manga', 'mock-manga-1');

      expect(chapters, hasLength(3));
      expect(chapters.first.number, 1);
    });

    test('gets manga pages through selected provider', () async {
      final pages = await service.getPages(
        'mock-manga',
        'mock-manga-1-chapter-1',
      );

      expect(pages, hasLength(3));
      expect(pages.first.index, 0);
    });

    test('throws for unknown anime provider id', () async {
      expect(
        () => service.searchAnime('missing', 'One'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when manga operation receives anime provider id', () async {
      expect(
        () => service.searchManga('mock-anime', 'One'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('searches anime through the selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(
          animeProviderId: 'mock-anime',
          mangaProviderId: 'mock-manga',
        ),
      );

      final results = await selectedService.searchSelectedAnime('One');

      expect(results, hasLength(1));
      expect(results.first.id, 'mock-anime-1');
    });

    test('searches manga through the selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(
          animeProviderId: 'mock-anime',
          mangaProviderId: 'mock-manga',
        ),
      );

      final results = await selectedService.searchSelectedManga('One');

      expect(results, hasLength(1));
      expect(results.first.id, 'mock-manga-1');
    });

    test('gets anime details through the selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(animeProviderId: 'mock-anime'),
      );

      final anime = await selectedService.getSelectedAnimeDetails(
        'mock-anime-1',
      );

      expect(anime, isNotNull);
      expect(anime!.title, 'Mock Anime One');
    });

    test('gets manga details through the selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(mangaProviderId: 'mock-manga'),
      );

      final manga = await selectedService.getSelectedMangaDetails(
        'mock-manga-1',
      );

      expect(manga, isNotNull);
      expect(manga!.title, 'Mock Manga One');
    });

    test('gets anime episodes through selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(animeProviderId: 'mock-anime'),
      );

      final episodes = await selectedService.getSelectedEpisodes(
        'mock-anime-1',
      );

      expect(episodes, hasLength(3));
      expect(episodes.first.number, 1);
    });

    test('gets anime streams through selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(animeProviderId: 'mock-anime'),
      );

      final streams = await selectedService.getSelectedStreams(
        'mock-anime-1-episode-1',
      );

      expect(streams, hasLength(2));
    });

    test('gets manga chapters through selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(mangaProviderId: 'mock-manga'),
      );

      final chapters = await selectedService.getSelectedChapters(
        'mock-manga-1',
      );

      expect(chapters, hasLength(3));
      expect(chapters.first.number, 1);
    });

    test('gets manga pages through selected provider', () async {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
        selection: const ProviderSelection(mangaProviderId: 'mock-manga'),
      );

      final pages = await selectedService.getSelectedPages(
        'mock-manga-1-chapter-1',
      );

      expect(pages, hasLength(3));
      expect(pages.first.index, 0);
    });

    test('throws when no anime provider is selected', () {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
      );

      expect(
        () => selectedService.searchSelectedAnime('One'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws when no manga provider is selected', () {
      final selectedService = ProviderService(
        ProviderRegistry(
          providers: [const MockAnimeProvider(), const MockMangaProvider()],
        ),
      );

      expect(
        () => selectedService.searchSelectedManga('One'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
