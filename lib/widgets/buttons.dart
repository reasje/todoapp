import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:todoapp/provider/drive_provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/screen/home_screen.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:url_launcher/url_launcher.dart';

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
  var _myProvider;
  var _timerState;
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
        Future.delayed(Duration(milliseconds: 100), () {
          final _myProvider = Provider.of<myProvider>(context, listen: false);
          final _timerState = Provider.of<TimerState>(context, listen: false);
          switch (widget.id) {
            case 'dogedonate':
              copyDogeAdress();
              _myProvider.showDogeCopied();
              break;
            case 'home':
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
              _myProvider.changeFirstTime();
              break;
            case 'menu':
              _myProvider.changeTimerStack();
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
              //_myProvider.changeLan();
              upload();
              break;
            case 'new':
              download();
              //_myProvider.newNoteClicked(context);
              break;
            case 'lamp':
              _myProvider.changeBrigness();
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
                                  color: _myProvider.mainColor,
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
              _myProvider.doneClicked();
              break;
            case 'cancel':
              _myProvider.cancelClicked();
              break;
            case 'coder':
              _myProvider.gotoDonate(context);
              break;
            case 'donate':
              print('object');
              _launchURL();
              break;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
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
                      color: _myProvider.lightShadowColor,
                      offset: Offset(2, 2),
                      blurRadius: 0.0,
                      // changes position of shadow
                    ),
                    BoxShadow(
                      color: _myProvider.shadowColor.withOpacity(0.14),
                      offset: Offset(-1, -1),
                    ),
                    BoxShadow(
                      color: _myProvider.mainColor,
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
                        color: _myProvider.blueMaterial,
                      ),
              ),
            )
          : Container(
              height: widget.sizePU,
              width: widget.sizePU,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: _myProvider.lightShadowColor,
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                      offset: Offset(-1, -1), // changes position of shadow
                    ),
                    BoxShadow(
                      color: _myProvider.shadowColor.withOpacity(0.17),
                      spreadRadius: 1.0,
                      blurRadius: 2.0,
                      offset: Offset(3, 4), // changes position of shadow
                    ),
                  ],
                  color: _myProvider.mainColor,
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
                              ? _myProvider.blueMaterial
                              : _myProvider.textColor
                          : widget.id == 'redo'
                              ? _myProvider.canRedo
                                  ? _myProvider.blueMaterial
                                  : _myProvider.textColor
                              : widget.id == 'save' || widget.id == 'cancel'
                                  ? _myProvider.canUndo ||
                                          _myProvider.isEdited()
                                      ? _myProvider.blueMaterial
                                      : _myProvider.textColor
                                  : widget.id == 'timer'
                                      ? _myProvider.time_duration != Duration()
                                          ? _myProvider.blueMaterial
                                          : _myProvider.textColor
                                      : _myProvider.textColor),
            ),
    );
  }
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
