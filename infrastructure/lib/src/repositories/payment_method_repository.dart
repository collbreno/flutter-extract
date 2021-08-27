import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
  Future<FailureOr<void>> deletePaymentMethodWithId(String paymentMethodId) async {
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
  Future<FailureOr<List<PaymentMethod>>> getAllPaymentMethods() async {
    try {
      final paymentMethods = await db.select(db.paymentMethods).get();
      if (paymentMethods.isNotEmpty) {
        return Right(
          paymentMethods.map(_mapToModel).toList(),
        );
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<PaymentMethod>> getPaymentMethodById(String id) async {
    try {
      final query = db.select(db.paymentMethods)..where((s) => s.id.equals(id));
      final paymentMethod = await query.getSingleOrNull();

      if (paymentMethod != null) {
        return Right(_mapToModel(paymentMethod));
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> insertPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      await db.into(db.paymentMethods).insert(_mapToEntity(paymentMethod));
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<void>> updatePaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final result = await db.update(db.paymentMethods).replace(_mapToEntity(paymentMethod));
      if (result) {
        return Right(Null);
      } else {
        return Left(NotFoundFailure());
      }
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  PaymentMethod _mapToModel(PaymentMethodEntity entity) {
    return PaymentMethod(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      icon: IconMapper.getIcon(name: entity.iconName, family: entity.iconFamily),
    );
  }

  PaymentMethodEntity _mapToEntity(PaymentMethod model) {
    return PaymentMethodEntity(
      id: model.id,
      name: model.name,
      color: model.color.value,
      iconName: IconMapper.getIconName(model.icon),
      iconFamily: IconMapper.getIconFamily(model.icon),
    );
  }
}
