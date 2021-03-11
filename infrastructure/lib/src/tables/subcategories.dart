import 'package:moor/moor.dart';
import '../helpers/builder_extensions.dart';

@DataClassName('SubCategory')
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 24)();

  IntColumn get iconId =>
      integer().nullable().references('icons(id)')();

  IntColumn get parentId =>
      integer().references('categories(id)')();
}
