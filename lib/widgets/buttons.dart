import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/conn_provider.dart';

import 'package:todoapp/provider/drive_provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/signin_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

//typedef function = void Function();
const _url = 'https://idpay.ir/todoapp';
const _dogeAdress = 'bnb1g3thz6z0t2gz2fffthdvv6mxpjvgfacp7hfjml';
Future<void> copyDogeAdress() async {
  ClipboardData data = ClipboardData(text: _dogeAdress);
  print(data.text);
  await Clipboard.setData(data);
}

void printMe() {
  print('Hell');
}

class MyButton extends StatefulWidget {
  final IconData iconData;
  final double sizePU;
  final double sizePD;
  final double iconSize;
  final String id;
  final BuildContext timerContext;
  final Color backgroundColor;
  const MyButton(
      {Key key,
      this.sizePU,
      this.sizePD,
      this.iconSize,
      this.iconData,
      this.id,
      this.timerContext,
      this.backgroundColor})
      : super(key: key);
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;
  void onPressedUp(PointerUpEvent event) {
    if (mounted) {
      setState(() {
        isPressed = false;
      });
    }
  }

  void onPressedDown(PointerDownEvent event) {
    if (mounted) {
      setState(() {
        isPressed = true;
        Future.delayed(Duration(milliseconds: 100), () async {
          final _myProvider = Provider.of<NoteProvider>(context, listen: false);
          final _timerState = Provider.of<TimerState>(context, listen: false);
          final _signinState = Provider.of<SigninState>(context, listen: false);
          final _connState = Provider.of<ConnState>(context, listen: false);
          final _themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
          double SizeX = MediaQuery.of(context).size.height;
          double SizeY = MediaQuery.of(context).size.width;
          LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
          switch (widget.id) {
            case 'dogedonate':
              copyDogeAdress();
              _myProvider.showDogeCopied(context);
              break;
            case 'home':
              Navigator.pushReplacement(
                  context, SliderTransition(uiKit.MyRorderable()));
              _themeProvider.changeFirstTime();
              break;
            case 'menu':
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext context) {
              //   return uiKit.Home();
              // }));
              Navigator.pop(context);
              // TODO Delete _myProvider.changeTimerStack();
              break;
            case 'start':
              if (!(_timerState.isRunning.any((element) => element == true))) {
                _timerState.startTimer(context);
              } else {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(uiKit.MySnackBar(
                    uiKit.AppLocalizations.of(context).translate('timerOn'),
                    'timerOn',
                    false,
                    context));
              }

              //startTimer();
              break;
            case 'stop':
              _timerState.stopTimer();
              break;
            case 'reset':
              _timerState.resetTimer(context);
              break;
            case 'redo':
              _myProvider.canRedo ? _myProvider.changesRedo() : null;
              break;
            case 'lan':
              _themeProvider.changeLan();
              break;
            case 'new':
              await _myProvider.newNoteClicked(context);
              Navigator.push(context, SliderTransition(uiKit.MyNotesEditing()));
              break;
            case 'lamp':
              _themeProvider.changeBrigness();
              break;
            case 'undo':
              {
                _myProvider.canUndo ? _myProvider.changesUndo() : null;
              }
              break;
            case 'timer':
              {
                // showCupertinoModalPopup(
                //     context: context,
                //     builder: (context) => Container(
                //           child: CupertinoActionSheet(
                //             actions: [uiKit.MyDatePicker(context)],
                //             cancelButton: Container(
                //               decoration: BoxDecoration(
                //                   color: _themeProvider.mainColor,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(10))),
                //               child: CupertinoActionSheetAction(
                //                 child: Text(uiKit.AppLocalizations.of(context)
                //                     .translate('done')),
                //                 onPressed: () {
                //                   _myProvider.timerDone();
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ),
                //           ),
                //         ));

                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Color(0xFF737373),
                        height: SizeX * 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                              color: _themeProvider.mainColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: uiKit.MyDatePicker(context),
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      uiKit.AppLocalizations.of(context)
                                          .translate('done'),
                                      style: TextStyle(
                                          color: _themeProvider.titleColor
                                              .withOpacity(0.6),
                                          fontSize: _themeProvider.isEn
                                              ? SizeX * SizeY * 0.00007
                                              : SizeX * SizeY * 0.00006),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).then((value) => _myProvider.timerDone());
              }
              break;

            case 'color':
              List<Color> colors = _themeProvider.getNoteColors();
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Color(0xFF737373),
                      height: SizeX * 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: _themeProvider.mainColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: SizeX * 0.05,
                                  crossAxisSpacing: SizeX * 0.06,
                                  crossAxisCount: 5),
                          padding: EdgeInsets.all(SizeX * 0.01),
                          children: colors
                              .map((color) => InkWell(
                                    onTap: () {
                                      _myProvider.noteColorSelected(color);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: SizeX * 0.05,
                                      width: SizeX * 0.05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: color),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  });
              break;
            case 'save':
              _myProvider.doneClicked(context);
              break;
            case 'cancel':
              _myProvider.cancelClicked(context);

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext context) {
              //   return uiKit.Home();
              // }));
              break;
            case 'coder':
              Navigator.push(context, SliderTransition(uiKit.MyDoante()));
              // TODO Delete _myProvider.gotoDonate(context);
              break;
            case 'donate':
              _launchURL();
              break;
            case 'upload':
              login(true, context);
              break;
            case 'setting':
              Navigator.push(context, SliderTransition(uiKit.SettingScreen()));
              break;
            case 'download':
              login(false, context);
              break;
            case 'google':
              if (_connState.is_conn) {
                _signinState.signinToAccount();
              } else {
                uiKit.showAlertDialog(context, id: 'internet');
              }
              break;
            case 'newpic':
              // showCupertinoModalPopup(
              //     context: context,
              //     builder: (context) => CupertinoActionSheet(
              //           actions: [
              //             Container(
              //               decoration: BoxDecoration(
              //                   color: _themeProvider.mainColor,
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(10))),
              //               child: CupertinoActionSheetAction(
              //                   onPressed: () {
              //                     _myProvider.imagePickerCamera();
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text('Camera')),
              //             ),
              //             Container(
              //               decoration: BoxDecoration(
              //                   color: _themeProvider.mainColor,
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(10))),
              //               child: CupertinoActionSheetAction(
              //                   onPressed: () {
              //                     _myProvider.imagePickerGalley();
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text('Gallery')),
              //             )
              //           ],
              //         ));
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Color(0xFF737373),
                      height: SizeX * 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: _themeProvider.mainColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    _myProvider.imagePickerCamera();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    uiKit.AppLocalizations.of(context)
                                        .translate('camera'),
                                    style: TextStyle(
                                        color: _themeProvider.titleColor
                                            .withOpacity(0.6),
                                        fontSize: _themeProvider.isEn
                                            ? SizeX * SizeY * 0.00008
                                            : SizeX * SizeY * 0.00007),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    _myProvider.imagePickerGalley();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    uiKit.AppLocalizations.of(context)
                                        .translate('gallery'),
                                    style: TextStyle(
                                        color: _themeProvider.titleColor
                                            .withOpacity(0.6),
                                        fontSize: _themeProvider.isEn
                                            ? SizeX * SizeY * 0.00008
                                            : SizeX * SizeY * 0.00007),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
              break;
            case 'newvoice':
              await _myProvider.startRecorder(context);
              break;
            case 'pausevoice':
              await _myProvider.pauseRecorder();
              break;
            case 'stopvoice':
              await _myProvider.stopRecorder(context: context);
              break;
            case 'resumevoice':
              await _myProvider.resumeRecorder();
              break;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _signinState = Provider.of<SigninState>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = widget.backgroundColor;
    bool floating = widget.id == 'newpic' ||
        widget.id == 'newvoice' ||
        widget.id == 'pausevoice' ||
        widget.id == 'stopvoice' ||
        widget.id == 'resumevoice';
    var shaded =
        floating ? Colors.transparent : backgroundColor.withOpacity(0.1);
    return Listener(
      onPointerUp: onPressedUp,
      onPointerDown: onPressedDown,
      // TODO if hovered more then the funrciton not to be executed
      child: isPressed
          ? AnimatedContainer(
              duration: Duration(seconds: 1),
              height: widget.sizePD,
              width: widget.sizePD,
              padding: EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shaded,
                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: widget.id == 'dogedonate'
                    ? Image.asset(
                        'assets/images/dogecoin.png',
                        fit: BoxFit.fill,
                      )
                    : Icon(
                        widget.iconData,
                        size: widget.iconSize * 0.8,
                        color: widget.id == 'google'
                            ? _signinState.isSignedin
                                ? Colors.green
                                : Colors.red
                            : floating
                                ? backgroundColor
                                : backgroundColor,
                      ),
              ),
            )
          : AnimatedContainer(
              duration: Duration(seconds: 1),
              height: widget.sizePU,
              width: widget.sizePU,
              decoration: BoxDecoration(
                color: shaded,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: widget.id == 'dogedonate'
                  ? Image.asset(
                      'assets/images/dogecoin.png',
                      fit: BoxFit.fill,
                    )
                  : Icon(widget.iconData,
                      textDirection: TextDirection.ltr,
                      size: widget.iconSize,
                      color: widget.id == 'google'
                          ? _signinState.isSignedin
                              ? Colors.green
                              : Colors.red
                          : floating
                              ? backgroundColor
                              : backgroundColor),
            ),
    );
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
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                child: page,
              );
            });
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
