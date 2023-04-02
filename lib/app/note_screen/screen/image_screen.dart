import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

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
    final _noteImageProvider = Provider.of<NoteImageProvider>(context, listen: false);
    var isWhite = _themeProvider.checkIsWhite();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    int textLength = _noteImageProvider.imageList[widget.index].desc.length;
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
                        _noteImageProvider.imageList[widget.index].image,
                      )),
                ),
              ),
              _noteImageProvider.imageList[widget.index].desc != ''
                  ? Positioned(
                      bottom: h * 0,
                      child: Container(
                        width: w,
                        padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: h * 0.01),
                        decoration: BoxDecoration(color: _themeProvider.textColor.withOpacity(0.1)),
                        child: Text(
                          textSize == TextSize.large
                              ? _noteImageProvider.imageList[widget.index].desc.substring(0, 410) + '...'
                              : _noteImageProvider.imageList[widget.index].desc,
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
                    var result = await FlutterImageCompress.compressWithList(_noteImageProvider.imageList[widget.index].image, rotate: 90);
                    _noteImageProvider.rotateImage(result, widget.index);
                  },
                ),
                FloatingActionButton(
                  elevation: 0,
                  heroTag: 'btn2',
                  backgroundColor: isWhite ? _themeProvider.blackMainColor : _themeProvider.whiteMainColor,
                  child: Icon(Icons.text_fields),
                  onPressed: () async {
                    showAlertDialog(context, id: 'imageDesc', index: widget.index, desc: _noteImageProvider.imageList[widget.index].desc ?? null);
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
