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
  String title;
  @HiveField(1)
  String text;
  @HiveField(2)
  bool isChecked;
  @HiveField(3)
  int time;
  @HiveField(4)
  int color;
  @HiveField(5)
  int leftTime;
  @HiveField(6)
  List<Image> imageList;
  @HiveField(7)
  List<Voice> voiceList;
  @HiveField(8)
  List<Task> taskList;
  @HiveField(9)
  bool resetCheckBoxs;
  Note(this.title, this.text, this.isChecked, this.time, this.color,
      this.leftTime, this.imageList, this.voiceList, this.taskList , this.resetCheckBoxs);

  // factory Note.fromJson(Map<String, dynamic> json) {
  //   return Note(json['title'], json['text'], false, json['time'], null, null);
  // }
}
