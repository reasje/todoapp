import 'package:hive/hive.dart';
// ran flutter packages pub run build_runner build to generate the dependency
part 'note_model.g.dart';

@HiveType(typeId:0)
class Note {
  @HiveField(0)
  String title;
  @HiveField(1)
  String text;
  @HiveField(2)
  bool isChecked;
  Note(
    this.title,
    this.text,
    this.isChecked,
  );

}
