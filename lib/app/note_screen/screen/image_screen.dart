import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../applocalizations.dart';
import '../../../widgets/dialog.dart';

enum TextSize { small, large }

class PicDetail extends StatefulWidget {
  final index;
  const PicDetail({Key key, this.index}) : super(key: key);

  @override
  _PicDetailState createState() => _PicDetailState();
}

class _PicDetailState extends State<PicDetail> {
  bool _showButton = true;
  Timer timer;
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
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _noteImageLogic = Get.find<NoteImageLogic>();
    var isWhite = _themeProvider.checkIsWhite();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    int textLength = _noteImageLogic.imageList[widget.index].desc.length;
    TextSize textSize;
    if (textLength >= 415) {
      textSize = TextSize.large;
    } else {
      textSize = TextSize.small;
    }
    return Scaffold(
      backgroundColor: _themeProvider.mainColor,
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
                        _noteImageLogic.imageList[widget.index].image,
                      )),
                ),
              ),
              _noteImageLogic.imageList[widget.index].desc != ''
                  ? Positioned(
                      bottom: h * 0,
                      child: Container(
                        width: w,
                        padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: h * 0.01),
                        decoration: BoxDecoration(color: _themeProvider.textColor.withOpacity(0.1)),
                        child: Text(
                          textSize == TextSize.large
                              ? _noteImageLogic.imageList[widget.index].desc.substring(0, 410) + '...'
                              : _noteImageLogic.imageList[widget.index].desc,
                          softWrap: true,
                          style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: _themeProvider.isEn ? h * w * 0.00006 : h * w * 0.00004,
                              fontWeight: _themeProvider.isEn ? FontWeight.w100 : FontWeight.w600),
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
                  backgroundColor: isWhite ? _themeProvider.blackMainColor : _themeProvider.whiteMainColor,
                  child: Icon(FontAwesome.rotate_right),
                  onPressed: () async {
                    var result = await FlutterImageCompress.compressWithList(_noteImageLogic.imageList[widget.index].image, rotate: 90);
                    _noteImageLogic.rotateImage(result, widget.index);
                  },
                ),
                FloatingActionButton(
                  elevation: 0,
                  heroTag: 'btn2',
                  backgroundColor: isWhite ? _themeProvider.blackMainColor : _themeProvider.whiteMainColor,
                  child: Icon(Icons.text_fields),
                  onPressed: () async {
                    TextEditingController dialogController = TextEditingController();
                    showAlertDialog(context,
                        title: AppLocalizations.of(context).translate('imageDesc'),
                        desc: _noteImageLogic.imageList[widget.index].desc ?? null,
                        textFieldMaxLength: 415,
                        hastTextField: true,
                        textFieldhintText: AppLocalizations.of(Get.overlayContext).translate('imageDesc'),
                        okButtonText: AppLocalizations.of(context).translate('ok'),
                        cancelButtonText: AppLocalizations.of(context).translate('cancel'), okButtonFunction: () {
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
