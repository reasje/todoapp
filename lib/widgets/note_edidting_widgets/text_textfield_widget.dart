import 'package:flutter/material.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;


class textTextField extends StatelessWidget {
  const textTextField({
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
      height: isLandscape ? SizeY * 0.5 : SizeX * 0.5,
      margin: EdgeInsets.all(SizeX * 0.02),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeX * 0.016)),
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
            fontSize: SizeX * SizeY * 0.00009,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                _myProvider.clearText();
              },
            ),
            contentPadding:
                EdgeInsets.all(SizeX * SizeY * 0.00006),
            hintText: uiKit.AppLocalizations.of(context)
                .translate('textHint'),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color:
                    _themeProvider.hintColor.withOpacity(0.12),
                fontSize: SizeX * SizeY * 0.00009,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}