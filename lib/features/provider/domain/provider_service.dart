import 'anime.dart';
import 'anime_provider.dart';
import 'chapter.dart';
import 'chapter_page.dart';
import 'episode.dart';
import 'manga.dart';
import 'manga_provider.dart';
import 'provider_registry.dart';
import 'stream_source.dart';

class ProviderService {
  const ProviderService(this.registry);

  final ProviderRegistry registry;

  AnimeProvider _getAnimeProvider(String providerId) {
    final provider = registry.getById(providerId);

    if (provider is! AnimeProvider) {
      throw ArgumentError.value(
        providerId,
        'providerId',
        'Provider is not an anime provider',
      );
    }

    return provider;
  }

  MangaProvider _getMangaProvider(String providerId) {
    final provider = registry.getById(providerId);

    if (provider is! MangaProvider) {
      throw ArgumentError.value(
        providerId,
        'providerId',
        'Provider is not a manga provider',
      );
    }

    return provider;
  }

  Future<List<Anime>> searchAnime(String providerId, String query) {
    return _getAnimeProvider(providerId).search(query);
  }

  Future<Anime?> getAnimeDetails(String providerId, String id) {
    return _getAnimeProvider(providerId).getDetails(id);
  }

  Future<List<Episode>> getEpisodes(String providerId, String animeId) {
    return _getAnimeProvider(providerId).getEpisodes(animeId);
  }

  Future<List<StreamSource>> getStreams(String providerId, String episodeId) {
    return _getAnimeProvider(providerId).getStreams(episodeId);
  }

  Future<List<Manga>> searchManga(String providerId, String query) {
    return _getMangaProvider(providerId).search(query);
  }

  Future<Manga?> getMangaDetails(String providerId, String id) {
    return _getMangaProvider(providerId).getDetails(id);
  }

  Future<List<Chapter>> getChapters(String providerId, String mangaId) {
    return _getMangaProvider(providerId).getChapters(mangaId);
  }

  Future<List<ChapterPage>> getPages(String providerId, String chapterId) {
    return _getMangaProvider(providerId).getPages(chapterId);
  }
}
