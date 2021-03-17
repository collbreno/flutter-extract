import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixtureTag {
  final tag1 = TagsCompanion(
    id: Value(1),
    name: Value('Stadium'),
    iconId: Value(13),
    color: Value(5423523),
  );

  final tag2 = TagsCompanion(
    id: Value(2),
    name: Value('Tech'),
    iconId: Value(23),
    color: Value(214),
  );

  final tag3 = TagsCompanion(
    id: Value(3),
    name: Value('Shared'),
    iconId: Value(7),
    color: Value(234),
  );
}
