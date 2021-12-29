import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'store_form_state.dart';

class StoreFormCubit extends Cubit<StoreFormState> {
  StoreFormCubit() : super(StoreFormInitial());
}
