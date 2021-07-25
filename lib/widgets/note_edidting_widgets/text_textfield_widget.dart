import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/notetitletext_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class textTextField extends StatelessWidget {
  const textTextField({
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
      height: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: SizeY*0.025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(SizeX * 0.016)),
      ),
      child: TextField(
        controller: _noteTitleTextProvider.text,
        focusNode: _noteTitleTextProvider.ftext,
        onChanged: (newVal) {
          _noteTitleTextProvider.listenerActivated(newVal);
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: _themeProvider.swachColor,
        cursorHeight: SizeX * 0.045,
        style: TextStyle(
            color: _themeProvider.textColor,
            fontSize: _themeProvider.isEn
                ? SizeX * SizeY * 0.00008
                : SizeX * SizeY * 0.00006,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                _noteTitleTextProvider.clearText();
              },
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: _themeProvider.isEn
                    ? SizeX * SizeY * 0.00004
                    : SizeX * SizeY * 0.00003,
                vertical: _themeProvider.isEn
                    ? SizeX * SizeY * 0.00004
                    : SizeX * SizeY * 0.00003),
            hintText:
                uiKit.AppLocalizations.of(context).translate('textHint'),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: _themeProvider.hintColor.withOpacity(0.12),
                fontSize: _themeProvider.isEn
                    ? SizeX * SizeY * 0.00007
                    : SizeX * SizeY * 0.00005,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
