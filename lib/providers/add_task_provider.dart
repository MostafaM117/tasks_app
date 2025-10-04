import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_app/models/task_model.dart';

class AddTaskProvider extends ChangeNotifier {
  final formkey = GlobalKey<FormState>();
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.tealAccent,
    Colors.amber,
    Colors.cyan,
    Colors.teal,
  ];
  int selectedColor = 0;

  void addTask(BuildContext context) async {
    final box = await Hive.openBox<TaskModel>('tasksBox');
    final task = TaskModel(
      title: titlecontroller.text,
      description: descriptioncontroller.text.isNotEmpty
          ? descriptioncontroller.text
          : 'No Description',
      createdAt: DateTime.now(),
      color: colors[selectedColor].value,
    );
    await box.add(task);
    print("Task added successfully");
    Navigator.pop(context, true);
    notifyListeners();
  }

  void changeColor(int index) {
    selectedColor = index;
    notifyListeners();
  }

  void fillData(TaskModel? task) {
    if (task != null) {
      titlecontroller.text = task.title;
      descriptioncontroller.text = task.description;
      selectedColor = colors.indexWhere((color) => color.value == task.color);
    }
  }
}
