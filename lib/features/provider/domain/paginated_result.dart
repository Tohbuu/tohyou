class PaginatedResult<T> {
  factory PaginatedResult({
    required List<T> items,
    required int offset,
    required int limit,
    required int total,
  }) {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Offset cannot be negative');
    }

    if (limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'Limit must be positive');
    }

    if (total < 0) {
      throw ArgumentError.value(total, 'total', 'Total cannot be negative');
    }

    if (offset > total) {
      throw ArgumentError.value(offset, 'offset', 'Offset cannot exceed total');
    }

    if (items.length > limit) {
      throw ArgumentError.value(
        items.length,
        'items',
        'Items cannot exceed limit',
      );
    }

    if (offset + items.length > total) {
      throw ArgumentError.value(
        items.length,
        'items',
        'Items cannot extend beyond total',
      );
    }

    return PaginatedResult._(
      items: List.unmodifiable(items),
      offset: offset,
      limit: limit,
      total: total,
    );
  }

  const PaginatedResult._({
    required this.items,
    required this.offset,
    required this.limit,
    required this.total,
  });

  final List<T> items;
  final int offset;
  final int limit;
  final int total;

  bool get hasMore => offset + items.length < total;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! PaginatedResult<T>) {
      return false;
    }

    return offset == other.offset &&
        limit == other.limit &&
        total == other.total &&
        _listsEqual(items, other.items);
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(items), offset, limit, total);

  static bool _listsEqual<T>(List<T> first, List<T> second) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }
}
