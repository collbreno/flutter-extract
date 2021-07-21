import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/tag_chip.dart';
import 'package:ui/services/color_service.dart';

class NewTagScreen extends StatefulWidget {
  const NewTagScreen({Key? key}) : super(key: key);

  @override
  _NewTagScreenState createState() => _NewTagScreenState();
}

class _NewTagScreenState extends State<NewTagScreen> {
  late TagBuilder _tagBuilder;

  @override
  void initState() {
    super.initState();
    _tagBuilder = TagBuilder();
    _tagBuilder.id = 'asfas';
    _tagBuilder.name = '';
    _tagBuilder.icon = null;
    _tagBuilder.color = Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Tag')),
      body: Form(
        child: ListView(
          children: [
            _buildTag(),
            _buildTitle(),
            _buildColor(),
            _buildIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTag() {
    final tag = _tagBuilder.build();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.center,
        child: TagChip.fromTag(tag),
      ),
    );
  }

  Widget _buildTitle() {
    return ListTileTextFormField(
      leading: Icon(Icons.edit),
      onChanged: (text) {
        setState(() {
          _tagBuilder.name = text;
        });
      },
    );
  }

  Widget _buildColor() {
    return PickerFormField<Color>(
      items: ColorService.colors.keys.toList(),
      columns: 5,
      onChanged: (color) {
        setState(() {
          _tagBuilder.color = color;
        });
      },
      initialValue: _tagBuilder.color,
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

  Widget _buildIcon() {
    return PickerFormField<IconData>(
      items: [Icons.edit, Icons.car_rental, Icons.sports_baseball, Icons.credit_card],
      columns: 5,
      onChanged: (icon) {
        setState(() {
          _tagBuilder.icon = icon;
        });
      },
      showRemoveButton: true,
      initialValue: _tagBuilder.icon,
      leading: Icon(Icons.color_lens),
      dialogItemBuilder: (icon) {
        return Icon(icon);
      },
      formFieldWidgetBuilder: (icon) {
        return FormFieldWidget(
          child: Text('Icon Name'),
          prefixIcon: Icon(icon),
        );
      },
    );
  }
}
