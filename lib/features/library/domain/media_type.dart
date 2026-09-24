enum MediaType {
  anime('anime'),
  manga('manga');

  const MediaType(this.value);

  final String value;

  static MediaType fromValue(String value) {
    return switch (value) {
      'anime' => MediaType.anime,
      'manga' => MediaType.manga,
      _ => throw ArgumentError('Unknown media type: $value'),
    };
  }
}
