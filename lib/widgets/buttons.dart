import 'package:android_alarm_manager/android_alarm_manager.dart';
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

Future<void> startTimer() async {
  print('started');
  await AndroidAlarmManager.oneShotAt(DateTime(2021, 5, 7, 12, 05), 0, printMe);
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
  const MyButton({
    Key key,
    this.sizePU,
    this.sizePD,
    this.iconSize,
    this.iconData,
    this.id,
    this.timerContext,
  }) : super(key: key);
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
          final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
              _timerState.startTimer();
              //startTimer();
              break;
            case 'stop':
              _timerState.stopTimer();
              _timerState.cancelAlarm();
              break;
            case 'reset':
              _timerState.resetTimer();
              break;
            case 'redo':
              _myProvider.canRedo ? _myProvider.changesRedo() : null;
              break;
            case 'lan':
              _themeProvider.changeLan();
              break;
            case 'new':
              await _myProvider.newNoteClicked(context);
              Navigator.push(
                  context,
                  SliderTransition(uiKit.MyNotesEditing(
                      SizeX: SizeX, SizeY: SizeY, noteBox: noteBox)));
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
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                          child: CupertinoActionSheet(
                            actions: [uiKit.MyDatePicker(context)],
                            cancelButton: Container(
                              decoration: BoxDecoration(
                                  color: _themeProvider.mainColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: CupertinoActionSheetAction(
                                child: Text(uiKit.AppLocalizations.of(context)
                                    .translate('done')),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ));
              }

              break;
            case 'color':
              // showModalBottomSheet(
              //     context: context,
              //     builder: (BuildContext ctx) {
              //       return uiKit.ColorSlider(context);
              //     });
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
              Navigator.push(context,
                  SliderTransition(uiKit.MyDoante(SizeX: SizeX, SizeY: SizeY)));
              // TODO Delete _myProvider.gotoDonate(context);
              break;
            case 'donate':
              _launchURL();
              break;
            case 'upload':
              login(true, context);
              break;
            case 'download':
              login(false, context);
              break;
            case 'google':
              if (_connState.is_conn) {
                _signinState.signinToAccount();
              } else {
                uiKit.showAlertDialog(context, 'internet');
              }
              break;
            case 'newpic':
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                        actions: [
                          Container(
                            decoration: BoxDecoration(
                                color: _themeProvider.mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: CupertinoActionSheetAction(
                                onPressed: () {
                                  _myProvider.imagePickerCamera();
                                  Navigator.pop(context);
                                },
                                child: Text('Camera')),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: _themeProvider.mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: CupertinoActionSheetAction(
                                onPressed: () {
                                  _myProvider.imagePickerGalley();
                                  Navigator.pop(context);
                                },
                                child: Text('Gallery')),
                          )
                        ],
                      ));
              break;
            case 'newvoice':
              await _myProvider.startRecorder();
              break;
            case 'pausevoice':
              await _myProvider.pauseRecorder();
              break;
            case 'stopvoice':
              await _myProvider.stopRecorder(context);
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
    return Listener(
      onPointerUp: onPressedUp,
      onPointerDown: onPressedDown,
      // TODO if hovered more then the funrciton not to be executed
      child: isPressed
          ? Container(
              height: widget.sizePD,
              width: widget.sizePD,
              padding: EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color:_themeProvider.lightShadowColor,
                      offset: Offset(2, 2),
                      blurRadius: 0.0,
                      // changes position of shadow
                    ),
                    BoxShadow(
                      color: _themeProvider.shadowColor.withOpacity(0.14),
                      offset: Offset(-1, -1),
                    ),
                    BoxShadow(
                      color: _themeProvider.mainColor,
                      offset: Offset(5, 8),
                      spreadRadius: -0.5,
                      blurRadius: 14.0,
                      // changes position of shadow
                    ),
                  ],
                ),
                child: widget.id == 'dogedonate'
                    ? Image.asset(
                        'assets/images/dogecoin.png',
                        fit: BoxFit.fill,
                      )
                    : Icon(
                        widget.iconData,
                        size: widget.iconSize,
                        color: _themeProvider.blueMaterial,
                      ),
              ),
            )
          : Container(
              height: widget.sizePU,
              width: widget.sizePU,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: _themeProvider.lightShadowColor,
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                      offset: Offset(-1, -1), // changes position of shadow
                    ),
                    BoxShadow(
                      color: _themeProvider.shadowColor.withOpacity(0.17),
                      spreadRadius: 1.0,
                      blurRadius: 2.0,
                      offset: Offset(3, 4), // changes position of shadow
                    ),
                  ],
                  color: _themeProvider.mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: widget.id == 'dogedonate'
                  ? Image.asset(
                      'assets/images/dogecoin.png',
                      fit: BoxFit.fill,
                    )
                  : Icon(widget.iconData,
                      size: widget.iconSize,
                      color: widget.id == 'undo'
                          ? _myProvider.canUndo
                              ? _themeProvider.blueMaterial
                              : _themeProvider.textColor
                          : widget.id == 'redo'
                              ? _myProvider.canRedo
                                  ? _themeProvider.blueMaterial
                                  : _themeProvider.textColor
                              : widget.id == 'save' || widget.id == 'cancel'
                                  ? _myProvider.canUndo || false
                                      ? _themeProvider.blueMaterial
                                      : _themeProvider.textColor
                                  : widget.id == 'timer'
                                      ? _myProvider.time_duration != Duration()
                                          ? _themeProvider.blueMaterial
                                          : _themeProvider.textColor
                                      : widget.id == 'google'
                                          ? _signinState.isSignedin
                                              ? Colors.green
                                              : Colors.red
                                          : _themeProvider.textColor),
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
