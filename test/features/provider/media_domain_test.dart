import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/features/provider/domain/anime.dart';
import 'package:tohyou/features/provider/domain/chapter_page.dart';
import 'package:tohyou/features/provider/domain/manga.dart';
import 'package:tohyou/features/provider/domain/stream_source.dart';
import 'package:tohyou/features/provider/domain/stream_type.dart';

void main() {
  group('Anime', () {
    test('stores required and optional media information', () {
      const anime = Anime(
        id: 'anime-1',
        title: 'Test Anime',
        coverUrl: 'https://example.com/anime.jpg',
      );

      expect(anime.id, 'anime-1');
      expect(anime.title, 'Test Anime');
      expect(anime.coverUrl, 'https://example.com/anime.jpg');
    });

    test('allows a missing cover URL', () {
      const anime = Anime(id: 'anime-1', title: 'Test Anime');

      expect(anime.coverUrl, isNull);
    });
  });

  group('Manga', () {
    test('stores required and optional media information', () {
      const manga = Manga(
        id: 'manga-1',
        title: 'Test Manga',
        coverUrl: 'https://example.com/manga.jpg',
      );

      expect(manga.id, 'manga-1');
      expect(manga.title, 'Test Manga');
      expect(manga.coverUrl, 'https://example.com/manga.jpg');
    });

    test('allows a missing cover URL', () {
      const manga = Manga(id: 'manga-1', title: 'Test Manga');

      expect(manga.coverUrl, isNull);
    });
  });

  group('StreamType', () {
    test('defines supported stream types', () {
      expect(StreamType.values, contains(StreamType.direct));
      expect(StreamType.values, contains(StreamType.hls));
      expect(StreamType.values, contains(StreamType.dash));
    });
  });

  group('StreamSource', () {
    test('stores stream information', () {
      const source = StreamSource(
        url: 'https://example.com/video.m3u8',
        type: StreamType.hls,
      );

      expect(source.url, 'https://example.com/video.m3u8');
      expect(source.type, StreamType.hls);
    });
  });

  group('ChapterPage', () {
    test('stores page information', () {
      const page = ChapterPage(index: 0, url: 'https://example.com/page-1.jpg');

      expect(page.index, 0);
      expect(page.url, 'https://example.com/page-1.jpg');
    });
  });
}
