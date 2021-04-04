import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/fixture_expense.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final duration = Duration(hours: 2);
  AppDatabase database;
  ForeignKeyUtils fkUtils;
  final fix = FixtureExpense();

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

  group(
    'On updating an expense, a copy of the old expense must be created at '
    'the expenses history table, preserving the updatedAt field, that must '
    'be stored as alteredAt',
    () {
      test('Updating description', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          description: Value('Changed description'),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Updating value', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          value: Value(expense.value.value + 15),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Updating date', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          date: Value(expense.date.value.add(duration)),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Updating paymentMethodId', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          paymentMethodId: Value(expense.paymentMethodId.value + 1),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Updating subcategoryId', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          subcategoryId: Value(expense.subcategoryId.value + 2),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Updating storeId', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          storeId: Value(expense.storeId.value + 7),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });

      test('Multiples updates must save all previous expenses copies', () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        expense = expense.copyWith(
          value: Value(expense.value.value + 15),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));

        final history2 = expense.toHistory(2);
        expense = expense.copyWith(
          description: Value('New ${expense.description.value}'),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1, history2]));

        final history3 = expense.toHistory(3);
        expense = expense.copyWith(
          storeId: Value(expense.storeId.value + 7),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1, history2, history3]));

        final history4 = expense.toHistory(4);
        expense = expense.copyWith(
          paymentMethodId: Value(expense.paymentMethodId.value + 2),
          updatedAt: Value(expense.updatedAt.value.add(duration)),
        );
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.updateExpense(expense);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1, history2, history3, history4]));
      });
    },
  );

  test(
      'On deleting an expense, a copy of the old expense must be created at '
      'the expenses history table, preserving the updatedAt field, that must '
      'be stored as alteredAt',
      () async {
        var expense = fix.expense1;
        await fkUtils.insertExpenseFKDependencies(expense);
        await database.expenseDao.insertExpense(expense);
        var fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, isEmpty);

        final history1 = expense.toHistory(1);
        await database.expenseDao.deleteExpenseWithId(expense.id.value);
        fromDb = await database.expensesHistoryDao.getAllExpensesHistory();
        expect(fromDb, orderedEquals([history1]));
      });
}

extension on ExpensesCompanion {
  ExpenseHistoryEntity toHistory(int id) {
    return ExpenseHistoryEntity(
      id: id,
      description: description.value,
      value: value.value,
      alteredAt: updatedAt.value,
      date: date.value,
      subcategoryId: subcategoryId.value,
      expenseId: this.id.value,
      paymentMethodId: paymentMethodId.value,
      storeId: storeId.value,
    );
  }
}
