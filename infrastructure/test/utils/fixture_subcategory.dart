import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureSubcategory {
  final _uid = Uuid();

  late final subcategory1 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconId: Value(_uid.v4()),
    name: Value('Lunch'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory2 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconId: Value(_uid.v4()),
    name: Value('Subway'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory3 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconId: Value(_uid.v4()),
    name: Value('Movie theater'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory4 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconId: Value(_uid.v4()),
    name: Value('Games'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory5 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconId: Value(_uid.v4()),
    name: Value('Soccer'),
    parentId: Value(_uid.v4()),
  );
}
