import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureSubcategory {
  final _uid = Uuid();

  late final subcategory1 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconName: Value('food'),
    iconFamily: Value('Material'),
    name: Value('Lunch'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory2 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconName: Value('subway'),
    iconFamily: Value('Material'),
    name: Value('Subway'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory3 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconName: Value('movie'),
    iconFamily: Value('Material'),
    name: Value('Movie theater'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory4 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconName: Value('game'),
    iconFamily: Value('Material'),
    name: Value('Games'),
    parentId: Value(_uid.v4()),
  );

  late final subcategory5 = SubcategoriesCompanion(
    id: Value(_uid.v4()),
    iconName: Value('ball'),
    iconFamily: Value('Material'),
    name: Value('Soccer'),
    parentId: Value(_uid.v4()),
  );
}
