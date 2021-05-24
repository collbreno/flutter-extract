import 'package:business/src/domain/entities/entities.dart';
import 'package:uuid/uuid.dart';

class FixtureStore {
  final _uid = Uuid();

  late final store1 = Store(
    id: _uid.v4(),
    name: 'Americanas',
  );

  late final store2 = Store(
    id: _uid.v4(),
    name: 'Amazon',
  );

  late final store3 = Store(
    id: _uid.v4(),
    name: 'Burger King',
  );
}
