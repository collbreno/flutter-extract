import 'package:flutter/material.dart';

class NewExpenseScreen extends StatefulWidget {
  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _focusNode.unfocus();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo gasto"),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text("R\$ 10,0"),
              leading: Icon(Icons.attach_money),
              onTap: () {},
            ),
            ListTile(
              title: Text("12/10/2020"),
              leading: Icon(Icons.calendar_today),
              onTap: () {},
            ),
            ListTile(
              title: Text("Transporte"),
              leading: Icon(Icons.directions_bus),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              focusNode: _focusNode,
              title: TextField(
                maxLines: 7,
                minLines: 1,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tags'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                child: Text("Salvar"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
