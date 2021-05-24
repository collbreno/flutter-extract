import 'package:business/src/domain/_domain.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FixtureTag {
  final _uid = Uuid();

  late final tag1 = Tag(
    id: _uid.v4(),
    name: 'Stadium',
    icon: Icons.sports_soccer,
    color: Colors.blue,
  );

  late final tag2 = Tag(
    id: _uid.v4(),
    name: 'Tech',
    icon: Icons.computer,
    color: Colors.grey,
  );

  late final tag3 = Tag(
    id: _uid.v4(),
    name: 'Shared',
    icon: Icons.safety_divider,
    color: Colors.grey,
  );
}
