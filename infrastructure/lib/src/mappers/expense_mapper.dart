import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:infrastructure/infrastructure.dart';

extension ExpenseModelToEntity on Expense {
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
      date: date,
      value: value,
      paymentMethodId: paymentMethod.id,
      subcategoryId: subcategory.id,
      storeId: store?.id,
    );
  }
}

extension ExpenseEntityToModel on ExpenseEntity {
  Expense toModel({
    required Subcategory subcategory,
    required PaymentMethod paymentMethod,
    required Store? store,
    required Iterable<Tag> tags,
    required Iterable<String> files,
  }) {
    return Expense(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
      date: date,
      value: value,
      tags: BuiltList.from(tags),
      paymentMethod: paymentMethod,
      subcategory: subcategory,
      store: store,
      files: BuiltList.from(files),
    );
  }
}
