import '../domain/chapter.dart';
import '../domain/chapter_page.dart';
import '../domain/manga.dart';
import '../domain/manga_provider.dart';
import '../domain/provider_capabilities.dart';
import '../domain/provider_exception.dart';
import '../domain/provider_type.dart';
import 'mangadex_client.dart';
import 'mangadex_http_client.dart';

class MangaDexProvider implements MangaProvider {
  const MangaDexProvider({this._client});

  final MangaDexClient? _client;

  @override
  String get id => 'mangadex';

  @override
  String get name => 'MangaDex';

  @override
  ProviderType get type => ProviderType.manga;

  @override
  ProviderCapabilities get capabilities => const ProviderCapabilities(
    search: true,
    details: true,
    chapters: true,
    pages: true,
  );

  MangaDexClient get client {
    final client = _client;

    if (client == null) {
      throw StateError('MangaDexProvider requires a MangaDexClient');
    }

    return client;
  }

  @override
  Future<List<Manga>> search(String query) {
    return _withProviderErrors(() async {
      final response = await client.searchManga(query);
      final data = response['data'];

      if (data is! List) {
        throw const FormatException('MangaDex search response is missing data');
      }

      return data.whereType<Map<String, dynamic>>().map(_parseManga).toList();
    });
  }

  @override
  Future<Manga?> getDetails(String id) {
    return _withProviderErrors(() async {
      final response = await client.getManga(id);
      final data = response['data'];

      if (data == null) {
        return null;
      }

      if (data is! Map<String, dynamic>) {
        throw const FormatException(
          'MangaDex details response contains invalid data',
        );
      }

      return _parseManga(data);
    });
  }

  @override
  Future<List<Chapter>> getChapters(String mangaId) {
    return _withProviderErrors(() async {
      final response = await client.getChapters(mangaId);
      final data = response['data'];

      if (data is! List) {
        throw const FormatException(
          'MangaDex chapters response is missing data',
        );
      }

      return data.whereType<Map<String, dynamic>>().map(_parseChapter).toList();
    });
  }

  @override
  Future<List<ChapterPage>> getPages(String chapterId) {
    return _withProviderErrors(() async {
      final response = await client.getChapterPages(chapterId);

      final baseUrl = response['baseUrl'];
      final chapter = response['chapter'];

      if (baseUrl is! String || baseUrl.isEmpty) {
        throw const FormatException(
          'MangaDex pages response is missing baseUrl',
        );
      }

      if (chapter is! Map<String, dynamic>) {
        throw const FormatException(
          'MangaDex pages response is missing chapter data',
        );
      }

      final hash = chapter['hash'];
      final data = chapter['data'];

      if (hash is! String || hash.isEmpty) {
        throw const FormatException(
          'MangaDex pages response is missing chapter hash',
        );
      }

      if (data is! List) {
        throw const FormatException(
          'MangaDex pages response is missing page data',
        );
      }

      return data.asMap().entries.map((entry) {
        final index = entry.key;
        final filename = entry.value;

        if (filename is! String || filename.isEmpty) {
          throw const FormatException('MangaDex page is missing a filename');
        }

        return ChapterPage(index: index, url: '$baseUrl/data/$hash/$filename');
      }).toList();
    });
  }

  Future<T> _withProviderErrors<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on MangaDexHttpException catch (error) {
      throw ProviderException(
        type: _mapHttpError(error.statusCode),
        message: error.message,
        providerId: id,
      );
    } on FormatException catch (error) {
      throw ProviderException(
        type: ProviderErrorType.invalidResponse,
        message: error.message,
        providerId: id,
      );
    }
  }

  ProviderErrorType _mapHttpError(int statusCode) {
    if (statusCode == 404) {
      return ProviderErrorType.notFound;
    }

    if (statusCode == 429) {
      return ProviderErrorType.unavailable;
    }

    if (statusCode >= 500 && statusCode <= 599) {
      return ProviderErrorType.network;
    }

    return ProviderErrorType.network;
  }

  Chapter _parseChapter(Map<String, dynamic> data) {
    final id = data['id'];

    if (id is! String || id.isEmpty) {
      throw const FormatException('MangaDex chapter is missing an id');
    }

    final attributes = data['attributes'];

    if (attributes is! Map<String, dynamic>) {
      throw const FormatException('MangaDex chapter is missing attributes');
    }

    final chapter = attributes['chapter'];

    if (chapter is! String || chapter.isEmpty) {
      throw const FormatException(
        'MangaDex chapter is missing a chapter number',
      );
    }

    final parsedNumber = int.tryParse(chapter);

    if (parsedNumber == null) {
      throw FormatException(
        'MangaDex chapter has an invalid chapter number: $chapter',
      );
    }

    final title = attributes['title'];

    return Chapter(
      id: id,
      number: parsedNumber,
      title: title is String && title.isNotEmpty
          ? title
          : 'Chapter $parsedNumber',
    );
  }

  Manga _parseManga(Map<String, dynamic> data) {
    final id = data['id'];

    if (id is! String || id.isEmpty) {
      throw const FormatException('MangaDex manga is missing an id');
    }

    final attributes = data['attributes'];

    if (attributes is! Map<String, dynamic>) {
      throw const FormatException('MangaDex manga is missing attributes');
    }

    final title = _parseTitle(attributes['title']);

    return Manga(id: id, title: title);
  }

  String _parseTitle(dynamic value) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('MangaDex manga is missing title');
    }

    final english = value['en'];

    if (english is String && english.isNotEmpty) {
      return english;
    }

    for (final entry in value.entries) {
      final title = entry.value;

      if (title is String && title.isNotEmpty) {
        return title;
      }

      if (title is List && title.isNotEmpty) {
        final first = title.first;

        if (first is String && first.isNotEmpty) {
          return first;
        }
      }
    }

    throw const FormatException('MangaDex manga has no usable title');
  }
}
