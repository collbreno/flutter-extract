import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/mappers/_mappers.dart';
import 'package:infrastructure/src/repositories/expense_repository.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

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

    fromDb.fold(
      (l) => expect(l, NotFoundFailure()),
      (r) => throw Exception('should be left'),
    );
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
  });
}
