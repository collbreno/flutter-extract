import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class FixtureStore {
  final _uid = Uuid();

  late final store1 = StoresCompanion(
    id: Value(_uid.v4()),
    name: Value('Americanas'),
  );

  late final store2 = StoresCompanion(
    id: Value(_uid.v4()),
    name: Value('Amazon'),
  );

  late final store3 = StoresCompanion(
    id: Value(_uid.v4()),
    name: Value('Burger King'),
  );
}
