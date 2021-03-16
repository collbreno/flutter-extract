import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixtureIcon {
  final icon1 = IconsCompanion(
    id: Value(1),
    name: Value('home'),
    family: Value('material'),
  );

  final icon2 = IconsCompanion(
    id: Value(2),
    name: Value('card'),
    family: Value('font-awesome'),
  );

  final icon3 = IconsCompanion(
    id: Value(3),
    name: Value('bus'),
    family: Value('cupertino'),
  );
}
