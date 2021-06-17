import 'package:animated_theme_switcher/animated_theme_switcher.dart';
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
    return ThemeSwitchingArea(
      child: ThemeSwitcher(
        builder: (context) {
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
                  onTap: () async {
                    final result = await showPickerDialog(
                      context: context,
                      pickerDialog: PickerDialog<Color>(
                        title: Text("Teste"),
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
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _selectedColor = result.value!;
                      });
                    }
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
        },
      ),
    );
  }
}
