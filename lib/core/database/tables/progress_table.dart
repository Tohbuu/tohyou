import 'package:drift/drift.dart';

class ProgressTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mediaId => integer()();

  IntColumn get itemNumber => integer()();

  IntColumn get positionSeconds =>
      integer().withDefault(const Constant(0))();

  IntColumn get durationSeconds =>
      integer().nullable()();

  DateTimeColumn get lastPlayedAt => dateTime()();
}