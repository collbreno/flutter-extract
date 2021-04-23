import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/new_category_screen.dart';
import 'package:ui/screens/new_expense_screen.dart';
import 'package:ui/screens/settings_screen.dart';
import 'package:ui/screens/test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
            ),
            ListTile(
              title: Text("Configurações"),
              onTap: _goToSettings,
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TestScreen(),
                    ),
                  );
                },
                child: Text("Teste"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewCategoryScreen(),
                    ),
                  );
                },
                child: Text("Adicionar Categoria"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewExpenseScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _goToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }
}
