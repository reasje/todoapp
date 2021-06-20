import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
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
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Expanded(
      child: Container(
        //margin: EdgeInsets.only(top: SizeX * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(SizeX * 0.016)),
        ),
        child: TextField(
          controller: _myProvider.text,
          focusNode: _myProvider.ftext,
          onChanged: (newVal) {
            _myProvider.listenerActivated(newVal);
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
                  _myProvider.clearText();
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
      ),
    );
  }
}
