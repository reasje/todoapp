import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/noteimage_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

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
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _noteImageProvider = Provider.of<NoteImageProvider>(context, listen: false);
    var isWhite = _themeProvider.checkIsWhite();
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
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
        onTap: () {
          if (_showButton) {
            _showButton = false;
            timer.cancel();
          } else {
            _showButton = true;
            timer.cancel();
            timer = Timer(Duration(seconds: 5), () {
              _showButton = false;
              setState(() {});
            });
          }

          setState(() {});
        },
        child: Container(
          height: SizeX,
          width: SizeY,
          child: Stack(
            children: [
              Positioned(
                top: SizeX * 0.1,
                height: SizeX * 0.7,
                width: SizeY,
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
                      bottom: SizeX * 0,
                      child: Container(
                        width: SizeY,
                        padding: EdgeInsets.symmetric(
                            vertical: SizeX * 0.01, horizontal: SizeX * 0.01),
                        decoration: BoxDecoration(
                            color: _themeProvider.textColor.withOpacity(0.1)),
                        child: Text(
                          textSize == TextSize.large
                              ? _noteImageProvider.imageList[widget.index].desc
                                      .substring(0, 410) +
                                  '...'
                              : _noteImageProvider.imageList[widget.index].desc,
                          softWrap: true,
                          style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: _themeProvider.isEn
                                  ? SizeX * SizeY * 0.00006
                                  : SizeX * SizeY * 0.00004,
                              fontWeight: _themeProvider.isEn
                                  ? FontWeight.w100
                                  : FontWeight.w600),
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
                  backgroundColor: isWhite
                      ? _themeProvider.blackMainColor
                      : _themeProvider.whiteMainColor,
                  child: Icon(FontAwesome.rotate_right),
                  onPressed: () async {
                    var result = await FlutterImageCompress.compressWithList(
                        _noteImageProvider.imageList[widget.index].image,
                        rotate: 90);
                    _noteImageProvider.rotateImage(result, widget.index);
                  },
                ),
                FloatingActionButton(
                  elevation: 0,
                  heroTag: 'btn2',
                  backgroundColor: isWhite
                      ? _themeProvider.blackMainColor
                      : _themeProvider.whiteMainColor,
                  child: Icon(Icons.text_fields),
                  onPressed: () async {
                    uiKit.showAlertDialog(context,
                        id: 'imageDesc',
                        index: widget.index,
                        desc: _noteImageProvider.imageList[widget.index].desc ?? null);
                  },
                ),
              ],
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
