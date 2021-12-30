import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/tag_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';

class TagFormScreen extends StatelessWidget implements Screen {
  final Tag? tag;

  const TagFormScreen._({Key? key, this.tag}) : super(key: key);

  static Route route([Tag? tag]) {
    return AndroidTransition(TagFormScreen._(tag: tag));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TagFormCubit(
        insertTag: context.read<InsertTagUseCase>(),
        updateTag: context.read<UpdateTagUseCase>(),
        tag: tag,
      ),
      child: EntityFormBuilder<TagFormCubit>(
        onOpenEntity: (value) {},
        titleWhenCreating: 'Criar Tag',
        titleWhenEditing: 'Editar Tag',
      ),
    );
  }
}
