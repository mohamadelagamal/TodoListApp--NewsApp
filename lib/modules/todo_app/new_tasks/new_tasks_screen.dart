
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/components/Constants.dart';
import 'package:todo/shared/components/todo_app/components.dart';
import 'package:todo/shared/cubit/todo_app/cubit.dart';
import 'package:todo/shared/cubit/todo_app/states.dart';


class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // TODO: implement builder
        var tasks = AppCubit.get(context).newTasks;

        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
