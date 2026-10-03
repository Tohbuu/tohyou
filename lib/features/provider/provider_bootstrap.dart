import 'data/mock_anime_provider.dart';
import 'data/mock_manga_provider.dart';
import 'domain/provider_registry.dart';
import 'domain/provider_service.dart';

ProviderRegistry createRegistry() {
  return ProviderRegistry(
    providers: const [MockAnimeProvider(), MockMangaProvider()],
  );
}

ProviderService createProviderService() {
  final registry = createRegistry();
  return ProviderService(registry);
}

final providerService = createProviderService();
