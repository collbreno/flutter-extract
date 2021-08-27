import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

extension StoreExtension on StoresCompanion {
  StoreEntity convert({
    String? id,
    String? name,
  }) {
    return StoreEntity(
      id: id ?? this.id.value,
      name: name ?? this.name.value,
    );
  }
}

extension ExpenseExtension on ExpensesCompanion {
  ExpenseDraftsCompanion toDraft({
    Value<String?>? description,
    Value<int?>? value,
    Value<DateTime?>? date,
    Value<String?>? paymentMethodId,
    Value<String?>? subcategoryId,
    Value<String?>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExpenseDraftsCompanion(
      id: id,
      description: description ?? this.description,
      value: value ?? this.value,
      date: date ?? this.date,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension ExpenseDraftExtension on ExpenseDraftsCompanion {
  ExpenseDraftEntity convert({
    String? id,
    String? description,
    int? value,
    DateTime? date,
    String? paymentMethodId,
    String? subcategoryId,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseDraftEntity(
      id: id ?? this.id.value,
      description: description ?? this.description.value,
      value: value ?? this.value.value,
      date: date ?? this.date.value,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId.value,
      subcategoryId: subcategoryId ?? this.subcategoryId.value,
      storeId: storeId ?? this.storeId.value,
      createdAt: createdAt ?? this.createdAt.value,
      updatedAt: updatedAt ?? this.updatedAt.value,
    );
  }
}

extension ExpenseDraftTagsCompanionExtension on ExpenseDraftTagsCompanion {
  ExpenseDraftTagEntity convert({
    String? expenseId,
    String? tagId,
    DateTime? createdAt,
  }) {
    return ExpenseDraftTagEntity(
      expenseId: expenseId ?? this.expenseId.value,
      tagId: tagId ?? this.tagId.value,
      createdAt: createdAt ?? this.createdAt.value,
    );
  }
}

extension ExpenseDraftFilesCompanionExtension on ExpenseDraftFilesCompanion {
  ExpenseDraftFileEntity convert({
    String? expenseId,
    String? filePath,
    DateTime? createdAt,
  }) {
    return ExpenseDraftFileEntity(
      expenseId: expenseId ?? this.expenseId.value,
      filePath: filePath ?? this.filePath.value,
      createdAt: createdAt ?? this.createdAt.value,
    );
  }
}
