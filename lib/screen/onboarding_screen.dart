import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'home_screen.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class Onboarding extends StatefulWidget {
  Onboarding({Key key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPage = 0;
  PageController _pageController =
      new PageController(initialPage: 0, keepPage: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () => uiKit.showAddDialog(context));
  }
  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _myProvider = Provider.of<myProvider>(context);
    
    return Scaffold(
      backgroundColor: _myProvider.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: SizeX*0.082, right: 30),
              child: uiKit.MyButton(
                sizePU: SizeX * 0.07,
                sizePD: SizeX * 0.08,
                iconSize: SizeX * SizeY * 0.0001,
                iconData: FontAwesome.check,
                id: 'home',
              ),
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
                        controller: _pageController,
                        children: [
                          onBoardPage(
                              "paradise",
                              uiKit.AppLocalizations.of(context)
                                  .translate('paradiseTitle'),
                              uiKit.AppLocalizations.of(context)
                                  .translate('paradise'),
                              SizeX,
                              SizeY),
                          onBoardPage(
                              "plant",
                              uiKit.AppLocalizations.of(context)
                                  .translate('plantTitle'),
                              uiKit.AppLocalizations.of(context)
                                  .translate('plant'),
                              SizeX,
                              SizeY),
                          onBoardPage(
                              "deepwork",
                              uiKit.AppLocalizations.of(context)
                                  .translate('deepWorkTitle'),
                              uiKit.AppLocalizations.of(context)
                                  .translate('deepWork'),
                              SizeX,
                              SizeY),
                          onBoardPage(
                              "pioritize",
                              uiKit.AppLocalizations.of(context)
                                  .translate('pioritizeTitle'),
                              uiKit.AppLocalizations.of(context)
                                  .translate('pioritize'),
                              SizeX,
                              SizeY),
                          onBoardPage(
                              "family",
                              uiKit.AppLocalizations.of(context)
                                  .translate('familyTitle'),
                              uiKit.AppLocalizations.of(context)
                                  .translate('family'),
                              SizeX,
                              SizeY),
                        ],
                        onPageChanged: (value) => {setCurrentPage(value)},
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(5, (index) => getIndicator(index)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
      
      duration: Duration(milliseconds: 200),
      height: 10,
      width: (currentPage == pageNo) ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: (currentPage == pageNo) ? Colors.black : Colors.grey),
    );
  }

  Column onBoardPage(
      String img, String title, String text, double SizeX, double SizeY) {
    return Column(
      children: [
        Container(
          height: SizeX * 0.45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage('assets/images/$img.png'))),
        ),
        Container(
          //padding: EdgeInsets.only(top: SizeX * 0.0005),
          child: Text(
            title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: SizeX * 0.02, right: SizeY * 0.03, left: SizeY * 0.03),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {});
  }
}
