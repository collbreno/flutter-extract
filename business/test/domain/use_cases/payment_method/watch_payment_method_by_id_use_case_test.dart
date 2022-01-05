import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixturePaymentMethod();
  late IPaymentMethodRepository repository;
  late WatchPaymentMethodByIdUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = WatchPaymentMethodByIdUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final paymentMethod = fix.paymentMethod1;

    when(repository.watchById(paymentMethod.id)).thenAnswer((_) {
      return Stream.fromIterable([
        Right(paymentMethod),
        Left(NotFoundFailure()),
      ]);
    });

    final expectation = expectLater(
      useCase(paymentMethod.id),
      emitsInOrder([
        Right(paymentMethod),
        Left(NotFoundFailure()),
      ]),
    );

    await expectation;

    verify(repository.watchById(paymentMethod.id));
    verifyNoMoreInteractions(repository);
  });
}
