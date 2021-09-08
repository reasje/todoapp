import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/conn_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;



class ReorderableListButtonsWidget extends StatelessWidget {
  const ReorderableListButtonsWidget({
    Key key,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
        final _connState = Provider.of<ConnState>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          top: SizeX * 0.03,
                          bottom: SizeX * 0.03,
                          left: SizeX * 0.03),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        uiKit.AppLocalizations.of(context)
                            .translate('notesApp'),
                        style: TextStyle(
                            color: _themeProvider
                                .titleColor
                                .withOpacity(0.6),
                            fontSize: _themeProvider.isEn
                                ? SizeY * 0.09
                                : SizeY * 0.07),
                      )),
                  Container(
                    child: Icon(
                      FontAwesome.dot_circle_o,
                      size: SizeX * SizeY * 0.00005,
                      color: _connState.is_conn
                          ? Colors.green.withOpacity(0.6)
                          : Colors.red.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  uiKit.MyButton(
                    backgroundColor:
                        _themeProvider.textColor,
                    iconData: Icons.settings,
                    iconSize: SizeX * SizeY * 0.00005,
                    sizePD: SizeY * 0.1,
                    sizePU: SizeY * 0.1,
                    id: 'setting',
                  ),
                  Container(
                    padding: EdgeInsets.all(
                        SizeXSizeY * 0.00004),
                    alignment: Alignment.centerLeft,
                    child: uiKit.MyButton(
                      backgroundColor:
                          _themeProvider.textColor,
                    sizePD: SizeY * 0.1,
                    sizePU: SizeY * 0.1,
                      iconSize: SizeX * SizeY * 0.00006,
                      iconData: FontAwesome.code,
                      id: 'coder',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}