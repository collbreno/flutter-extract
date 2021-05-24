import 'package:built_value/built_value.dart';

part 'store.g.dart';

abstract class Store implements Built<Store, StoreBuilder> {
  String get id;
  String get name;

  Store._();

  factory Store({
    required String id,
    required String name,
  }) = _$Store._;
}
