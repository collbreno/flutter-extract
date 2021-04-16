import 'package:built_value/built_value.dart';
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
  int? get storeId;

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
    required int id,
    required String description,
    required int value,
    required DateTime date,
    required int paymentMethodId,
    required int subcategoryId,
    int? storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _$ExpenseModel._;
}
