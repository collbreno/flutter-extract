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
  late GetPaymentMethodByIdUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = GetPaymentMethodByIdUseCase(repository);
  });

  test('should get the payment method from repository', () async {
    final expected = fix.paymentMethod1;

    when(repository.getPaymentMethodById(expected.id)).thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getPaymentMethodById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getPaymentMethodById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getPaymentMethodById(id));
    verifyNoMoreInteractions(repository);
  });
}
