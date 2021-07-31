import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

import 'fixture_category.dart';
import 'fixture_icon.dart';
import 'fixture_payment_method.dart';
import 'fixture_store.dart';
import 'fixture_subcategory.dart';
import 'fixture_tag.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.database);

  final AppDatabase database;

  late final FixtureIcon fixIcon = FixtureIcon();
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

  Future<void> insertCategoryFKDependencies(CategoriesCompanion category) async {
    if (category.iconId.present) await _insertIconIfNeeded(category.iconId.value);
  }

  Future<void> insertSubcategoryFKDependencies(SubcategoriesCompanion subcategory) async {
    if (subcategory.parentId.present) await _insertCategoryIfNeeded(subcategory.parentId.value);
    if (subcategory.iconId.present) await _insertIconIfNeeded(subcategory.iconId.value);
  }

  Future<void> insertTagFKDependencies(TagsCompanion tag) async {
    if (tag.iconId.present && tag.iconId.value != null) {
      await _insertIconIfNeeded(tag.iconId.value!);
    }
  }

  Future<void> insertPaymentMethodFKDependencies(PaymentMethodsCompanion paymentMethods) async {
    if (paymentMethods.iconId.present && paymentMethods.iconId.value != null) {
      await _insertIconIfNeeded(paymentMethods.iconId.value!);
    }
  }

  Future<void> _insertIconIfNeeded(String iconId) async {
    final iconFromDb = await database.iconDao.getIconById(iconId);
    if (iconFromDb == null) {
      final iconToInsert = fixIcon.icon1.copyWith(id: Value(iconId));
      await database.iconDao.insertIcon(iconToInsert);
    }
  }

  Future<void> _insertCategoryIfNeeded(String categoryId) async {
    final categoryFromDb = await database.categoryDao.getCategoryById(categoryId);
    if (categoryFromDb == null) {
      final categoryToInsert = fixCategory.category1.copyWith(id: Value(categoryId));
      await insertCategoryFKDependencies(categoryToInsert);
      await database.categoryDao.insertCategory(categoryToInsert);
    }
  }

  Future<void> _insertSubcategoryIfNeeded(String subcategoryId) async {
    final subcategoryFromDb = await database.subcategoryDao.getSubcategoryById(subcategoryId);
    if (subcategoryFromDb == null) {
      final subcategoryToInsert = fixSubcategory.subcategory1.copyWith(id: Value(subcategoryId));
      await insertSubcategoryFKDependencies(subcategoryToInsert);
      await database.subcategoryDao.insertSubcategory(subcategoryToInsert);
    }
  }

  Future<void> _insertStoreIfNeeded(String storeId) async {
    final storeFromDb = await database.storeDao.getById(storeId);
    if (storeFromDb == null) {
      final storeToInsert = fixStore.store1.copyWith(id: Value(storeId));
      await database.storeDao.insert(storeToInsert);
    }
  }

  Future<void> _insertPaymentMethodIfNeeded(String paymentMethodId) async {
    final paymentMethodFromDb =
        await database.paymentMethodDao.getPaymentMethodById(paymentMethodId);
    if (paymentMethodFromDb == null) {
      final pmToInsert = fixPaymentMethod.paymentMethod1.copyWith(id: Value(paymentMethodId));
      await insertPaymentMethodFKDependencies(pmToInsert);
      await database.paymentMethodDao.insertPaymentMethod(pmToInsert);
    }
  }
}
