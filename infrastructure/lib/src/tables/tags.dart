import 'package:moor/moor.dart';

@DataClassName('TagEntity')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 24)();

  IntColumn get color => integer()();

  IntColumn get iconId => integer().nullable().customConstraint('NULL REFERENCES icons(id)')();
}

class A {
  static const map = {
    'A': 3,
  };
}