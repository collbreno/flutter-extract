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
  late PaymentMethodRepository repository;
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixturePaymentMethod();
  final fixExpenses = FixtureExpense();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = PaymentMethodRepository(database);
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
      final paymentMethod = fix.paymentMethod1;

      await repository.insert(paymentMethod);

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod]));
    });

    test('Insertion with duplicated id must fail', () async {
      final id = uid.v4();
      final paymentMethod1 = fix.paymentMethod1.rebuild((t) => t.id = id);

      var result = await repository.insert(paymentMethod1);
      expect(result, Right(Null));

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod1]));

      final paymentMethod2 = fix.paymentMethod2.rebuild((t) => t.id = id);

      result = await repository.insert(paymentMethod2);
      expect(result, Left(UnknownDatabaseFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod1]));
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;
      await repository.insert(paymentMethod1);
      await repository.insert(paymentMethod2);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod1, paymentMethod2]));

      var result = await repository.delete(paymentMethod1.id);
      expect(result, Right(Null));

      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod2]));
    });

    test('Deletion of an item that does not exist', () async {
      final paymentMethod1 = fix.paymentMethod1;
      await repository.insert(paymentMethod1);

      var fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod1]));

      var result = await repository.delete(uid.v4());
      expect(result, Left(NothingToDeleteFailure()));

      // Database is not affected
      fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([paymentMethod1]));
    });
  });

  group('Query by id', () {
    test('Success case', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;
      await repository.insert(paymentMethod1);
      await repository.insert(paymentMethod2);

      var result = await repository.getById(paymentMethod1.id);
      expect(result, Right(paymentMethod1));

      result = await repository.getById(paymentMethod2.id);
      expect(result, Right(paymentMethod2));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.getById(uid.v4());
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('Watch by id', () {
    test('Simple case', () async {
      final paymentMethod = fix.paymentMethod1;

      await repository.insert(paymentMethod);

      final result = await repository.watchById(paymentMethod.id).first;

      expect(result, Right(paymentMethod));
    });

    test('Query by id of an item that does not exist must return $NotFoundFailure', () async {
      final result = await repository.watchById(uid.v4()).first;
      expect(result, Left(NotFoundFailure()));
    });

    test('Updation must emit a new paymentMethod', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = paymentMethod1.rebuild((p0) => p0.name = 'New paymentMethod');

      await repository.insert(paymentMethod1);

      final expectation = expectLater(
        repository.watchById(paymentMethod1.id),
        emitsInOrder([
          Right(paymentMethod1),
          Right(paymentMethod2),
        ]),
      );

      await repository.update(paymentMethod2);

      await expectation;
    });

    test('Deletion must emit a new failure', () async {
      final paymentMethod = fix.paymentMethod1;

      await repository.insert(paymentMethod);

      final expectation = expectLater(
        repository.watchById(paymentMethod.id),
        emitsInOrder([
          Right(paymentMethod),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(paymentMethod.id);

      await expectation;
    });
  });

  group('Watch all', () {
    test('Simple case', () async {
      final paymentMethod = fix.paymentMethod1;

      await repository.insert(paymentMethod);

      final result = await repository.watchAll().first;

      expect(result, orderedRightEquals([paymentMethod]));
    });

    test('Must return $NotFoundFailure when there is no paymentMethods', () async {
      final result = await repository.watchAll().first;
      expect(result, Left(NotFoundFailure()));
    });

    test('First insertion must emit a new list', () async {
      final paymentMethod = fix.paymentMethod1;

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          Left(NotFoundFailure()),
          orderedRightEquals([paymentMethod]),
        ]),
      );

      await repository.insert(paymentMethod);

      await expectation;
    });

    test('Updation must emit a new list', () async {
      final paymentMethod = fix.paymentMethod1;
      final newPaymentMethod = paymentMethod.rebuild((p0) => p0.name = 'New Payment Method');

      await repository.insert(paymentMethod);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([paymentMethod]),
          orderedRightEquals([newPaymentMethod]),
        ]),
      );

      await repository.update(newPaymentMethod);

      await expectation;
    });

    test('Insertion must emit a new list', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;

      await repository.insert(paymentMethod1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([paymentMethod1]),
          orderedRightEquals([paymentMethod1, paymentMethod2]),
        ]),
      );

      await repository.insert(paymentMethod2);

      await expectation;
    });

    test('Deletion must emit a new list', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;

      await repository.insert(paymentMethod1);
      await repository.insert(paymentMethod2);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([paymentMethod1, paymentMethod2]),
          orderedRightEquals([paymentMethod1]),
        ]),
      );

      await repository.delete(paymentMethod2.id);

      await expectation;
    });

    test('Deletion of the last item must emit $NotFoundFailure', () async {
      final paymentMethod1 = fix.paymentMethod1;

      await repository.insert(paymentMethod1);

      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          orderedRightEquals([paymentMethod1]),
          Left(NotFoundFailure()),
        ]),
      );

      await repository.delete(paymentMethod1.id);

      await expectation;
    });
  });

  group('Update', () {
    final paymentMethod1 = fix.paymentMethod1;
    final paymentMethod2 = fix.paymentMethod2;

    setUp(() async {
      await repository.insert(paymentMethod1);
      await repository.insert(paymentMethod2);
    });

    test('Should return normally when entity has changed', () async {
      final newName = 'New ${paymentMethod1.name}';
      final newPaymentMethod = paymentMethod1.rebuild((t) => t..name = newName);
      final result = await repository.update(newPaymentMethod);
      expect(result, Right(Null));

      final fromDb = await repository.getAll();
      expect(fromDb, orderedRightEquals([newPaymentMethod, paymentMethod2]));
    });

    test('Should return $NotFoundFailure when entity does not exist', () async {
      final paymentMethod = fix.paymentMethod3;
      final result = await repository.update(paymentMethod);
      expect(result, Left(NotFoundFailure()));

      final fromDb = await repository.getAll();
      // Database is not affected
      expect(fromDb, orderedRightEquals([paymentMethod1, paymentMethod2]));
    });
  });

  test('Count usages', () async {
    final paymentMethod1 = fix.paymentMethod1;
    final expense1 = fixExpenses.expense1.rebuild((e) => e.paymentMethod.id = paymentMethod1.id);
    final expense2 = fixExpenses.expense2.rebuild((e) => e.paymentMethod.id = paymentMethod1.id);

    final paymentMethod2 = fix.paymentMethod2;
    final expense3 = fixExpenses.expense3.rebuild((e) => e.paymentMethod.id = paymentMethod2.id);

    final paymentMethod3 = fix.paymentMethod3;

    await repository.insert(paymentMethod1);
    await repository.insert(paymentMethod2);
    await repository.insert(paymentMethod3);
    await fkUtils.insertExpenseFKDependencies(expense1);
    await fkUtils.insertExpenseFKDependencies(expense2);
    await fkUtils.insertExpenseFKDependencies(expense3);
    await database.into(database.expenses).insert(expense1.toEntity());
    await database.into(database.expenses).insert(expense2.toEntity());
    await database.into(database.expenses).insert(expense3.toEntity());
    var result = await repository.countUsages(paymentMethod1.id);
    expect(result, Right(2));

    result = await repository.countUsages(paymentMethod2.id);
    expect(result, Right(1));

    result = await repository.countUsages(paymentMethod3.id);
    expect(result, Right(0));
  });
}
