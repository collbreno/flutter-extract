// import 'package:flutter_test/flutter_test.dart';
// import 'package:infrastructure/infrastructure.dart';
// import 'package:moor/ffi.dart';
// import 'package:drift/drift.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:uuid/uuid.dart';
//
// import '../utils/fixture_expense.dart';
// import '../utils/foreign_keys_utils.dart';
//
// void main() {
//   final _uid = Uuid();
//   final duration = Duration(hours: 2);
//   late AppDatabase database;
//   late ForeignKeyUtils fkUtils;
//   final fix = FixtureExpense();
//
//   setUpAll(() {
//     sqfliteFfiInit();
//   });
//
//   setUp(() {
//     database = AppDatabase(NativeDatabase.memory());
//     fkUtils = ForeignKeyUtils(database);
//   });
//
//   tearDown(() async {
//     await database.close();
//   });
//
//   group(
//     'On updating an expense, a copy of the old expense must be created at '
//     'the expenses history table, preserving the updatedAt field, that must '
//     'be stored as alteredAt',
//     () {
//       test('Updating description', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           description: 'Changed description',
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Updating value', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           value: expense.value + 15,
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Updating date', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           date: expense.date.add(duration),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Updating paymentMethodId', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           paymentMethodId: _uid.v4(),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Updating subcategoryId', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           subcategoryId: _uid.v4(),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Updating storeId', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           storeId: _uid.v4(),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//       });
//
//       test('Multiples updates must save all previous expenses copies', () async {
//         var expense = fix.expense1;
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.into(database.expenses).insert(expense);
//         var fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, isEmpty);
//
//         final history1 = expense.toHistory(1);
//         expense = expense.copyWith(
//           value: expense.value + 15,
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1]));
//
//         final history2 = expense.toHistory(2);
//         expense = expense.copyWith(
//           description: 'New ${expense.description}',
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1, history2]));
//
//         final history3 = expense.toHistory(3);
//         expense = expense.copyWith(
//           storeId: _uid.v4(),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1, history2, history3]));
//
//         final history4 = expense.toHistory(4);
//         expense = expense.copyWith(
//           paymentMethodId: _uid.v4(),
//           updatedAt: expense.updatedAt.add(duration),
//         );
//         await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//         await database.update(database.expenses).replace(expense);
//         fromDb = await database.select(database.expensesHistory).get();
//         expect(fromDb, orderedEquals([history1, history2, history3, history4]));
//       });
//     },
//   );
//
//   test(
//     'On deleting an expense, a copy of the old expense must be created at '
//     'the expenses history table, preserving the updatedAt field, that must '
//     'be stored as alteredAt',
//     () async {
//       var expense = fix.expense1;
//       await fkUtils.insertExpenseFKDependencies(expense.toCompanion(false));
//       await database.into(database.expenses).insert(expense);
//       var fromDb = await database.select(database.expensesHistory).get();
//       expect(fromDb, isEmpty);
//
//       final history1 = expense.toHistory(1);
//       await database.expenseDao.deleteExpenseWithId(expense.id.value);
//       fromDb = await database.select(database.expensesHistory).get();
//       expect(fromDb, orderedEquals([history1]));
//     },
//   );
// }
//
// extension on ExpenseEntity {
//   ExpenseHistoryEntity toHistory(int id) {
//     return ExpenseHistoryEntity(
//       id: id,
//       description: description,
//       value: value,
//       alteredAt: updatedAt,
//       date: date,
//       subcategoryId: subcategoryId,
//       expenseId: this.id,
//       paymentMethodId: paymentMethodId,
//       storeId: storeId,
//     );
//   }
// }
