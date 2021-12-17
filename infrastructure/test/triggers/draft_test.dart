// import 'package:flutter_test/flutter_test.dart';
// import 'package:infrastructure/infrastructure.dart';
// import 'package:moor/ffi.dart';
// import 'package:drift/drift.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//
// import '../utils/extensions.dart';
// import '../utils/fixture_date_time.dart';
// import '../utils/fixture_expense.dart';
// import '../utils/fixture_tag.dart';
// import '../utils/foreign_keys_utils.dart';
//
// void main() {
//   late AppDatabase database;
//   late ForeignKeyUtils fkUtils;
//   final fixExpense = FixtureExpense();
//   final fixTag = FixtureTag();
//   final fixDate = FixtureDateTime();
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
//   test('When a expense draft is effectively saved, the draft has to be deleted.', () async {
//     // 1st draft, with 2 tags and 2 files
//     final expenseDraft1 = fixExpense.expense1.toDraft(
//       description: Value('test description'),
//       storeId: Value.absent(),
//     );
//     final expense1Tag1 = ExpenseDraftTagsCompanion(
//       expenseId: fixExpense.expense1.id,
//       tagId: fixTag.tag1.id,
//       createdAt: Value(fixDate.dateTime1),
//     );
//     final expense1Tag2 = ExpenseDraftTagsCompanion(
//       expenseId: fixExpense.expense1.id,
//       tagId: fixTag.tag2.id,
//       createdAt: Value(fixDate.dateTime2),
//     );
//     final expense1File1 = ExpenseDraftFilesCompanion(
//       expenseId: fixExpense.expense1.id,
//       filePath: Value('lkjslfsafs'),
//       createdAt: Value(fixDate.dateTime4),
//     );
//     final expense1File2 = ExpenseDraftFilesCompanion(
//       expenseId: fixExpense.expense1.id,
//       filePath: Value('sfasfgsfs'),
//       createdAt: Value(fixDate.dateTime5),
//     );
//
//     // 2nd draft, with 1 tag and 1 file
//     final expenseDraft2 = fixExpense.expense2.toDraft(
//       value: Value(320),
//       paymentMethodId: Value.absent(),
//     );
//     final expense2Tag1 = ExpenseDraftTagsCompanion(
//       expenseId: fixExpense.expense2.id,
//       tagId: fixTag.tag3.id,
//       createdAt: Value(fixDate.dateTime3),
//     );
//     final expense2File1 = ExpenseDraftFilesCompanion(
//       expenseId: fixExpense.expense2.id,
//       filePath: Value('ajskfhksafsa'),
//       createdAt: Value(fixDate.dateTime6),
//     );
//
//     // Inserting all the dependencies (store, payment method, subcategory, category and tags)
//     await fkUtils.insertExpenseFKDependencies(fixExpense.expense1);
//     await fkUtils.insertExpenseFKDependencies(fixExpense.expense2);
//     await database.into(database.tags).insert(fixTag.tag1);
//     await database.into(database.tags).insert(fixTag.tag2);
//     await database.into(database.tags).insert(fixTag.tag3);
//
//     // Inserting the 1st draft
//     await database.into(database.expenseDrafts).insert(expenseDraft1);
//     await database.into(database.expenseDraftTags).insert(expense1Tag1);
//     await database.into(database.expenseDraftTags).insert(expense1Tag2);
//     await database.into(database.expenseDraftFiles).insert(expense1File1);
//     await database.into(database.expenseDraftFiles).insert(expense1File2);
//
//     // Inserting the 2nd draft
//     await database.into(database.expenseDrafts).insert(expenseDraft2);
//     await database.into(database.expenseDraftTags).insert(expense2Tag1);
//     await database.into(database.expenseDraftFiles).insert(expense2File1);
//
//     // Asserting that the two drafts exists
//     var expenseDraftsFromDb = await database.select(database.expenseDrafts).get();
//     var expenseDraftsTagsFromDb = await database.select(database.expenseDraftTags).get();
//     var expenseDraftsFilesFromDb = await database.select(database.expenseDraftFiles).get();
//     expect(expenseDraftsFromDb, [
//       expenseDraft1.convert(),
//       expenseDraft2.convert(),
//     ]);
//     expect(expenseDraftsTagsFromDb, [
//       expense1Tag1.convert(),
//       expense1Tag2.convert(),
//       expense2Tag1.convert(),
//     ]);
//     expect(expenseDraftsFilesFromDb, [
//       expense1File1.convert(),
//       expense1File2.convert(),
//       expense2File1.convert(),
//     ]);
//
//     // Effectively saving one of the drafts
//     await database.into(database.expenses).insert(fixExpense.expense1);
//
//     // Then this draft is deleted from all the drafts tables
//     expenseDraftsFromDb = await database.select(database.expenseDrafts).get();
//     expenseDraftsTagsFromDb = await database.select(database.expenseDraftTags).get();
//     expenseDraftsFilesFromDb = await database.select(database.expenseDraftFiles).get();
//     expect(expenseDraftsFromDb, [
//       expenseDraft2.convert(),
//     ]);
//     expect(expenseDraftsTagsFromDb, [
//       expense2Tag1.convert(),
//     ]);
//     expect(expenseDraftsFilesFromDb, [
//       expense2File1.convert(),
//     ]);
//   });
// }
