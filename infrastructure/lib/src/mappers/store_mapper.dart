import 'package:business/business.dart';
import 'package:infrastructure/infrastructure.dart';

extension StoreModelToEntity on Store {
  StoreEntity toEntity() {
    return StoreEntity(
      id: id,
      name: name,
    );
  }
}

extension StoreEntityToModel on StoreEntity {
  Store toModel() {
    return Store(
      id: id,
      name: name,
    );
  }
}
