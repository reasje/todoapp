import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetitletext_logic.dart';
import 'package:todoapp/app/logic/theme_provider.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../../applocalizations.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: isLandscape ? w * 0.06 : h * 0.06,
      margin: EdgeInsets.only(top: h * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(h * 0.016)),
      ),
      child: TextField(
        controller: _noteTitleTextLogic.state.titleController,
        focusNode: _noteTitleTextLogic.state.titleFocusNode,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: _themeProvider.swashColor,
        cursorHeight: h * 0.055,
        style: TextStyle(
            color: _themeProvider.textColor, fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00006, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: _themeProvider.isEn ? h * w * 0.00004 : h * w * 0.00003),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                _noteTitleTextLogic.clearTitle();
              },
            ),
            hintText:  locale.titleHint.tr,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: _themeProvider.hinoteColor.withOpacity(0.12),
                fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00006,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
