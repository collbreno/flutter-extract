import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import '../matchers/either_matcher.dart';
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
