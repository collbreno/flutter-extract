import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixtureSubcategory {
  final subcategory1 = SubcategoriesCompanion(
    id: Value(1),
    iconId: Value(32),
    name: Value('Lunch'),
    parentId: Value(6),
  );

  final subcategory2 = SubcategoriesCompanion(
    id: Value(2),
    iconId: Value(12),
    name: Value('Subway'),
    parentId: Value(4),
  );

  final subcategory3 = SubcategoriesCompanion(
    id: Value(3),
    iconId: Value(7),
    name: Value('Movie theater'),
    parentId: Value(5),
  );

  final subcategory4 = SubcategoriesCompanion(
    id: Value(4),
    iconId: Value(37),
    name: Value('Games'),
    parentId: Value(2),
  );

  final subcategory5 = SubcategoriesCompanion(
    id: Value(5),
    iconId: Value(13),
    name: Value('Soccer'),
    parentId: Value(8),
  );
}
