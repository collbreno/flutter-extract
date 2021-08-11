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
  late GetAllPaymentMethodsUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = GetAllPaymentMethodsUseCase(repository);
  });

  test('should get all payment methods from repository', () async {
    final expected = [fix.paymentMethod1, fix.paymentMethod2];

    when(repository.getAllPaymentMethods()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAllPaymentMethods());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAllPaymentMethods()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAllPaymentMethods());
    verifyNoMoreInteractions(repository);
  });
}
