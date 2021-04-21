import 'package:flutter/material.dart';
import 'package:ui/common/picker_dialog.dart';
import 'package:ui/services/color_service.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  late Color _selectedColor;

  @override
  void initState() {
    _selectedColor = Colors.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Categoria"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.color_lens_sharp,
              color: _selectedColor,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return PickerDialog<Color>(
                      title: "Teste",
                      columns: 5,
                      items: ColorService.colors.keys.toList(),
                      renderer: (color) {
                        return Container(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: color,
                          ),
                          margin: EdgeInsets.all(8),
                        );
                      },
                      onItemSelected: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    );
                  });
            },
            title: Text("Selecionar cor"),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Confirmar"),
            ),
          )
        ],
      ),
    );
  }
}
