import '../domain/anime.dart';
import '../domain/anime_provider.dart';
import '../domain/episode.dart';
import '../domain/provider_capabilities.dart';
import '../domain/provider_type.dart';
import '../domain/stream_source.dart';
import '../domain/stream_type.dart';

class MockAnimeProvider implements AnimeProvider {
  const MockAnimeProvider();

  @override
  String get id => 'mock-anime';

  @override
  String get name => 'Mock Anime';

  @override
  ProviderType get type => ProviderType.anime;

  @override
  ProviderCapabilities get capabilities => const ProviderCapabilities(
    search: true,
    details: true,
    episodes: true,
    streaming: true,
  );

  @override
  Future<List<Anime>> search(String query) async {
    const results = [
      Anime(
        id: 'mock-anime-1',
        title: 'Mock Anime One',
        coverUrl: 'https://example.com/mock-anime-1.jpg',
      ),
      Anime(
        id: 'mock-anime-2',
        title: 'Mock Anime Two',
        coverUrl: 'https://example.com/mock-anime-2.jpg',
      ),
    ];

    if (query.trim().isEmpty) {
      return results;
    }

    final normalizedQuery = query.trim().toLowerCase();

    return results
        .where((anime) => anime.title.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  @override
  Future<Anime?> getDetails(String id) async {
    const anime = Anime(
      id: 'mock-anime-1',
      title: 'Mock Anime One',
      coverUrl: 'https://example.com/mock-anime-1.jpg',
    );

    if (anime.id == id) {
      return anime;
    }

    return null;
  }

  @override
  Future<List<Episode>> getEpisodes(String animeId) async {
    if (animeId != 'mock-anime-1') {
      return [];
    }

    return const [
      Episode(id: 'mock-anime-1-episode-1', number: 1, title: 'Episode One'),
      Episode(id: 'mock-anime-1-episode-2', number: 2, title: 'Episode Two'),
      Episode(id: 'mock-anime-1-episode-3', number: 3, title: 'Episode Three'),
    ];
  }

  @override
  Future<List<StreamSource>> getStreams(String episodeId) async {
    if (episodeId != 'mock-anime-1-episode-1') {
      return [];
    }

    return const [
      StreamSource(
        url: 'https://example.com/mock-anime-1-episode-1.mp4',
        type: StreamType.direct,
      ),
      StreamSource(
        url: 'https://example.com/mock-anime-1-episode-1.m3u8',
        type: StreamType.hls,
      ),
    ];
  }
}
