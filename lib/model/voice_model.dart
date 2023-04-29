import 'dart:typed_data';

import 'package:hive/hive.dart';
// run flutter packages pub run build_runner build to generate the dependency
part 'voice_model.g.dart';

@HiveType(typeId: 1)
class Voice {
  @HiveField(0)
  String? title;
  @HiveField(1)
  Uint8List? voice;

  Voice(this.title, this.voice);

  // factory Note.fromJson(Map<String, dynamic> json) {
  //   return Note(json['title'], json['text'], false, json['time'], null, null);
  // }
}