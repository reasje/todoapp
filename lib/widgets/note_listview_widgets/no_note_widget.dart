import 'package:flutter/material.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
class noNotes extends StatelessWidget {
  const noNotes({
    Key key,
    @required this.SizeX,
    @required this.SizeY,
    @required ThemeProvider themeProvider,
  }) : _themeProvider = themeProvider, super(key: key);

  final double SizeX;
  final double SizeY;
  final ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeX * 0.7,
      child: Column(
        children: [
          Container(
            height: SizeX * 0.45,
            width: SizeY * 0.8,
            child: Padding(
              padding:
                  EdgeInsets.only(top: SizeX * 0.019),
              child: Container(
                height: SizeX * 0.45,
                width: SizeY,
                child: Image.asset(
                  _themeProvider.noTaskImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            //padding: EdgeInsets.only(bottom: SizeX * 0.2),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                Text(
                  uiKit.AppLocalizations.of(context)
                      .translate('NoNotesyet'),
                  style: TextStyle(
                      color: _themeProvider.textColor,
                      fontWeight: FontWeight.w400,
                      fontSize:
                          SizeX * SizeY * 0.00008),
                ),
                Text(
                  uiKit.AppLocalizations.of(context)
                      .translate('addNewNotePlease'),
                  style: TextStyle(
                      color: _themeProvider.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: _themeProvider.isEn
                          ? SizeX * SizeY * 0.00008
                          : SizeX * SizeY * 0.00006),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}