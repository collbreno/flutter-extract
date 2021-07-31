import 'package:infrastructure/infrastructure.dart';

extension StoreExtension on StoresCompanion {
  StoreEntity convert({
    String? id,
    String? name,
  }) {
    return StoreEntity(
      id: id ?? this.id.value,
      name: name ?? this.name.value,
    );
  }
}
