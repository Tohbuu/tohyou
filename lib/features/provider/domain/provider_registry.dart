import 'provider.dart';
import 'provider_type.dart';

class ProviderRegistry {
  ProviderRegistry({List<Provider> providers = const []})
    : _providers = List.unmodifiable(providers);

  final List<Provider> _providers;

  List<Provider> get all => _providers;

  List<Provider> get anime => _providers
      .where((provider) => provider.type == ProviderType.anime)
      .toList();

  List<Provider> get manga => _providers
      .where((provider) => provider.type == ProviderType.manga)
      .toList();

  Provider? getById(String id) {
    for (final provider in _providers) {
      if (provider.id == id) {
        return provider;
      }
    }

    return null;
  }
}
