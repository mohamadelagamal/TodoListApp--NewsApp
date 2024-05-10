
abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {
  final int index;

  AppChangeBottomNavBarState(this.index);

}

class AppCreateDataBaseState extends AppStates {
  final database;

  AppCreateDataBaseState(this.database);
}
class AppInsertDataBaseState extends AppStates {
  final int id;

  AppInsertDataBaseState(this.id);
}
class AppGetDataBaseState extends AppStates {
  final List<Map> tasks;

  AppGetDataBaseState(this.tasks);
}

class AppChangeBottomSheetState  extends AppStates{

}
class AppGetDatabaseLoadingState extends AppStates {

}
class AppUpdateDataBaseState extends AppStates {

}
