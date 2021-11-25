import 'dart:ui';

import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/category_form_cubit.dart';
import 'package:formz/formz.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/list_tile_input_fields.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';
import 'package:ui/services/color_service.dart';

class CategoryForm extends StatelessWidget {
  CategoryForm({Key? key}) : super(key: key);

  final _nameKey = GlobalKey<TextInputFieldState>();
  final _colorKey = GlobalKey<PickerInputFieldState<Color?>>();
  final _iconKey = GlobalKey<PickerInputFieldState<IconData?>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: BlocListener<CategoryFormCubit, CategoryFormState>(
        child: _buildForm(context),
        listener: _listener,
      ),
    );
  }

  void _listener(BuildContext context, CategoryFormState state) {
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
              onPressed: () => Navigator.of(context).push(
                CategoryViewScreen.route(state.id),
              ),
            ),
          ),
        );
    } else if (state.status.isPure) {
      print('state mudou e é puro');
      _nameKey.currentState?.didChange(state.name.value);
      _colorKey.currentState?.didChange(state.color.value);
      _iconKey.currentState?.didChange(state.icon.value);
    }
  }

  Widget _buildForm(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmissionInProgress,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (state.status.isSubmissionInProgress) LinearProgressIndicator(),
                    _NameInput(inputKey: _nameKey),
                    _ColorInput(inputKey: _colorKey),
                    _IconInput(inputKey: _iconKey),
                  ],
                ),
              ),
              _SaveButton(),
            ],
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      builder: (context, state) {
        return AppBar(
          title: state.id.isEmpty ? Text("Nova Categoria") : Text("Editar Categoria"),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.read<CategoryFormCubit>().onSubmitted();
            },
            child: Text("Save"),
          ),
        ),
      ),
    );
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
          initialValue: state.name.value,
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
          initialValue: state.color.value,
          errorText: state.color.invalid ? "Inválido" : null,
          onChanged: context.read<CategoryFormCubit>().onColorChanged,
          columns: 5,
          items: ColorService.colors.keys,
          leading: Icon(Icons.color_lens),
          onTap: () => FocusScope.of(context).unfocus(),
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
          initialValue: state.icon.value,
          errorText: state.icon.invalid ? "Inválido" : null,
          onChanged: context.read<CategoryFormCubit>().onIconChanged,
          items: IconMapper.getAll().toList(),
          columns: 5,
          onSearch: (icon, text) => IconMapper.getIconName(icon).contains(text),
          leading: Icon(Icons.color_lens),
          onTap: () => FocusScope.of(context).unfocus(),
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
