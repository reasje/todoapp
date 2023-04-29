import 'dart:typed_data';

import 'package:hive/hive.dart';
// run flutter packages pub run build_runner build to generate the dependency
part 'image_model.g.dart';

@HiveType(typeId: 3)
class Image {
  @HiveField(0)
  Uint8List? image;
  @HiveField(1)
  String? desc;
  Image(this.image, this.desc);
}