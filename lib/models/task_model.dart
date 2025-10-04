import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  bool isCompleted;
  @HiveField(4)
  int color;

  TaskModel({
    required this.title,
    this.description = 'No Description',
    required this.createdAt,
    this.isCompleted = false,
    this.color = 0,
  });
}
