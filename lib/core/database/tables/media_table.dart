import 'package:drift/drift.dart';

class MediaTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get type => text()();

  TextColumn get description => text().nullable()();

  TextColumn get coverUrl => text().nullable()();

  TextColumn get sourceId => text().nullable()();

  TextColumn get sourceName => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}