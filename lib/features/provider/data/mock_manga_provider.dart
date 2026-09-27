import '../domain/chapter.dart';
import '../domain/manga.dart';
import '../domain/manga_provider.dart';
import '../domain/chapter_page.dart';
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
  Future<List<Manga>> search(String query) async {
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

    if (query.trim().isEmpty) {
      return results;
    }

    final normalizedQuery = query.trim().toLowerCase();

    return results
        .where((manga) => manga.title.toLowerCase().contains(normalizedQuery))
        .toList();
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
  Future<List<Chapter>> getChapters(String mangaId) async {
    if (mangaId != 'mock-manga-1') {
      return [];
    }

    return const [
      Chapter(id: 'mock-manga-1-chapter-1', number: 1, title: 'Chapter One'),
      Chapter(id: 'mock-manga-1-chapter-2', number: 2, title: 'Chapter Two'),
      Chapter(id: 'mock-manga-1-chapter-3', number: 3, title: 'Chapter Three'),
    ];
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
