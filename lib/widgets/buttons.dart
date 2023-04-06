import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/settings/settings_logic.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

class ButtonWidget extends StatefulWidget {
  final IconData iconData;
  final double sizePU;
  final double sizePD;
  final double iconSize;
  final Function function;
  final BuildContext timerContext;
  final Color backgroundColor;
  final bool hasFloating;
  final Widget child;
  const ButtonWidget(
      {Key key,
      this.sizePU,
      this.sizePD,
      this.iconSize,
      this.iconData,
      this.function,
      this.timerContext,
      this.backgroundColor,
      this.hasFloating,
      this.child})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<ButtonWidget> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final _signInProvider = Provider.of<SettingsLogic>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = widget.backgroundColor;
    // bool floating =
    //     widget.id == 'newpic' || widget.id == 'newvoice' || widget.id == 'pausevoice' || widget.id == 'stopvoice' || widget.id == 'resumevoice';
    var shaded = widget.hasFloating ? Colors.transparent : backgroundColor.withOpacity(0.1);
    IconData iconData = widget.iconData;
    double iconSize = widget.iconSize;
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            isTapped == true ? isTapped = false : isTapped = true;
          });
          Future.delayed(Duration(milliseconds: 150), () {
            setState(() {
              isTapped == true ? isTapped = false : isTapped = true;
            });
          });
          // if (mounted) {
          //   setState(() {
          //     Future.delayed(Duration(milliseconds: 100), () async {
          //       final _noteLogic = Provider.of<NoteProvider>(context, listen: false);
          //       final _signInProvider = Provider.of<SettingsLogic>(context, listen: false);
          //       final _connState = Provider.of<ConnectionLogic>(context, listen: false);
          //       final _noteImageLogic = Get.find<NoteImageLogic>();
          //       final _noteVoiceRecorderProvider = Provider.of<NoteVoiceRecorderProvider>(context, listen: false);
          //       final _noteTitleTextProvider = Provider.of<NoteTitleTextProvider>(context, listen: false);
          //       final _noteColorLogic = Provider.of<NoteColorLogic>(context, listen: false);
          //       final _donateProvider = Provider.of<DonateProvider>(context, listen: false);
          //       final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          //       double h = MediaQuery.of(context).size.height;
          //       double w = MediaQuery.of(context).size.width;
          //       LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
          //       // switch (widget.id) {
          //       //   case 'new':
          //       //     await _noteLogic.newNoteClicked(context);
          //       //     Navigator.push(context, SliderTransition(NoteScreen()));
          //       //     break;
          //       //   case 'setting':
          //       //     Navigator.push(context, SliderTransition(SettingsScreen()));
          //       //     break;
          //       // }
          //     });
          //   });
          // }
        },
        child: Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 50),
            curve: Curves.fastLinearToSlowEaseIn,
            height: isTapped ? widget.sizePD * 0.4 : widget.sizePU,
            width: isTapped ? widget.sizePD * 0.4 : widget.sizePU,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shaded,
              //borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            // padding: EdgeInsets?.all(4),
            child: widget.child ?? Icon(widget.iconData, size: widget.iconSize, color: backgroundColor),
          ),
        ));
  }
}

class SliderTransition extends PageRouteBuilder {
  final Widget page;
  SliderTransition(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: Duration(milliseconds: 1500),
            reverseTransitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(curve: Curves.fastLinearToSlowEaseIn, parent: animation, reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
                child: page,
              );
            });
}
