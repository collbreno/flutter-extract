import 'package:drift/drift.dart';
import 'package:infrastructure/infrastructure.dart';

@DataClassName('StoreEntity')
class Stores extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();

  TextColumn get name => text().withLength(min: STORE_NAME_MIN, max: STORE_NAME_MAX)();

  @override
  Set<Column>? get primaryKey => {id};
}
