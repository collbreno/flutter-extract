import 'package:moor/moor.dart';

class Files extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get path =>
      text().customConstraint('UNIQUE').withLength(min: 1, max: 120)();
}
