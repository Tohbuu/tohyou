import 'chapter.dart';
import 'chapter_page.dart';
import 'manga.dart';
import 'paginated_result.dart';
import 'provider.dart';

abstract interface class MangaProvider implements Provider {
  Future<PaginatedResult<Manga>> search(
    String query, {
    int offset = 0,
    int limit = 20,
  });

  Future<Manga?> getDetails(String id);

  Future<PaginatedResult<Chapter>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  });

  Future<List<ChapterPage>> getPages(String chapterId);
}
