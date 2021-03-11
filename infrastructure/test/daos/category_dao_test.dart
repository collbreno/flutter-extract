import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/fixture_category.dart';

void main() {
  AppDatabase database;
  final fix = FixtureCategory();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
  });
  tearDown(() async {
    await database.close();
  });

  // Insertion, deletion and update methods are tested along with the
  // getAllCategories because this method is just a select from the table,
  // so it's more reliable rather other queries methods.
  group('Insertion', () {
    test('Auto incremented insertion', () async {
      final category1 = fix.category1.copyWith(id: Value.absent());
      final category2 = fix.category2.copyWith(id: Value.absent());

      var result = await database.categoryDao.insertCategory(category1);
      expect(result, 1);

      var fromDb = await database.categoryDao.getAllCategories();
      final expected1 = Category(
        id: 1,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      expect(fromDb, orderedEquals([expected1]));

      result = await database.categoryDao.insertCategory(category2);
      expect(result, 2);

      fromDb = await database.categoryDao.getAllCategories();
      final expected2 = Category(
        id: 2,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Insertion with id', () async {
      final category = fix.category1.copyWith(id: Value(42));

      final result = await database.categoryDao.insertCategory(category);
      expect(result, 42);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected = Category(
        id: category.id.value,
        iconId: category.iconId.value,
        name: category.name.value,
      );

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with duplicated id', () async {
      final category1 = fix.category1.copyWith(id: Value(42));

      final result = await database.categoryDao.insertCategory(category1);
      expect(result, 42);

      final expected1 = Category(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      var fromDB = await database.categoryDao.getAllCategories();
      expect(fromDB, orderedEquals([expected1]));

      final category2 = fix.category1.copyWith(id: Value(42));

      expect(
        () => database.categoryDao.insertCategory(category2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.categoryDao.getAllCategories();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final category1 = fix.category1;
      await database.categoryDao.insertCategory(category1);

      var fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, hasLength(1));

      var result =
          await database.categoryDao.deleteCategoryWithId(category1.id.value);
      expect(result, 1);

      fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, isEmpty);
    });

    test('Deletion of an item that does not exist', () async {
      final category1 = fix.category1;
      await database.categoryDao.insertCategory(category1);

      var fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, hasLength(1));

      var result = await database.categoryDao
          .deleteCategoryWithId(category1.id.value + 1);
      expect(result, 0);

      // Database is not affected
      fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, hasLength(1));
    });
  });

  test('Get amount', () async {
    final category1 = fix.category1;
    final category2 = fix.category2;

    var count = await database.categoryDao.getCategoriesAmount();
    expect(count, 0);

    await database.categoryDao.insertCategory(category1);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 1);

    await database.categoryDao.insertCategory(category2);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 2);

    await database.categoryDao.deleteCategoryWithId(category1.id.value);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 1);
  });

  group('Query by id', () {
    final category1 = fix.category1;
    final category2 = fix.category2;

    test('Success cases', () async {
      await database.categoryDao.insertCategory(category1);
      await database.categoryDao.insertCategory(category2);

      var result =
          await database.categoryDao.getCategoryWithId(category1.id.value);
      var expected = Category(
        id: category1.id.value,
        name: category1.name.value,
        iconId: category1.iconId.value,
      );
      expect(result, expected);

      result = await database.categoryDao.getCategoryWithId(category2.id.value);
      expected = Category(
        id: category2.id.value,
        name: category2.name.value,
        iconId: category2.iconId.value,
      );
      expect(result, expected);
    });

    test('Error cases', () async {
      final result = await database.categoryDao.getCategoryWithId(1);

      expect(result, isNull);
    });
  });

  group('Update', () {
    final category1 = fix.category1;
    final category2 = fix.category2;
    final category3 = fix.category3;

    setUp(() async {
      await database.categoryDao.insertCategory(category1);
      await database.categoryDao.insertCategory(category2);
    });

    test('Updating name', () async {
      final newCategory = category1.copyWith(name: Value('Novo nome'));
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isTrue);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = Category(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: newCategory.name.value,
      );
      final expected2 = Category(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Updating icon id', () async {
      final newCategory = category1.copyWith(iconId: Value(4834));
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isTrue);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = Category(
        id: category1.id.value,
        iconId: newCategory.iconId.value,
        name: category1.name.value,
      );
      final expected2 = Category(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Updating a category that does not exist', () async {
      final newCategory = category3.copyWith(iconId: Value(4834));
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isFalse);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = Category(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      final expected2 = Category(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });
}
