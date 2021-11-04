import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:business/fixtures.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixturePaymentMethod();
  late IPaymentMethodRepository repository;
  late InsertPaymentMethodUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = InsertPaymentMethodUseCase(repository);
  });

  test('should insert the payment method on repository', () async {
    final paymentMethod = fix.paymentMethod1;

    when(repository.insertPaymentMethod(paymentMethod)).thenAnswer((_) async => Right(Null));

    final result = await useCase(paymentMethod);

    expect(result, Right(Null));

    verify(repository.insertPaymentMethod(paymentMethod));
    verifyNoMoreInteractions(repository);
  });

  test('should return $UnknownDatabaseFailure when repository fails', () async {
    final failure = UnknownDatabaseFailure();
    final paymentMethod = fix.paymentMethod1;

    when(repository.insertPaymentMethod(paymentMethod)).thenAnswer((_) async => Left(failure));

    final result = await useCase(paymentMethod);

    expect(result, Left(failure));

    verify(repository.insertPaymentMethod(paymentMethod));
    verifyNoMoreInteractions(repository);
  });
}
