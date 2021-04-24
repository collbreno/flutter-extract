import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('IconEntity')
class Icons extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get family => text().withLength(min: 1, max: 40)();

  @override
  Set<Column>? get primaryKey => {id};
}
