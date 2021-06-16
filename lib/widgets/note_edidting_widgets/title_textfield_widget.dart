import 'package:flutter/material.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
class titleTextField extends StatelessWidget {
  const titleTextField({
    Key key,
    @required this.isLandscape,
    @required this.SizeY,
    @required this.SizeX,
    @required ThemeProvider themeProvider,
    @required NoteProvider myProvider,
  }) : _themeProvider = themeProvider, _myProvider = myProvider, super(key: key);

  final bool isLandscape;
  final double SizeY;
  final double SizeX;
  final ThemeProvider _themeProvider;
  final NoteProvider _myProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLandscape ? SizeY * 0.09 : SizeX * 0.09,
      margin: EdgeInsets.all(SizeX * 0.02),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeX * 0.016)),
        boxShadow: [
          BoxShadow(
            color: _themeProvider.lightShadowColor,
            offset: Offset(2, 2),
            blurRadius: 0.0,
            // changes position of shadow
          ),
          BoxShadow(
            color: _themeProvider.shadowColor.withOpacity(0.14),
            offset: Offset(-1, -1),
          ),
          BoxShadow(
            color: _themeProvider.mainColor,
            offset: Offset(5, 8),
            spreadRadius: -0.5,
            blurRadius: 14.0,
            // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: _myProvider.title,
        focusNode: _myProvider.fTitle,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: _themeProvider.swachColor,
        cursorHeight: SizeX * 0.055,
        style: TextStyle(
            color: _themeProvider.textColor,
            fontSize: _themeProvider.isEn
                ? SizeX * SizeY * 0.00012
                : SizeX * SizeY * 0.0001,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(_themeProvider.isEn
                ? SizeX * SizeY * 0.00004
                : SizeX * SizeY * 0.00003),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                _myProvider.clearTitle();
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
                    ? SizeX * SizeY * 0.00012
                    : SizeX * SizeY * 0.0001,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}