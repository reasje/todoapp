import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;

class NoteImageProvider with ChangeNotifier {
  // list of images that will be loaded on user tap
  List<imageModel.Image> imageList = [];
  List<imageModel.Image> imageListSnapshot = [];
  imageModel.Image dismissedImage;
  // used for both loading images and taking images
  final picker = ImagePicker();
  PickedFile _image;
  // Show the image picker dilog
  void initialImageList(List<imageModel.Image> givenImageList) {
    imageList = givenImageList;
  }
  Future<void> updateImageDesc(int index, String desc) async {
    imageList[index].desc = desc;
    notifyListeners();
  }
  void initialImageListSnapshot() {
    imageListSnapshot = List.from(imageList);
  }

  void clearImageList() {
    imageList.clear();
  }

  Future<void> imagePickerGalley() async {
    _image = await picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      var h = await _image.readAsBytes();
      var fileSize = h.lengthInBytes;
      if (fileSize > 300000) {
        if (fileSize < 5000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 60,
          );
        } else if (fileSize < 10000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 50,
          );
        } else if (fileSize < 15000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 40,
          );
        } else {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 30,
          );
        }
      }
      imageList.add(imageModel.Image(h, ''));
    }
    notifyListeners();
  }

  Future<void> imagePickerCamera() async {
    _image = await picker.getImage(source: ImageSource.camera);
    if (_image != null) {
      var h = await _image.readAsBytes();
      var fileSize = h.lengthInBytes;
      if (fileSize > 300000) {
        if (fileSize < 5000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 60,
          );
        } else if (fileSize < 10000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 50,
          );
        } else if (fileSize < 15000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 40,
          );
        } else {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 30,
          );
        }
      }
      imageList.add(imageModel.Image(h, ''));
    }
    notifyListeners();
  }

  void imageDissmissed(index) {
    dismissedImage = imageList.removeAt(index);
    notifyListeners();
  }

  void imageRecover(index) {
    imageList.insert(index, dismissedImage);
    notifyListeners();
  }

  void rotateImage(Uint8List image, int index) {
    imageList[index].image = image;
    notifyListeners();
  }

  Future<List<imageModel.Image>> getImageList() async {
    return imageList;
  }
}
