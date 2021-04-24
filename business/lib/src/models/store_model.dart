import 'package:built_value/built_value.dart';
import 'package:infrastructure/infrastructure.dart';

part 'store_model.g.dart';

abstract class StoreModel implements Built<StoreModel, StoreModelBuilder> {
  String get id;
  String get name;

  StoreModel._();

  StoreEntity toEntity() {
    return StoreEntity(
      id: id,
      name: name,
    );
  }

  factory StoreModel.fromEntity(StoreEntity entity) {
    return StoreModel(
      id: entity.id,
      name: entity.name,
    );
  }

  factory StoreModel({
    required String id,
    required String name,
  }) = _$StoreModel._;
}
