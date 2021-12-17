import 'package:infrastructure/infrastructure.dart';
import 'package:drift/drift.dart';

@DataClassName('SubcategoryEntity')
class Subcategories extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: CATEGORY_NAME_MIN, max: CATEGORY_NAME_MAX)();
  IntColumn get color => integer()();
  TextColumn get iconName => text().withLength(min: 1, max: ICON_NAME_MAX)();
  TextColumn get iconFamily => text().withLength(min: 1, max: ICON_PACKAGE_MAX)();
  TextColumn get parentId => text().customConstraint('REFERENCES categories(id)')();

  @override
  Set<Column>? get primaryKey => {id};
}
