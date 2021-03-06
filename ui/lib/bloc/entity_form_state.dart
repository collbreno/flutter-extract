part of 'entity_form_cubit.dart';

class EntityFormState extends Equatable {
  final String id;
  final FormzStatus status;
  final BuiltList<FormzInput> inputs;

  EntityFormState({
    this.id = '',
    this.status = FormzStatus.pure,
    required this.inputs,
  });

  EntityFormState copyWith({
    String? id,
    FormzStatus? status,
    BuiltList<FormzInput>? inputs,
  }) {
    return EntityFormState(
      id: id ?? this.id,
      status: status ?? this.status,
      inputs: inputs ?? this.inputs,
    );
  }

  @override
  List<Object?> get props => [id, status, inputs];
}
