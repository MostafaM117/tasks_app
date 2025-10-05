import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/add_task.dart';
import 'package:tasks_app/models/task_model.dart';
import 'package:tasks_app/providers/add_task_provider.dart';
import 'package:tasks_app/providers/app_provider.dart';
import 'package:tasks_app/providers/task_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..getTasks(),
      builder: (context, child) {
        final taskprovider = context.read<TaskProvider>();
        final appprovider = context.read<AppProvider>();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Task Manager"),
            actions: [
              IconButton(
                onPressed: () {
                  appprovider.setIsDark();
                },
                icon: Icon(Icons.dark_mode),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTask()),
              );
              if (result != null && result) {
                taskprovider.getTasks();
              }
            },
            child: Icon(Icons.add, size: 28),
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: Consumer<TaskProvider>(
              builder: (context, value, child) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final task = taskprovider.tasks[index];
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddTask(task: task, index: index),
                          ),
                        );
                        if (result != null && result) {
                          taskprovider.getTasks();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(task.color),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                taskprovider.changeTaskStatus(
                                  index,
                                  value ?? false,
                                );
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                taskprovider.deleteTask(index);
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemCount: taskprovider.tasks.length,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
