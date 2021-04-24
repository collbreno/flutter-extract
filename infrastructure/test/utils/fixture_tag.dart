import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureTag {
  final _uid = Uuid();

  late final tag1 = TagsCompanion(
    id: Value(_uid.v4()),
    name: Value('Stadium'),
    iconId: Value(_uid.v4()),
    color: Value(5423523),
  );

  late final tag2 = TagsCompanion(
    id: Value(_uid.v4()),
    name: Value('Tech'),
    iconId: Value(_uid.v4()),
    color: Value(214),
  );

  late final tag3 = TagsCompanion(
    id: Value(_uid.v4()),
    name: Value('Shared'),
    iconId: Value(_uid.v4()),
    color: Value(234),
  );
}
