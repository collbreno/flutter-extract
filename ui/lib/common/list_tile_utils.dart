import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/tag_chip.dart';

abstract class ListTileItem extends StatelessWidget {
  Widget get title => throw UnimplementedError();
  Widget? get trailing => null;
  Widget? get leading => null;

  ListTile build(BuildContext context) {
    return ListTile(
      title: title,
      leading: leading,
      trailing: trailing,
    );
  }
}

class CategoryListTile extends ListTileItem {
  final Category category;

  CategoryListTile(this.category);
  @override
  Widget? get leading => Icon(category.icon, color: category.color);

  @override
  Widget get title => Text(category.name);
}

class SubcategoryListTile extends ListTileItem {
  final Subcategory subcategory;

  SubcategoryListTile(this.subcategory);
  @override
  Widget? get leading => Icon(subcategory.icon, color: subcategory.color);

  @override
  Widget get title => Text(subcategory.name);
}

class TitledListTile extends ListTileItem {
  final String text;

  TitledListTile(this.text);

  @override
  Widget get title => Text(text);
}

class TagListTile extends ListTileItem {
  final Tag tag;

  TagListTile(this.tag);

  @override
  Widget get title => Align(alignment: Alignment.centerLeft, child: TagChip.fromTag(tag));
}
