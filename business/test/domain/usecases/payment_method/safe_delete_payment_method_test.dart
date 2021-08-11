import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_payment_method.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixturePaymentMethod();
  late IPaymentMethodRepository repository;
  late SafeDeletePaymentMethodUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = SafeDeletePaymentMethodUseCase(repository);
  });

  test(
      'should delete payment method from repository '
      'when it is not being used', () async {
    final id = fix.paymentMethod1.id;

    when(repository.countExpensesWithPaymentMethodWithId(id)).thenAnswer((_) async => Right(0));
    when(repository.deletePaymentMethodWithId(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countExpensesWithPaymentMethodWithId(id));
    verify(repository.deletePaymentMethodWithId(id));
    verifyNoMoreInteractions(repository);
  });

  group('error cases', () {
    test(
        'should return $EntityBeingUsedFailure '
        'when the payment method is being used', () async {
      final id = fix.paymentMethod1.id;
      final count = 2;

      when(repository.countExpensesWithPaymentMethodWithId(id))
          .thenAnswer((_) async => Right(count));

      final result = await useCase(id);

      expect(result, Left(EntityBeingUsedFailure(count)));

      verify(repository.countExpensesWithPaymentMethodWithId(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while checking payment method usages', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.paymentMethod1.id;

      when(repository.countExpensesWithPaymentMethodWithId(id))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countExpensesWithPaymentMethodWithId(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails'
        'while deleting payment method', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.paymentMethod1.id;

      when(repository.countExpensesWithPaymentMethodWithId(id)).thenAnswer((_) async => Right(0));
      when(repository.deletePaymentMethodWithId(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countExpensesWithPaymentMethodWithId(id));
      verify(repository.deletePaymentMethodWithId(id));
      verifyNoMoreInteractions(repository);
    });
  });
}
