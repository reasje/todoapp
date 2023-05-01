import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
class NoteImageState {
  // used for both loading images and taking images
  final picker = ImagePicker();

  // list of images that will be loaded on user tap
  RxList<imageModel.Image> imageList = <imageModel.Image>[].obs;
  RxList<imageModel.Image> imageListSnapshot = <imageModel.Image>[].obs ;

  Rx<imageModel.Image?> _dismissedImage = null.obs;
  set dismissedImage(imageModel.Image? value) => _dismissedImage.value = value;
  imageModel.Image? get dismissedImage => _dismissedImage.value;
  
  Rx<PickedFile?> _image = null.obs;
  set image(PickedFile? value) => _image.value = value;
  PickedFile? get image => _image.value;
  NoteImageState();
}