import 'package:flutter_test/flutter_test.dart';

import 'package:tohyou/features/provider/domain/paginated_result.dart';

void main() {
  group('PaginatedResult', () {
    test('represents a normal paginated result', () {
      final result = PaginatedResult<String>(
        items: ['one', 'two'],
        offset: 10,
        limit: 20,
        total: 50,
      );

      expect(result.items, ['one', 'two']);
      expect(result.offset, 10);
      expect(result.limit, 20);
      expect(result.total, 50);
      expect(result.hasMore, isTrue);
    });

    test('represents an empty result', () {
      final result = PaginatedResult<String>(
        items: const [],
        offset: 0,
        limit: 20,
        total: 0,
      );

      expect(result.items, isEmpty);
      expect(result.hasMore, isFalse);
    });

    test('derives no more pages for an empty final page', () {
      final result = PaginatedResult<String>(
        items: const [],
        offset: 8,
        limit: 20,
        total: 8,
      );

      expect(result.hasMore, isFalse);
    });

    test('derives hasMore for the first page', () {
      final result = PaginatedResult<int>(
        items: [1, 2, 3],
        offset: 0,
        limit: 3,
        total: 8,
      );

      expect(result.hasMore, isTrue);
    });

    test('derives hasMore for a middle page', () {
      final result = PaginatedResult<int>(
        items: [4, 5, 6],
        offset: 3,
        limit: 3,
        total: 8,
      );

      expect(result.hasMore, isTrue);
    });

    test('derives hasMore for the final page', () {
      final result = PaginatedResult<int>(
        items: [7, 8],
        offset: 6,
        limit: 3,
        total: 8,
      );

      expect(result.hasMore, isFalse);
    });

    test('rejects a negative offset', () {
      expect(
        () => PaginatedResult<int>(
          items: const [],
          offset: -1,
          limit: 20,
          total: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a non-positive limit', () {
      expect(
        () => PaginatedResult<int>(
          items: const [],
          offset: 0,
          limit: 0,
          total: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a negative total', () {
      expect(
        () => PaginatedResult<int>(
          items: const [],
          offset: 0,
          limit: 20,
          total: -1,
        ),
        throwsArgumentError,
      );
    });

    test('rejects an offset beyond total', () {
      expect(
        () => PaginatedResult<int>(
          items: const [],
          offset: 6,
          limit: 20,
          total: 5,
        ),
        throwsArgumentError,
      );
    });

    test('rejects items larger than the page limit', () {
      expect(
        () => PaginatedResult<int>(
          items: [1, 2, 3],
          offset: 0,
          limit: 2,
          total: 3,
        ),
        throwsArgumentError,
      );
    });

    test('supports value equality and matching hash codes', () {
      final first = PaginatedResult<int>(
        items: [1, 2],
        offset: 0,
        limit: 2,
        total: 2,
      );
      final second = PaginatedResult<int>(
        items: [1, 2],
        offset: 0,
        limit: 2,
        total: 2,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });
  });
}
