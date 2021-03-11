import 'package:moor/moor.dart';

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 24)();

  IntColumn get iconId =>
      integer().nullable().customConstraint('NULL REFERENCES icons(id)')();
}
