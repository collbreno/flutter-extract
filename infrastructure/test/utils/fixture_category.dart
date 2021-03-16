import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixtureCategory {
  final category1 = CategoriesCompanion(
    id: Value(1),
    name: Value('Market'),
    iconId: Value(15),
  );

  final category2 = CategoriesCompanion(
    id: Value(2),
    name: Value('Shop'),
    iconId: Value(60),
  );

  final category3 = CategoriesCompanion(
    id: Value(3),
    name: Value('Health'),
    iconId: Value(37),
  );

  final category4 = CategoriesCompanion(
    id: Value(4),
    name: Value('Fun'),
    iconId: Value(92),
  );
}