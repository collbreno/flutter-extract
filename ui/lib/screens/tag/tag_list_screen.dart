import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/entity_list_builder.dart';
import 'package:ui/common/tag_chip.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/screens/tag/tag_form_screen.dart';

class TagListScreen extends StatelessWidget {
  const TagListScreen._({Key? key}) : super(key: key);

  static Route route() {
    return AndroidTransition(TagListScreen._());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EntityListCubit<Tag>(
        watchAllUseCase: context.read<WatchTagsUseCase>(),
        deleteUseCase: context.read<SafeDeleteTagUseCase>(),
        editItemCallback: (item) => Navigator.of(context).push(TagFormScreen.route(item)),
        openItemCallback: (item) {
          // TODO: implement
          print('open item');
        },
      ),
      child: EntityListBuilder<Tag>(
        appBarTitle: 'Tags',
        onAddPressed: () => Navigator.of(context).push(TagFormScreen.route()),
        itemBuilder: (context, item, selected) {
          return ListTile(
            dense: true,
            title: Align(
              alignment: Alignment.centerLeft,
              child: TagChip.fromTag(item),
            ),
            selected: selected,
            trailing: AnimatedScale(
              duration: Duration(milliseconds: 100),
              scale: selected ? 1 : 0,
              child: Icon(
                Icons.check,
                key: ValueKey(item.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
