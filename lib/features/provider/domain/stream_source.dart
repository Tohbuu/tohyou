import 'package:tohyou/features/provider/domain/stream_type.dart';

class StreamSource {
  const StreamSource({required this.url, required this.type});
  final String url;
  final StreamType type;
}
