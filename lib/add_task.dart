import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/models/task_model.dart';
import 'package:tasks_app/providers/add_task_provider.dart';

class AddTask extends StatelessWidget {
  final TaskModel? task;
  final int? index;
  const AddTask({super.key, this.task, this.index});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddTaskProvider()..fillData(task),
      builder: (context, child) {
        final addtaskprovider = context.read<AddTaskProvider>();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add a new task',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Column(
                children: [
                  Form(
                    key: addtaskprovider.formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        TextFormField(
                          controller: addtaskprovider.titlecontroller,
                          decoration: InputDecoration(
                            labelText: 'Task title',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Task title is required";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          controller: addtaskprovider.descriptioncontroller,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Task Description',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose task color:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Consumer<AddTaskProvider>(
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 7,
                                children: List.generate(
                                  addtaskprovider.colors.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        value.changeColor(index);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            addtaskprovider.colors[index],
                                        child:
                                            addtaskprovider.selectedColor ==
                                                index
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 26,
                                                fontWeight: FontWeight.bold,
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(18),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(25),
                      ),
                    ),
                    onPressed: () {
                      if (addtaskprovider.formkey.currentState!.validate()) {
                        addtaskprovider.addTask(context);
                      }
                    },
                    child: Text("Add Task"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
