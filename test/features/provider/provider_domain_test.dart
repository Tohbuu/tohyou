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
    test('defaults capabilities to false', () {
      const capabilities = ProviderCapabilities();

      expect(capabilities.search, isFalse);
      expect(capabilities.details, isFalse);
    });

    test('stores configured capabilities', () {
      const capabilities = ProviderCapabilities(search: true, details: true);

      expect(capabilities.search, isTrue);
      expect(capabilities.details, isTrue);
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
