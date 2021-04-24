import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

@DataClassName('FileEntity')
class Files extends Table {
  TextColumn get id => text().withLength(min: UID_SIZE, max: UID_SIZE)();
  TextColumn get path => text().withLength(min: 1, max: 120).customConstraint('UNIQUE')();

  @override
  Set<Column>? get primaryKey => {id};
}
