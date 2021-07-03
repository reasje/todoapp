import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/notetitletext_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
class titleTextField extends StatelessWidget {
  const titleTextField({
    Key key,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
            final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _noteTitleTextProvider = Provider.of<NoteTitleTextProvider>(context, listen: false);
        double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      
      height: isLandscape ? SizeY * 0.06 : SizeX * 0.06,
      margin: EdgeInsets.only(top: SizeX* 0.04),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeX * 0.016)),
      ),
      child: TextField(
        controller: _noteTitleTextProvider.title,
        focusNode: _noteTitleTextProvider.fTitle,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: _themeProvider.swachColor,
        cursorHeight: SizeX * 0.055,
        style: TextStyle(
            
            color: _themeProvider.textColor,
            fontSize: _themeProvider.isEn
                ? SizeX * SizeY * 0.00008
                : SizeX * SizeY * 0.00006,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal:  _themeProvider.isEn
                ? SizeX * SizeY * 0.00004
                : SizeX * SizeY * 0.00003),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                _noteTitleTextProvider.clearTitle();
              },
            ),
            hintText: uiKit.AppLocalizations.of(context)
                .translate('titleHint'),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color:
                    _themeProvider.hintColor.withOpacity(0.12),
                fontSize: _themeProvider.isEn
                    ?  SizeX * SizeY * 0.00008
                    :  SizeX * SizeY * 0.00006,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}