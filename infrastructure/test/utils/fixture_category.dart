import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureCategory {
  final _uid = Uuid();

  late final category1 = CategoriesCompanion(
    id: Value(_uid.v4()),
    name: Value('Market'),
    iconId: Value(_uid.v4()),
  );

  late final category2 = CategoriesCompanion(
    id: Value(_uid.v4()),
    name: Value('Shop'),
    iconId: Value(_uid.v4()),
  );

  late final category3 = CategoriesCompanion(
    id: Value(_uid.v4()),
    name: Value('Health'),
    iconId: Value(_uid.v4()),
  );

  late final category4 = CategoriesCompanion(
    id: Value(_uid.v4()),
    name: Value('Fun'),
    iconId: Value(_uid.v4()),
  );
}
