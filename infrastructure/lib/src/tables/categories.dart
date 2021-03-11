import 'package:moor/moor.dart';
import 'package:moor/moor.dart';
import '../helpers/builder_extensions.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable().withLength(min: 1, max: 40)();

  IntColumn get iconId => integer().references('icons(id)')();
}
