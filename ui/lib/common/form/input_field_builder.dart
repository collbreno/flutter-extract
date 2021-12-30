import 'package:flutter/material.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/color_input_builder.dart';
import 'package:ui/common/form/icon_input_builder.dart';
import 'package:ui/common/form/text_input_builder.dart';
import 'package:ui/models/_models.dart';

class InputFieldBuilder<T extends EntityFormCubit> extends StatelessWidget {
  final FormzInputSuper input;
  final GlobalObjectKey inputKey;

  InputFieldBuilder({
    Key? key,
    required this.input,
    required this.inputKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = input.runtimeType;

    if (type == IconFormzInput) {
      return IconInputBuilder<T>(inputKey: inputKey);
    } else if (type == ColorFormzInput) {
      return ColorInputBuilder<T>(inputKey: inputKey);
    } else if (type == CategoryNameFormzInput) {
      return TextInputBuilder<T, CategoryNameFormzInput>(inputKey: inputKey);
    } else if (type == StoreNameFormzInput) {
      return TextInputBuilder<T, StoreNameFormzInput>(inputKey: inputKey);
    }

    throw Exception('InputBuilder not defined for input of type $type');
  }
}
