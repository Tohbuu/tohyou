import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mangadex_client.dart';
import 'package:tohyou/features/provider/data/mangadex_http_client.dart';
import 'package:tohyou/features/provider/data/mangadex_provider.dart';
import 'package:tohyou/features/provider/domain/manga_provider.dart';
import 'package:tohyou/features/provider/domain/provider_exception.dart';

class FakeMangaDexClient implements MangaDexClient {
  FakeMangaDexClient({
    this.searchResponse = const <String, dynamic>{
      'result': 'ok',
      'limit': 10,
      'offset': 0,
      'total': 0,
      'data': <dynamic>[],
    },
    this.getMangaResponse = const <String, dynamic>{
      'result': 'ok',
      'response': 'entity',
      'data': null,
    },
    this.getChaptersResponse = const <String, dynamic>{
      'result': 'ok',
      'limit': 100,
      'offset': 0,
      'total': 0,
      'data': <dynamic>[],
    },
    this.getChapterPagesResponse = const <String, dynamic>{
      'result': 'ok',
      'baseUrl': 'https://uploads.mangadex.org',
      'chapter': <String, dynamic>{'hash': 'abc123', 'data': <dynamic>[]},
    },
  });

  final Map<String, dynamic> searchResponse;
  final Map<String, dynamic> getMangaResponse;
  final Map<String, dynamic> getChaptersResponse;
  final Map<String, dynamic> getChapterPagesResponse;

  @override
  Future<Map<String, dynamic>> getManga(String id) async {
    return getMangaResponse;
  }

  @override
  Future<Map<String, dynamic>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    return searchResponse;
  }

  @override
  Future<Map<String, dynamic>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) async {
    return getChaptersResponse;
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) async {
    return getChapterPagesResponse;
  }
}

class ThrowingMangaDexClient implements MangaDexClient {
  const ThrowingMangaDexClient({required this.error});

  final Exception error;

  @override
  Future<Map<String, dynamic>> getManga(String id) {
    return Future<Map<String, dynamic>>.error(error);
  }

  @override
  Future<Map<String, dynamic>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    return Future<Map<String, dynamic>>.error(error);
  }

  @override
  Future<Map<String, dynamic>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) {
    return Future<Map<String, dynamic>>.error(error);
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) {
    return Future<Map<String, dynamic>>.error(error);
  }
}

