abstract interface class MangaDexClient {
  Future<Map<String, dynamic>> getManga(String id);

  Future<Map<String, dynamic>> searchManga(String query);

  Future<Map<String, dynamic>> getChapters(String mangaId);

  Future<Map<String, dynamic>> getChapterPages(String chapterId);
}
