import 'package:flutter/material.dart';
import 'package:ui/common/list_tile_form_fields.dart';

class FormDemo extends StatefulWidget {
  const FormDemo({Key? key}) : super(key: key);

  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Demo'),
      ),
      body: Form(
        child: ListView(
          children: [
            FilePickerFormField(),
          ],
        ),
      ),
    );
  }
}
