import 'package:flutter/material.dart';
import 'package:ui/common/picker_dialog.dart';

class PickerDialogDemo extends StatefulWidget {
  const PickerDialogDemo({Key? key}) : super(key: key);

  @override
  _PickerDialogDemoState createState() => _PickerDialogDemoState();
}

class _PickerDialogDemoState extends State<PickerDialogDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picker Dialog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Open Dialog'),
              onPressed: () async {
                final result = await showPickerDialog(
                  context: context,
                  pickerDialog: PickerDialog<String>(
                    title: Text('Selecione'),
                    onSearch: (item, text) => item.toLowerCase().contains(text.toLowerCase()),
                    items: ['Banana', 'Maçã', 'Mamão', 'Melancia', 'Abacaxi', 'Goiaba'],
                    renderer: (item) => ListTile(
                      title: Text(item),
                    ),
                    canRemove: true,
                  ),
                );
                if (result != null) {
                  setState(() {
                    _selected = result.value;
                  });
                }
              },
            ),
            SizedBox(height: 8),
            Text(_selected ?? 'Nenhum selecionado')
          ],
        ),
      ),
    );
  }
}
