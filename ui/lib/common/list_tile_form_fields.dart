import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:ui/common/calculator.dart';
import 'package:ui/common/picker_dialog.dart';
import 'package:ui/services/date_formatter.dart';

const _horizontalTitleGap = 8.0;

class NotNullValidator<T> {
  final String fieldName;

  NotNullValidator(this.fieldName);
  String? call(T? item) => item != null ? null : '$fieldName é obrigatório';
}

class FormFieldWidget {
  final Widget? prefixIcon;
  final Widget child;

  FormFieldWidget({required this.child, this.prefixIcon});
}

class MultiPickerFormField<T> extends FormField<List<T>> {
  MultiPickerFormField({
    required List<T> items,
    required Widget Function(List<T> items) formFieldWidgetBuilder,
    required Widget Function(T item, Widget checkbox) dialogItemBuilder,
    FormFieldValidator<List<T>>? validator,
    ValueSetter<List<T>>? onSaved,
    Key? key,
    List<T>? initialValue,
    Widget? leading,
    bool enabled = true,
    bool Function(T, String)? onSearch,
    ValueChanged<List<T>>? onChanged,
    String hintText = 'Selecione',
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          onSaved: (list) {
            onSaved?.call(list ?? []);
          },
          builder: (formState) {
            return Builder(
              builder: (ctx) => _OuterListTile(
                leading: leading,
                formState: formState,
                enabled: enabled,
                onTap: () async {
                  final result = await showMultiPickerDialog(
                    context: ctx,
                    pickerDialog: PickerDialog<T>.multiple(
                      title: Text('Selecione'),
                      items: items,
                      initialSelection: formState.value,
                      renderer: (item, isSelected) => dialogItemBuilder(
                        item,
                        AbsorbPointer(
                          child: Checkbox(value: isSelected, onChanged: (_) {}),
                        ),
                      ),
                      onSearch: onSearch,
                    ),
                  );
                  if (result != null && formState.value != result) {
                    formState.didChange(result.toList());
                    onChanged?.call(result.toList());
                  }
                },
                suffixIcon: Icon(Icons.arrow_drop_down),
                child: (formState.value ?? []).isEmpty
                    ? Text(hintText)
                    : formFieldWidgetBuilder(formState.value!),
              ),
            );
          },
        );
}

class PickerFormField<T> extends FormField<T> {
  PickerFormField({
    Key? key,
    required List<T> items,
    required Widget Function(T) dialogItemBuilder,
    required FormFieldWidget Function(T) formFieldWidgetBuilder,
    FormFieldValidator<T>? validator,
    ValueChanged<T?>? onChanged,
    ValueSetter<T?>? onSaved,
    String? labelText,
    bool Function(T, String)? onSearch,
    String hintText = 'Selecione',
    Widget? leading,
    T? initialValue,
    bool showRemoveButton = false,
    bool enabled = true,
    int columns = 1,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          builder: (formState) {
            return Builder(
              builder: (ctx) => _OuterListTile(
                leading: leading,
                showRemoveButton: showRemoveButton,
                formState: formState,
                onClear: () {
                  onChanged?.call(null);
                },
                enabled: enabled,
                onTap: () async {
                  final result = await showPickerDialog(
                    context: ctx,
                    pickerDialog: PickerDialog.single(
                      title: Text('Selecione'),
                      columns: columns,
                      items: items,
                      renderer: dialogItemBuilder,
                      onSearch: onSearch,
                    ),
                  );
                  if (result != null && formState.value != result.value) {
                    formState.didChange(result.value);
                    onChanged?.call(result.value);
                  }
                },
                prefixIcon: formState.value != null
                    ? formFieldWidgetBuilder(formState.value!).prefixIcon
                    : null,
                suffixIcon: Icon(Icons.arrow_drop_down),
                child: formState.value != null
                    ? formFieldWidgetBuilder(formState.value!).child
                    : Text(hintText),
              ),
            );
          },
        );
}

class DateFormField extends FormField<DateTime> {
  DateFormField({
    DateTime? initialValue,
    FormFieldValidator<DateTime>? validator,
    ValueSetter<DateTime?>? onSaved,
    String? labelText,
    String hintText = 'Selecione',
    Widget? leading = const Icon(Icons.calendar_today),
    bool showRemoveButton = false,
  }) : super(
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          builder: (formState) {
            return Builder(
              builder: (ctx) => _OuterListTile(
                leading: leading,
                showRemoveButton: showRemoveButton,
                formState: formState,
                suffixIcon: Icon(Icons.arrow_drop_down),
                child: formState.value != null
                    ? Text(DateFormatter.formatShort(formState.value!))
                    : Text(hintText),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: ctx,
                    initialDate: formState.value ?? DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                    currentDate: formState.value,
                  );
                  if (selectedDate != null) {
                    formState.didChange(selectedDate);
                  }
                },
              ),
            );
          },
        );
}

class MoneyFormField extends FormField<int> {
  MoneyFormField({
    required Currency currency,
    int? initialValue,
    String? labelText,
    FormFieldValidator<int>? validator,
    ValueSetter<int?>? onSaved,
    String hintText = 'Selecione',
    Widget? leading = const Icon(Icons.attach_money),
    bool showRemoveButton = false,
    Widget? suffixIcon = const Icon(Icons.arrow_drop_down),
  }) : super(
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          builder: (formState) {
            return Builder(
              builder: (ctx) => _OuterListTile(
                leading: leading,
                showRemoveButton: showRemoveButton,
                formState: formState,
                onTap: () async {
                  final result = await showCalculator(
                    ctx,
                    // initialValue: (formState.value ?? initialValue)?.toDouble(),
                  );
                  if (result != null) {
                    formState.didChange((result * 100).toInt());
                  }
                },
                suffixIcon: suffixIcon,
                child: formState.value != null
                    ? Text(Money.fromInt(formState.value!, currency).toString())
                    : Text(hintText),
              ),
            );
          },
        );
}

class ListTileTextFormField extends FormField<String> {
  ListTileTextFormField({
    int? minLines,
    int? maxLines = 1,
    FormFieldValidator<String>? validator,
    ValueSetter<String?>? onSaved,
    String? initialValue,
    Widget? leading,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    String? labelText,
    String? hintText,
    ValueChanged<String>? onChanged,
  }) : super(builder: (formState) {
          return Builder(
            builder: (ctx) => ListTile(
              horizontalTitleGap: _horizontalTitleGap,
              leading: leading,
              title: TextFormField(
                onChanged: onChanged,
                focusNode: focusNode,
                keyboardType: keyboardType,
                maxLines: maxLines,
                minLines: minLines,
                validator: validator,
                onSaved: onSaved,
                initialValue: initialValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: hintText,
                  labelText: labelText,
                ),
              ),
            ),
          );
        });
}

class _OuterListTile extends StatelessWidget {
  final Widget? leading;
  final bool showRemoveButton;
  final bool enabled;
  final FormFieldState formState;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget child;
  final VoidCallback? onClear;

  _OuterListTile({
    required this.child,
    required this.formState,
    required this.onTap,
    this.leading,
    this.enabled = true,
    this.showRemoveButton = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      horizontalTitleGap: _horizontalTitleGap,
      leading: leading,
      trailing: formState.hasError
          ? Icon(
              Icons.error,
              color: Colors.red,
            )
          : !(showRemoveButton && formState.value != null)
              ? null
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    formState.didChange(null);
                    onClear?.call();
                  },
                ),
      title: InkWell(
        onTap: !enabled ? null : onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorText: formState.errorText,
          ),
          child: child,
        ),
      ),
    );
  }
}
