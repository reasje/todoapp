import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:todoapp/app/donate/logic/donate_provider.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';

class DonateScreen extends StatefulWidget {
  DonateScreen({Key? key}) : super(key: key);

  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    final _themeState = Get.find<ThemeLogic>().state;
    final _donateProvider = Get.put(DonateLogic());
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _themeState.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: h * 0.05,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: h * 0.02),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonWidget(
                    backgroundColor: _themeState.textColor,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.arrow_back_ios,
                    function: () {
                      Get.back();
                    },
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
                      height: h * 0.35,
                      width: h * 0.35,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.donate.tr,
                            style: TextStyle(
                                color: _themeState.textColor,
                                fontSize: _themeState.isEn! ? h * w * 0.00009 : h * w * 0.000075,
                                fontWeight: FontWeight.w100),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: h * 0.008),
                            child: Text(
                              '@Rezaaslejeddian@gmail.com',
                              style: TextStyle(
                                  color: _themeState.textColor,
                                  fontSize: _themeState.isEn! ? h * w * 0.00005 : h * w * 0.00006,
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
                        ButtonWidget(
                          backgroundColor: _themeState.textColor,
                          sizePU: h * 0.1,
                          sizePD: h * 0.1,
                          iconSize: h * w * 0.00014,
                          iconData: FontAwesomeIcons.dollar,
                          function: () {
                            Get.find<DonateLogic>().launchURL();
                          },
                        ),
                        Text(
                          locale.donateRials.tr,
                          style: TextStyle(
                              color: _themeState.textColor,
                              fontSize: _themeState.isEn! ? h * w * 0.00007 : h * w * 0.00007,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonWidget(
                          backgroundColor: _themeState.textColor,
                          sizePU: h * 0.1,
                          sizePD: h * 0.1,
                          iconSize: h * w * 0.00014,
                          iconData: FontAwesomeIcons.dollar,
                          function: () {
                            _donateProvider.copyDogeAdress();
                            _donateProvider.showDogeCopied(context);
                          },
                          child: Image.asset(
                            'assets/images/dogecoin.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          locale.donateDoge.tr,
                          style: TextStyle(
                              color: _themeState.textColor,
                              fontSize: _themeState.isEn! ? h * w * 0.00007 : h * w * 0.00006,
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
