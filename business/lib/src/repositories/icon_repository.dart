import 'package:infrastructure/infrastructure.dart';

class IconRepository {
  final AppDatabase database;

  IconRepository(this.database);

  Future<IconEntity> getIconFromDatabase(int iconId) {
    return database.iconDao.getIconById(iconId);
  }

  Future<List<IconEntity>> getAllIconsFromDatabase() {
    return database.iconDao.getAllIcons();
  }
}
