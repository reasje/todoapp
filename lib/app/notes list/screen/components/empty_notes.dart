import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../../applocalizations.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeState = Get.find<ThemeLogic>().state;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: h * 0.7,
      child: Column(
        children: [
          Container(
            height: h * 0.45,
            width: w * 0.8,
            child: Padding(
              padding: EdgeInsets.only(top: h * 0.019),
              child: Container(
                height: h * 0.45,
                width: w,
                child: Image.asset(
                  _themeState.noTaskImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              //padding: EdgeInsets.only(bottom: h * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: h * 0.1,
                    width: w * 0.7,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(h * w * 0.0001), color: _themeState.textColor!.withOpacity(0.1)),
                    child: Center(
                      child: Text(
                        locale.NoNotesyet.tr,
                        style: TextStyle(color: _themeState.textColor, fontWeight: FontWeight.w400, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                  Container(
                    height: h * 0.1,
                    width: w * 0.9,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(h * w * 0.0001), color: _themeState.textColor!.withOpacity(0.1)),
                    child: Center(
                      child: Text(
                        locale.addNewNotePlease.tr,
                        style: TextStyle(color: _themeState.textColor, fontWeight: FontWeight.w500, fontSize: _themeState.isEn! ? w * 0.06 : w * 0.04),
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
