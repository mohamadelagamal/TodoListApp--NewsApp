import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/shared/cubit/todo_app/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 10.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
        width: width,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: MaterialButton(
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ));

Widget defaultTextField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? submit,
  Function(String)? change,
  required String? Function(String?) validate,
  required String label,
  IconData? prefix,
  bool isPassword =false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  InputDecoration? decoration,
  Function()? onTap,
  bool isClickable = false,

}) => TextFormField(
  controller: controller,
  onTap: onTap,
  keyboardType: type,
  obscureText: isPassword,
  validator: validate,
  readOnly: isClickable,
  onFieldSubmitted: submit,
  onChanged: change,
  decoration: decoration ?? InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefix),
    suffixIcon: IconButton(
      onPressed: suffixPressed,
      icon: Icon(suffix),
    ),
  )
);

Widget buildTaskItem(Map model,context) => GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a TextEditingController for each field you want to update
        TextEditingController titleController = TextEditingController(text: model['title']);
        TextEditingController timeController = TextEditingController(text: model['time']);
        TextEditingController dateController = TextEditingController(text: model['date']);

        return AlertDialog(
          title: Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              SizedBox(height: 25.0,),
              defaultTextField(
                controller: titleController,
                type: TextInputType.text,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                label: 'Title',
              ),
              SizedBox(height: 25.0,),
              defaultTextField(
                controller: dateController,
                type: TextInputType.text,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                label: 'Date',
              ),
              SizedBox(height: 25.0,),
              defaultTextField(
                controller: timeController,
                type: TextInputType.text,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                label: 'Time',
              ),
            ],
          ),
          actions: <Widget>[
            defaultButton(
              function: () {
                print('Button pressed'); // Debugging line
                AppCubit.get(context).updateTaskData(
                  title: "titleController.text",
                  date: "dateController.text",
                  time: "timeController.text",
                  id: model['id'],
                ).then((value) => {
                  Navigator.of(context).pop()
                });


              },
              text: 'Update',
            ),
          ],
        );
      },
    );
  },
  child: Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [

          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.blue,
            child: Center(
              child: Text(
                '${model['time']}',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0),
          IconButton(
            onPressed: () {
               AppCubit.get(context).updateTask(status: 'done', id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateTask(status: 'archived', id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteTask(id: model['id']);
    },
  ),
);
Widget tasksBuilder({
  required List<Map> tasks,

})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context, index) => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);