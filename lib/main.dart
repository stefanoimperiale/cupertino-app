import 'package:babynames/model/app_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'model/app_state_model.dart';

void main() {
  runApp( ChangeNotifierProvider<AppStateModel>(
    create: (context) => AppStateModel()..loadProducts(),
    child: CupertinoStoreApp(),
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]);
}