import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/fixture_category.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  AppDatabase database;
  ForeignKeyUtils fkUtils;
  final fix = FixtureCategory();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    fkUtils = ForeignKeyUtils(database);
  });
  tearDown(() async {
    await database.close();
  });

  // Insertion, deletion and update methods are tested along with the
  // getAllCategories because this method is just a select from the table,
  // so it's more reliable rather other queries methods.
  group('Insertion', () {
    test('Insertion without id must have an auto incremented id', () async {
      final category1 = fix.category1.copyWith(id: Value.absent());
      final category2 = fix.category2.copyWith(id: Value.absent());

      await fkUtils.insertCategoryFKDependencies(category1);
      var result = await database.categoryDao.insertCategory(category1);
      expect(result, 1);

      var fromDb = await database.categoryDao.getAllCategories();
      final expected1 = CategoryEntity(
        id: 1,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      expect(fromDb, orderedEquals([expected1]));

      await fkUtils.insertCategoryFKDependencies(category2);
      result = await database.categoryDao.insertCategory(category2);
      expect(result, 2);

      fromDb = await database.categoryDao.getAllCategories();
      final expected2 = CategoryEntity(
        id: 2,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Insertion without name must fail', () async {
      final category = fix.category1.copyWith(name: Value.absent());

      await fkUtils.insertCategoryFKDependencies(category);
      expect(
        () => database.categoryDao.insertCategory(category),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, isEmpty);
    });

    test('Insertion without icon id must fail', () async {
      final category = fix.category1.copyWith(iconId: Value.absent());

      expect(
        () async => await database.categoryDao.insertCategory(category),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('Insertion with defined id must use the given id', () async {
      final category = fix.category1.copyWith(id: Value(42));

      await fkUtils.insertCategoryFKDependencies(category);
      final result = await database.categoryDao.insertCategory(category);
      expect(result, 42);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected = CategoryEntity(
        id: category.id.value,
        iconId: category.iconId.value,
        name: category.name.value,
      );

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with duplicated id must fail', () async {
      final category1 = fix.category1.copyWith(id: Value(42));

      await fkUtils.insertCategoryFKDependencies(category1);
      final result = await database.categoryDao.insertCategory(category1);
      expect(result, 42);

      final expected1 = CategoryEntity(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      var fromDB = await database.categoryDao.getAllCategories();
      expect(fromDB, orderedEquals([expected1]));

      final category2 = fix.category2.copyWith(id: Value(42));

      await fkUtils.insertCategoryFKDependencies(category2);
      expect(
        () => database.categoryDao.insertCategory(category2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.categoryDao.getAllCategories();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Foreign Keys', () {
    test(
        'Insertion with icon id that does not have any reference '
        'to the icon table must fail.', () async {
      final category = fix.category1;

      final iconFromDb = await database.iconDao.getIconById(category.iconId.value);
      expect(iconFromDb, isNull);

      expect(
        () async => await database.categoryDao.insertCategory(category),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final category1 = fix.category1;
      await fkUtils.insertCategoryFKDependencies(category1);
      await database.categoryDao.insertCategory(category1);

      var fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, hasLength(1));

      var result = await database.categoryDao.deleteCategoryWithId(category1.id.value);
      expect(result, 1);

      fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, isEmpty);
    });

    test('Deletion of an item that does not exist', () async {
      final category1 = fix.category1;
      await fkUtils.insertCategoryFKDependencies(category1);
      await database.categoryDao.insertCategory(category1);

      var fromDb = await database.categoryDao.getAllCategories();
      expect(fromDb, hasLength(1));

      var result = await database.categoryDao.deleteCategoryWithId(category1.id.value + 1);
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

    await fkUtils.insertCategoryFKDependencies(category1);
    await database.categoryDao.insertCategory(category1);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 1);

    await fkUtils.insertCategoryFKDependencies(category2);
    await database.categoryDao.insertCategory(category2);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 2);

    await database.categoryDao.deleteCategoryWithId(category1.id.value);
    count = await database.categoryDao.getCategoriesAmount();
    expect(count, 1);
  });

  group('Query by id', () {
    test('Success cases', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;

      await fkUtils.insertCategoryFKDependencies(category1);
      await database.categoryDao.insertCategory(category1);
      await fkUtils.insertCategoryFKDependencies(category2);
      await database.categoryDao.insertCategory(category2);

      var result = await database.categoryDao.getCategoryById(category1.id.value);
      var expected = CategoryEntity(
        id: category1.id.value,
        name: category1.name.value,
        iconId: category1.iconId.value,
      );
      expect(result, expected);

      result = await database.categoryDao.getCategoryById(category2.id.value);
      expected = CategoryEntity(
        id: category2.id.value,
        name: category2.name.value,
        iconId: category2.iconId.value,
      );
      expect(result, expected);
    });

    test('Error cases', () async {
      final result = await database.categoryDao.getCategoryById(1);
      expect(result, isNull);
    });
  });

  group('Update', () {
    final category1 = fix.category1;
    final category2 = fix.category2;

    setUp(() async {
      await fkUtils.insertCategoryFKDependencies(category1);
      await database.categoryDao.insertCategory(category1);
      await fkUtils.insertCategoryFKDependencies(category2);
      await database.categoryDao.insertCategory(category2);
    });

    test('Updating name', () async {
      final newCategory = category1.copyWith(name: Value('New name'));
      await fkUtils.insertCategoryFKDependencies(newCategory);
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isTrue);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = CategoryEntity(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: newCategory.name.value,
      );
      final expected2 = CategoryEntity(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Updating icon id', () async {
      final newCategory = category1.copyWith(iconId: Value(4834));
      await fkUtils.insertCategoryFKDependencies(newCategory);
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isTrue);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = CategoryEntity(
        id: category1.id.value,
        iconId: newCategory.iconId.value,
        name: category1.name.value,
      );
      final expected2 = CategoryEntity(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Updating a category that does not exist', () async {
      final newCategory = fix.category3.copyWith(name: Value('New name'));
      await fkUtils.insertCategoryFKDependencies(newCategory);
      final result = await database.categoryDao.updateCategory(newCategory);
      expect(result, isFalse);

      final fromDb = await database.categoryDao.getAllCategories();
      final expected1 = CategoryEntity(
        id: category1.id.value,
        iconId: category1.iconId.value,
        name: category1.name.value,
      );
      final expected2 = CategoryEntity(
        id: category2.id.value,
        iconId: category2.iconId.value,
        name: category2.name.value,
      );
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });
}
