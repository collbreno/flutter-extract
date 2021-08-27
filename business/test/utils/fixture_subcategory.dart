import 'package:business/src/domain/_domain.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'fixture_category.dart';

class FixtureSubcategory {
  final _uid = Uuid();
  final _fixCategory = FixtureCategory();

  late final subcategory1 = Subcategory(
    id: _uid.v4(),
    icon: Icons.dinner_dining,
    name: 'Lunch',
    parent: _fixCategory.category1,
    color: Colors.orange,
  );

  late final subcategory2 = Subcategory(
    id: _uid.v4(),
    icon: Icons.subway,
    name: 'Subway',
    parent: _fixCategory.category2,
    color: Colors.purple,
  );

  late final subcategory3 = Subcategory(
    id: _uid.v4(),
    icon: Icons.theaters,
    name: 'Movie theater',
    parent: _fixCategory.category1,
    color: Colors.brown,
  );

  late final subcategory4 = Subcategory(
    id: _uid.v4(),
    icon: Icons.videogame_asset_sharp,
    name: 'Games',
    parent: _fixCategory.category3,
    color: Colors.black,
  );

  late final subcategory5 = Subcategory(
    id: _uid.v4(),
    icon: Icons.sports_soccer,
    name: 'Soccer',
    parent: _fixCategory.category4,
    color: Colors.green,
  );
}
