import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../matchers/either_matcher.dart';

void main() {
  final uid = Uuid();
  late CategoryRepository repository;
  late AppDatabase database;
  final fix = FixtureCategory();
  final fixSubcategories = FixtureSubcategory();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = CategoryRepository(database);
    addTearDown(() async {
      await database.close();
    });
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAllCategories();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    test('Successfully insertion', () async {
      final category = fix.category1;

      await repository.insertCategory(category);

      final fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final category1 = fix.category1.rebuild((s) => s.id = id);

      var result = await repository.insertCategory(category1);
      expect(result, Right(Null));

      var fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category1]));

      final category2 = fix.category2.rebuild((s) => s.id = id);

      result = await repository.insertCategory(category2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;
      await repository.insertCategory(category1);
      await repository.insertCategory(category2);

      var fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category1, category2]));

      var result = await repository.deleteCategory(category1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category2]));
    });

    test('Deletion of an item that does not exist', () async {
      final category1 = fix.category1;
      await repository.insertCategory(category1);

      var fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category1]));

      final idToDelete = uid.v4();
      expect(idToDelete, isNot(category1.id));
      var result = await repository.deleteCategory(idToDelete);
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([category1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;
      await repository.insertCategory(category1);
      await repository.insertCategory(category2);

      var result = await repository.getCategoryById(category1.id);
      expect(result, Right(category1));

      result = await repository.getCategoryById(category2.id);
      expect(result, Right(category2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getCategoryById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Update', () {
    final category1 = fix.category1;
    final category2 = fix.category2;

    setUp(() async {
      await repository.insertCategory(category1);
      await repository.insertCategory(category2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${category1.name}';
      final newCategory = category1.rebuild((s) => s..name = newName);
      final result = await repository.updateCategory(newCategory);
      expect(result, Right(Null));

      final fromDb = await repository.getAllCategories();
      expect(fromDb, orderedRightEquals([newCategory, category2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final category = fix.category3;
      final result = await repository.updateCategory(category);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAllCategories();
      // Database is not affected
      expect(fromDb, orderedRightEquals([category1, category2]));
    });
  });

  test('Count usages', () async {
    final category1 = fix.category1;
    final subcategory1 = fixSubcategories.subcategory1.toEntity().copyWith(parentId: category1.id);
    final subcategory2 = fixSubcategories.subcategory2.toEntity().copyWith(parentId: category1.id);

    final category2 = fix.category2;
    final subcategory3 = fixSubcategories.subcategory3.toEntity().copyWith(parentId: category2.id);

    final category3 = fix.category3;

    await repository.insertCategory(category1);
    await repository.insertCategory(category2);
    await repository.insertCategory(category3);
    await database.into(database.subcategories).insert(subcategory1);
    await database.into(database.subcategories).insert(subcategory2);
    await database.into(database.subcategories).insert(subcategory3);

    var result = await repository.countUsages(category1.id);
    expect(result, Right(2));

    result = await repository.countUsages(category2.id);
    expect(result, Right(1));

    result = await repository.countUsages(category3.id);
    expect(result, Right(0));
  });
}
