import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

import 'fixture_category.dart';
import 'fixture_payment_method.dart';
import 'fixture_store.dart';
import 'fixture_subcategory.dart';
import 'fixture_tag.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.database);

  final AppDatabase database;

  late final FixtureCategory fixCategory = FixtureCategory();
  late final FixtureSubcategory fixSubcategory = FixtureSubcategory();
  late final FixturePaymentMethod fixPaymentMethod = FixturePaymentMethod();
  late final FixtureStore fixStore = FixtureStore();
  late final FixtureTag fixTag = FixtureTag();

  Future<void> insertExpenseFKDependencies(ExpensesCompanion expense) async {
    if (expense.subcategoryId.present) {
      await _insertSubcategoryIfNeeded(expense.subcategoryId.value);
    }
    if (expense.paymentMethodId.present) {
      await _insertPaymentMethodIfNeeded(expense.paymentMethodId.value);
    }
    if (expense.storeId.present && expense.storeId.value != null) {
      await _insertStoreIfNeeded(expense.storeId.value!);
    }
  }

  Future<void> insertSubcategoryFKDependencies(SubcategoriesCompanion subcategory) async {
    if (subcategory.parentId.present) await _insertCategoryIfNeeded(subcategory.parentId.value);
  }

  Future<void> _insertCategoryIfNeeded(String categoryId) async {
    final categoryFromDb = await (database.select(database.categories)
          ..where((tbl) => tbl.id.equals(categoryId)))
        .getSingleOrNull();
    if (categoryFromDb == null) {
      final categoryToInsert = fixCategory.category1.entity.copyWith(id: categoryId);
      await database.into(database.categories).insert(categoryToInsert);
    }
  }

  Future<void> _insertSubcategoryIfNeeded(String subcategoryId) async {
    final subcategoryFromDb = await (database.select(database.subcategories)
          ..where((tbl) => tbl.id.equals(subcategoryId)))
        .getSingleOrNull();
    if (subcategoryFromDb == null) {
      final subcategoryToInsert = fixSubcategory.subcategory1.copyWith(id: Value(subcategoryId));
      await insertSubcategoryFKDependencies(subcategoryToInsert);
      await database.into(database.subcategories).insert(subcategoryToInsert);
    }
  }

  Future<void> _insertStoreIfNeeded(String storeId) async {
    final storeFromDb = await (database.select(database.stores)
          ..where((tbl) => tbl.id.equals(storeId)))
        .getSingleOrNull();
    if (storeFromDb == null) {
      final storeToInsert = fixStore.store1.copyWith(id: Value(storeId));
      await database.into(database.stores).insert(storeToInsert);
    }
  }

  Future<void> _insertPaymentMethodIfNeeded(String paymentMethodId) async {
    final pmFromDb = await (database.select(database.paymentMethods)
          ..where((tbl) => tbl.id.equals(paymentMethodId)))
        .getSingleOrNull();
    if (pmFromDb == null) {
      final pmToInsert = fixPaymentMethod.paymentMethod1.toEntity().copyWith(id: paymentMethodId);
      await database.into(database.paymentMethods).insert(pmToInsert);
    }
  }
}
