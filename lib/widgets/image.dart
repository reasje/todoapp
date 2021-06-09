import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';

class PicDetail extends StatefulWidget {
  final index;
  const PicDetail({Key key, this.index}) : super(key: key);

  @override
  _PicDetailState createState() => _PicDetailState();
}

class _PicDetailState extends State<PicDetail> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    var isWhite = _themeProvider.checkIsWhite();

    return Scaffold(
      backgroundColor: _themeProvider.mainColor,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
              tag: 'imageHero',
              transitionOnUserGestures: true,
              child: Image.memory(
                _myProvider.imageList[widget.index],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isWhite
            ? _themeProvider.blackMainColor
            : _themeProvider.whiteMainColor,
        child: Icon(FontAwesome.rotate_right),
        onPressed: () async {
          var result = await FlutterImageCompress.compressWithList(
              _myProvider.imageList[widget.index],
              rotate: 90);
          setState(() {
            _myProvider.imageList[widget.index] = result;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
