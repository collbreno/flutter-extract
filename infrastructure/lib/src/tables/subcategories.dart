import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('SubcategoryEntity')
class Subcategories extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  TextColumn get iconId => text().customConstraint('REFERENCES icons(id)')();
  TextColumn get parentId => text().customConstraint('REFERENCES categories(id)')();

  @override
  Set<Column>? get primaryKey => {id};
}
