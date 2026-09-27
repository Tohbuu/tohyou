import 'anime.dart';
import 'anime_provider.dart';
import 'chapter.dart';
import 'chapter_page.dart';
import 'episode.dart';
import 'manga.dart';
import 'manga_provider.dart';
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

  Future<List<Anime>> searchSelectedAnime(String query) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw StateError('No anime provider is selected');
    }

    return searchAnime(providerId, query);
  }

  Future<List<Manga>> searchSelectedManga(String query) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw StateError('No manga provider is selected');
    }

    return searchManga(providerId, query);
  }

  Future<Anime?> getSelectedAnimeDetails(String id) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw StateError('No anime provider is selected');
    }

    return getAnimeDetails(providerId, id);
  }

  Future<Manga?> getSelectedMangaDetails(String id) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw StateError('No manga provider is selected');
    }

    return getMangaDetails(providerId, id);
  }

  Future<List<Episode>> getSelectedEpisodes(String animeId) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw StateError('No anime provider is selected');
    }

    return getEpisodes(providerId, animeId);
  }

  Future<List<StreamSource>> getSelectedStreams(String episodeId) {
    final providerId = selection.animeProviderId;

    if (providerId == null) {
      throw StateError('No anime provider is selected');
    }

    return getStreams(providerId, episodeId);
  }

  Future<List<Chapter>> getSelectedChapters(String mangaId) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw StateError('No manga provider is selected');
    }

    return getChapters(providerId, mangaId);
  }

  Future<List<ChapterPage>> getSelectedPages(String chapterId) {
    final providerId = selection.mangaProviderId;

    if (providerId == null) {
      throw StateError('No manga provider is selected');
    }

    return getPages(providerId, chapterId);
  }
}
