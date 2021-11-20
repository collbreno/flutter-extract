import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/repositories/expense_repository.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../matchers/either_matcher.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late IExpenseRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureExpense();
  final fixTags = FixtureTag();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = ExpenseRepository(database);
    fkUtils = ForeignKeyUtils(database);
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAll();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    // The query to get expenses is very complex because it has a many to many relationship.
    // So the insertion test has to get directly from the table instead of using the repository.
    test('Successfully insertion', () async {
      final expense = fix.expense1;

      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insert(expense);

      // Expected
      final expectedExpense = expense.toEntity();
      final expectedExpenseFiles = expense.files.map(
        (file) => ExpenseFileEntity(
          expenseId: expense.id,
          filePath: file,
          createdAt: expense.createdAt,
        ),
      );
      final expectedExpenseTags = expense.tags.map(
        (tag) => ExpenseTagEntity(
          expenseId: expense.id,
          tagId: tag.id,
          createdAt: expense.createdAt,
        ),
      );

      final expenseFromDb = await database.select(database.expenses).get();
      final expenseFilesFromDb = await database.select(database.expenseFiles).get();
      final expenseTagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, [expectedExpense]);
      expect(expenseFilesFromDb, expectedExpenseFiles);
      expect(expenseTagsFromDb, expectedExpenseTags);
    });

    test('Getting after inserting', () async {
      final expense = fix.expense1;

      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insert(expense);

      final fromDb = await repository.getAll();

      expect(fromDb, orderedRightEquals([expense]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final expense1 = fix.expense1.rebuild((t) => t.id = id);
      final expense2 = fix.expense2.rebuild((t) => t.id = id);

      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);

      var result = await repository.insert(expense1);
      expect(result, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense1]));

      result = await repository.insert(expense2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final expense1 = fix.expense1;
      final expense2 = fix.expense2;

      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);

      final insert1 = await repository.insert(expense1);
      final insert2 = await repository.insert(expense2);

      expect(insert1, Right(Null));
      expect(insert2, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense1, expense2]));

      var result = await repository.delete(expense1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense2]));
    });

    test('Deletion of an item that does not exist', () async {
      final expense1 = fix.expense1;

      await fkUtils.insertExpenseFKDependencies(expense1);
      final insert = await repository.insert(expense1);
      expect(insert, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense1]));

      var result = await repository.delete(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final expense1 = fix.expense1;
      final expense2 = fix.expense2;
      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense1);
      await repository.insert(expense2);

      var result = await repository.getById(expense1.id);
      expect(result, Right(expense1));

      result = await repository.getById(expense2.id);
      expect(result, Right(expense2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Update', () {
    final expense1 = fix.expense1;
    final expense2 = fix.expense2;

    setUp(() async {
      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense1);
      await repository.insert(expense2);
    });

    test('Should return normally when entity has changed', () async {
      final newDescription = 'New ${expense1.description}';
      final newExpense = expense1.rebuild((e) => e..description = newDescription);
      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newExpense, expense2]));
    });

    test('Should return normally when tag list has changes', () async {
      final newTags = expense1.tags.rebuild((t) => t
        ..remove(fixTags.tag1)
        ..add(fixTags.tag3));
      expect(expense1.tags, isNot(newTags));

      final newExpense = expense1.rebuild((e) => e..tags = newTags.toBuilder());
      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newExpense, expense2]));
    });

    test('Should return normally when file list has changes', () async {
      final newFiles = expense1.files.rebuild((t) => t
        ..remove(expense1.files.first)
        ..add('new_file.png'));
      expect(expense1.files, isNot(newFiles));

      final newExpense = expense1.rebuild((e) => e..files = newFiles.toBuilder());
      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newExpense, expense2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final expense = fix.expense3;
      final result = await repository.update(expense);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
      // Database is not affected
      expect(fromDb, orderedRightEquals([expense1, expense2]));
    });
  });
}
