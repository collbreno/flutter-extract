import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/category_form_cubit.dart';
import 'package:formz/formz.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/list_tile_input_fields.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/services/color_service.dart';

class CategoryForm extends StatelessWidget {
  CategoryForm({Key? key}) : super(key: key);

  final _nameKey = GlobalKey<TextInputFieldState>();
  final _colorKey = GlobalKey<PickerInputFieldState<Color?>>();
  final _iconKey = GlobalKey<PickerInputFieldState<IconData?>>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryFormCubit, CategoryFormState>(
      child: _buildForm(context),
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Algo deu errado"),
                backgroundColor: Colors.red,
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Criado com sucesso")),
            );
        } else if (state.status.isPure) {
          print('state mudou e é puro');
          _nameKey.currentState?.didChange(state.name.value);
          _colorKey.currentState?.didChange(state.color.value);
          _iconKey.currentState?.didChange(state.icon.value);
        }
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _NameInput(inputKey: _nameKey),
              _ColorInput(inputKey: _colorKey),
              _IconInput(inputKey: _iconKey),
            ],
          ),
        ),
        _SaveButton(),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: state.status.isSubmissionInProgress
                    ? null
                    : context.read<CategoryFormCubit>().onSubmitted,
                child: _buildContent(state.status),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(FormzStatus status) {
    if (status.isSubmissionInProgress) return CircularProgressIndicator();
    return Text("Save");
  }
}

class _NameInput extends StatelessWidget {
  final Key inputKey;

  const _NameInput({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return TextInputField(
          key: inputKey,
          onChanged: context.read<CategoryFormCubit>().onNameChanged,
          leading: Icon(Icons.edit),
          hintText: "Insira o nome",
          errorText: _getErrorText(state.name),
        );
      },
    );
  }

  String? _getErrorText(CategoryNameFormzInput input) {
    if (input.invalid) {
      final error = input.error;
      if (error == null) return null;
      if (error == CategoryNameFormzInputValidationError.empty) return "Não pode ser vazio";
      if (error == CategoryNameFormzInputValidationError.tooLong)
        return "Deve ter tamanho máximo de $CATEGORY_NAME_MAX";
      if (error == CategoryNameFormzInputValidationError.tooShort)
        return "Deve ter tamanho mínimo de $CATEGORY_NAME_MIN";
      throw ArgumentError();
    } else {
      return null;
    }
  }
}

class _ColorInput extends StatelessWidget {
  final Key inputKey;

  const _ColorInput({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return PickerInputField<Color>(
          key: inputKey,
          errorText: state.color.invalid ? "Inválido" : null,
          onChanged: context.read<CategoryFormCubit>().onColorChanged,
          columns: 5,
          items: ColorService.colors.keys,
          leading: Icon(Icons.color_lens),
          dialogItemBuilder: (color) {
            return Container(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: color,
              ),
              margin: EdgeInsets.all(8),
            );
          },
          inputFieldWidgetBuilder: (color) {
            return InputFieldWidget(
              child: Text('0x' + color.value.toRadixString(16).toUpperCase()),
              prefixIcon: Icon(
                Icons.circle,
                color: color,
              ),
            );
          },
        );
      },
    );
  }
}

class _IconInput extends StatelessWidget {
  final Key inputKey;

  const _IconInput({Key? key, required this.inputKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return PickerInputField<IconData>(
          key: inputKey,
          errorText: state.icon.invalid ? "Inválido" : null,
          onChanged: context.read<CategoryFormCubit>().onIconChanged,
          items: IconMapper.getAll().toList(),
          columns: 5,
          onSearch: (icon, text) => IconMapper.getIconName(icon).contains(text),
          leading: Icon(Icons.color_lens),
          dialogItemBuilder: (icon) {
            return Container(
              child: Icon(icon),
              margin: EdgeInsets.all(8),
            );
          },
          inputFieldWidgetBuilder: (icon) {
            return InputFieldWidget(
              child: Text(IconMapper.getIconName(icon)),
              prefixIcon: Icon(
                icon,
              ),
            );
          },
        );
      },
    );
  }
}
