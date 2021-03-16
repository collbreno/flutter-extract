import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/fixture_subcategory.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  AppDatabase database;
  ForeignKeyUtils fkUtils;
  final fix = FixtureSubcategory();

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

  group('Insertion', () {
    test('Insertion without id must have an auto incremented id', () async {
      final subcategory1 = fix.subcategory1.copyWith(id: Value.absent());
      final subcategory2 = fix.subcategory2.copyWith(id: Value.absent());

      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      var result = await database.subcategoryDao.insertSubcategory(subcategory1);
      expect(result, 1);

      var fromDb = await database.subcategoryDao.getAllSubcategories();
      final expected1 = Subcategory(
        id: 1,
        iconId: subcategory1.iconId.value,
        name: subcategory1.name.value,
        parentId: subcategory1.parentId.value,
      );
      expect(fromDb, orderedEquals([expected1]));

      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      result = await database.subcategoryDao.insertSubcategory(subcategory2);
      expect(result, 2);

      fromDb = await database.subcategoryDao.getAllSubcategories();
      final expected2 = Subcategory(
        id: 2,
        iconId: subcategory2.iconId.value,
        name: subcategory2.name.value,
        parentId: subcategory2.parentId.value,
      );
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Insertion without name must fail', () async {
      final subcategory = fix.subcategory1.copyWith(name: Value.absent());

      await fkUtils.insertSubcategoryFKDependencies(subcategory);
      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, isEmpty);
    });

    test('Insertion without iconId must fail', () async {
      final subcategory = fix.subcategory1.copyWith(iconId: Value.absent());

      await fkUtils.insertSubcategoryFKDependencies(subcategory);
      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, isEmpty);
    });

    test('Insertion without parentId must fail', () async {
      final subcategory = fix.subcategory1.copyWith(parentId: Value.absent());

      await fkUtils.insertSubcategoryFKDependencies(subcategory);
      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, isEmpty);
    });

    test('Insertion with defined id must use the id given', () async {
      final subcategory = fix.subcategory1.copyWith(id: Value(42));

      await fkUtils.insertSubcategoryFKDependencies(subcategory);
      final result = await database.subcategoryDao.insertSubcategory(subcategory);
      expect(result, 42);

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      final expected = Subcategory(
        id: subcategory.id.value,
        parentId: subcategory.parentId.value,
        iconId: subcategory.iconId.value,
        name: subcategory.name.value,
      );

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with duplicated id must fail', () async {
      final subcategory1 = fix.subcategory1.copyWith(id: Value(42));

      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      final result = await database.subcategoryDao.insertSubcategory(subcategory1);
      expect(result, 42);

      final expected1 = Subcategory(
        id: subcategory1.id.value,
        iconId: subcategory1.iconId.value,
        parentId: subcategory1.parentId.value,
        name: subcategory1.name.value,
      );
      var fromDB = await database.subcategoryDao.getAllSubcategories();
      expect(fromDB, orderedEquals([expected1]));

      final subcategory2 = fix.subcategory2.copyWith(id: Value(42));

      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.subcategoryDao.getAllSubcategories();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Foreign keys', () {
    test(
        'Insertion with iconId that does not have any reference '
        'to the icon table must fail.', () async {
      final subcategory = fix.subcategory1;

      final parentFromDb = await database.iconDao.getIconById(subcategory.iconId.value);
      expect(parentFromDb, isNull);

      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory),
        throwsA(isA<SqliteException>()),
      );
    });

    test(
        'Insertion with parentId that does not have any reference '
        'to the category table must fail.', () async {
      final subcategory = fix.subcategory1;

      final parentFromDb = await database.categoryDao.getCategoryById(subcategory.parentId.value);
      expect(parentFromDb, isNull);

      expect(
        () => database.subcategoryDao.insertSubcategory(subcategory),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final subcategory1 = fix.subcategory1;
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await database.subcategoryDao.insertSubcategory(subcategory1);

      var fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, hasLength(1));

      var result = await database.subcategoryDao.deleteSubcategoryWithId(subcategory1.id.value);
      expect(result, 1);

      fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, isEmpty);
    });

    test('Deletion of an item that does not exist', () async {
      final subcategory1 = fix.subcategory1;
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await database.subcategoryDao.insertSubcategory(subcategory1);

      var fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, hasLength(1));

      var result = await database.subcategoryDao.deleteSubcategoryWithId(subcategory1.id.value + 1);
      expect(result, 0);

      // Database is not affected
      fromDb = await database.subcategoryDao.getAllSubcategories();
      expect(fromDb, hasLength(1));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final subcategory1 = fix.subcategory1;
      final subcategory2 = fix.subcategory2;

      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await database.subcategoryDao.insertSubcategory(subcategory1);
      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      await database.subcategoryDao.insertSubcategory(subcategory2);

      var result = await database.subcategoryDao.getSubcategoryById(subcategory1.id.value);
      var expected = Subcategory(
        id: subcategory1.id.value,
        parentId: subcategory1.parentId.value,
        name: subcategory1.name.value,
        iconId: subcategory1.iconId.value,
      );
      expect(result, expected);

      result = await database.subcategoryDao.getSubcategoryById(subcategory2.id.value);
      expected = Subcategory(
        id: subcategory2.id.value,
        parentId: subcategory2.parentId.value,
        name: subcategory2.name.value,
        iconId: subcategory2.iconId.value,
      );
      expect(result, expected);
    });

    test('Error cases', () async {
      final result = await database.subcategoryDao.getSubcategoryById(1);
      expect(result, isNull);
    });
  });

  test('Query by parent id', () async {
    final subcategory1 = fix.subcategory1.copyWith(parentId: Value(1));
    final subcategory2 = fix.subcategory2.copyWith(parentId: Value(3));
    final subcategory3 = fix.subcategory3.copyWith(parentId: Value(1));
    final subcategory4 = fix.subcategory4.copyWith(parentId: Value(2));
    final subcategory5 = fix.subcategory5.copyWith(parentId: Value(1));

    await fkUtils.insertSubcategoryFKDependencies(subcategory1);
    await fkUtils.insertSubcategoryFKDependencies(subcategory2);
    await fkUtils.insertSubcategoryFKDependencies(subcategory3);
    await fkUtils.insertSubcategoryFKDependencies(subcategory4);
    await fkUtils.insertSubcategoryFKDependencies(subcategory5);

    var fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    var expected = <Subcategory>[];
    expect(fromDb, expected);

    await database.subcategoryDao.insertSubcategory(subcategory1);
    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    expected.add(subcategory1.convert());
    expect(fromDb, expected);

    await database.subcategoryDao.insertSubcategory(subcategory2);
    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    expect(fromDb, expected);

    await database.subcategoryDao.insertSubcategory(subcategory3);
    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    expected.add(subcategory3.convert());
    expect(fromDb, expected);

    await database.subcategoryDao.insertSubcategory(subcategory4);
    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    expect(fromDb, expected);

    await database.subcategoryDao.insertSubcategory(subcategory5);
    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(1);
    expected.add(subcategory5.convert());
    expect(fromDb, expected);

    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(2);
    expected = [subcategory4.convert()];
    expect(fromDb, expected);

    fromDb = await database.subcategoryDao.getSubcategoriesByParentId(3);
    expected = [subcategory2.convert()];
    expect(fromDb, expected);
  });

  group('Update', () {
    final subcategory1 = fix.subcategory1;
    final subcategory2 = fix.subcategory2;
    final expected1 = subcategory1.convert();
    final expected2 = subcategory2.convert();

    setUp(() async {
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await database.subcategoryDao.insertSubcategory(subcategory1);
      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      await database.subcategoryDao.insertSubcategory(subcategory2);
    });

    test('Updating name', () async {
      final newName = 'New ${subcategory1.name.value}';
      final newSubcategory = subcategory1.copyWith(name: Value(newName));
      final result = await database.subcategoryDao.updateSubcategory(newSubcategory);
      expect(result, isTrue);

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      final newExpected1 = expected1.copyWith(name: newName);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating iconId', () async {
      final newIconId = subcategory1.iconId.value + 1;
      final newSubcategory = subcategory1.copyWith(iconId: Value(newIconId));
      await fkUtils.insertSubcategoryFKDependencies(newSubcategory);
      final result = await database.subcategoryDao.updateSubcategory(newSubcategory);
      expect(result, isTrue);

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      final newExpected1 = expected1.copyWith(iconId: newIconId);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating parentId', () async {
      final newParentId = subcategory1.parentId.value + 1;
      final newSubcategory = subcategory1.copyWith(parentId: Value(newParentId));
      await fkUtils.insertSubcategoryFKDependencies(newSubcategory);
      final result = await database.subcategoryDao.updateSubcategory(newSubcategory);
      expect(result, isTrue);

      final fromDb = await database.subcategoryDao.getAllSubcategories();
      final newExpected1 = expected1.copyWith(parentId: newParentId);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });
  });
}

extension on SubcategoriesCompanion {
  Subcategory convert({
    int id,
    int iconId,
    int parentId,
    String name,
  }) {
    return Subcategory(
      id: id ?? this.id.value,
      iconId: iconId ?? this.iconId.value,
      parentId: parentId ?? this.parentId.value,
      name: name ?? this.name.value,
    );
  }
}
