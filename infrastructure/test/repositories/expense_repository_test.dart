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

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = ExpenseRepository(database);
    fkUtils = ForeignKeyUtils(database);
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAllExpenses();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    // The query to get expenses is very complex because it has a many to many relationship.
    // So the insertion test has to get directly from the table instead of using the repository.
    test('Successfully insertion', () async {
      final expense = fix.expense1;

      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insertExpense(expense);

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
      await repository.insertExpense(expense);

      final fromDb = await repository.getAllExpenses();

      expect(fromDb, orderedRightEquals([expense]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final expense1 = fix.expense1;
      final expense2 = fix.expense2;
      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insertExpense(expense1);
      await repository.insertExpense(expense2);

      var result = await repository.getExpenseById(expense1.id);
      expect(result, Right(expense1));

      result = await repository.getExpenseById(expense2.id);
      expect(result, Right(expense2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getExpenseById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });
}
