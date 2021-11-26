import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../matchers/either_matcher.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late SubcategoryRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureSubcategory();
  final fixExpense = FixtureExpense();
  final fixCategory = FixtureCategory();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = SubcategoryRepository(database);
    fkUtils = ForeignKeyUtils(database);
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
      final subcategory = fix.subcategory1;

      await fkUtils.insertSubcategoryFKDependencies(subcategory);
      await repository.insert(subcategory);

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final subcategory1 = fix.subcategory1.rebuild((s) => s.id = id);

      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      var result = await repository.insert(subcategory1);
      expect(result, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory1]));

      final subcategory2 = fix.subcategory2.rebuild((s) => s.id = id);

      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      result = await repository.insert(subcategory2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final subcategory1 = fix.subcategory1;
      final subcategory2 = fix.subcategory2;
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await repository.insert(subcategory1);
      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      await repository.insert(subcategory2);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory1, subcategory2]));

      var result = await repository.delete(subcategory1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory2]));
    });

    test('Deletion of an item that does not exist', () async {
      final subcategory1 = fix.subcategory1;
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await repository.insert(subcategory1);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory1]));

      final idToDelete = uid.v4();
      expect(idToDelete, isNot(subcategory1.id));
      var result = await repository.delete(idToDelete);
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([subcategory1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final subcategory1 = fix.subcategory1;
      final subcategory2 = fix.subcategory2;
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await repository.insert(subcategory1);
      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      await repository.insert(subcategory2);

      var result = await repository.getById(subcategory1.id);
      expect(result, Right(subcategory1));

      result = await repository.getById(subcategory2.id);
      expect(result, Right(subcategory2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  test('Query by parent id', () async {
    final category1 = fixCategory.category1;
    final subcategory1 = fix.subcategory1.rebuild((s) => s..parent = category1.toBuilder());
    final subcategory2 = fix.subcategory2.rebuild((s) => s..parent = category1.toBuilder());

    final category2 = fixCategory.category2;
    final subcategory3 = fix.subcategory3.rebuild((s) => s..parent = category2.toBuilder());

    await fkUtils.insertSubcategoryFKDependencies(subcategory1);
    await fkUtils.insertSubcategoryFKDependencies(subcategory2);
    await fkUtils.insertSubcategoryFKDependencies(subcategory3);
    await repository.insert(subcategory1);
    await repository.insert(subcategory2);
    await repository.insert(subcategory3);

    var result = await repository.getByParentId(category1.id);
    expect(result, orderedRightEquals([subcategory1, subcategory2]));

    result = await repository.getByParentId(category2.id);
    expect(result, orderedRightEquals([subcategory3]));

    result = await repository.getByParentId(uid.v4());
    expect(result, Left(NotFoundFailure()));
  });

  group('Update', () {
    final subcategory1 = fix.subcategory1;
    final subcategory2 = fix.subcategory2;

    setUp(() async {
      await fkUtils.insertSubcategoryFKDependencies(subcategory1);
      await repository.insert(subcategory1);
      await fkUtils.insertSubcategoryFKDependencies(subcategory2);
      await repository.insert(subcategory2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${subcategory1.name}';
      final newSubcategory = subcategory1.rebuild((s) => s..name = newName);
      final result = await repository.update(newSubcategory);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newSubcategory, subcategory2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final subcategory = fix.subcategory3;
      final result = await repository.update(subcategory);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
      // Database is not affected
      expect(fromDb, orderedRightEquals([subcategory1, subcategory2]));
    });
  });

  test('Count usages', () async {
    final subcategory1 = fix.subcategory1;
    final expense1 = fixExpense.expense1.rebuild((e) => e.subcategory = subcategory1.toBuilder());
    final expense2 = fixExpense.expense2.rebuild((e) => e.subcategory = subcategory1.toBuilder());

    final subcategory2 = fix.subcategory2;
    final expense3 = fixExpense.expense3.rebuild((e) => e.subcategory = subcategory2.toBuilder());

    final subcategory3 = fix.subcategory3;

    await fkUtils.insertSubcategoryFKDependencies(subcategory1);
    await fkUtils.insertSubcategoryFKDependencies(subcategory2);
    await fkUtils.insertSubcategoryFKDependencies(subcategory3);
    await repository.insert(subcategory1);
    await repository.insert(subcategory2);
    await repository.insert(subcategory3);
    await fkUtils.insertExpenseFKDependencies(expense1);
    await fkUtils.insertExpenseFKDependencies(expense2);
    await fkUtils.insertExpenseFKDependencies(expense3);
    await database.into(database.expenses).insert(expense1.toEntity());
    await database.into(database.expenses).insert(expense2.toEntity());
    await database.into(database.expenses).insert(expense3.toEntity());

    var result = await repository.countUsages(subcategory1.id);
    expect(result, Right(2));

    result = await repository.countUsages(subcategory2.id);
    expect(result, Right(1));

    result = await repository.countUsages(subcategory3.id);
    expect(result, Right(0));
  });
}
