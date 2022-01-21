import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/entity_item_input_builder.dart';
import 'package:ui/common/list_tile_input_fields.dart';

class CategoryInputBuilder<T extends EntityFormCubit> extends EntityItemInputBuilder<Category, T> {
  CategoryInputBuilder({
    required Key inputKey,
  }) : super(
          inputKey: inputKey,
          dialogItemBuilder: (item) {
            return ListTile(
              title: Text(item.name),
              leading: Icon(item.icon, color: item.color),
            );
          },
          inputFieldWidgetBuilder: (item) {
            return InputFieldWidget(
              child: Text(item.name),
              prefixIcon: Icon(item.icon, color: item.color),
            );
          },
        );
}
