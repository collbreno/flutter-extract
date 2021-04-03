import 'package:built_collection/built_collection.dart';
import 'package:business/src/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AppState {
  final AsyncSnapshot<BuiltList<Tag>> tags;
  final AsyncSnapshot<BuiltList<IconData>> icons;

  AppState({
    this.tags = const AsyncSnapshot.nothing(),
    this.icons = const AsyncSnapshot.nothing(),
  });
}
