import 'dart:async';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:googleapis/cloudbuild/v1.dart';

import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';

import '../../../applocalizations.dart';
import '../../../widgets/dialog.dart';

enum TextSize { small, large }

class PicDetail extends StatefulWidget {
  final index;
  const PicDetail({Key? key, this.index}) : super(key: key);

  @override
  _PicDetailState createState() => _PicDetailState();
}

class _PicDetailState extends State<PicDetail> {
  bool _showButton = true;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    // For hiding button
    timer = Timer(Duration(seconds: 5), () {
      _showButton = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final _themeLogic = Get.find<ThemeLogic>();
    final _themeState = _themeLogic.state;
    final _noteImageLogic = Get.find<NoteImageLogic>();
    var isWhite = _themeLogic.checkIsWhite();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    int textLength = _noteImageLogic.state.imageList[widget.index].desc!.length;
    TextSize textSize;
    if (textLength >= 415) {
      textSize = TextSize.large;
    } else {
      textSize = TextSize.small;
    }
    return Scaffold(
      backgroundColor: _themeState.mainColor,
      body: InkWell(
        onTap: helli,
        child: Container(
          height: h,
          width: w,
          child: Stack(
            children: [
              Positioned(
                top: h * 0.1,
                height: h * 0.7,
                width: w,
                child: Center(
                  child: Hero(
                      tag: 'imageHero',
                      transitionOnUserGestures: true,
                      child: Image.memory(
                        _noteImageLogic.state.imageList[widget.index].image!,
                      )),
                ),
              ),
              _noteImageLogic.state.imageList[widget.index].desc != ''
                  ? Positioned(
                      bottom: h * 0,
                      child: Container(
                        width: w,
                        padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: h * 0.01),
                        decoration: BoxDecoration(color: _themeState.textColor!.withOpacity(0.1)),
                        child: Text(
                          textSize == TextSize.large
                              ? _noteImageLogic.state.imageList[widget.index].desc!.substring(0, 410) + '...'
                              : _noteImageLogic.state.imageList[widget.index].desc!,
                          softWrap: true,
                          style: TextStyle(
                              color: _themeState.textColor,
                              fontSize: _themeState.isEn! ? h * w * 0.00006 : h * w * 0.00004,
                              fontWeight: _themeState.isEn! ? FontWeight.w100 : FontWeight.w600),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: _showButton
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  elevation: 0,
                  heroTag: 'btn1',
                  backgroundColor: _themeState.mainOpColor,
                  child: Icon(Icons.rotate_right),
                  onPressed: () async {
                    var result = await FlutterImageCompress.compressWithList(_noteImageLogic.state.imageList[widget.index].image!, rotate: 90);
                    _noteImageLogic.rotateImage(result, widget.index);
                  },
                ),
                FloatingActionButton(
                  elevation: 0,
                  heroTag: 'btn2',
                  backgroundColor: _themeState.mainOpColor,
                  child: Icon(Icons.text_fields),
                  onPressed: () async {
                    TextEditingController dialogController = TextEditingController();
                    showAlertDialog(
                        title: locale.imageDesc.tr,
                        desc: _noteImageLogic.state.imageList[widget.index].desc ?? null,
                        textFieldMaxLength: 415,
                        hastTextField: true,
                        textFieldhintText: locale.imageDesc.tr,
                        okButtonText: locale.ok.tr,
                        cancelButtonText: locale.cancel.tr,
                        okButtonFunction: () {
                          _noteImageLogic.updateImageDesc(widget.index, dialogController.text);
                        });
                  },
                ),
              ],
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void helli() {}
}
