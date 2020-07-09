import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/storage/task_storage.dart';
import 'package:first_team_project/locator.dart';
import 'package:first_team_project/ui/util/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator<TaskStorage>().refreshTaskList();
  MainModel().updateGlobalStats();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        title: 'Not yet discussed',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Quicksand'),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
