import 'provider_capabilities.dart';
import 'provider_type.dart';

abstract interface class Provider {
  String get id;
  String get name;
  ProviderType get type;
  ProviderCapabilities get capabilities;
}
