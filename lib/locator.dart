import 'package:first_team_project/core/storage/db_helper.dart';
import 'package:first_team_project/core/storage/task_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/models/main_model.dart';

var locator = GetIt.asNewInstance();

void setupLocator(){
  locator.registerSingleton<DBHelper>(DBHelper());
  locator.registerSingleton<TaskStorage>(TaskStorage());
  locator.registerFactory(() => MainModel());
}