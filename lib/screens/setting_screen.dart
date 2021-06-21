import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    return Scaffold(
      backgroundColor: _themeProvider.mainColor,
      body: SafeArea(
        child: Container(
          height: SizeX,
          width: SizeY,
          child: Column(
            children: [
              Container(
                height: SizeX * 0.05,
                width: double.maxFinite,
                margin: EdgeInsets.only(top: SizeX * 0.02),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    uiKit.MyButton(
                      backgroundColor: _themeProvider.textColor,
                      sizePU: SizeXSizeY * 0.00017,
                      sizePD: SizeXSizeY * 0.00018,
                      iconSize: SizeX * SizeY * 0.00008,
                      iconData: Icons.arrow_back_ios,
                      id: 'menu',
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(SizeX * SizeY * 0.00008),
                child: Column(
                  children: [
                    Container(
                        height: SizeXSizeY * 0.00025,
                        width: SizeXSizeY * 0.0006,
                        decoration: BoxDecoration(
                            color: _themeProvider.textColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(SizeXSizeY * 0.0001)),
                        child: Center(
                          child: Text(
                            uiKit.AppLocalizations.of(context)
                                .translate('googleBackup'),
                            style: TextStyle(
                                color: _themeProvider.textColor,
                                fontSize: SizeXSizeY * 0.0001),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.all(SizeX * 0.035),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(SizeXSizeY * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: uiKit.MyButton(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: SizeXSizeY * 0.00012,
                              sizePD: SizeXSizeY * 0.00013,
                              iconSize: SizeX * SizeY * 0.00006,
                              iconData: FontAwesome.download,
                              id: 'download',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(SizeXSizeY * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: uiKit.MyButton(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: SizeXSizeY * 0.00012,
                              sizePD: SizeXSizeY * 0.00013,
                              iconSize: SizeX * SizeY * 0.00006,
                              iconData: FontAwesome.upload,
                              id: 'upload',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(SizeXSizeY * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: uiKit.MyButton(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: SizeXSizeY * 0.00012,
                              sizePD: SizeXSizeY * 0.00013,
                              iconSize: SizeX * SizeY * 0.00006,
                              iconData: FontAwesome.google,
                              id: 'google',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: SizeXSizeY * 0.00025,
                  width: SizeXSizeY * 0.0006,
                  decoration: BoxDecoration(
                      color: _themeProvider.textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(SizeXSizeY * 0.0001)),
                  child: Center(
                    child: Text(
                      uiKit.AppLocalizations.of(context)
                          .translate('theme'),
                      style: TextStyle(
                          color: _themeProvider.textColor,
                          fontSize: SizeXSizeY * 0.0001),
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(SizeX * 0.035),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      uiKit.MyButton(
                        backgroundColor: _themeProvider.textColor,
                        sizePU: SizeXSizeY * 0.00017,
                        sizePD: SizeXSizeY * 0.00018,
                        iconSize: SizeX * SizeY * 0.0001,
                        iconData: FontAwesome.language,
                        id: 'lan',
                      ),
                      uiKit.MyButton(
                        backgroundColor: _themeProvider.textColor,
                        sizePU: SizeXSizeY * 0.00017,
                        sizePD: SizeXSizeY * 0.00018,
                        iconSize: SizeX * SizeY * 0.0001,
                        iconData: FontAwesome.lightbulb_o,
                        id: 'lamp',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
