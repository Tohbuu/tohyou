import 'package:drift/drift.dart';

class LibraryEntriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mediaId => integer()();

  TextColumn get status => text()();

  IntColumn get progress => integer().withDefault(const Constant(0))();

  IntColumn get total => integer().nullable()();

  BoolColumn get favorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get addedAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}