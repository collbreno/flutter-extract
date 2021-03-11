import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FixtureCategory {
  final category1 = CategoriesCompanion(
    id: Value(1),
    name: Value('Mercado'),
    iconId: Value(15),
  );

  final category2 = CategoriesCompanion(
    id: Value(2),
    name: Value('Compras'),
    iconId: Value(60),
  );

  final category3 = CategoriesCompanion(
    id: Value(3),
    name: Value('Saúde'),
    iconId: Value(37),
  );

  final category4 = CategoriesCompanion(
    id: Value(4),
    name: Value('Entretenimento'),
    iconId: Value(92),
  );
}