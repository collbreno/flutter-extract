import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:business/src/domain/_domain.dart';

part 'expense.g.dart';

abstract class Expense implements Built<Expense, ExpenseBuilder> {
  String get id;
  String get description;
  int get value;
  DateTime get date;
  DateTime get createdAt;
  DateTime get updatedAt;
  PaymentMethod get paymentMethod;
  Subcategory get subcategory;
  Store? get store;
  BuiltList<Tag> get tags;

  Expense._();

  factory Expense({
    required String id,
    required String description,
    required int value,
    required DateTime date,
    required DateTime createdAt,
    required DateTime updatedAt,
    required PaymentMethod paymentMethod,
    required Subcategory subcategory,
    required BuiltList<Tag> tags,
    Store? store,
  }) = _$Expense._;
}
