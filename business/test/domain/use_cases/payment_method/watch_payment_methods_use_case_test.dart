import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixturePaymentMethod();
  late IPaymentMethodRepository repository;
  late WatchPaymentMethodsUseCase useCase;

  setUp(() {
    repository = MockIPaymentMethodRepository();
    useCase = WatchPaymentMethodsUseCase(repository);
  });

  test('should return the stream from repository', () async {
    final paymentMethod1 = fix.paymentMethod1;
    final paymentMethod2 = fix.paymentMethod2;

    when(repository.watchAll()).thenAnswer((_) {
      return Stream.fromIterable([
        Left(NotFoundFailure()),
        Right([paymentMethod1]),
        Right([paymentMethod1, paymentMethod2]),
      ]);
    });

    await expectLater(
      useCase(),
      emitsInOrder([
        Left(NotFoundFailure()),
        orderedRightEquals([paymentMethod1]),
        orderedRightEquals([paymentMethod1, paymentMethod2]),
      ]),
    );

    verify(repository.watchAll());
    verifyNoMoreInteractions(repository);
  });
}
