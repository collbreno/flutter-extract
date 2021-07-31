import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/daos/interfaces.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([], customMocks: [MockSpec<IEntityDao<StoreEntity>>(as: #MockStoreDao)])
void main() {}
