enum ProviderErrorType {
  network,
  unavailable,
  notFound,
  invalidResponse,
  unsupported,
  unknown,
}

class ProviderException implements Exception {
  const ProviderException({
    required this.type,
    required this.message,
    this.providerId,
  });

  final ProviderErrorType type;
  final String message;
  final String? providerId;

  @override
  String toString() {
    final prefix = providerId == null
        ? 'Provider error'
        : 'Provider "$providerId" error';
    return '$prefix: $message';
  }
}
