import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
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
  Note(this.title, this.text, this.isChecked, this.time, this.color , this.leftTime);
}
