import 'package:flutter/material.dart';
import 'package:ui/common/picker_dialog.dart';

class PickerDialogDemo extends StatefulWidget {
  const PickerDialogDemo({Key? key}) : super(key: key);

  @override
  _PickerDialogDemoState createState() => _PickerDialogDemoState();
}

class _PickerDialogDemoState extends State<PickerDialogDemo> {
  String? _selected;
  List<String> _multipleSelected = [];

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
              child: Text('Open Multiple Item Dialog'),
              onPressed: () async {
                final result = await showMultiPickerDialog(
                  context: context,
                  pickerDialog: PickerDialog<String>.multiple(
                    title: Text('Selecione'),
                    initialSelection: _multipleSelected,
                    onSearch: (item, text) => item.contains(text),
                    items: ['Banana', 'Maçã', 'Mamão', 'Melancia', 'Abacaxi', 'Goiaba'],
                    renderer: (item, isSelected) => ListTile(
                      title: Text(item),
                      trailing: AbsorbPointer(
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _multipleSelected = result.toList();
                  });
                }
              },
            ),
            SizedBox(height: 8),
            _multipleSelected.isEmpty
                ? Text('Nenhum selecionado')
                : Column(children: (_multipleSelected.map((e) => Text(e)).toList())),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Open Single Item Dialog'),
              onPressed: () async {
                final result = await showPickerDialog(
                  context: context,
                  pickerDialog: PickerDialog<String>.single(
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
