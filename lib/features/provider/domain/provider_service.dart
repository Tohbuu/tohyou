import 'package:tohyou/features/provider/domain/provider_exception.dart';

import 'anime.dart';
import 'anime_provider.dart';
import 'chapter.dart';
import 'chapter_page.dart';
import 'episode.dart';
import 'manga.dart';
import 'manga_provider.dart';
import 'paginated_result.dart';
import 'provider_registry.dart';
import 'stream_source.dart';
import 'provider_selection.dart';

class ProviderService {
  const ProviderService(
    this.registry, {
    this.selection = const ProviderSelection(),
  });

  final ProviderRegistry registry;
  final ProviderSelection selection;

  AnimeProvider _getAnimeProvider(String providerId) {
    final provider = registry.getById(providerId);

    if (provider == null) {
      throw ProviderException(
        type: ProviderErrorType.notFound,
        message: 'Provider was not found',
        providerId: providerId,
      );
    }

    if (provider is! AnimeProvider) {
      throw ProviderException(
        type: ProviderErrorType.unsupported,
        message: 'Provider is not an anime provider',
        providerId: providerId,
      );
    }

    return provider;
  }

  MangaProvider _getMangaProvider(String providerId) {
    final provider = registry.getById(providerId);

    if (provider == null) {
      throw ProviderException(
        type: ProviderErrorType.notFound,
        message: 'Provider was not found',
        providerId: providerId,
      );
    }

    if (provider is! MangaProvider) {
      throw ProviderException(
        type: ProviderErrorType.unsupported,
        message: 'Provider is not a manga provider',
        providerId: providerId,
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

  Future<PaginatedResult<Manga>> searchManga(
    String providerId,
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    return _getMangaProvider(providerId)
        .search(query, offset: offset, limit: limit);
  }

  Future<Manga?> getMangaDetails(String providerId, String id) {
    return _getMangaProvider(providerId).getDetails(id);
  }

  Future<PaginatedResult<Chapter>> getChapters(
    String providerId,
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) {
    return _getMangaProvider(providerId)
        .getChapters(mangaId, offset: offset, limit: limit);
  }

  Future<List<ChapterPage>> getPages(String providerId, String chapterId) {
    return _getMangaProvider(providerId).getPages(chapterId);
  }

  Future<List<Anime>> searchSelectedAnime(String query) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No anime provider is selected',
      );
    }

    return searchAnime(providerId, query);
  }

  Future<PaginatedResult<Manga>> searchSelectedManga(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No manga provider is selected',
      );
    }

    return searchManga(providerId, query, offset: offset, limit: limit);
  }

  Future<Anime?> getSelectedAnimeDetails(String id) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No anime provider is selected',
      );
    }

    return getAnimeDetails(providerId, id);
  }

  Future<Manga?> getSelectedMangaDetails(String id) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No manga provider is selected',
      );
    }

    return getMangaDetails(providerId, id);
  }

  Future<List<Episode>> getSelectedEpisodes(String animeId) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No anime provider is selected',
      );
    }

    return getEpisodes(providerId, animeId);
  }

  Future<List<StreamSource>> getSelectedStreams(String episodeId) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No anime provider is selected',
      );
    }

    return getStreams(providerId, episodeId);
  }

  Future<PaginatedResult<Chapter>> getSelectedChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No manga provider is selected',
      );
    }

    return getChapters(providerId, mangaId, offset: offset, limit: limit);
  }

  Future<List<ChapterPage>> getSelectedPages(String chapterId) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw const ProviderException(
        type: ProviderErrorType.notFound,
        message: 'No manga provider is selected',
      );
    }

    return getPages(providerId, chapterId);
  }
}
