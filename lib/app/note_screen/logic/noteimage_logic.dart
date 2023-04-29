import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import '../state/note_image_state.dart';


class NoteImageLogic extends GetxController {
  NoteImageState state = NoteImageState();
  // Show the image picker dilog
  void initialImageList(List<imageModel.Image?>? givenImageList) {
    state.imageList = givenImageList as RxList<imageModel.Image?>?;
  }
  Future<void> updateImageDesc(int index, String desc) async {
    state.imageList![index]!.desc = desc;
  }
  void initialImageListSnapshot() {
    state.imageListSnapshot = List.from(state.imageList!) as RxList<imageModel.Image>;
  }

  void clearImageList() {
    state.imageList!.clear();
  }

  Future<void> imagePickerGalley() async {
    state.image = await state.picker.getImage(source: ImageSource.gallery);
    if (state.image != null) {
      var h = await state.image!.readAsBytes();
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
      state.imageList!.add(imageModel.Image(h, ''));
    }
  }

  Future<void> imagePickerCamera() async {
    state.image = await state.picker.getImage(source: ImageSource.camera);
    if (state.image != null) {
      var h = await state.image!.readAsBytes();
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
      state.imageList!.add(imageModel.Image(h, ''));
    }
  }

  void imageDissmissed(index) {
    state.dismissedImage = state.imageList!.removeAt(index);
  }

  void imageRecover(index) {
    state.imageList!.insert(index, state.dismissedImage);
  }

  void rotateImage(Uint8List image, int index) {
    state.imageList![index]!.image = image;
  }

  Future<List<imageModel.Image?>?>? getImageList() async {
    return state.imageList;
  }
}
