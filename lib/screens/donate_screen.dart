import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class MyDoante extends StatefulWidget {
  MyDoante({Key key}) : super(key: key);

  @override
  _MyDoanteState createState() => _MyDoanteState();
}

class _MyDoanteState extends State<MyDoante> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    return Scaffold(
            resizeToAvoidBottomInset: false,
      backgroundColor: _themeProvider.mainColor,
      body: SafeArea(
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
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/coffee.png',
                      fit: BoxFit.cover,
                      height: SizeX * 0.35,
                      width: SizeX * 0.35,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            uiKit.AppLocalizations.of(context).translate('donate'),
                            style: TextStyle(
                                color: _themeProvider.textColor,
                                fontSize: _themeProvider.isEn
                                    ? SizeX * SizeY * 0.00009
                                    : SizeX * SizeY * 0.000075,
                                fontWeight: FontWeight.w100),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeX * 0.008),
                            child: Text(
                              '@Rezaaslejeddian@gmail.com',
                              style: TextStyle(
                                  color: _themeProvider.textColor,
                                  fontSize: _themeProvider.isEn
                                      ? SizeX * SizeY * 0.00005
                                      : SizeX * SizeY * 0.00006,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        uiKit.MyButton(
                          backgroundColor: _themeProvider.textColor,
                          sizePU: SizeX * 0.1,
                          sizePD: SizeX * 0.1,
                          iconSize: SizeX * SizeY * 0.00014,
                          iconData: FontAwesome.dollar,
                          id: 'donate',
                        ),
                        Text(
                          uiKit.AppLocalizations.of(context)
                              .translate('donateRials'),
                          style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize:_themeProvider.isEn
                                  ? SizeX * SizeY * 0.00007
                                  : SizeX * SizeY * 0.00007,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        uiKit.MyButton(
                          backgroundColor: _themeProvider.textColor,
                          sizePU: SizeX * 0.1,
                          sizePD: SizeX * 0.1,
                          iconSize: SizeX * SizeY * 0.00014,
                          iconData: FontAwesome.dollar,
                          id: 'dogedonate',
                        ),
                        Text(
                          uiKit.AppLocalizations.of(context)
                              .translate('donateDoge'),
                          style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: _themeProvider.isEn
                                  ? SizeX * SizeY * 0.00007
                                  : SizeX * SizeY * 0.00006,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
