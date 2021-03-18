import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';

class FixtureStore {
  final store1 = StoresCompanion(
    id: Value(1),
    name: Value('Americanas'),
  );

  final store2 = StoresCompanion(
    id: Value(2),
    name: Value('Amazon'),
  );

  final store3 = StoresCompanion(
    id: Value(3),
    name: Value('Burger King'),
  );
}