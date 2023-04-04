import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/buttons.dart';
import '../../../donate/screen/donate_screen.dart';
import '../../../logic/connection_provider.dart';

class ReOrderableListButtonsWidget extends StatelessWidget {
  const ReOrderableListButtonsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _connState = Provider.of<ConnectionProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: h * 0.03, bottom: h * 0.03, left: h * 0.03),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).translate('notesApp'),
                        style: TextStyle(color: _themeProvider.titleColor.withOpacity(0.6), fontSize: _themeProvider.isEn ? w * 0.09 : w * 0.07),
                      )),
                  Container(
                    child: Icon(
                      FontAwesome.dot_circle_o,
                      size: h * w * 0.00005,
                      color: _connState.is_conn ? Colors.green.withOpacity(0.6) : Colors.red.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                    backgroundColor: _themeProvider.textColor,
                    iconData: Icons.settings,
                    iconSize: h * w * 0.00005,
                    sizePD: w * 0.1,
                    sizePU: w * 0.1,
                    function:(){Navigator.push(context, SliderTransition(DonateScreen()));},
                  ),
                  Container(
                    padding: EdgeInsets.all(h * w * 0.00004),
                    alignment: Alignment.centerLeft,
                    child: ButtonWidget(
                      backgroundColor: _themeProvider.textColor,
                      sizePD: w * 0.1,
                      sizePU: w * 0.1,
                      iconSize: h * w * 0.00006,
                      iconData: FontAwesome.code,
                      function:(){Navigator.push(context, SliderTransition(DonateScreen()));},
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
