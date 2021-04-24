import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('StoreEntity')
class Stores extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 48)();

  @override
  Set<Column>? get primaryKey => {id};
}
