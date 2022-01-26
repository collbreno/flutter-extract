import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late IExpenseRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureExpense();
  final fixTags = FixtureTag();
  final oneDay = Duration(days: 1);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ExpenseRepository(database);
    fkUtils = ForeignKeyUtils(database);
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAll();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    final file1 = 'file1.png';
    final file2 = 'file2.png';
    final tag1 = fixTags.tag1;
    final tag2 = fixTags.tag2;
    // The query to get expenses is very complex because it has a many to many relationship.
    // So the insertion test has to get directly from the table instead of using the repository.
    test('Successfully insertion', () async {
      final expense = fix.expense1.rebuild(
        (p0) => p0
          ..tags = SetBuilder([fixTags.tag1, fixTags.tag2])
          ..files = SetBuilder([file1, file2]),
      );

      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insert(expense);

      expect(expense.files.length, greaterThan(1));
      expect(expense.tags.length, greaterThan(1));

      final expectedExpense = expense.toEntity();
      final expectedExpenseFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: expense.createdAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: expense.createdAt),
      ];
      final expectedExpenseTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: expense.createdAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: expense.createdAt),
      ];

      final expenseFromDb = await database.select(database.expenses).get();
      final expenseFilesFromDb = await database.select(database.expenseFiles).get();
      final expenseTagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, [expectedExpense]);
      expect(expenseFilesFromDb, unorderedEquals(expectedExpenseFiles));
      expect(expenseTagsFromDb, unorderedEquals(expectedExpenseTags));
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
    final file1 = 'file1.png';
    final file2 = 'file2.png';
    final file3 = 'file3.png';
    final tag1 = fixTags.tag1;
    final tag2 = fixTags.tag2;
    final tag3 = fixTags.tag3;

    final expense = fix.expense1.rebuild(
      (p0) => p0
        ..updatedAt = p0.createdAt
        ..tags = SetBuilder([tag1, tag2])
        ..files = SetBuilder([file1, file2]),
    );

    final expectedTags = [
      ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: expense.createdAt),
      ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: expense.createdAt),
    ];
    final expectedFiles = [
      ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: expense.createdAt),
      ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: expense.createdAt),
    ];

    setUp(() async {
      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insert(expense);
    });

    test('Checking set up', () async {
      final expectedExpense = expense.toEntity();

      final expenseFromDb = await database.select(database.expenses).get();
      final filesFromDb = await database.select(database.expenseFiles).get();
      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, unorderedEquals([expectedExpense]));
      expect(tagsFromDb, unorderedEquals(expectedTags));
      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Simple deletion', () async {
      final expense2 = fix.expense2;

      await fkUtils.insertExpenseFKDependencies(expense2);

      final insert2 = await repository.insert(expense2);

      expect(insert2, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense, expense2]));

      var result = await repository.delete(expense.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense2]));
    });

    test('Deletion of an item that does not exist', () async {
      var result = await repository.delete(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([expense]));
    });

    test('Should delete the entries of tags table', () async {
      await repository.delete(expense.id);

      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(tagsFromDb, isEmpty);
    });

    test('Should not affect others expense tags', () async {
      final expense2 = fix.expense2.rebuild((p0) => p0..tags = SetBuilder([tag1]));

      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense2);

      await repository.delete(expense.id);

      final expectedTags = [
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag1.id, createdAt: expense2.createdAt),
      ];

      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(tagsFromDb, expectedTags);
    });

    test('Should delete the entries of files table', () async {
      await repository.delete(expense.id);

      final filesFromDb = await database.select(database.expenseFiles).get();

      expect(filesFromDb, isEmpty);
    });

    test('Should not affect others expense files', () async {
      final expense2 = fix.expense2.rebuild((p0) => p0..files = SetBuilder([file1]));

      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense2);

      await repository.delete(expense.id);

      final expectedFiles = [
        ExpenseFileEntity(expenseId: expense2.id, filePath: file1, createdAt: expense2.createdAt),
      ];

      final filesFromDb = await database.select(database.expenseFiles).get();

      expect(filesFromDb, expectedFiles);
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
    final file1 = 'file1.png';
    final file2 = 'file2.png';
    final file3 = 'file3.png';
    final tag1 = fixTags.tag1;
    final tag2 = fixTags.tag2;
    final tag3 = fixTags.tag3;

    final expense = fix.expense1.rebuild(
      (p0) => p0
        ..updatedAt = p0.createdAt
        ..tags = SetBuilder([tag1, tag2])
        ..files = SetBuilder([file1, file2]),
    );

    final expectedTags = [
      ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: expense.createdAt),
      ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: expense.createdAt),
    ];
    final expectedFiles = [
      ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: expense.createdAt),
      ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: expense.createdAt),
    ];

    setUp(() async {
      await fkUtils.insertExpenseFKDependencies(expense);
      await repository.insert(expense);
    });

    test('Checking set up', () async {
      final expectedExpense = expense.toEntity();

      final expenseFromDb = await database.select(database.expenses).get();
      final filesFromDb = await database.select(database.expenseFiles).get();
      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, unorderedEquals([expectedExpense]));
      expect(tagsFromDb, unorderedEquals(expectedTags));
      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Should return normally when entity has changed', () async {
      final newExpense = expense.rebuild(
        (e) => e
          ..description = 'New ${e.description}'
          ..updatedAt = e.createdAt!.add(oneDay),
      );

      final expectedExpense = newExpense.toEntity();
      final expectedTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: newExpense.updatedAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: newExpense.updatedAt),
      ];
      final expectedFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: newExpense.updatedAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: newExpense.updatedAt),
      ];

      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final expenseFromDb = await database.select(database.expenses).get();
      final filesFromDb = await database.select(database.expenseFiles).get();
      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, unorderedEquals([expectedExpense]));
      expect(tagsFromDb, unorderedEquals(expectedTags));
      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Should return normally when tag list has changed', () async {
      final newExpense = expense.rebuild(
        (e) => e
          ..tags = SetBuilder([tag1, tag3])
          ..updatedAt = e.createdAt!.add(oneDay),
      );

      final expectedExpense = newExpense.toEntity();
      final expectedTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: newExpense.updatedAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag3.id, createdAt: newExpense.updatedAt),
      ];
      final expectedFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: newExpense.updatedAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: newExpense.updatedAt),
      ];

      await fkUtils.insertExpenseFKDependencies(newExpense);
      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final expenseFromDb = await database.select(database.expenses).get();
      final filesFromDb = await database.select(database.expenseFiles).get();
      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, unorderedEquals([expectedExpense]));
      expect(tagsFromDb, unorderedEquals(expectedTags));
      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Should not modify others expenses when tag list has changed', () async {
      final expense2 = fix.expense2.rebuild(
        (p0) => p0
          ..tags = SetBuilder([tag1, tag2, tag3])
          ..files = SetBuilder([file1, file2, file3]),
      );

      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense2);

      var expectedTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: expense.createdAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: expense.createdAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag1.id, createdAt: expense2.createdAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag2.id, createdAt: expense2.createdAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag3.id, createdAt: expense2.createdAt),
      ];

      var tagsFromDb = await database.select(database.expenseTags).get();

      expect(tagsFromDb, unorderedEquals(expectedTags));

      final newExpense = expense.rebuild((p0) => p0
        ..tags = SetBuilder([tag1, tag3])
        ..updatedAt = p0.createdAt!.add(oneDay));

      await repository.update(newExpense);

      expectedTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: newExpense.updatedAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag3.id, createdAt: newExpense.updatedAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag1.id, createdAt: expense2.createdAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag2.id, createdAt: expense2.createdAt),
        ExpenseTagEntity(expenseId: expense2.id, tagId: tag3.id, createdAt: expense2.createdAt),
      ];

      tagsFromDb = await database.select(database.expenseTags).get();

      expect(tagsFromDb, unorderedEquals(expectedTags));
    });

    test('Should return normally when file list has changed', () async {
      final newExpense = expense.rebuild(
        (e) => e
          ..files = SetBuilder([file1, file3])
          ..updatedAt = e.createdAt!.add(oneDay),
      );

      final expectedExpense = newExpense.toEntity();
      final expectedFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: newExpense.updatedAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file3, createdAt: newExpense.updatedAt),
      ];
      final expectedTags = [
        ExpenseTagEntity(expenseId: expense.id, tagId: tag1.id, createdAt: newExpense.updatedAt),
        ExpenseTagEntity(expenseId: expense.id, tagId: tag2.id, createdAt: newExpense.updatedAt),
      ];

      final result = await repository.update(newExpense);
      expect(result, Right(Null));

      final expenseFromDb = await database.select(database.expenses).get();
      final filesFromDb = await database.select(database.expenseFiles).get();
      final tagsFromDb = await database.select(database.expenseTags).get();

      expect(expenseFromDb, unorderedEquals([expectedExpense]));
      expect(tagsFromDb, unorderedEquals(expectedTags));
      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Should not modify others expenses when file list has changed', () async {
      final expense2 = fix.expense2.rebuild(
        (p0) => p0
          ..tags = SetBuilder([tag1, tag2, tag3])
          ..files = SetBuilder([file1, file2, file3]),
      );

      await fkUtils.insertExpenseFKDependencies(expense2);
      await repository.insert(expense2);

      var expectedFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: expense.createdAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file2, createdAt: expense.createdAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file1, createdAt: expense2.createdAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file2, createdAt: expense2.createdAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file3, createdAt: expense2.createdAt),
      ];

      var filesFromDb = await database.select(database.expenseFiles).get();

      expect(filesFromDb, unorderedEquals(expectedFiles));

      final newExpense = expense.rebuild((p0) => p0
        ..files = SetBuilder([file1, file3])
        ..updatedAt = p0.createdAt!.add(oneDay));

      await repository.update(newExpense);

      expectedFiles = [
        ExpenseFileEntity(expenseId: expense.id, filePath: file1, createdAt: newExpense.updatedAt),
        ExpenseFileEntity(expenseId: expense.id, filePath: file3, createdAt: newExpense.updatedAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file1, createdAt: expense2.createdAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file2, createdAt: expense2.createdAt),
        ExpenseFileEntity(expenseId: expense2.id, filePath: file3, createdAt: expense2.createdAt),
      ];

      filesFromDb = await database.select(database.expenseFiles).get();

      expect(filesFromDb, unorderedEquals(expectedFiles));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final expense2 = fix.expense2;
      final result = await repository.update(expense2);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
      // Database is not affected
      expect(fromDb, orderedRightEquals([expense]));
    });
  });
}
