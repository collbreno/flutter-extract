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
  late UpdatePaymentMethodUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = UpdatePaymentMethodUseCase(repository);
  });

  test('should get the payment method from repository', () async {
    final expected = fix.paymentMethod1;

    when(repository.updatePaymentMethod(expected)).thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.updatePaymentMethod(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.updatePaymentMethod(fix.paymentMethod1)).thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.paymentMethod1);

    expect(result, Left(failure));

    verify(repository.updatePaymentMethod(fix.paymentMethod1));
    verifyNoMoreInteractions(repository);
  });
}
