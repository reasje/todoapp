import 'package:hive/hive.dart';
// run flutter packages pub run build_runner build to generate the dependency
part 'task_model.g.dart';

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool isDone;
  Task(this.title, this.isDone);
}