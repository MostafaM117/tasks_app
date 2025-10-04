import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_app/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  void getTasks() async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    tasks = box.values.toList();
    notifyListeners();
  }

  void deleteTask(int index) async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    await box.deleteAt(index);
    getTasks();
    notifyListeners();
  }

  void changeTaskStatus(int index, bool value) async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    final task = tasks[index];
    task.isCompleted = value;
    await box.putAt(index, task);
    getTasks();
    notifyListeners();
  }
}
