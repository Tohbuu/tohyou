class LibraryEntry {
  const LibraryEntry({
    required this.id,
    required this.mediaId,
    required this.title,
    required this.type,
    required this.status,
    required this.progress,
    this.total,
    this.favorite = false,
    this.coverUrl,
  });

  final int id;
  final int mediaId;
  final String title;
  final String type;
  final String status;
  final int progress;
  final int? total;
  final bool favorite;
  final String? coverUrl;
}