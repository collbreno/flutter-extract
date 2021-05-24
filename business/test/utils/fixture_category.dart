import 'package:business/src/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FixtureCategory {
  final _uid = Uuid();

  late final category1 = Category(
    id: _uid.v4(),
    name: 'Market',
    icon: Icons.shopping_cart,
  );

  late final category2 = Category(
    id: _uid.v4(),
    name: 'Shop',
    icon: Icons.shopping_basket,
  );

  late final category3 = Category(
    id: _uid.v4(),
    name: 'Health',
    icon: Icons.healing,
  );

  late final category4 = Category(
    id: _uid.v4(),
    name: 'Fun',
    icon: Icons.sports_football,
  );
}