void main() {
  group('MangaDexProvider', () {
    test('implements MangaProvider', () {
      const provider = MangaDexProvider();

      expect(provider, isA<MangaProvider>());
    });

    test('exposes provider metadata', () {
      const provider = MangaDexProvider();

      expect(provider.id, 'mangadex');
      expect(provider.name, 'MangaDex');
      expect(provider.type.name, 'manga');
    });

    test('exposes supported capabilities', () {
      const provider = MangaDexProvider();

      expect(provider.capabilities.search, isTrue);
      expect(provider.capabilities.details, isTrue);
      expect(provider.capabilities.chapters, isTrue);
      expect(provider.capabilities.pages, isTrue);
      expect(provider.capabilities.episodes, isFalse);
      expect(provider.capabilities.streaming, isFalse);
    });

    test('searches and parses MangaDex results', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': 20,
            'total': 42,
            'data': <dynamic>[
              <String, dynamic>{
                'id': 'manga-1',
                'attributes': <String, dynamic>{
                  'title': <String, dynamic>{'en': 'One Piece'},
                },
              },
              <String, dynamic>{
                'id': 'manga-2',
                'attributes': <String, dynamic>{
                  'title': <String, dynamic>{'ja': 'ワンピース'},
                },
              },
            ],
          },
        ),
      );

      final results = await provider.search('One Piece', offset: 20, limit: 10);

      expect(results.items, hasLength(2));
      expect(results.offset, 20);
      expect(results.limit, 10);
      expect(results.total, 42);
      expect(results.hasMore, isTrue);
      expect(results.items[0].id, 'manga-1');
      expect(results.items[0].title, 'One Piece');
      expect(results.items[1].id, 'manga-2');
      expect(results.items[1].title, 'ワンピース');
    });

    test('search throws when data is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{'result': 'ok'},
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('search throws when a manga has no usable id', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': 0,
            'total': 2,
            'data': <dynamic>[
              <String, dynamic>{
                'attributes': <String, dynamic>{
                  'title': <String, dynamic>{'en': 'One Piece'},
                },
              },
            ],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('search throws when a manga has no usable title', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': 0,
            'total': 1,
            'data': <dynamic>[
              <String, dynamic>{
                'id': 'manga-1',
                'attributes': <String, dynamic>{'title': <String, dynamic>{}},
              },
            ],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('accepts valid MangaDex pagination metadata', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': 20,
            'total': 42,
            'data': <dynamic>[],
          },
        ),
      );

      final results = await provider.search('One Piece');

      expect(results.items, isEmpty);
    });

    test('pagination throws when metadata is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pagination throws when a value is not an integer', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': '10',
            'offset': 0,
            'total': 42,
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pagination throws when offset is negative', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': -1,
            'total': 42,
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pagination throws when limit is negative', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': -1,
            'offset': 0,
            'total': 42,
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pagination throws when total is invalid', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          searchResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 10,
            'offset': 0,
            'total': -1,
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('gets and parses manga details', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'response': 'entity',
            'data': <String, dynamic>{
              'id': 'manga-1',
              'attributes': <String, dynamic>{
                'title': <String, dynamic>{'en': 'One Piece'},
              },
            },
          },
        ),
      );

      final manga = await provider.getDetails('manga-1');

      expect(manga, isNotNull);
      expect(manga!.id, 'manga-1');
      expect(manga.title, 'One Piece');
    });

    test('gets details using a fallback title', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'response': 'entity',
            'data': <String, dynamic>{
              'id': 'manga-1',
              'attributes': <String, dynamic>{
                'title': <String, dynamic>{'ja': 'ワンピース'},
              },
            },
          },
        ),
      );

      final manga = await provider.getDetails('manga-1');

      expect(manga!.title, 'ワンピース');
    });

    test('returns null when MangaDex details contain no data', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'response': 'entity',
          },
        ),
      );

      final manga = await provider.getDetails('missing');

      expect(manga, isNull);
    });

    test('details throws when data has an invalid shape', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'data': <dynamic>[],
          },
        ),
      );

      expect(
        () => provider.getDetails('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('details throws when manga has no usable id', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'data': <String, dynamic>{
              'attributes': <String, dynamic>{
                'title': <String, dynamic>{'en': 'One Piece'},
              },
            },
          },
        ),
      );

      expect(
        () => provider.getDetails('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('details throws when manga has no usable title', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getMangaResponse: <String, dynamic>{
            'result': 'ok',
            'data': <String, dynamic>{
              'id': 'manga-1',
              'attributes': <String, dynamic>{'title': <String, dynamic>{}},
            },
          },
        ),
      );

      expect(
        () => provider.getDetails('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('gets and parses manga chapters', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChaptersResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 100,
            'offset': 0,
            'total': 2,
            'data': <dynamic>[
              <String, dynamic>{
                'id': 'chapter-1',
                'attributes': <String, dynamic>{
                  'chapter': '1',
                  'title': 'The Beginning',
                },
              },
              <String, dynamic>{
                'id': 'chapter-2',
                'attributes': <String, dynamic>{
                  'chapter': '2',
                  'title': 'The Journey',
                },
              },
            ],
          },
        ),
      );

      final chapters = await provider.getChapters('manga-1');

      expect(chapters.items, hasLength(2));
      expect(chapters.offset, 0);
      expect(chapters.limit, 100);
      expect(chapters.total, 2);
      expect(chapters.hasMore, isFalse);
      expect(chapters.items[0].id, 'chapter-1');
      expect(chapters.items[0].number, 1);
      expect(chapters.items[0].title, 'The Beginning');
      expect(chapters.items[1].id, 'chapter-2');
      expect(chapters.items[1].number, 2);
      expect(chapters.items[1].title, 'The Journey');
    });

    test('uses a fallback title when chapter title is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChaptersResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 100,
            'offset': 0,
            'total': 1,
            'data': <dynamic>[
              <String, dynamic>{
                'id': 'chapter-1',
                'attributes': <String, dynamic>{'chapter': '1'},
              },
            ],
          },
        ),
      );

      final chapters = await provider.getChapters('manga-1');

      expect(chapters.items.single.title, 'Chapter 1');
    });

    test('chapters throw when data is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChaptersResponse: <String, dynamic>{'result': 'ok'},
        ),
      );

      expect(
        () => provider.getChapters('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('chapters throw when chapter id is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChaptersResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 100,
            'offset': 0,
            'total': 1,
            'data': <dynamic>[
              <String, dynamic>{
                'attributes': <String, dynamic>{'chapter': '1'},
              },
            ],
          },
        ),
      );

      expect(
        () => provider.getChapters('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('chapters throw when chapter number is invalid', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChaptersResponse: <String, dynamic>{
            'result': 'ok',
            'limit': 100,
            'offset': 0,
            'total': 1,
            'data': <dynamic>[
              <String, dynamic>{
                'id': 'chapter-1',
                'attributes': <String, dynamic>{'chapter': 'not-a-number'},
              },
            ],
          },
        ),
      );

      expect(
        () => provider.getChapters('manga-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('gets and parses chapter pages', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'baseUrl': 'https://uploads.mangadex.org',
            'chapter': <String, dynamic>{
              'hash': 'abc123',
              'data': <dynamic>['page-001.jpg', 'page-002.jpg', 'page-003.jpg'],
            },
          },
        ),
      );

      final pages = await provider.getPages('chapter-1');

      expect(pages, hasLength(3));
      expect(pages[0].index, 0);
      expect(
        pages[0].url,
        'https://uploads.mangadex.org/data/abc123/page-001.jpg',
      );
      expect(pages[1].index, 1);
      expect(
        pages[1].url,
        'https://uploads.mangadex.org/data/abc123/page-002.jpg',
      );
      expect(pages[2].index, 2);
      expect(
        pages[2].url,
        'https://uploads.mangadex.org/data/abc123/page-003.jpg',
      );
    });

    test('pages throw when base URL is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'chapter': <String, dynamic>{
              'hash': 'abc123',
              'data': <dynamic>['page-001.jpg'],
            },
          },
        ),
      );

      expect(
        () => provider.getPages('chapter-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pages throw when chapter data is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'baseUrl': 'https://uploads.mangadex.org',
          },
        ),
      );

      expect(
        () => provider.getPages('chapter-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pages throw when chapter hash is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'baseUrl': 'https://uploads.mangadex.org',
            'chapter': <String, dynamic>{
              'data': <dynamic>['page-001.jpg'],
            },
          },
        ),
      );

      expect(
        () => provider.getPages('chapter-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pages throw when page data is missing', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'baseUrl': 'https://uploads.mangadex.org',
            'chapter': <String, dynamic>{'hash': 'abc123'},
          },
        ),
      );

      expect(
        () => provider.getPages('chapter-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('pages throw when a filename is invalid', () async {
      final provider = MangaDexProvider(
        client: FakeMangaDexClient(
          getChapterPagesResponse: <String, dynamic>{
            'result': 'ok',
            'baseUrl': 'https://uploads.mangadex.org',
            'chapter': <String, dynamic>{
              'hash': 'abc123',
              'data': <dynamic>['page-001.jpg', null],
            },
          },
        ),
      );

      expect(
        () => provider.getPages('chapter-1'),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.type,
            'type',
            ProviderErrorType.invalidResponse,
          ),
        ),
      );
    });

    test('converts MangaDex not found errors to ProviderException', () async {
      final provider = MangaDexProvider(
        client: ThrowingMangaDexClient(
          error: const MangaDexHttpException(
            statusCode: 404,
            message: 'Not found',
          ),
        ),
      );

      expect(
        () => provider.getDetails('missing'),
        throwsA(
          isA<ProviderException>()
              .having((error) => error.type, 'type', ProviderErrorType.notFound)
              .having((error) => error.providerId, 'providerId', 'mangadex'),
        ),
      );
    });

    test('converts MangaDex rate limit errors to unavailable', () async {
      final provider = MangaDexProvider(
        client: ThrowingMangaDexClient(
          error: const MangaDexHttpException(
            statusCode: 429,
            message: 'Too many requests',
          ),
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>()
              .having(
                (error) => error.type,
                'type',
                ProviderErrorType.unavailable,
              )
              .having((error) => error.providerId, 'providerId', 'mangadex'),
        ),
      );
    });

    test('converts MangaDex server errors to network errors', () async {
      final provider = MangaDexProvider(
        client: ThrowingMangaDexClient(
          error: const MangaDexHttpException(
            statusCode: 503,
            message: 'Service unavailable',
          ),
        ),
      );

      expect(
        () => provider.search('One Piece'),
        throwsA(
          isA<ProviderException>()
              .having((error) => error.type, 'type', ProviderErrorType.network)
              .having((error) => error.providerId, 'providerId', 'mangadex'),
        ),
      );
    });
  });
}
