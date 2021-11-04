import 'package:flutter/material.dart';

class ToggleButtonsFormField<T> extends FormField<T> {
  ToggleButtonsFormField({
    Key? key,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    BorderRadius? borderRadius,
    double? borderWidth,
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
    FormFieldValidator<T>? validator,
    ValueChanged<T>? onChanged,
  }) : super(
          key: key,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (formState) {
            return Builder(
              builder: (context) {
                final theme = Theme.of(context);
                final length = items.length;
                final actualBorderWidth = borderWidth ?? 1.0;

                return LayoutBuilder(builder: (context, constraints) {
                  return ToggleButtons(
                    borderColor: formState.hasError ? theme.colorScheme.error : null,
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth / length - actualBorderWidth * 2,
                    ),
                    children: items
                        .map(
                          (item) => Padding(
                            padding: contentPadding,
                            child: itemBuilder(item),
                          ),
                        )
                        .toList(),
                    isSelected: items.map((e) => formState.value == e).toList(),
                    onPressed: (index) {
                      final newItem = items[index];
                      if (newItem != formState.value) {
                        formState.didChange(newItem);
                        onChanged?.call(newItem);
                      }
                    },
                    fillColor: theme.buttonTheme.colorScheme?.primary,
                    selectedColor: theme.buttonTheme.colorScheme?.onPrimary,
                    textStyle: theme.textTheme.button,
                    borderRadius: borderRadius,
                  );
                });
              },
            );
          },
        );
}
