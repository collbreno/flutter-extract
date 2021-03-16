import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

import 'fixture_category.dart';
import 'fixture_icon.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.database);

  final AppDatabase database;

  FixtureIcon _fixtureIcon;
  FixtureCategory _fixtureCategory;

  FixtureIcon get fixtureIcon => _fixtureIcon ?? FixtureIcon();

  FixtureCategory get fixtureCategory => _fixtureCategory ?? FixtureCategory();

  Future<void> insertCategoryFKDependencies(CategoriesCompanion category) async {
    await _insertIconIfNeeded(category.iconId.value);
  }

  Future<void> insertSubcategoryFKDependencies(SubcategoriesCompanion subcategory) async {
    await _insertCategoryIfNeeded(subcategory.parentId.value);
    await _insertIconIfNeeded(subcategory.iconId.value);
  }

  Future<void> _insertIconIfNeeded(int iconId) async {
    if (iconId != null) {
      final iconFromDb = await database.iconDao.getIconById(iconId);
      if (iconFromDb == null) {
        final iconToInsert = fixtureIcon.icon1.copyWith(id: Value(iconId));
        await database.iconDao.insertIcon(iconToInsert);
      }
    }
  }

  Future<void> _insertCategoryIfNeeded(int categoryId) async {
    if (categoryId != null) {
      final categoryFromDb = await database.categoryDao.getCategoryById(categoryId);
      if (categoryFromDb == null) {
        final categoryToInsert = fixtureCategory.category1.copyWith(id: Value(categoryId));
        await insertCategoryFKDependencies(categoryToInsert);
        await database.categoryDao.insertCategory(categoryToInsert);
      }
    }
  }
}
