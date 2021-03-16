import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

import 'fixture_icon.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.database);

  AppDatabase database;

  FixtureIcon _fixtureIcon;

  FixtureIcon get fixtureIcon => _fixtureIcon ?? FixtureIcon();

  Future<void> insertCategoryFKDependencies(CategoriesCompanion category) async {
    final iconFromDb = await database.iconDao.getIconById(category.iconId.value);
    if (iconFromDb == null) {
      final iconToInsert = fixtureIcon.icon1.copyWith(id: category.iconId);
      await database.iconDao.insertIcon(iconToInsert);
    }
  }
}
