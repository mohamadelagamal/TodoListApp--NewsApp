import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/todo_app/states.dart';

import '../../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

// Add your methods here
  static AppCubit get(context) => BlocProvider.of(context);

  Database?database; // database is a variable of type Database used to store the database object
  int currentIndex = 0; // used to store the current index of the selected screen

  List<Map> newTasks = []; // a list of maps used to store the new tasks
  List<Map> doneTasks = []; // a list of maps used to store the done tasks
  List<Map> archivedTasks = []; // a list of maps used to store the archived tasks
  List<Widget> screens = [
    // a list of widgets that will be displayed in the body of the scaffold
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    // a list of strings that will be displayed in the app bar
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  bool isBottomSheetShown = false; // a boolean variable used to check if the bottom sheet is shown or not
  IconData fabIcon = Icons.edit; // a variable of type IconData used to store the icon of the floating action button

  Future<void> createDataBase() async {
    // Add your createDataBase code here!
      openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
        print('table created');
      },
      onOpen: (database) {},
    ).then((value) => {
      database = value,
      emit(AppCreateDataBaseState(database)),
        if (database != null)
          {
            getTasks()
          }
      });
  }

  Future<void>insertTask({
    required String title,
    required String date,
    required String time,

}) async {

    await database?.transaction((txn) async{
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState(value));
        getTasks();
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
    });
  }
  void getTasks()  {
     newTasks = [];
     doneTasks = [];
     archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    if (database != null) {
      database!.query('tasks')..then((value) {
        newTasks = value;

        for (var element in value) {
          if (element['status'] == 'done') {
            doneTasks.add(element);
          } else if (element['status'] == 'archived') {
            archivedTasks.add(element);
          }
        }
        emit(AppGetDataBaseState(value));
      });
    } else {
      print('Database is null in getTasks()');
    }
  }
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState(index)); // emit the new state with the new index
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateTask({required String status, required int id}) {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then((value) {
      getTasks();
    });
  }
  void deleteTask({required int id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getTasks();
    });
  }
  Future<void> updateTaskData({String? title, String? date, String? time, int? id}) async {
    if (title != null && date != null && time != null && id != null) {
      // Check if database is null
      if(database == null) {
      createDataBase();

      }
      // Update the task data
      if(database != null) {
        await database!.rawUpdate('UPDATE tasks SET title = ?, date = ?, time = ? WHERE id = ?', [title, date, time, id]);
        getTasks();
        emit(AppUpdateDataBaseState());
        print('updated successfully');
      } else {
        print('Database is null in updateTaskData()');
      }
    } else {
      print('One or more parameters are null');
    }
  }

}
