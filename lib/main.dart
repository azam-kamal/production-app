import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'providers/planClass.dart';
import 'providers/printClass.dart';
import 'providers/finishClass.dart';
import 'providers/glueClass.dart';
import 'providers/dieClass.dart';
import './screens/dashboard.dart';
import './screens/plan.dart';
import './screens/print.dart';
import './screens/glue.dart';
import './screens/finish.dart';
import './screens/die.dart';
import './screens/addPlan.dart';
import './screens/addPrint.dart';
import './screens/addGlue.dart';
import './screens/addDie.dart';
import './screens/addFinish.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            // create:(ctx) => Products(),
            value: Plans(),
          ),
          ChangeNotifierProvider.value(
            // create:(ctx) => Products(),
            value: Prints(),
          ),
          ChangeNotifierProvider.value(
            // create:(ctx) => Products(),
            value: Diess(),
          ),
          ChangeNotifierProvider.value(
            // create:(ctx) => Products(),
            value: Glues(),
          ),
          ChangeNotifierProvider.value(
            // create:(ctx) => Products(),
            value: Finishs(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
              //primarySwatch: Colors.purple,
              primaryColor: Colors.black),
          home: Dashboard(),
          routes: {
            PlanPage.routeName: (ctx) => PlanPage(),
            PrintPage.routeName: (ctx) => PrintPage(),
            GluePage.routeName: (ctx) => GluePage(),
            FinishPage.routeName: (ctx) => FinishPage(),
            DiePage.routeName: (ctx) => DiePage(),
            AddPlan.routeName: (ctx) => AddPlan(),
            AddPrint.routeName: (ctx) => AddPrint(),
            AddGlue.routeName: (ctx) => AddGlue(),
            AddFinish.routeName: (ctx) => AddFinish(),
            AddDie.routeName: (ctx) => AddDie(),
          },
        ));
  }
}
