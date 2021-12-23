import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

import '../matchers/either_matcher.dart';

void main() {
  final uid = Uuid();
  late CategoryRepository repository;
  late AppDatabase database;
  final fix = FixtureCategory();
  final fixSubcategories = FixtureSubcategory();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CategoryRepository(database);
    addTearDown(() async {
      await database.close();
    });
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAll();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    test('Successfully insertion', () async {
      final category = fix.category1;

      await repository.insert(category);

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final category1 = fix.category1.rebuild((s) => s.id = id);

      var result = await repository.insert(category1);
      expect(result, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category1]));

      final category2 = fix.category2.rebuild((s) => s.id = id);

      result = await repository.insert(category2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;
      await repository.insert(category1);
      await repository.insert(category2);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category1, category2]));

      var result = await repository.delete(category1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category2]));
    });

    test('Deletion of an item that does not exist', () async {
      final category1 = fix.category1;
      await repository.insert(category1);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category1]));

      final idToDelete = uid.v4();
      expect(idToDelete, isNot(category1.id));
      var result = await repository.delete(idToDelete);
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([category1]));
    });
  });

  group('Get by id', () {
    test('Success case', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;
      await repository.insert(category1);
      await repository.insert(category2);

      var result = await repository.getById(category1.id);
      expect(result, Right(category1));

      result = await repository.getById(category2.id);
      expect(result, Right(category2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Watch by id', () {
    test('Simple case', () async {
      final category = fix.category1;

      await repository.insert(category);

      final result = await repository.watchById(category.id).first;

      expect(result, Right(category));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.watchById(uid.v4()).first;
      expect(result, Left(NotFoundFailure()));
    });

    test('Updation must emit a new category', () async {
      final category1 = fix.category1;
      final category2 = category1.rebuild((p0) => p0.name = 'New category');
      final category3 = category2.rebuild((p0) => p0.color = Color(Colors.amber.value));

      await repository.insert(category1);

      final expectation = expectLater(
        repository.watchById(category1.id),
        emitsInOrder([
          Right(category1),
          Right(category2),
          Right(category3),
        ]),
      );

      await repository.update(category2);
      await repository.update(category3);

      await expectation;
    });

    test('Deletion must emit a new failure', () async {
      final category = fix.category1;

      await repository.insert(category);

      final expectation = expectLater(
        repository.watchById(category.id),
        emitsInOrder([
          Right(category),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(category.id);

      await expectation;
    });
  });

  group('Watch all', () {
    test('Simple case', () async {
      final category = fix.category1;

      await repository.insert(category);

      final result = await repository.watchAll().first;

      expect(result, orderedRightEquals([category]));
    });

    test('Must return $NotFoundFailure when there is no categories', () async {
      final result = await repository.watchAll().first;
      expect(result, Left(NotFoundFailure()));
    });

    test('First insertion must emit a new list', () async {
      final category = fix.category1;

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          Left(NotFoundFailure()),
          orderedRightEquals([category]),
        ]),
      );

      await repository.insert(category);

      await expectation;
    });

    test('Updation must emit a new list', () async {
      final category = fix.category1;
      final newCategory = category.rebuild((p0) => p0.name = 'New Category');

      await repository.insert(category);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([category]),
          orderedRightEquals([newCategory]),
        ]),
      );

      await repository.update(newCategory);

      await expectation;
    });

    test('Insertion must emit a new list', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;

      await repository.insert(category1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([category1]),
          orderedRightEquals([category1, category2]),
        ]),
      );

      await repository.insert(category2);

      await expectation;
    });

    test('Deletion must emit a new list', () async {
      final category1 = fix.category1;
      final category2 = fix.category2;

      await repository.insert(category1);
      await repository.insert(category2);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([category1, category2]),
          orderedRightEquals([category1]),
        ]),
      );

      await repository.delete(category2.id);

      await expectation;
    });

    test('Deletion of the last item must emit $NotFoundFailure', () async {
      final category1 = fix.category1;

      await repository.insert(category1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([category1]),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(category1.id);

      await expectation;
    });
  });

  group('Update', () {
    final category1 = fix.category1;
    final category2 = fix.category2;

    setUp(() async {
      await repository.insert(category1);
      await repository.insert(category2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${category1.name}';
      final newCategory = category1.rebuild((s) => s..name = newName);
      final result = await repository.update(newCategory);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newCategory, category2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final category = fix.category3;
      final result = await repository.update(category);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
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

    await repository.insert(category1);
    await repository.insert(category2);
    await repository.insert(category3);
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
