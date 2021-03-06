import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

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

    when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
    when(repository.delete(id)).thenAnswer((_) async => Right(Null));

    final result = await useCase(id);

    expect(result, Right(Null));

    verify(repository.countUsages(id));
    verify(repository.delete(id));
    verifyNoMoreInteractions(repository);
  });

  group('error cases', () {
    test(
        'should return $EntityBeingUsedFailure '
        'when the payment method is being used', () async {
      final id = fix.paymentMethod1.id;
      final count = 2;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(count));

      final result = await useCase(id);

      expect(result, Left(EntityBeingUsedFailure(count)));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails '
        'while checking payment method usages', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.paymentMethod1.id;

      when(repository.countUsages(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verifyNoMoreInteractions(repository);
    });

    test(
        'should return database failure when repository fails'
        'while deleting payment method', () async {
      final failure = UnknownDatabaseFailure();
      final id = fix.paymentMethod1.id;

      when(repository.countUsages(id)).thenAnswer((_) async => Right(0));
      when(repository.delete(id)).thenAnswer((_) async => Left(failure));

      final result = await useCase(id);

      expect(result, Left(failure));

      verify(repository.countUsages(id));
      verify(repository.delete(id));
      verifyNoMoreInteractions(repository);
    });
  });
}
