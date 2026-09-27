import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/domain/provider.dart';
import 'package:tohyou/features/provider/domain/provider_capabilities.dart';
import 'package:tohyou/features/provider/domain/provider_registry.dart';
import 'package:tohyou/features/provider/domain/provider_type.dart';

class TestProvider implements Provider {
  const TestProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.capabilities,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  final ProviderType type;

  @override
  final ProviderCapabilities capabilities;
}

void main() {
  group('ProviderRegistry', () {
    test('starts empty', () {
      final registry = ProviderRegistry();

      expect(registry.all, isEmpty);
      expect(registry.anime, isEmpty);
      expect(registry.manga, isEmpty);
    });

    test('stores registered providers', () {
      const provider = TestProvider(
        id: 'test-anime',
        name: 'Test Anime',
        type: ProviderType.anime,
        capabilities: ProviderCapabilities(
          search: true,
          details: true,
          episodes: true,
          streaming: true,
        ),
      );

      final registry = ProviderRegistry(providers: [provider]);

      expect(registry.all, hasLength(1));
      expect(registry.all.single.id, 'test-anime');
    });

    test('filters anime providers', () {
      const animeProvider = TestProvider(
        id: 'anime',
        name: 'Anime Provider',
        type: ProviderType.anime,
        capabilities: ProviderCapabilities(),
      );

      const mangaProvider = TestProvider(
        id: 'manga',
        name: 'Manga Provider',
        type: ProviderType.manga,
        capabilities: ProviderCapabilities(),
      );

      final registry = ProviderRegistry(
        providers: [animeProvider, mangaProvider],
      );

      expect(registry.anime, hasLength(1));
      expect(registry.anime.single.id, 'anime');
    });

    test('filters manga providers', () {
      const animeProvider = TestProvider(
        id: 'anime',
        name: 'Anime Provider',
        type: ProviderType.anime,
        capabilities: ProviderCapabilities(),
      );

      const mangaProvider = TestProvider(
        id: 'manga',
        name: 'Manga Provider',
        type: ProviderType.manga,
        capabilities: ProviderCapabilities(),
      );

      final registry = ProviderRegistry(
        providers: [animeProvider, mangaProvider],
      );

      expect(registry.manga, hasLength(1));
      expect(registry.manga.single.id, 'manga');
    });

    test('finds provider by id', () {
      const provider = TestProvider(
        id: 'test-provider',
        name: 'Test Provider',
        type: ProviderType.anime,
        capabilities: ProviderCapabilities(),
      );

      final registry = ProviderRegistry(providers: [provider]);

      expect(registry.getById('test-provider'), same(provider));
    });

    test('returns null for unknown provider id', () {
      final registry = ProviderRegistry();

      expect(registry.getById('missing'), isNull);
    });
  });
}
