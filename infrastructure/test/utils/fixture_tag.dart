import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:uuid/uuid.dart';

class _FixtureObject {
  final TagEntity entity;
  final Tag model;

  _FixtureObject({required this.entity, required this.model});
}

class FixtureTag {
  final _uid = Uuid();

  late final String _id1 = _uid.v4();
  final String _name1 = 'Delivery';
  final Color _color1 = Color(Colors.grey.value);
  late final tag1 = _FixtureObject(
    entity: TagEntity(
      id: _id1,
      color: _color1.value,
      name: _name1,
      iconName: 'delivery_dining',
      iconFamily: 'MaterialIcons',
    ),
    model: Tag(
      id: _id1,
      name: _name1,
      color: _color1,
      icon: Icons.delivery_dining,
    ),
  );
  late final String _id2 = _uid.v4();
  final String _name2 = 'Tech';
  final Color _color2 = Color(Colors.black.value);
  late final tag2 = _FixtureObject(
    entity: TagEntity(
      id: _id2,
      color: _color2.value,
      name: _name2,
      iconName: 'computer',
      iconFamily: 'MaterialIcons',
    ),
    model: Tag(
      id: _id2,
      name: _name2,
      color: _color2,
      icon: Icons.computer,
    ),
  );
  late final String _id3 = _uid.v4();
  final String _name3 = 'Barney';
  final Color _color3 = Color(Colors.brown.value);
  late final tag3 = _FixtureObject(
    entity: TagEntity(
      id: _id3,
      color: _color3.value,
      name: _name3,
      iconName: 'pets',
      iconFamily: 'MaterialIcons',
    ),
    model: Tag(
      id: _id3,
      name: _name3,
      color: _color3,
      icon: Icons.pets,
    ),
  );
}
