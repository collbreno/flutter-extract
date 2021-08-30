import 'package:business/src/domain/_domain.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FixtureTag {
  final _uid = Uuid();

  late final tag1 = Tag(
    id: _uid.v4(),
    name: 'Stadium',
    icon: Icons.sports_soccer,
    color: Color(Colors.blue.value),
  );

  late final tag2 = Tag(
    id: _uid.v4(),
    name: 'Tech',
    icon: Icons.computer,
    color: Color(Colors.grey.value),
  );

  late final tag3 = Tag(
    id: _uid.v4(),
    name: 'Shared',
    icon: Icons.safety_divider,
    color: Color(Colors.grey.value),
  );
}
