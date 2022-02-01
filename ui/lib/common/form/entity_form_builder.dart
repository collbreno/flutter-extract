import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/input_field_builder.dart';
import 'package:ui/common/form/input_fields/list_tile_input_fields.dart';
import 'package:uuid/uuid.dart';

class EntityFormBuilder<T extends EntityFormCubit> extends StatelessWidget {
  final _keyCreator = _KeyCreator();
  final Map<Type, GlobalObjectKey<InputFieldState>> _inputKeys = {};
  final ValueSetter<String> onOpenEntity;
  final String titleWhenCreating;
  final String titleWhenEditing;

  EntityFormBuilder({
    Key? key,
    required this.onOpenEntity,
    required this.titleWhenEditing,
    required this.titleWhenCreating,
  }) : super(key: key);

  GlobalObjectKey<InputFieldState> _getKey(Type type) {
    return _inputKeys.putIfAbsent(type, () => _keyCreator.create(type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<T, EntityFormState>(
          builder: (context, state) => Text(
            state.id.isEmpty ? titleWhenCreating : titleWhenEditing,
          ),
        ),
      ),
      body: BlocListener<T, EntityFormState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _listener,
        child: _buildForm(),
      ),
    );
  }

  void _listener(BuildContext context, EntityFormState state) {
    if (state.status.isSubmissionFailure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Algo deu errado"),
            backgroundColor: Colors.red,
          ),
        );
    } else if (state.status.isSubmissionSuccess) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Salvo com sucesso"),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "Abrir",
              onPressed: () => onOpenEntity(state.id),
            ),
          ),
        );
    } else if (state.status.isPure) {
      print('status é puro');
      state.inputs.forEach((e) {
        final key = _getKey(e.runtimeType);
        key.currentState?.didChange(e.value);
      });
    }
  }

  Widget _buildForm() {
    return BlocBuilder<T, EntityFormState>(
      builder: (context, state) {
        final isInProgress = state.status.isSubmissionInProgress;
        return AbsorbPointer(
          absorbing: isInProgress,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  if (isInProgress) LinearProgressIndicator(),
                  ...state.inputs
                      .map((e) => InputFieldBuilder<T>(inputKey: _getKey(e.runtimeType), input: e)),
                ]),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<T>().onSubmitted();
                      },
                      child: Text("Save"),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _KeyCreator {
  final String _uid;

  _KeyCreator() : _uid = Uuid().v4();

  GlobalObjectKey<InputFieldState> create(Type type) {
    return GlobalObjectKey('input_field_${type}_$_uid');
  }
}
