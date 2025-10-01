import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_app/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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

  void addTask() async {
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
  }

  @override
  Widget build(BuildContext context) {
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
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    TextFormField(
                      controller: titlecontroller,
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
                      controller: descriptioncontroller,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 7,
                        children: List.generate(colors.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = index;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: colors[index],
                              child: selectedColor == index
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 26,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : null,
                            ),
                          );
                        }),
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
                  if (formkey.currentState!.validate()) {
                    addTask();
                  }
                },
                child: Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
