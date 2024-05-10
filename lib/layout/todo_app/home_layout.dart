
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/todo_app/components.dart';
import 'package:todo/shared/cubit/todo_app/cubit.dart';
import 'package:todo/shared/cubit/todo_app/states.dart';

class HomeLayout extends StatelessWidget {
  // GlobalKey is a class that is used to create a global key that can be used to access the state of a widget from outside the widget itself
  var scaffoldKey = GlobalKey<
      ScaffoldState>(); // used to access the scaffold widget from the code to show snack bar
  var formKey = GlobalKey<
      FormState>(); // used to access the form widget from the code to validate the form

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          // TODO: implement builder
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            // assign the scaffold key to the scaffold widget
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Colors.blue,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // show bottom sheet
                if (!cubit.isBottomSheetShown) {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Add Task',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextField(
                                    controller: titleController,
                                    change: (String value) {
                                      // turn off the error message when the user starts typing
                                      formKey.currentState!.validate();
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Task Title',
                                      icon: Icon(Icons.title),
                                    ),
                                    type: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    onTap: () {
                                      print('title tapped');
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextField(
                                    controller: timeController,
                                    isClickable: true,
                                    change: (String value) {
                                      // turn off the error message when the user starts typing
                                      formKey.currentState!.validate();
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Task Time',
                                      icon: Icon(Icons.watch_later_outlined),
                                    ),
                                    type: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    onTap: () {
                                      // time picker
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then(
                                        (value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                          formKey.currentState!.validate();
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextField(
                                    controller: dateController,
                                    isClickable: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Task Date',
                                      icon: Icon(Icons.calendar_today_outlined),
                                    ),
                                    type: TextInputType.text,
                                    change: (String value) {
                                      // turn off the error message when the user starts typing
                                      formKey.currentState!.validate();
                                    },
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    onTap: () {
                                      // date picker
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                      ).then(
                                        (value) {
                                          dateController.text = value!
                                              .toString()
                                              .substring(0, 10);
                                          print(value);
                                          formKey.currentState!.validate();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);

                    // });
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                  // });
                  // send state to new task screen
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.insertTask(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    )
                        .then((value) {
                      print('inserted successfully');
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);

                      //  setState(() {

                      // });
                    }).catchError((error) {
                      print(
                          'error when inserting new record ${error.toString()}');
                    });
                  }
                  // close bottom sheet
                }
              },
              tooltip: 'Increment',
              backgroundColor: Colors.blue,
              shape: CircleBorder(),
              child: Icon(cubit.fabIcon, color: Colors.white),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Archived',
                ),
              ],
              selectedItemColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                //  setState(() {
                //currentIndex = index;
                cubit.changeIndex(index);
                //  });
              },
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
          );
        },
      ),
    );
  }
}
