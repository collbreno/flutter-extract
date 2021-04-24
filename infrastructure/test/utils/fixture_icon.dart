import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureIcon {
  final _uid = Uuid();

  late final icon1 = IconsCompanion(
    id: Value(_uid.v4()),
    name: Value('home'),
    family: Value('material'),
  );

  late final icon2 = IconsCompanion(
    id: Value(_uid.v4()),
    name: Value('card'),
    family: Value('font-awesome'),
  );

  late final icon3 = IconsCompanion(
    id: Value(_uid.v4()),
    name: Value('bus'),
    family: Value('cupertino'),
  );
}
