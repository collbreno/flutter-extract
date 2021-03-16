import 'package:moor/moor.dart';

@DataClassName('SubCategory')
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 24)();

  IntColumn get iconId =>
      integer().nullable().customConstraint('REFERENCES icons(id)')();

  IntColumn get parentId =>
      integer().customConstraint('REFERENCES categories(id)')();
}
