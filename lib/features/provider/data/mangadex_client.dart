abstract interface class MangaDexClient {
  Future<Map<String, dynamic>> getManga(String id);

  Future<Map<String, dynamic>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
  });

  Future<Map<String, dynamic>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  });

  Future<Map<String, dynamic>> getChapterPages(String chapterId);
}
