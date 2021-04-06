import 'package:moor/moor.dart';

@DataClassName('StoreEntity')
class Stores extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 48)();
}