import 'package:moor/moor.dart';

@DataClassName('IconEntity')
class Icons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get family => text().withLength(min: 1, max: 40)();
}
