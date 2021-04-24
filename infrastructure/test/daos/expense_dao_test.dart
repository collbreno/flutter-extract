import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../utils/fixture_expense.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
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

  group('Insertion', () {
    test('Insertion without id must fail', () async {
      final expense = fix.expense1.copyWith(id: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without description must fail', () async {
      final expense = fix.expense1.copyWith(description: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without value must fail', () async {
      final expense = fix.expense1.copyWith(value: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without date must fail', () async {
      final expense = fix.expense1.copyWith(date: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without payment method must fail', () async {
      final expense = fix.expense1.copyWith(paymentMethodId: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without subcategory id must fail', () async {
      final expense = fix.expense1.copyWith(subcategoryId: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without store id must define store id as null', () async {
      final expense = fix.expense1.copyWith(storeId: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      await database.expenseDao.insertExpense(expense);

      final fromDb = await database.expenseDao.getAllExpenses();
      final expected = expense.convert();

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion without created at must fail', () async {
      final expense = fix.expense1.copyWith(createdAt: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion without updated at must fail', () async {
      final expense = fix.expense1.copyWith(updatedAt: Value.absent());

      await fkUtils.insertExpenseFKDependencies(expense);
      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, isEmpty);
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final expense1 = fix.expense1.copyWith(id: Value(id));

      await fkUtils.insertExpenseFKDependencies(expense1);
      await database.expenseDao.insertExpense(expense1);

      final expected1 = expense1.convert();
      var fromDB = await database.expenseDao.getAllExpenses();
      expect(fromDB, orderedEquals([expected1]));

      final expense2 = fix.expense2.copyWith(id: Value(id));

      await fkUtils.insertExpenseFKDependencies(expense2);
      expect(
        () => database.expenseDao.insertExpense(expense2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.expenseDao.getAllExpenses();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Foreign keys', () {
    test(
        'Insertion with payment method id that does not have any '
        'reference to the payment method table must fail', () async {
      final expense = fix.expense1;

      final pmFromDb =
          await database.paymentMethodDao.getPaymentMethodById(expense.paymentMethodId.value);
      expect(pmFromDb, isNull);

      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<SqliteException>()),
      );
    });

    test(
        'Insertion with subcategory id that does not have any '
        'reference to the subcategory table must fail', () async {
      final expense = fix.expense1;

      final subcategoryFromDb =
          await database.subcategoryDao.getSubcategoryById(expense.subcategoryId.value);
      expect(subcategoryFromDb, isNull);

      expect(
        () => database.expenseDao.insertExpense(expense),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final expense1 = fix.expense1;
      final expense2 = fix.expense2;
      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await database.expenseDao.insertExpense(expense1);
      await database.expenseDao.insertExpense(expense2);

      var fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, hasLength(2));

      var result = await database.expenseDao.deleteExpenseWithId(expense1.id.value);
      expect(result, 1);

      fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, hasLength(1));
    });

    test('Deletion of an item that does not exist', () async {
      final expense1 = fix.expense1;
      await fkUtils.insertExpenseFKDependencies(expense1);
      await database.expenseDao.insertExpense(expense1);

      var fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, hasLength(1));

      final differentId = uid.v4();
      expect(expense1.id.value, isNot(differentId));

      var result = await database.expenseDao.deleteExpenseWithId(differentId);
      expect(result, 0);

      // Database is not affected
      fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, hasLength(1));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final expense1 = fix.expense1;
      final expense2 = fix.expense2;
      await fkUtils.insertExpenseFKDependencies(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await database.expenseDao.insertExpense(expense1);
      await database.expenseDao.insertExpense(expense2);

      var result = await database.expenseDao.getExpenseById(expense1.id.value);
      var expected = expense1.convert();
      expect(result, expected);

      result = await database.expenseDao.getExpenseById(expense2.id.value);
      expected = expense2.convert();
      expect(result, expected);
    });

    test('Query by id of an expense that does\'nt exist must return null.', () async {
      final result = await database.expenseDao.getExpenseById(uid.v4());
      expect(result, isNull);
    });
  });

  group('Update', () {
    final expense1 = fix.expense1;
    final expense2 = fix.expense2;

    setUp(() async {
      await fkUtils.insertExpenseFKDependencies(expense1);
      await database.expenseDao.insertExpense(expense1);
      await fkUtils.insertExpenseFKDependencies(expense2);
      await database.expenseDao.insertExpense(expense2);
    });

    test('Updating description', () async {
      final newExpense1 = expense1.copyWith(
        description: Value('New ${expense1.description.value}'),
      );
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating value', () async {
      final newExpense1 = expense1.copyWith(
        value: Value(expense1.value.value + 1),
      );
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating date', () async {
      final newExpense1 = expense1.copyWith(
        date: Value(expense1.date.value.add(Duration(days: 1))),
      );
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating paymentMethodId', () async {
      final newExpense1 = expense1.copyWith(
        paymentMethodId: Value(uid.v4()),
      );
      await fkUtils.insertExpenseFKDependencies(newExpense1);
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating subcategoryId', () async {
      final newExpense1 = expense1.copyWith(
        subcategoryId: Value(uid.v4()),
      );
      await fkUtils.insertExpenseFKDependencies(newExpense1);
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating storeId', () async {
      final newExpense1 = expense1.copyWith(
        storeId: Value(uid.v4()),
      );
      await fkUtils.insertExpenseFKDependencies(newExpense1);
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating createdAt', () async {
      final newExpense1 = expense1.copyWith(
        createdAt: Value(expense1.createdAt.value.add(Duration(days: 1))),
      );
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating updatedAt', () async {
      final newExpense1 = expense1.copyWith(
        updatedAt: Value(expense1.updatedAt.value.add(Duration(days: 1))),
      );
      final result = await database.expenseDao.updateExpense(newExpense1);
      expect(result, isTrue);

      final fromDb = await database.expenseDao.getAllExpenses();
      expect(fromDb, orderedEquals([newExpense1.convert(), expense2.convert()]));
    });

    test('Updating an item that does not exist', () async {
      final expense = fix.expense3;
      final result = await database.expenseDao.updateExpense(expense);
      expect(result, isFalse);

      final fromDb = await database.expenseDao.getAllExpenses();
      // Database is not affected
      expect(fromDb, orderedEquals([expense1.convert(), expense2.convert()]));
    });
  });
}

extension on ExpensesCompanion {
  ExpenseEntity convert({
    String? id,
    String? description,
    int? value,
    DateTime? date,
    String? paymentMethodId,
    String? subcategoryId,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseEntity(
      id: id ?? this.id.value,
      description: description ?? this.description.value,
      value: value ?? this.value.value,
      date: date ?? this.date.value,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId.value,
      subcategoryId: subcategoryId ?? this.subcategoryId.value,
      storeId: storeId ?? this.storeId.value,
      createdAt: createdAt ?? this.createdAt.value,
      updatedAt: updatedAt ?? this.updatedAt.value,
    );
  }
}
