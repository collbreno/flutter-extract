import 'package:business/business.dart';
import 'package:business/src/reducers/settings_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ui/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Store<AppState>(
      SettingsReducer(),
      middleware: [SettingsMiddleware()],
      initialState: AppState.initialState(),
    );
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, Brightness>(
        converter: (store) => store.state.brightness,
        builder: (context, brightness) {
          return MaterialApp(
            title: 'Extract',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.blue[800],
              brightness: brightness,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
