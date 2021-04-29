import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class MyDoante extends StatefulWidget {
  double SizeX;
  double SizeY;
  MyDoante({Key key, this.SizeX, this.SizeY}) : super(key: key);

  @override
  _MyDoanteState createState() => _MyDoanteState();
}

class _MyDoanteState extends State<MyDoante> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    double SizeX = widget.SizeX;
    double SizeY = widget.SizeY;
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(30),
            child: uiKit.MyButton(
              sizePU: SizeX * 0.07,
              sizePD: SizeX * 0.08,
              iconSize: SizeX * SizeY * 0.0001,
              iconData: FontAwesome.check,
              id: 'menu',
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            color: _myProvider.textColor,
                            fontSize: _myProvider.isEn ? SizeX * SizeY * 0.00009 : SizeX * SizeY * 0.000075,
                            fontWeight: FontWeight.w100),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: SizeX*0.008),
                        child: Text(
                          '@Rezaaslejeddian@gmail.com',
                          style: TextStyle(
                              color: _myProvider.textColor,
                              fontSize: _myProvider.isEn ? SizeX * SizeY * 0.00005 : SizeX * SizeY * 0.00006,
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
            flex: 3,
            child: Center(
              child: uiKit.MyButton(
                sizePU: SizeX * 0.1,
                sizePD: SizeX * 0.1,
                iconSize: SizeX * SizeY * 0.00014,
                iconData: FontAwesome.dollar,
                id: 'donate',
              ),
            ))
      ],
    );
  }
}
