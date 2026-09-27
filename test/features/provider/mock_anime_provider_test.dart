import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/data/mock_anime_provider.dart';
import 'package:tohyou/features/provider/domain/provider_type.dart';
import 'package:tohyou/features/provider/domain/stream_type.dart';

void main() {
  const provider = MockAnimeProvider();

  group('MockAnimeProvider', () {
    test('exposes anime provider metadata', () {
      expect(provider.id, 'mock-anime');
      expect(provider.name, 'Mock Anime');
      expect(provider.type, ProviderType.anime);

      expect(provider.capabilities.search, isTrue);
      expect(provider.capabilities.details, isTrue);
      expect(provider.capabilities.episodes, isTrue);
      expect(provider.capabilities.streaming, isTrue);
      expect(provider.capabilities.chapters, isFalse);
      expect(provider.capabilities.pages, isFalse);
    });

    test('search returns matching anime', () async {
      final results = await provider.search('One');

      expect(results, hasLength(1));
      expect(results.single.id, 'mock-anime-1');
      expect(results.single.title, 'Mock Anime One');
    });

    test('search is case insensitive', () async {
      final results = await provider.search('mock anime two');

      expect(results, hasLength(1));
      expect(results.single.id, 'mock-anime-2');
    });

    test('empty search returns all anime', () async {
      final results = await provider.search('');

      expect(results, hasLength(2));
    });

    test('getDetails returns matching anime', () async {
      final result = await provider.getDetails('mock-anime-1');

      expect(result, isNotNull);
      expect(result!.title, 'Mock Anime One');
    });

    test('getDetails returns null for unknown anime', () async {
      final result = await provider.getDetails('missing');

      expect(result, isNull);
    });

    test('getEpisodes returns episodes for known anime', () async {
      final episodes = await provider.getEpisodes('mock-anime-1');

      expect(episodes, hasLength(3));
      expect(episodes[0].number, 1);
      expect(episodes[1].number, 2);
      expect(episodes[2].number, 3);
    });

    test('getEpisodes returns empty list for unknown anime', () async {
      final episodes = await provider.getEpisodes('missing');

      expect(episodes, isEmpty);
    });

    test('getStreams returns stream sources', () async {
      final streams = await provider.getStreams('mock-anime-1-episode-1');

      expect(streams, hasLength(2));
      expect(streams[0].type, StreamType.direct);
      expect(streams[1].type, StreamType.hls);
    });

    test('getStreams returns empty list for unknown episode', () async {
      final streams = await provider.getStreams('missing');

      expect(streams, isEmpty);
    });
  });
}
