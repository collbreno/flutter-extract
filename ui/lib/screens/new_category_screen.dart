import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/toggle_buttons_form_field.dart';
import 'package:ui/services/color_service.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _parentKey = GlobalKey();
  late bool _showParent;

  @override
  void initState() {
    super.initState();
    _showParent = false;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: ThemeSwitcher(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Nova Categoria"),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildToggleButtons(),
                  _buildName(),
                  _buildColor(),
                  _buildParent(),
                  _buildButton()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          _formKey.currentState?.validate();
        },
        child: Text("Confirmar"),
      ),
    );
  }

  Widget _buildParent() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
      child: _showParent
          ? PickerFormField<String>(
              key: _parentKey,
              items: ['a', 'b'],
              dialogItemBuilder: (text) => ListTile(title: Text(text)),
              formFieldWidgetBuilder: (text) => FormFieldWidget(child: Text(text)),
            )
          : SizedBox(key: _sizedBoxKey),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ToggleButtonsFormField<String>(
        items: [_ToggleButtons.category, _ToggleButtons.subcategory],
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        itemBuilder: (text) => Text(text),
        borderRadius: BorderRadius.circular(4),
        validator: (item) => item == null ? 'Obrigatório' : null,
        onChanged: (value) {
          setState(() {
            _showParent = value == _ToggleButtons.subcategory;
          });
        },
      ),
    );
  }

  Widget _buildName() {
    return ListTileTextFormField(
      leading: Icon(Icons.edit),
      hintText: 'Insira o nome',
    );
  }

  Widget _buildColor() {
    return PickerFormField<Color>(
      items: ColorService.colors.keys.toList(),
      columns: 5,
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
      formFieldWidgetBuilder: (color) {
        return FormFieldWidget(
          child: Text('0x' + color.value.toRadixString(16).toUpperCase()),
          prefixIcon: Icon(
            Icons.circle,
            color: color,
          ),
        );
      },
    );
  }
}

class _ToggleButtons {
  static const category = 'Categoria';
  static const subcategory = 'Subcategory';
}
