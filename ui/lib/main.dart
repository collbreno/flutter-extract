import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:business/business.dart';
import 'package:drift_inspector/drift_inspector.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ui/common/app_theme.dart';
import 'package:ui/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await _openDatabase();

  final driftInspectorBuilder = DriftInspectorBuilder()
    ..addDatabase('database', database)
    ..bundleId = 'com.coll.extractapp.ui';
  final inspector = driftInspectorBuilder.build();

  await inspector.start();

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp(this.database, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _createProviders(database),
      child: ThemeProvider(
        initTheme: AppTheme.initTheme,
        builder: (context, theme) {
          return MaterialApp(
            title: 'Extract',
            theme: theme,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

Future<AppDatabase> _openDatabase() async {
  final documents = await getTemporaryDirectory();
  final path = join(documents.path, 'database.sqlite');
  return AppDatabase.fromFile(File(path));
}

List<Provider> _createProviders(AppDatabase db) {
  final categoryRepo = CategoryRepository(db);
  final subcategoryRepo = SubcategoryRepository(db);
  final storeRepo = StoreRepository(db);
  final tagRepo = TagRepository(db);

  return [
    // category use cases
    Provider<InsertCategoryUseCase>(create: (_) => InsertCategoryUseCase(categoryRepo)),
    Provider<UpdateCategoryUseCase>(create: (_) => UpdateCategoryUseCase(categoryRepo)),
    Provider<GetCategoriesUseCase>(create: (_) => GetCategoriesUseCase(categoryRepo)),
    Provider<GetCategoryByIdUseCase>(create: (_) => GetCategoryByIdUseCase(categoryRepo)),
    Provider<WatchCategoryByIdUseCase>(create: (_) => WatchCategoryByIdUseCase(categoryRepo)),
    Provider<WatchCategoriesUseCase>(create: (_) => WatchCategoriesUseCase(categoryRepo)),

    // subcategory use cases
    Provider<InsertSubcategoryUseCase>(create: (_) => InsertSubcategoryUseCase(subcategoryRepo)),
    Provider<UpdateSubcategoryUseCase>(create: (_) => UpdateSubcategoryUseCase(subcategoryRepo)),
    Provider<DeleteSubcategoryUseCase>(create: (_) => DeleteSubcategoryUseCase(subcategoryRepo)),
    Provider<GetSubcategoryByIdUseCase>(create: (_) => GetSubcategoryByIdUseCase(subcategoryRepo)),
    Provider<GetSubcategoriesUseCase>(create: (_) => GetSubcategoriesUseCase(subcategoryRepo)),
    Provider<GetSubcategoriesFromParentUseCase>(
        create: (_) => GetSubcategoriesFromParentUseCase(subcategoryRepo)),

    // store use cases
    Provider<InsertStoreUseCase>(create: (_) => InsertStoreUseCase(storeRepo)),
    Provider<UpdateStoreUseCase>(create: (_) => UpdateStoreUseCase(storeRepo)),

    // tag use cases
    Provider<InsertTagUseCase>(create: (_) => InsertTagUseCase(tagRepo)),
    Provider<UpdateTagUseCase>(create: (_) => UpdateTagUseCase(tagRepo)),
  ];
}
