import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:todoapp/model/image_model.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/model/voice_model.dart';
// run flutter packages pub run build_runner build to generate the dependency
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? text;
  @HiveField(2)
  bool? isChecked;
  @HiveField(3)
  int? color;
  @HiveField(4)
  List<Image>? imageList;
  @HiveField(5)
  List<Voice>? voiceList;
  @HiveField(6)
  List<Task>? taskList;
  @HiveField(7)
  bool? resetCheckBoxs;
  @HiveField(8)
  String? password;
  Note(
      this.title,
      this.text,
      this.isChecked,
      this.color,
      this.imageList,
      this.voiceList,
      this.taskList,
      this.resetCheckBoxs,
      this.password,
      );
}
