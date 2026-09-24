enum LibraryStatus {
  watching('watching'),
  reading('reading'),
  completed('completed'),
  planToWatch('plan_to_watch'),
  planToRead('plan_to_read'),
  dropped('dropped');

  const LibraryStatus(this.value);

  final String value;

  static LibraryStatus fromValue(String value) {
    return switch (value) {
      'watching' => LibraryStatus.watching,
      'reading' => LibraryStatus.reading,
      'completed' => LibraryStatus.completed,
      'plan_to_watch' => LibraryStatus.planToWatch,
      'plan_to_read' => LibraryStatus.planToRead,
      'dropped' => LibraryStatus.dropped,
      _ => throw ArgumentError('Unknown library status: $value'),
    };
  }
}
