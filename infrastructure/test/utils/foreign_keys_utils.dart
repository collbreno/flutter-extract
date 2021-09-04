import 'package:business/fixtures.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/mappers/_mappers.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.database);

  final AppDatabase database;

  late final FixtureCategory fixCategory = FixtureCategory();
  late final FixtureSubcategory fixSubcategory = FixtureSubcategory();
  late final FixturePaymentMethod fixPaymentMethod = FixturePaymentMethod();
  late final FixtureStore fixStore = FixtureStore();
  late final FixtureTag fixTag = FixtureTag();

  Future<void> insertExpenseFKDependencies(ExpenseEntity expense) async {
    await _insertSubcategoryIfNeeded(expense.subcategoryId);
    await _insertPaymentMethodIfNeeded(expense.paymentMethodId);
    if (expense.storeId != null) {
      await _insertStoreIfNeeded(expense.storeId!);
    }
  }

  Future<void> insertSubcategoryFKDependencies(SubcategoryEntity subcategory) async {
    await _insertCategoryIfNeeded(subcategory.parentId);
  }

  Future<void> _insertCategoryIfNeeded(String categoryId) async {
    final categoryFromDb = await (database.select(database.categories)
          ..where((tbl) => tbl.id.equals(categoryId)))
        .getSingleOrNull();
    if (categoryFromDb == null) {
      final categoryToInsert = fixCategory.category1.toEntity().copyWith(id: categoryId);
      await database.into(database.categories).insert(categoryToInsert);
    }
  }

  Future<void> _insertSubcategoryIfNeeded(String subcategoryId) async {
    final subcategoryFromDb = await (database.select(database.subcategories)
          ..where((tbl) => tbl.id.equals(subcategoryId)))
        .getSingleOrNull();
    if (subcategoryFromDb == null) {
      final subcategoryToInsert =
          fixSubcategory.subcategory1.toEntity().copyWith(id: subcategoryId);
      await insertSubcategoryFKDependencies(subcategoryToInsert);
      await database.into(database.subcategories).insert(subcategoryToInsert);
    }
  }

  Future<void> _insertStoreIfNeeded(String storeId) async {
    final storeFromDb = await (database.select(database.stores)
          ..where((tbl) => tbl.id.equals(storeId)))
        .getSingleOrNull();
    if (storeFromDb == null) {
      final storeToInsert = fixStore.store1.toEntity().copyWith(id: storeId);
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
