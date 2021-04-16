import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart' hide isNull;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/fixture_payment_method.dart';
import '../utils/foreign_keys_utils.dart';

void main() {
  late AppDatabase database;
  late ForeignKeyUtils fkUtils;
  final fix = FixturePaymentMethod();

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
    test('Insertion without id must have an auto incremented id', () async {
      final paymentMethod1 = fix.paymentMethod1.copyWith(id: Value.absent());
      final paymentMethod2 = fix.paymentMethod2.copyWith(id: Value.absent());

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      var result = await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);
      expect(result, 1);

      var fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final expected1 = paymentMethod1.convert(id: 1);
      expect(fromDb, orderedEquals([expected1]));

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod2);
      result = await database.paymentMethodDao.insertPaymentMethod(paymentMethod2);
      expect(result, 2);

      fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final expected2 = paymentMethod2.convert(id: 2);
      expect(fromDb, orderedEquals([expected1, expected2]));
    });

    test('Insertion without name must fail', () async {
      final paymentMethod = fix.paymentMethod1.copyWith(name: Value.absent());

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod);
      expect(
        () => database.paymentMethodDao.insertPaymentMethod(paymentMethod),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, isEmpty);
    });

    test('Insertion without color must fail', () async {
      final paymentMethod = fix.paymentMethod1.copyWith(color: Value.absent());

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod);
      expect(
        () => database.paymentMethodDao.insertPaymentMethod(paymentMethod),
        throwsA(isA<InvalidDataException>()),
      );

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, isEmpty);
    });

    test('Insertion without iconId must define iconId as null', () async {
      final paymentMethod = fix.paymentMethod1.copyWith(iconId: Value.absent());

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final expected = paymentMethod.convert();

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with defined id must use the given id', () async {
      final paymentMethod = fix.paymentMethod1.copyWith(id: Value(42));

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod);
      final result = await database.paymentMethodDao.insertPaymentMethod(paymentMethod);
      expect(result, 42);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final expected = paymentMethod.convert();

      expect(fromDb, orderedEquals([expected]));
    });

    test('Insertion with duplicated id must fail', () async {
      final paymentMethod1 = fix.paymentMethod1.copyWith(id: Value(42));

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      final result = await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);
      expect(result, 42);

      final expected1 = paymentMethod1.convert();
      var fromDB = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDB, orderedEquals([expected1]));

      final paymentMethod2 = fix.paymentMethod2.copyWith(id: Value(42));

      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod2);
      expect(
        () => database.paymentMethodDao.insertPaymentMethod(paymentMethod2),
        throwsA(isA<SqliteException>()),
      );

      // Database is not affected
      fromDB = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDB, orderedEquals([expected1]));
    });
  });

  group('Foreign keys', () {
    test(
        'Insertion with iconId that does not have any reference '
        'to the icon table must fail.', () async {
      final paymentMethod = fix.paymentMethod1;

      final parentFromDb = await database.iconDao.getIconById(paymentMethod.iconId.value!);
      expect(parentFromDb, isNull);

      expect(
        () => database.paymentMethodDao.insertPaymentMethod(paymentMethod),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Deletion', () {
    test('Simple deletion', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod2);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod2);

      var fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, orderedEquals([paymentMethod1.convert(), paymentMethod2.convert()]));

      var result =
          await database.paymentMethodDao.deletePaymentMethodWithId(paymentMethod1.id.value);
      expect(result, 1);

      fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, [paymentMethod2.convert()]);
    });

    test('Deletion of an item that does not exist', () async {
      final paymentMethod1 = fix.paymentMethod1;
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);

      var fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, hasLength(1));

      var result =
          await database.paymentMethodDao.deletePaymentMethodWithId(paymentMethod1.id.value + 1);
      expect(result, 0);

      // Database is not affected
      fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      expect(fromDb, hasLength(1));
    });
  });

  group('Query by id', () {
    test('Success cases', () async {
      final paymentMethod1 = fix.paymentMethod1;
      final paymentMethod2 = fix.paymentMethod2;
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod2);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod2);

      var result = await database.paymentMethodDao.getPaymentMethodById(paymentMethod1.id.value);
      var expected = paymentMethod1.convert();
      expect(result, expected);

      result = await database.paymentMethodDao.getPaymentMethodById(paymentMethod2.id.value);
      expected = paymentMethod2.convert();
      expect(result, expected);
    });

    test('Error cases', () async {
      final result = await database.paymentMethodDao.getPaymentMethodById(1);
      expect(result, isNull);
    });
  });

  group('Update', () {
    final paymentMethod1 = fix.paymentMethod1;
    final paymentMethod2 = fix.paymentMethod2;
    final expected1 = paymentMethod1.convert();
    final expected2 = paymentMethod2.convert();

    setUp(() async {
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod1);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod1);
      await fkUtils.insertPaymentMethodFKDependencies(paymentMethod2);
      await database.paymentMethodDao.insertPaymentMethod(paymentMethod2);
    });

    test('Updating name', () async {
      final newName = 'New ${paymentMethod1.name.value}';
      final newPaymentMethod = paymentMethod1.copyWith(name: Value(newName));
      final result = await database.paymentMethodDao.updatePaymentMethod(newPaymentMethod);
      expect(result, isTrue);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final newExpected1 = expected1.copyWith(name: newName);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating iconId', () async {
      final newIconId = paymentMethod1.iconId.value! + 1;
      final newPaymentMethod = paymentMethod1.copyWith(iconId: Value(newIconId));
      await fkUtils.insertPaymentMethodFKDependencies(newPaymentMethod);
      final result = await database.paymentMethodDao.updatePaymentMethod(newPaymentMethod);
      expect(result, isTrue);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final newExpected1 = expected1.copyWith(iconId: newIconId);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating color', () async {
      final newColor = paymentMethod1.color.value + 1;
      final newPaymentMethod = paymentMethod1.copyWith(color: Value(newColor));
      await fkUtils.insertPaymentMethodFKDependencies(newPaymentMethod);
      final result = await database.paymentMethodDao.updatePaymentMethod(newPaymentMethod);
      expect(result, isTrue);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      final newExpected1 = expected1.copyWith(color: newColor);
      expect(fromDb, orderedEquals([newExpected1, expected2]));
    });

    test('Updating an item that does not exist', () async {
      final paymentMethod = fix.paymentMethod3;
      final result = await database.paymentMethodDao.updatePaymentMethod(paymentMethod);
      expect(result, isFalse);

      final fromDb = await database.paymentMethodDao.getAllPaymentMethods();
      // Database is not affected
      expect(fromDb, orderedEquals([expected1, expected2]));
    });
  });
}

extension on PaymentMethodsCompanion {
  PaymentMethodEntity convert({
    int? id,
    int? iconId,
    int? color,
    String? name,
  }) {
    return PaymentMethodEntity(
      id: id ?? this.id.value,
      iconId: iconId ?? this.iconId.value,
      color: color ?? this.color.value,
      name: name ?? this.name.value,
    );
  }
}
