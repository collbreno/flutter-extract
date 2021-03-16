import 'package:moor/moor.dart';

class Files extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get path =>
      text().withLength(min: 1, max: 120).customConstraint('UNIQUE')();
}
