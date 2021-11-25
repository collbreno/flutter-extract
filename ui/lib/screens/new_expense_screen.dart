import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/list_tile_utils.dart';
import 'package:ui/common/tag_chip.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';

class NewExpenseScreen extends StatefulWidget implements Screen {
  static Route route() {
    return AndroidTransition(NewExpenseScreen());
  }
  final Expense? expenseToEdit;

  const NewExpenseScreen({
    Key? key,
    this.expenseToEdit,
  }) : super(key: key);

  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subcategoryKey = GlobalKey<FormFieldState<Subcategory>>();
  final _categoryKey = GlobalKey<FormFieldState<Category>>();
  final _brlCurrency = CommonCurrencies().brl;
  final _availableCategories = [
    Category(id: '', name: 'Transporte', color: Colors.purple, icon: Icons.directions_bus),
    Category(id: '', name: 'Barney', color: Colors.brown, icon: Icons.pets),
    Category(id: '', name: 'Alimentação', color: Colors.amber, icon: Icons.restaurant),
    Category(id: '', name: 'Saúde', color: Colors.red, icon: Icons.healing),
    Category(id: '', name: 'Lazer', color: Colors.blue, icon: Icons.sports_soccer),
  ];
  late final _availableSubcategories = [
    Subcategory(
        id: '',
        name: 'Aluguel',
        icon: Icons.car_rental,
        color: Colors.grey[900]!,
        parent: _availableCategories.first),
    Subcategory(
        id: '',
        name: 'Metrô',
        icon: Icons.directions_subway,
        color: Colors.deepPurple,
        parent: _availableCategories.first),
    Subcategory(
        id: '',
        name: 'Uber',
        icon: Icons.directions_car,
        color: Colors.black,
        parent: _availableCategories.first),
    Subcategory(
        id: '',
        name: 'Ônibus',
        icon: Icons.directions_bus,
        color: Colors.green[800]!,
        parent: _availableCategories.first),
  ];
  final _paymentMethods = [
    PaymentMethod(id: '', name: 'Crédito', color: Colors.purple, icon: Icons.credit_card),
    PaymentMethod(id: '', name: 'Débito', color: Colors.purple, icon: Icons.credit_card),
    PaymentMethod(id: '', name: 'Dinheiro', color: Colors.green, icon: Icons.money),
  ];
  final _stores = [
    Store(id: '', name: 'Santa Marta'),
    Store(id: '', name: 'Zona Sul'),
    Store(id: '', name: 'Americanas'),
    Store(id: '', name: 'Burger King'),
    Store(id: '', name: 'Steam'),
  ];

  late ExpenseBuilder _expenseBuilder;
  late FocusNode _descriptionFocusNode;
  final tags = [
    Tag(id: '', name: 'Almoço', color: Colors.grey),
    Tag(id: '', name: 'Splid', color: Colors.grey, icon: Icons.horizontal_split),
    Tag(id: '', name: 'Fluminense', color: Colors.grey),
    Tag(id: '', name: 'Maracanã', color: Colors.grey, icon: Icons.sports_soccer),
    Tag(id: '', name: 'Amanda', color: Colors.pink, icon: Icons.favorite),
  ];
  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    _expenseBuilder = widget.expenseToEdit?.toBuilder() ?? ExpenseBuilder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _descriptionFocusNode.unfocus();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo gasto"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildValue(),
              _buildDate(),
              _buildCategory(),
              _buildSubcategory(),
              _buildPaymentMethod(),
              _buildStore(),
              _buildDescription(),
              _buildTags(),
              _buildFiles(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStore() {
    return PickerFormField<Store>(
      items: _stores,
      showRemoveButton: true,
      hintText: 'Selecione a loja',
      leading: Icon(Icons.store),
      dialogItemBuilder: (store) => ListTile(
        title: Text(store.name),
        leading: Icon(Icons.store),
      ),
      formFieldWidgetBuilder: (store) => FormFieldWidget(
        child: Text(store.name),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return PickerFormField<PaymentMethod>(
      items: _paymentMethods,
      hintText: 'Selecione a forma de pagamento',
      leading: Icon(Icons.account_balance_wallet),
      showRemoveButton: true,
      validator: NotNullValidator('Forma de pagamento'),
      dialogItemBuilder: (pm) => ListTile(
        title: Text(pm.name),
        leading: Icon(pm.icon, color: pm.color),
      ),
      formFieldWidgetBuilder: (pm) => FormFieldWidget(
        child: Text(pm.name),
        prefixIcon: Icon(pm.icon, color: pm.color),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {},
            child: Text('Rascunho'),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.validate();
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return MultiPickerFormField<Tag>(
      leading: Icon(Icons.label),
      items: tags,
      hintText: 'Selecione as tags',
      onSearch: (tag, text) => tag.name.contains(text),
      dialogItemBuilder: (tag, checkbox) => ListTile(
        title: Align(child: TagChip.fromTag(tag), alignment: Alignment.centerLeft),
        trailing: checkbox,
      ),
      formFieldWidgetBuilder: (tags) => Wrap(
        spacing: 4,
        runSpacing: 4,
        children: tags.map((tag) => TagChip.fromTag(tag)).toList(),
      ),
    );
  }

  Widget _buildDescription() {
    return ListTileTextFormField(
      focusNode: _descriptionFocusNode,
      minLines: 1,
      hintText: 'Insira a descrição',
      keyboardType: TextInputType.multiline,
      leading: Icon(Icons.edit),
      maxLines: 4,
    );
  }

  Widget _buildDate() {
    return DateFormField(
      hintText: 'Selecione a data',
      validator: NotNullValidator('Data'),
    );
  }

  Widget _buildCategory() {
    return PickerFormField<Category>(
      key: _categoryKey,
      leading: SizedBox(),
      items: _availableCategories,
      hintText: 'Selecione a categoria',
      validator: NotNullValidator('Categoria'),
      onChanged: (category) {
        setState(() {
          _subcategoryKey.currentState?.didChange(null);
        });
      },
      dialogItemBuilder: (category) => CategoryListTile(category),
      formFieldWidgetBuilder: (category) => FormFieldWidget(
        child: Text(category.name),
        prefixIcon: Icon(category.icon, color: category.color),
      ),
    );
  }

  Widget _buildSubcategory() {
    return PickerFormField<Subcategory>(
      key: _subcategoryKey,
      enabled: _categoryKey.currentState?.value != null,
      leading: SizedBox(),
      hintText: 'Selecione a subcategoria',
      items: _availableSubcategories,
      validator: NotNullValidator('Subcategoria'),
      dialogItemBuilder: (subcategory) => SubcategoryListTile(subcategory),
      formFieldWidgetBuilder: (subcategory) => FormFieldWidget(
        child: Text(subcategory.name),
        prefixIcon: Icon(subcategory.icon, color: subcategory.color),
      ),
    );
  }

  Widget _buildValue() {
    return MoneyFormField(
      currency: _brlCurrency,
      hintText: 'Selecione o valor',
      initialValue: _expenseBuilder.value,
      validator: (value) {
        if (value == null) return 'Valor é obrigatório';
        if (value <= 0) return 'Valor deve ser maior que zero';
        return null;
      },
    );
  }

  Widget _buildFiles() {
    return FilePickerFormField();
  }
}
