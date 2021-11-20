import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/infrastructure.dart';

class PaymentMethodRepository implements IPaymentMethodRepository {
  final AppDatabase db;

  PaymentMethodRepository(this.db);

  @override
  Future<FailureOr<int>> countUsages(String paymentMethodId) async {
    try {
      final query = db.select(db.expenses)..where((e) => e.paymentMethodId.equals(paymentMethodId));
      final usages = (await query.get()).length;
      return Right(usages);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> delete(String paymentMethodId) async {
    try {
      final query = db.delete(db.paymentMethods)..where((s) => s.id.equals(paymentMethodId));
      final countDeleted = await query.go();

      if (countDeleted != 0) {
        return Right(Null);
      } else {
        return Left(NothingToDeleteFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<List<PaymentMethod>>> getAll() async {
    try {
      final paymentMethods = await db.select(db.paymentMethods).get();
      if (paymentMethods.isNotEmpty) {
        return Right(
          paymentMethods.map((c) => c.toModel()).toList(),
        );
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<PaymentMethod>> getById(String id) async {
    try {
      final query = db.select(db.paymentMethods)..where((s) => s.id.equals(id));
      final paymentMethod = await query.getSingleOrNull();

      if (paymentMethod != null) {
        return Right(paymentMethod.toModel());
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> insert(PaymentMethod paymentMethod) async {
    try {
      await db.into(db.paymentMethods).insert(paymentMethod.toEntity());
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> update(PaymentMethod paymentMethod) async {
    try {
      final result = await db.update(db.paymentMethods).replace(paymentMethod.toEntity());
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }
}
