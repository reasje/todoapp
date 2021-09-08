import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class noNotes extends StatelessWidget {
  const noNotes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    return Container(
      height: SizeX * 0.7,
      child: Column(
        children: [
          Container(
            height: SizeX * 0.45,
            width: SizeY * 0.8,
            child: Padding(
              padding: EdgeInsets.only(top: SizeX * 0.019),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: SizeX * 0.1,
                    width: SizeY * 0.7,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeXSizeY * 0.0001),
                        color: _themeProvider.textColor.withOpacity(0.1)),
                    child: Center(
                      child: Text(
                        uiKit.AppLocalizations.of(context)
                            .translate('NoNotesyet'),
                        style: TextStyle(
                            color: _themeProvider.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeY * 0.06),
                      ),
                    ),
                  ),
                  Container(
                    height: SizeX * 0.1,
                    width: SizeY * 0.9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeXSizeY * 0.0001),
                        color: _themeProvider.textColor.withOpacity(0.1)),
                    child: Center(
                      child: Text(
                        uiKit.AppLocalizations.of(context)
                            .translate('addNewNotePlease'),
                        style: TextStyle(
                            color: _themeProvider.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: _themeProvider.isEn
                                ? SizeY * 0.06
                                : SizeY * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
