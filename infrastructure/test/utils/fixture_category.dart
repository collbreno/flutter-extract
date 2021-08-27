import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

class _FixtureObject {
  final CategoryEntity entity;
  final Category model;

  _FixtureObject({required this.entity, required this.model});
}

class FixtureCategory {
  final _uid = Uuid();

  late final String _id1 = _uid.v4();
  final _name1 = 'Market';
  final _color1 = Color(Colors.orange.value);
  late final category1 = _FixtureObject(
    entity: CategoryEntity(
      id: _id1,
      name: _name1,
      iconFamily: 'MaterialIcons',
      iconName: 'shopping_cart',
      color: _color1.value,
    ),
    model: Category(
      id: _id1,
      name: _name1,
      color: _color1,
      icon: Icons.shopping_cart,
    ),
  );

  late final String _id2 = _uid.v4();
  final _name2 = 'Shop';
  final _color2 = Color(Colors.deepOrange.value);
  late final category2 = _FixtureObject(
    entity: CategoryEntity(
      id: _id2,
      name: _name2,
      iconFamily: 'MaterialIcons',
      iconName: 'shopping_basket',
      color: _color2.value,
    ),
    model: Category(
      id: _id2,
      name: _name2,
      color: _color2,
      icon: Icons.shopping_basket,
    ),
  );

  late final String _id3 = _uid.v4();
  final _name3 = 'Health';
  final _color3 = Color(Colors.red.value);
  late final category3 = _FixtureObject(
    entity: CategoryEntity(
      id: _id3,
      name: _name3,
      iconFamily: 'MaterialIcons',
      iconName: 'healing',
      color: _color3.value,
    ),
    model: Category(
      id: _id3,
      name: _name3,
      color: _color3,
      icon: Icons.healing,
    ),
  );

  late final String _id4 = _uid.v4();
  final _name4 = 'Fun';
  final _color4 = Color(Colors.blue.value);
  late final category4 = _FixtureObject(
    entity: CategoryEntity(
      id: _id4,
      name: _name4,
      iconFamily: 'MaterialIcons',
      iconName: 'sports_volleyball',
      color: _color4.value,
    ),
    model: Category(
      id: _id4,
      name: _name4,
      color: _color4,
      icon: Icons.sports_volleyball,
    ),
  );
}
