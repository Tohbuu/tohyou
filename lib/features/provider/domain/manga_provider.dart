import 'chapter.dart';
import 'chapter_page.dart';
import 'manga.dart';
import 'provider.dart';

abstract interface class MangaProvider implements Provider {
  Future<List<Manga>> search(String query);

  Future<Manga?> getDetails(String id);

  Future<List<Chapter>> getChapters(String mangaId);

  Future<List<ChapterPage>> getPages(String chapterId);
}
