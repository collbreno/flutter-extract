import 'package:flutter/material.dart';
import 'package:ui/common/mutable_app_bar.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final Widget widget1 = Text(
    'Primary',
    key: UniqueKey(),
  );
  final list = ['Um', "Dois", "Tres", "Quatro"];

  late List<String> _selectedItems;

  @override
  void initState() {
    _selectedItems = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MutableAppBar(
        defaultAppBar: AppBar(
          title: Text("Gastos"),
          key: GlobalKey(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
        onClear: () {
          setState(() {
            _selectedItems.clear();
          });
        },
        selectedItems: _selectedItems,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            onTap: () {
              setState(() {
                if (_selectedItems.contains(item)) {
                  _selectedItems.remove(item);
                } else {
                  _selectedItems.add(item);
                }
              });
            },
            selected: _selectedItems.contains(item),
            title: Text(item),
          );
        },
      ),
    );
  }
}
