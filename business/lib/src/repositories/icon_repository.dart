import 'package:business/business.dart';
import 'package:business/src/actions/icon_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:redux/redux.dart';

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
