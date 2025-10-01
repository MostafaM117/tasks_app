import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_app/add_task.dart';
import 'package:tasks_app/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> tasks = [];
  void getTasks() async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    setState(() {
      tasks = box.values.toList();
    });
  }

  void deleteTask(int index) async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    await box.deleteAt(index);
    getTasks();
  }

  void changeTaskStatus(int index, bool value) async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    final task = tasks[index];
    task.isCompleted = value;
    await box.putAt(index, task);
    getTasks();
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Manager"),
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
          if (result != null && result) {
            getTasks();
          }
        },
        child: Icon(Icons.add, size: 28),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Container(
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
                      changeTaskStatus(index, value ?? false);
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteTask(index);
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 15),
          itemCount: tasks.length,
        ),
      ),
    );
  }
}
