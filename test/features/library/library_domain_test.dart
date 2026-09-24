import 'package:flutter_test/flutter_test.dart';
import 'package:tohyou/features/library/domain/library_status.dart';
import 'package:tohyou/features/library/domain/media_type.dart';

void main() {
  group('MediaType', () {
    test('converts database value to domain value', () {
      expect(MediaType.fromValue('anime'), MediaType.anime);
      expect(MediaType.fromValue('manga'), MediaType.manga);
    });

    test('converts domain value to database value', () {
      expect(MediaType.anime.value, 'anime');
      expect(MediaType.manga.value, 'manga');
    });

    test('rejects unknown values', () {
      expect(() => MediaType.fromValue('unknown'), throwsArgumentError);
    });
  });

  group('LibraryStatus', () {
    test('converts database values to domain values', () {
      expect(LibraryStatus.fromValue('watching'), LibraryStatus.watching);
      expect(LibraryStatus.fromValue('reading'), LibraryStatus.reading);
      expect(LibraryStatus.fromValue('completed'), LibraryStatus.completed);
      expect(
        LibraryStatus.fromValue('plan_to_watch'),
        LibraryStatus.planToWatch,
      );
      expect(LibraryStatus.fromValue('plan_to_read'), LibraryStatus.planToRead);
      expect(LibraryStatus.fromValue('dropped'), LibraryStatus.dropped);
    });

    test('converts domain values to database values', () {
      expect(LibraryStatus.watching.value, 'watching');
      expect(LibraryStatus.reading.value, 'reading');
      expect(LibraryStatus.completed.value, 'completed');
      expect(LibraryStatus.planToWatch.value, 'plan_to_watch');
      expect(LibraryStatus.planToRead.value, 'plan_to_read');
      expect(LibraryStatus.dropped.value, 'dropped');
    });

    test('rejects unknown values', () {
      expect(() => LibraryStatus.fromValue('unknown'), throwsArgumentError);
    });
  });
}
