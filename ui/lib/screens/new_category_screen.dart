import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/new_category_cubit.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/toggle_buttons_form_field.dart';
import 'package:ui/services/color_service.dart';
import 'package:provider/provider.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _parentKey = GlobalKey();
  late bool _showParent;
  late final NewCategoryCubit _bloc;

  @override
  void initState() {
    _bloc = NewCategoryCubit(
      insertCategory: context.read<InsertCategoryUseCase>(),
      updateCategory: context.read<UpdateCategoryUseCase>(),
      // updateCategory: context.read<Up>()
    );
    super.initState();
    _showParent = false;
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
            body: Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildToggleButtons(),
                        _buildName(),
                        _buildColor(),
                        _buildParent(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _bloc.submit(
                                  id: null,
                                  name: "Teste",
                                  color: Colors.blue,
                                  icon: Icons.directions_bus_filled,
                                  parent: null,
                                );
                              },
                              child: BlocBuilder(
                                bloc: _bloc,
                                builder: (context, state) {
                                  if (state is NewCategoryInitial)
                                    return Text("Save");
                                  else if (state is NewCategoryError)
                                    return Text("Erro");
                                  else if (state is NewCategoryLoading)
                                    return Text("Carregando");
                                  else
                                    throw ArgumentError();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParent() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
      child: _showParent
          ? PickerFormField<String>(
              key: _parentKey,
              items: ['a', 'b'],
              dialogItemBuilder: (text) => ListTile(title: Text(text)),
              formFieldWidgetBuilder: (text) => FormFieldWidget(child: Text(text)),
            )
          : SizedBox(key: _sizedBoxKey),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ToggleButtonsFormField<String>(
        items: [_ToggleButtons.category, _ToggleButtons.subcategory],
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        itemBuilder: (text) => Text(text),
        borderRadius: BorderRadius.circular(4),
        validator: (item) => item == null ? 'Obrigatório' : null,
        onChanged: (value) {
          setState(() {
            _showParent = value == _ToggleButtons.subcategory;
          });
        },
      ),
    );
  }

  Widget _buildName() {
    return ListTileTextFormField(
      leading: Icon(Icons.edit),
      hintText: 'Insira o nome',
    );
  }

  Widget _buildColor() {
    return PickerFormField<Color>(
      items: ColorService.colors.keys.toList(),
      columns: 5,
      leading: Icon(Icons.color_lens),
      dialogItemBuilder: (color) {
        return Container(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: color,
          ),
          margin: EdgeInsets.all(8),
        );
      },
      formFieldWidgetBuilder: (color) {
        return FormFieldWidget(
          child: Text('0x' + color.value.toRadixString(16).toUpperCase()),
          prefixIcon: Icon(
            Icons.circle,
            color: color,
          ),
        );
      },
    );
  }
}

class _ToggleButtons {
  static const category = 'Categoria';
  static const subcategory = 'Subcategory';
}
