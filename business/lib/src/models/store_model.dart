import 'package:built_value/built_value.dart';

part 'store_model.g.dart';

abstract class StoreModel implements Built<StoreModel, StoreModelBuilder> {
  int get id;
  String get name;

  StoreModel._();

  factory StoreModel({
    int id,
    String name,
  }) = _$StoreModel._;
}
