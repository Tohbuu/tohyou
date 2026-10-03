import '../domain/chapter.dart';
import '../domain/manga.dart';
import '../domain/manga_provider.dart';
import '../domain/chapter_page.dart';
import '../domain/paginated_result.dart';
import '../domain/provider_capabilities.dart';
import '../domain/provider_type.dart';

class MockMangaProvider implements MangaProvider {
  const MockMangaProvider();

  @override
  String get id => 'mock-manga';

  @override
  String get name => 'Mock Manga';

  @override
  ProviderType get type => ProviderType.manga;

  @override
  ProviderCapabilities get capabilities => const ProviderCapabilities(
    search: true,
    details: true,
    chapters: true,
    pages: true,
  );

  @override
  Future<PaginatedResult<Manga>> search(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    const results = [
      Manga(
        id: 'mock-manga-1',
        title: 'Mock Manga One',
        coverUrl: 'https://example.com/mock-manga-1.jpg',
      ),
      Manga(
        id: 'mock-manga-2',
        title: 'Mock Manga Two',
        coverUrl: 'https://example.com/mock-manga-2.jpg',
      ),
    ];

    final filteredResults = query.trim().isEmpty
        ? results
        : results
              .where(
                (manga) => manga.title.toLowerCase().contains(
                  query.trim().toLowerCase(),
                ),
              )
              .toList();

    final pageEnd = (offset + limit < filteredResults.length)
        ? offset + limit
        : filteredResults.length;
    final pageItems = offset < filteredResults.length
        ? filteredResults.sublist(offset, pageEnd)
        : <Manga>[];

    return PaginatedResult(
      items: pageItems,
      offset: offset,
      limit: limit,
      total: filteredResults.length,
    );
  }

  @override
  Future<Manga?> getDetails(String id) async {
    const manga = Manga(
      id: 'mock-manga-1',
      title: 'Mock Manga One',
      coverUrl: 'https://example.com/mock-manga-1.jpg',
    );

    if (manga.id == id) {
      return manga;
    }

    return null;
  }

  @override
  Future<PaginatedResult<Chapter>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) async {
    late final List<Chapter> chapters;

    if (mangaId != 'mock-manga-1') {
      chapters = [];
    } else {
      chapters = const [
        Chapter(id: 'mock-manga-1-chapter-1', number: 1, title: 'Chapter One'),
        Chapter(id: 'mock-manga-1-chapter-2', number: 2, title: 'Chapter Two'),
        Chapter(
          id: 'mock-manga-1-chapter-3',
          number: 3,
          title: 'Chapter Three',
        ),
      ];
    }

    final pageEnd = (offset + limit < chapters.length)
        ? offset + limit
        : chapters.length;
    final pageItems = offset < chapters.length
        ? chapters.sublist(offset, pageEnd)
        : <Chapter>[];

    return PaginatedResult(
      items: pageItems,
      offset: offset,
      limit: limit,
      total: chapters.length,
    );
  }

  @override
  Future<List<ChapterPage>> getPages(String chapterId) async {
    if (chapterId != 'mock-manga-1-chapter-1') {
      return [];
    }

    return const [
      ChapterPage(
        index: 0,
        url: 'https://example.com/mock-manga-1-chapter-1-page-1.jpg',
      ),
      ChapterPage(
        index: 1,
        url: 'https://example.com/mock-manga-1-chapter-1-page-2.jpg',
      ),
      ChapterPage(
        index: 2,
        url: 'https://example.com/mock-manga-1-chapter-1-page-3.jpg',
      ),
    ];
  }
}
