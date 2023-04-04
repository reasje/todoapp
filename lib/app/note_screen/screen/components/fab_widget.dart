import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/buttons.dart';
import '../../logic/noteimage_provider.dart';

class NoteEditingFloatingActionButtonWidget extends StatefulWidget {
  const NoteEditingFloatingActionButtonWidget({Key key}) : super(key: key);

  @override
  _NoteEditingFloatingActionButtonWidgetState createState() => _NoteEditingFloatingActionButtonWidgetState();
}

class _NoteEditingFloatingActionButtonWidgetState extends State<NoteEditingFloatingActionButtonWidget> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Disposed');
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Consumer3<NoteVoiceRecorderProvider, BottomNavProvider, ThemeProvider>(
        builder: (ctx, _noteVoiceRecorderProvider, _bottomNavProvider, _themeProvider, _) {
      return _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].title == "Image"
          ? FloatingActionButton(
              focusColor: Colors.transparent,
              highlightElevation: 0,
              elevation: 0,
              onPressed: () {},
              backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
              child: ButtonWidget(
                backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                sizePU: h * w * 0.00017,
                sizePD: h * w * 0.00018,
                iconSize: h * w * 0.00006,
                iconData: FontAwesome.plus,
                function:(){
                                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Color(0xFF737373),
                            height: h * 0.2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _themeProvider.mainColor,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<NoteImageProvider>(context, listen: false).imagePickerCamera();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context).translate('camera'),
                                          style: TextStyle(
                                              color: _themeProvider.titleColor.withOpacity(0.6),
                                              fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00007),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<NoteImageProvider>(context, listen: false).imagePickerGalley();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context).translate('gallery'),
                                          style: TextStyle(
                                              color: _themeProvider.titleColor.withOpacity(0.6),
                                              fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00007),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                },
              ),
            )
          : _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].title == "Voice"
              ? _noteVoiceRecorderProvider.flutterSoundRecorder.isStopped
                  ? FloatingActionButton(
                      highlightElevation: 0,
                      elevation: 0,
                      onPressed: () {},
                      backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                      child: ButtonWidget(
                        backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                        sizePU: h * w * 0.00017,
                        sizePD: h * w * 0.00018,
                        iconSize: h * w * 0.00006,
                        iconData: FontAwesome.microphone,
                        function:()async{
                          await Provider.of<NoteVoiceRecorderProvider>(context, listen: false).startRecorder(context);
                        },
                      ))
                  : _noteVoiceRecorderProvider.flutterSoundRecorder.isRecording
                      ? Container(
                          width: w * 0.8,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                                child: ButtonWidget(
                                  backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                  sizePU: h * w * 0.00012,
                                  sizePD: h * w * 0.00013,
                                  iconSize: h * w * 0.00006,
                                  iconData: FontAwesome.pause,
                                  function:()async{
                                    await _noteVoiceRecorderProvider.pauseRecorder();
                                  },
                                ),
                              ),
                              Container(
                                width: w * 0.4,
                                padding: EdgeInsets.symmetric(vertical: w * 0.04, horizontal: w * 0.04),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${((_noteVoiceRecorderProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                    Text(
                                      ':',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                    Text(
                                      '${((_noteVoiceRecorderProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                                child: ButtonWidget(
                                  backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                  sizePU: h * w * 0.00012,
                                  sizePD: h * w * 0.00013,
                                  iconSize: h * w * 0.00006,
                                  iconData: FontAwesome.stop,
                                  function:(){
                                    _noteVoiceRecorderProvider.stopRecorder();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: w * 0.8,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                                child: ButtonWidget(
                                  backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                  sizePU: h * 0.05,
                                  sizePD: h * 0.06,
                                  iconSize: h * w * 0.00006,
                                  iconData: FontAwesome.play,
                                  function:(){
                                    _noteVoiceRecorderProvider.resumeRecorder();
                                  },
                                ),
                              ),
                              Container(
                                width: w * 0.4,
                                padding: EdgeInsets.symmetric(vertical: w * 0.02, horizontal: w * 0.02),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${((_noteVoiceRecorderProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                    Text(
                                      ':',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                    Text(
                                      '${((_noteVoiceRecorderProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                      style:
                                          TextStyle(color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color, fontSize: h * w * 0.0001),
                                    ),
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                                child: ButtonWidget(
                                  backgroundColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                  sizePU: h * 0.05,
                                  sizePD: h * 0.06,
                                  iconSize: h * w * 0.00006,
                                  iconData: FontAwesome.stop,
                                  function:(){
                                    _noteVoiceRecorderProvider.stopRecorder();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
              : Visibility(
                  visible: false,
                  child: FloatingActionButton(
                    onPressed: () {},
                  ),
                );
    });
  }
}
