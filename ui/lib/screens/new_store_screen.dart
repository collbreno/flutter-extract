import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/list_tile_form_fields.dart';

class NewStoreScreen extends StatefulWidget {
  final Expense? expenseToEdit;

  const NewStoreScreen({
    Key? key,
    this.expenseToEdit,
  }) : super(key: key);

  @override
  _NewStoreScreenState createState() => _NewStoreScreenState();
}

class _NewStoreScreenState extends State<NewStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _nameFocusNode.unfocus();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nova Loja"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildName(),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          _formKey.currentState?.validate();
        },
        child: Text("Confirmar"),
      ),
    );
  }

  Widget _buildName() {
    return ListTileTextFormField(
      focusNode: _nameFocusNode,
      leading: Icon(Icons.store),
      hintText: 'Insira o nome',
    );
  }
}
