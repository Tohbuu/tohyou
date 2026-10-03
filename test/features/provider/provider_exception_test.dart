import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/domain/provider_exception.dart';

void main() {
  group('ProviderException', () {
    test('every ProviderErrorType can be represented', () {
      for (final type in ProviderErrorType.values) {
        final exception = ProviderException(
          type: type,
          message: 'message for ${type.name}',
        );

        expect(exception.type, type);
      }
    });

    test('message is preserved', () {
      const exception = ProviderException(
        type: ProviderErrorType.network,
        message: 'Network unavailable',
      );

      expect(exception.message, 'Network unavailable');
    });

    test('providerId is optional', () {
      const exception = ProviderException(
        type: ProviderErrorType.network,
        message: 'Network unavailable',
      );

      expect(exception.providerId, isNull);
    });

    test('toString includes the provider ID when supplied', () {
      const exception = ProviderException(
        type: ProviderErrorType.notFound,
        message: 'Provider not found',
        providerId: 'mock-anime',
      );

      expect(
        exception.toString(),
        'Provider "mock-anime" error: Provider not found',
      );
    });

    test('toString still works without a provider ID', () {
      const exception = ProviderException(
        type: ProviderErrorType.unavailable,
        message: 'Provider temporarily unavailable',
      );

      expect(
        exception.toString(),
        'Provider error: Provider temporarily unavailable',
      );
    });
  });
}
