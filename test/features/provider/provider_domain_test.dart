import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/features/provider/domain/provider.dart';
import 'package:tohyou/features/provider/domain/provider_capabilities.dart';
import 'package:tohyou/features/provider/domain/provider_type.dart';

class TestProvider implements Provider {
  @override
  String get id => 'test';

  @override
  String get name => 'Test Provider';

  @override
  ProviderType get type => ProviderType.anime;

  @override
  ProviderCapabilities get capabilities =>
      const ProviderCapabilities(search: true, details: true);
}

void main() {
  group('ProviderType', () {
    test('defines anime and manga provider types', () {
      expect(ProviderType.values, contains(ProviderType.anime));
      expect(ProviderType.values, contains(ProviderType.manga));
    });
  });

  group('ProviderCapabilities', () {
    test('defaults all capabilities to false', () {
      const capabilities = ProviderCapabilities();

      expect(capabilities.search, isFalse);
      expect(capabilities.details, isFalse);
      expect(capabilities.episodes, isFalse);
      expect(capabilities.streaming, isFalse);
      expect(capabilities.chapters, isFalse);
      expect(capabilities.pages, isFalse);
    });

    test('stores configured capabilities', () {
      const capabilities = ProviderCapabilities(
        search: true,
        details: true,
        episodes: true,
        streaming: true,
        chapters: true,
        pages: true,
      );

      expect(capabilities.search, isTrue);
      expect(capabilities.details, isTrue);
      expect(capabilities.episodes, isTrue);
      expect(capabilities.streaming, isTrue);
      expect(capabilities.chapters, isTrue);
      expect(capabilities.pages, isTrue);
    });

    test('can represent anime capabilities', () {
      const capabilities = ProviderCapabilities(
        search: true,
        details: true,
        episodes: true,
        streaming: true,
      );

      expect(capabilities.search, isTrue);
      expect(capabilities.details, isTrue);
      expect(capabilities.episodes, isTrue);
      expect(capabilities.streaming, isTrue);
      expect(capabilities.chapters, isFalse);
      expect(capabilities.pages, isFalse);
    });

    test('can represent manga capabilities', () {
      const capabilities = ProviderCapabilities(
        search: true,
        details: true,
        chapters: true,
        pages: true,
      );

      expect(capabilities.search, isTrue);
      expect(capabilities.details, isTrue);
      expect(capabilities.episodes, isFalse);
      expect(capabilities.streaming, isFalse);
      expect(capabilities.chapters, isTrue);
      expect(capabilities.pages, isTrue);
    });
  });

  group('Provider', () {
    test('exposes provider identity and capabilities', () {
      final provider = TestProvider();

      expect(provider.id, 'test');
      expect(provider.name, 'Test Provider');
      expect(provider.type, ProviderType.anime);
      expect(provider.capabilities.search, isTrue);
      expect(provider.capabilities.details, isTrue);
    });
  });
}
