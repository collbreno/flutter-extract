import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  AppDatabase database;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  group('Insertion', () {
    test('Simple insertion', () async {
      final category = CategoriesCompanion(
        iconId: Value(37),
        name: Value('Mercado'),
      );

      final result = await database.categoryDao.insertCategory(category);
      expect(result, 1);

      final fromDb = await database.categoryDao.getCategoryWithId(1);
      final expected = Category(
        id: 1,
        iconId: 37,
        name: 'Mercado',
      );

      expect(fromDb, expected);
    });

    test('Insertion with id', () async {
      final category = CategoriesCompanion(
        id: Value(42),
        iconId: Value(37),
        name: Value('Mercado'),
      );

      final result = await database.categoryDao.insertCategory(category);
      expect(result, 42);

      final fromDb = await database.categoryDao.getCategoryWithId(42);
      final expected = Category(
        id: 42,
        iconId: 37,
        name: 'Mercado',
      );

      expect(fromDb, expected);
    });

    test('Insertion with duplicated id', () async {
      final category = CategoriesCompanion(
        id: Value(42),
        iconId: Value(37),
        name: Value('Mercado'),
      );

      final result = await database.categoryDao.insertCategory(category);
      expect(result, 42);

      final category2 = CategoriesCompanion(
        id: Value(42),
        iconId: Value(96),
        name: Value('Alimentação'),
      );

      expect(
        () => database.categoryDao.insertCategory(category2),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
