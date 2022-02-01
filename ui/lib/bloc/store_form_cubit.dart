import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/list.dart';
import 'package:business/business.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';
import 'package:uuid/uuid.dart';

class StoreFormCubit extends EntityFormCubit<Store> {
  StoreFormCubit({
    required FutureUseCase<void, Store> insertStore,
    required FutureUseCase<void, Store> updateStore,
    required Uuid uid,
    Store? store,
  }) : super(
          insertUseCase: insertStore,
          updateUseCase: updateStore,
          id: store?.id ?? '',
          inputs: _getDefaultInputs(store),
          uid: uid,
        );

  static BuiltList<FormzInput> _getDefaultInputs(Store? store) {
    return BuiltList([
      StoreNameFormzInput.pure(store?.name ?? ''),
    ]);
  }

  @override
  BuiltList<FormzInput> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Store mapInputsToEntity(String id) {
    return Store(
      id: id,
      name: state.inputs.singleWithType<StoreNameFormzInput>().value,
    );
  }
}
