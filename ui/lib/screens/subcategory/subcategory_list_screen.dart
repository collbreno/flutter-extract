// import 'package:business/business.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ui/bloc/entity_mutable_list_cubit.dart';
// import 'package:ui/navigation/page_transitions.dart';
// import 'package:ui/navigation/screen.dart';
//
// class SubcategoryListScreen extends StatelessWidget implements Screen {
//   static Route route() {
//     return AndroidTransition(SubcategoryListScreen._());
//   }
//
//   const SubcategoryListScreen._({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EntityListCubit<Subcategory>(
//         watchAllUseCase: context.read<WatchSubcategoriesUseCase>(),
//         deleteUseCase: context.read<DeleteSubcategoryUseCase>(),
//         editItemCallback: (item) => Navigator.of(context).push(SubcategoryFormScreen.route(item)),
//         openItemCallback: (item) {},
//       ),
//     );
//   }
// }
