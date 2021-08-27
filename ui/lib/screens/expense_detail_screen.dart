import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/common/tag_chip.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;
  ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final _df = DateFormat('dd/MM/yyyy');

  late bool _isShowingMoreInfo;

  @override
  void initState() {
    super.initState();
    _isShowingMoreInfo = false;
  }

  List<Widget> _buildTagChips() {
    return [
      TagChip.fromPaymentMethod(widget.expense.paymentMethod),
      if (widget.expense.store != null) TagChip.fromStore(widget.expense.store!),
      ...widget.expense.tags.map((tag) => TagChip.fromTag(tag)).toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gasto'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: ListView(
        children: [
          _buildDate(),
          _buildValue(),
          _buildCategory(),
          _buildSubcategory(),
          _buildDescription(),
          _buildTags(),
          !_isShowingMoreInfo ? _buildMoreInfo() : _buildDebugInfo(),
        ],
      ),
    );
  }

  ListTile _buildTags() {
    return ListTile(
      leading: Icon(Icons.label),
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Tags'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Voltar'),
                  )
                ],
                content: Container(
                  height: 300,
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.expense.tags.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        dense: true,
                        title: Align(
                          child: TagChip.fromTag(widget.expense.tags[index]),
                        ),
                      );
                    },
                  ),
                ),
              );
            });
      },
      title: Wrap(
        runSpacing: 6,
        spacing: 6,
        children: _buildTagChips(),
      ),
    );
  }

  ListTile _buildDescription() {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text(widget.expense.description),
    );
  }

  ListTile _buildSubcategory() {
    return ListTile(
      leading: Icon(widget.expense.subcategory.icon, color: widget.expense.subcategory.color),
      title: Text(widget.expense.subcategory.name),
    );
  }

  ListTile _buildCategory() {
    return ListTile(
      leading: Icon(widget.expense.subcategory.parent.icon,
          color: widget.expense.subcategory.parent.color),
      title: Text(widget.expense.subcategory.parent.name),
    );
  }

  ListTile _buildValue() {
    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text(MoneyService.format(widget.expense.value)),
    );
  }

  ListTile _buildDate() {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(_df.format(widget.expense.date)),
    );
  }

  Widget _buildMoreInfo() {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text('Ver mais'),
      onTap: () {
        setState(() {
          _isShowingMoreInfo = true;
        });
      },
    );
  }

  Widget _buildDebugInfo() {
    return Column(children: [
      ListTile(
        leading: Icon(Icons.watch_later_outlined),
        title: Text('Criado em'),
        subtitle: Text(widget.expense.createdAt.toString()),
      ),
      ListTile(
        leading: Icon(Icons.watch_later_outlined),
        title: Text('Atualizado em'),
        subtitle: Text(widget.expense.updatedAt.toString()),
      ),
    ]);
  }
}
