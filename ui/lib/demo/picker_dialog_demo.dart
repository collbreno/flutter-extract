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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return PickerDialog<String>(
                        title: Text('teste'),
                        onSearch: (item, text) => item.contains(text),
                        items: ['Banana', 'Maçã', 'Mamão', 'Melancia', 'Banana', 'Goiaba'],
                        renderer: (item) => ListTile(
                          title: Text(item),
                        ),
                        onRemove: () {
                          setState(() {
                            _selected = null;
                          });
                        },
                        onItemSelected: (selected) {
                          setState(() {
                            _selected = selected;
                          });
                        },
                      );
                    });
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
