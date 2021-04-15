import 'package:built_value/built_value.dart';
import 'package:business/src/models/payment_method_model.dart';
import 'package:business/src/models/store_model.dart';
import 'package:business/src/models/subcategory_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:infrastructure/infrastructure.dart';

part 'expense_model.g.dart';

abstract class ExpenseModel implements Built<ExpenseModel, ExpenseModelBuilder> {
  int get id;
  String get description;
  int get value;
  DateTime get date;
  DateTime get createdAt;
  DateTime get updatedAt;
  int get paymentMethodId;
  int get subcategoryId;
  int get storeId;

  ExpenseModel._();

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      description: description,
      value: value,
      date: date,
      paymentMethodId: paymentMethodId,
      subcategoryId: subcategoryId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      description: entity.description,
      value: entity.value,
      date: entity.date,
      paymentMethodId: entity.paymentMethodId,
      subcategoryId: entity.subcategoryId,
      storeId: entity.storeId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ExpenseModel({
    int id,
    String description,
    int value,
    DateTime date,
    int paymentMethodId,
    int subcategoryId,
    int storeId,
    DateTime createdAt,
    DateTime updatedAt,
  }) = _$ExpenseModel._;
}
