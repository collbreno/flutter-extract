import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/form/category_input_builder.dart';
import 'package:ui/common/form/color_input_builder.dart';
import 'package:ui/common/form/icon_input_builder.dart';
import 'package:ui/common/form/text_input_builder.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/models/entity_formz_input.dart';
import 'package:ui/models/subcategory_name_formz_input.dart';

class InputFieldBuilder<T extends EntityFormCubit> extends StatelessWidget {
  final FormzInput input;
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
      return IconInputBuilder<T, IconFormzInput>(inputKey: inputKey);
    } else if (type == NullableIconFormzInput) {
      return IconInputBuilder<T, NullableIconFormzInput>(inputKey: inputKey);
    } else if (type == ColorFormzInput) {
      return ColorInputBuilder<T>(inputKey: inputKey);
    } else if (type == CategoryNameFormzInput) {
      return TextInputBuilder<T, CategoryNameFormzInput>(inputKey: inputKey);
    } else if (type == SubcategoryNameFormzInput) {
      return TextInputBuilder<T, SubcategoryNameFormzInput>(inputKey: inputKey);
    } else if (type == StoreNameFormzInput) {
      return TextInputBuilder<T, StoreNameFormzInput>(inputKey: inputKey);
    } else if (type == TagNameFormzInput) {
      return TextInputBuilder<T, TagNameFormzInput>(inputKey: inputKey);
    } else if (type == PaymentMethodNameFormzInput) {
      return TextInputBuilder<T, PaymentMethodNameFormzInput>(inputKey: inputKey);
    } else if (type == EntityFormzInput<Category>) {
      return BlocProvider(
        create: (context) => EntityListCubit<Category>(
          watchAllUseCase: context.read<WatchCategoriesUseCase>(),
          deleteUseCase: context.read<DeleteCategoryUseCase>(),
          openItemCallback: (value) {},
          editItemCallback: (value) {},
        ),
        child: CategoryInputBuilder<T>(inputKey: inputKey),
      );
    }
    throw Exception('InputBuilder not defined for input of type $type');
  }
}
