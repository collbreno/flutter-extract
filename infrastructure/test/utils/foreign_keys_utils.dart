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

  FixtureIcon _fixIcon;
  FixtureCategory _fixCategory;
  FixtureSubcategory _fixSubcategory;
  FixturePaymentMethod _fixPaymentMethod;
  FixtureTag _fixTag;
  FixtureStore _fixStore;

  FixtureIcon get fixIcon => _fixIcon ?? FixtureIcon();

  FixtureCategory get fixCategory => _fixCategory ?? FixtureCategory();

  FixtureSubcategory get fixSubcategory => _fixSubcategory ?? FixtureSubcategory();

  FixturePaymentMethod get fixPaymentMethod => _fixPaymentMethod ?? FixturePaymentMethod();

  FixtureStore get fixStore => _fixStore ?? FixtureStore();

  FixtureTag get fixTag => _fixTag ?? FixtureTag();

  Future<void> insertExpenseFKDependencies(ExpensesCompanion expense) async {
    await _insertSubcategoryIfNeeded(expense.subcategoryId.value);
    await _insertPaymentMethodIfNeeded(expense.paymentMethodId.value);
    await _insertStoreIfNeeded(expense.storeId.value);
  }

  Future<void> insertCategoryFKDependencies(CategoriesCompanion category) async {
    await _insertIconIfNeeded(category.iconId.value);
  }

  Future<void> insertSubcategoryFKDependencies(SubcategoriesCompanion subcategory) async {
    await _insertCategoryIfNeeded(subcategory.parentId.value);
    await _insertIconIfNeeded(subcategory.iconId.value);
  }

  Future<void> insertTagFKDependencies(TagsCompanion tag) async {
    await _insertIconIfNeeded(tag.iconId.value);
  }

  Future<void> insertPaymentMethodFKDependencies(PaymentMethodsCompanion paymentMethods) async {
    await _insertIconIfNeeded(paymentMethods.iconId.value);
  }

  Future<void> _insertIconIfNeeded(int iconId) async {
    if (iconId != null) {
      final iconFromDb = await database.iconDao.getIconById(iconId);
      if (iconFromDb == null) {
        final iconToInsert = fixIcon.icon1.copyWith(id: Value(iconId));
        await database.iconDao.insertIcon(iconToInsert);
      }
    }
  }

  Future<void> _insertCategoryIfNeeded(int categoryId) async {
    if (categoryId != null) {
      final categoryFromDb = await database.categoryDao.getCategoryById(categoryId);
      if (categoryFromDb == null) {
        final categoryToInsert = fixCategory.category1.copyWith(id: Value(categoryId));
        await insertCategoryFKDependencies(categoryToInsert);
        await database.categoryDao.insertCategory(categoryToInsert);
      }
    }
  }

  Future<void> _insertSubcategoryIfNeeded(int subcategoryId) async {
    if (subcategoryId != null) {
      final subcategoryFromDb = await database.subcategoryDao.getSubcategoryById(subcategoryId);
      if (subcategoryFromDb == null) {
        final subcategoryToInsert = fixSubcategory.subcategory1.copyWith(id: Value(subcategoryId));
        await insertSubcategoryFKDependencies(subcategoryToInsert);
        await database.subcategoryDao.insertSubcategory(subcategoryToInsert);
      }
    }
  }

  Future<void> _insertStoreIfNeeded(int storeId) async {
    if (storeId != null) {
      final storeFromDb = await database.storeDao.getStoreById(storeId);
      if (storeFromDb == null) {
        final storeToInsert = fixStore.store1.copyWith(id: Value(storeId));
        await database.storeDao.insertStore(storeToInsert);
      }
    }
  }

  Future<void> _insertPaymentMethodIfNeeded(int paymentMethodId) async {
    if (paymentMethodId != null) {
      final paymentMethodFromDb =
          await database.paymentMethodDao.getPaymentMethodById(paymentMethodId);
      if (paymentMethodFromDb == null) {
        final pmToInsert = fixPaymentMethod.paymentMethod1.copyWith(id: Value(paymentMethodId));
        await insertPaymentMethodFKDependencies(pmToInsert);
        await database.paymentMethodDao.insertPaymentMethod(pmToInsert);
      }
    }
  }
}
