import 'package:built_value/built_value.dart';
import 'package:business/src/models/payment_method_model.dart';
import 'package:business/src/models/store_model.dart';
import 'package:business/src/models/subcategory_model.dart';
import 'package:flutter/material.dart' hide Builder;

part 'expense_model.g.dart';

abstract class ExpenseModel implements Built<ExpenseModel, ExpenseModelBuilder> {
  int get id;
  String get name;
  int get value;
  DateTime get date;
  AsyncSnapshot<PaymentMethodModel> get paymentMethod;
  AsyncSnapshot<SubcategoryModel> get subcategory;
  AsyncSnapshot<StoreModel> get store;

  ExpenseModel._();

  factory ExpenseModel({
    int id,
    String name,
    int value,
    DateTime date,
    AsyncSnapshot<PaymentMethodModel> paymentMethod,
    AsyncSnapshot<SubcategoryModel> subcategory,
    AsyncSnapshot<StoreModel> store,
  }) = _$ExpenseModel._;
}
