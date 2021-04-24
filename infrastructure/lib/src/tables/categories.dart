import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('CategoryEntity')
class Categories extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get iconId => text().customConstraint('REFERENCES icons(id)')();

  @override
  Set<Column>? get primaryKey => {id};
}
