import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/features/provider/domain/provider_selection.dart';

void main() {
  group('ProviderSelection', () {
    test('starts with no selected providers', () {
      const selection = ProviderSelection();

      expect(selection.animeProviderId, isNull);
      expect(selection.mangaProviderId, isNull);
    });

    test('stores selected anime provider', () {
      const selection = ProviderSelection(animeProviderId: 'mock-anime');

      expect(selection.animeProviderId, 'mock-anime');
      expect(selection.mangaProviderId, isNull);
    });

    test('stores selected manga provider', () {
      const selection = ProviderSelection(mangaProviderId: 'mock-manga');

      expect(selection.animeProviderId, isNull);
      expect(selection.mangaProviderId, 'mock-manga');
    });

    test('stores both selected providers', () {
      const selection = ProviderSelection(
        animeProviderId: 'mock-anime',
        mangaProviderId: 'mock-manga',
      );

      expect(selection.animeProviderId, 'mock-anime');
      expect(selection.mangaProviderId, 'mock-manga');
    });
  });
}
