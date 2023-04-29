import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/on_boarding/logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';
import '../../notes list/screen/notes_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _logic = Get.put(OnBoardingLogic());
  final _state = Get.find<OnBoardingLogic>().state;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final _themeLogic = Get.find<ThemeLogic>();
    final _themeState = _themeLogic.state;

    return Scaffold(
      backgroundColor: _themeState.mainColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: h * 0.05,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: h * 0.02),
              alignment: Alignment.centerRight,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                    backgroundColor: _themeState.textColor,
                    sizePU: h * 0.07,
                    sizePD: h * 0.08,
                    iconSize: h * w * 0.0001,
                    iconData: Icons.arrow_forward_ios,
                    function: () {
                      Navigator.pushReplacement(context, SliderTransition(NotesScreen()));
                      _themeLogic.changeFirstTime();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: PageView(
                          controller: _state.pageController,
                          children: [
                            onBoardPage("paradise", locale.paradiseTitle.tr, locale.paradise.tr, h, w),
                            onBoardPage("plant", locale.plantTitle.tr, locale.plant.tr, h, w),
                            onBoardPage("deepwork", locale.deepWorkTitle.tr, locale.deepWork.tr, h, w),
                            onBoardPage("pioritize", locale.pioritizeTitle.tr, locale.pioritize.tr, h, w),
                            onBoardPage("family", locale.familyTitle.tr, locale.family.tr, h, w),
                          ],
                          onPageChanged: (value) => {setCurrentPage(value)},
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) => getIndicator(index)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 10,
      width: (_state.currentPage == pageNo) ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: (_state.currentPage == pageNo) ? Colors.black : Colors.grey),
    );
  }

  Column onBoardPage(String img, String title, String text, double h, double w) {
    return Column(
      children: [
        Container(
          height: h * 0.45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/$img.png'))),
        ),
        Container(
          //padding: EdgeInsets.only(top: h * 0.0005),
          child: Text(
            title,
            style: TextStyle(fontSize: h * w * 0.00008, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: h * 0.02, right: w * 0.03, left: w * 0.03),
          child: Text(
            text,
            style: TextStyle(fontSize: h * w * 0.00005, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  setCurrentPage(int value) {
    _state.currentPage = value;
    setState(() {});
  }
}
