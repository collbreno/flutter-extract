import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/repositories/tag_repository.dart';
import 'package:moor/ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

import '../matchers/either_matcher.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  final uid = Uuid();
  late TagRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureTag();
  final fixExpenses = FixtureExpense();
  final fixDate = FixtureDateTime();

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    repository = TagRepository(database);
    fkUtils = ForeignKeyUtils(database);

    addTearDown(() async {
      await database.close();
    });
  });

  test('Get all must return $NotFoundFailure when there is no items in database', () async {
    final fromDb = await repository.getAllTags();

    expect(fromDb, Left(NotFoundFailure()));
  });

  group('Insertion', () {
    test('Successfully insertion', () async {
      final tag = fix.tag1;

      await repository.insertTag(tag);

      final fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final tag1 = fix.tag1.rebuild((t) => t.id = id);

      var result = await repository.insertTag(tag1);
      expect(result, Right(Null));

      var fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag1]));

      final tag2 = fix.tag2.rebuild((t) => t.id = id);

      result = await repository.insertTag(tag2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final tag1 = fix.tag1;
      final tag2 = fix.tag2;
      final insert1 = await repository.insertTag(tag1);
      final insert2 = await repository.insertTag(tag2);

      expect(insert1, Right(Null));
      expect(insert2, Right(Null));

      var fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag1, tag2]));

      var result = await repository.deleteTagWithId(tag1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag2]));
    });

    test('Deletion of an item that does not exist', () async {
      final tag1 = fix.tag1;
      await repository.insertTag(tag1);

      var fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag1]));

      var result = await repository.deleteTagWithId(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([tag1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final tag1 = fix.tag1;
      final tag2 = fix.tag2;
      await repository.insertTag(tag1);
      await repository.insertTag(tag2);

      var result = await repository.getTagById(tag1.id);
      expect(result, Right(tag1));

      result = await repository.getTagById(tag2.id);
      expect(result, Right(tag2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getTagById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Update', () {
    final tag1 = fix.tag1;
    final tag2 = fix.tag2;

    setUp(() async {
      await repository.insertTag(tag1);
      await repository.insertTag(tag2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${tag1.name}';
      final newTag = tag1.rebuild((t) => t..name = newName);
      final result = await repository.updateTag(newTag);
      expect(result, Right(Null));

      final fromDb = await repository.getAllTags();
      expect(fromDb, orderedRightEquals([newTag, tag2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final tag = fix.tag3;
      final result = await repository.updateTag(tag);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAllTags();
      // Database is not affected
      expect(fromDb, orderedRightEquals([tag1, tag2]));
    });
  });

  test('Count usages', () async {
    final tag1 = fix.tag1;
    final expense1 = fixExpenses.expense1;
    final expense2 = fixExpenses.expense2;

    final tag2 = fix.tag2;
    final expense3 = fixExpenses.expense3;

    final tag3 = fix.tag3;

    await repository.insertTag(tag1);
    await repository.insertTag(tag2);
    await repository.insertTag(tag3);
    await fkUtils.insertExpenseFKDependencies(expense1);
    await fkUtils.insertExpenseFKDependencies(expense2);
    await fkUtils.insertExpenseFKDependencies(expense3);
    await database.into(database.expenses).insert(expense1.toEntity());
    await database.into(database.expenses).insert(expense2.toEntity());
    await database.into(database.expenses).insert(expense3.toEntity());
    await database.into(database.expenseTags).insert(
        ExpenseTagEntity(tagId: tag1.id, expenseId: expense1.id, createdAt: fixDate.dateTime1));
    await database.into(database.expenseTags).insert(
        ExpenseTagEntity(tagId: tag1.id, expenseId: expense2.id, createdAt: fixDate.dateTime1));
    await database.into(database.expenseTags).insert(
        ExpenseTagEntity(tagId: tag2.id, expenseId: expense3.id, createdAt: fixDate.dateTime1));

    var result = await repository.countUsages(tag1.id);
    expect(result, Right(2));

    result = await repository.countUsages(tag2.id);
    expect(result, Right(1));

    result = await repository.countUsages(tag3.id);
    expect(result, Right(0));
  });
}
