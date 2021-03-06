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
  late StoreRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixtureStore();
  final fixExpenses = FixtureExpense();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = StoreRepository(database);
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
      final store = fix.store1;

      await repository.insert(store);

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final store1 = fix.store1.rebuild((s) => s.id = id);

      var result = await repository.insert(store1);
      expect(result, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store1]));

      final store2 = fix.store2.rebuild((s) => s.id = id);

      result = await repository.insert(store2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await repository.insert(store1);
      await repository.insert(store2);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store1, store2]));

      var result = await repository.delete(store1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store2]));
    });

    test('Deletion of an item that does not exist', () async {
      final store1 = fix.store1;
      await repository.insert(store1);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store1]));

      var result = await repository.delete(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([store1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;
      await repository.insert(store1);
      await repository.insert(store2);

      var result = await repository.getById(store1.id);
      expect(result, Right(store1));

      result = await repository.getById(store2.id);
      expect(result, Right(store2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Watch by id', () {
    test('Simple case', () async {
      final store = fix.store1;

      await repository.insert(store);

      final result = await repository.watchById(store.id).first;

      expect(result, Right(store));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.watchById(uid.v4()).first;
      expect(result, Left(NotFoundFailure()));
    });

    test('Updation must emit a new store', () async {
      final store1 = fix.store1;
      final store2 = store1.rebuild((p0) => p0.name = 'New store');

      await repository.insert(store1);

      final expectation = expectLater(
        repository.watchById(store1.id),
        emitsInOrder([
          Right(store1),
          Right(store2),
        ]),
      );

      await repository.update(store2);

      await expectation;
    });

    test('Deletion must emit a new failure', () async {
      final store = fix.store1;

      await repository.insert(store);

      final expectation = expectLater(
        repository.watchById(store.id),
        emitsInOrder([
          Right(store),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(store.id);

      await expectation;
    });
  });

  group('Watch all', () {
    test('Simple case', () async {
      final store = fix.store1;

      await repository.insert(store);

      final result = await repository.watchAll().first;

      expect(result, orderedRightEquals([store]));
    });

    test('Must return $NotFoundFailure when there is no stores', () async {
      final result = await repository.watchAll().first;
      expect(result, Left(NotFoundFailure()));
    });

    test('First insertion must emit a new list', () async {
      final store = fix.store1;

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          Left(NotFoundFailure()),
          orderedRightEquals([store]),
        ]),
      );

      await repository.insert(store);

      await expectation;
    });

    test('Updation must emit a new list', () async {
      final store = fix.store1;
      final newStore = store.rebuild((p0) => p0.name = 'New Store');

      await repository.insert(store);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([store]),
          orderedRightEquals([newStore]),
        ]),
      );

      await repository.update(newStore);

      await expectation;
    });

    test('Insertion must emit a new list', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;

      await repository.insert(store1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([store1]),
          orderedRightEquals([store1, store2]),
        ]),
      );

      await repository.insert(store2);

      await expectation;
    });

    test('Deletion must emit a new list', () async {
      final store1 = fix.store1;
      final store2 = fix.store2;

      await repository.insert(store1);
      await repository.insert(store2);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([store1, store2]),
          orderedRightEquals([store1]),
        ]),
      );

      await repository.delete(store2.id);

      await expectation;
    });

    test('Deletion of the last item must emit $NotFoundFailure', () async {
      final store1 = fix.store1;

      await repository.insert(store1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([store1]),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(store1.id);

      await expectation;
    });
  });

  group('Update', () {
    final store1 = fix.store1;
    final store2 = fix.store2;

    setUp(() async {
      await repository.insert(store1);
      await repository.insert(store2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${store1.name}';
      final newStore = store1.rebuild((s) => s..name = newName);
      final result = await repository.update(newStore);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newStore, store2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final store = fix.store3;
      final result = await repository.update(store);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
      // Database is not affected
      expect(fromDb, orderedRightEquals([store1, store2]));
    });
  });

  test('Count usages', () async {
    final store1 = fix.store1;
    final expense1 = fixExpenses.expense1.rebuild((e) => e.store.id = store1.id);
    final expense2 = fixExpenses.expense2.rebuild((e) => e.store.id = store1.id);

    final store2 = fix.store2;
    final expense3 = fixExpenses.expense3.rebuild((e) => e.store.id = store2.id);

    final store3 = fix.store3;

    await repository.insert(store1);
    await repository.insert(store2);
    await repository.insert(store3);
    await fkUtils.insertExpenseFKDependencies(expense1);
    await fkUtils.insertExpenseFKDependencies(expense2);
    await fkUtils.insertExpenseFKDependencies(expense3);
    await database.into(database.expenses).insert(expense1.toEntity());
    await database.into(database.expenses).insert(expense2.toEntity());
    await database.into(database.expenses).insert(expense3.toEntity());

    var result = await repository.countUsages(store1.id);
    expect(result, Right(2));

    result = await repository.countUsages(store2.id);
    expect(result, Right(1));

    result = await repository.countUsages(store3.id);
    expect(result, Right(0));
  });
}
