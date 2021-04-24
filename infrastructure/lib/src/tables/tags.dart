import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('TagEntity')
class Tags extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  IntColumn get color => integer()();
  TextColumn get iconId => text().nullable().customConstraint('NULL REFERENCES icons(id)')();

  @override
  Set<Column>? get primaryKey => {id};
}
