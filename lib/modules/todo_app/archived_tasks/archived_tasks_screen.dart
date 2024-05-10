
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/todo_app/components.dart';
import 'package:todo/shared/cubit/todo_app/cubit.dart';
import 'package:todo/shared/cubit/todo_app/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // TODO: implement builder
        var tasks = AppCubit.get(context).archivedTasks;
        print('here is the new tasks: $tasks');
        // check if database is null or not
        if (AppCubit.get(context).database == null) {
          AppCubit.get(context).createDataBase();
        }
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
