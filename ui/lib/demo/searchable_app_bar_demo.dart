import 'package:flutter/material.dart';
import 'package:ui/common/searchable_app_bar.dart';

class SearchableAppBarDemo extends StatelessWidget {
  const SearchableAppBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchableAppBar(),
      body: Center(child: Text("Just a demo")),
    );
  }
}
