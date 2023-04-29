import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:todoapp/theme/theme_logic.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/buttons.dart';
import '../../logic/noteimage_logic.dart';
import '../../logic/notevoice_recorder_provider.dart';

class NoteEditingFloatingActionButtonWidget extends StatefulWidget {
  const NoteEditingFloatingActionButtonWidget({Key? key}) : super(key: key);

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

  final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();
  final _bottomNavLogic = Get.find<BottomNavLogic>();
  final _themeState = Get.find<ThemeLogic>().state;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Obx(
      () {
        return _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].title == "Image"
            ? FloatingActionButton(
                focusColor: Colors.transparent,
                highlightElevation: 0,
                elevation: 0,
                onPressed: () {},
                backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                child: ButtonWidget(
                  backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00006,
                  iconData: FontAwesomeIcons.plus,
                  function: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Color(0xFF737373),
                            height: h * 0.2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _themeState.mainColor,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Get.find<NoteImageLogic>().imagePickerCamera();
                                          Get.back();
                                        },
                                        child: Text(
                                          locale.camera.tr,
                                          style: TextStyle(
                                              color: _themeState.titleColor!.withOpacity(0.6),
                                              fontSize: _themeState.isEn! ? h * w * 0.00008 : h * w * 0.00007),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Get.find<NoteImageLogic>().imagePickerGalley();
                                          Get.back();
                                        },
                                        child: Text(
                                          locale.gallery.tr,
                                          style: TextStyle(
                                              color: _themeState.titleColor!.withOpacity(0.6),
                                              fontSize: _themeState.isEn! ? h * w * 0.00008 : h * w * 0.00007),
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
            : _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].title == "Voice"
                ? _noteVoiceRecorderLogic.state.flutterSoundRecorder.isStopped
                    ? FloatingActionButton(
                        highlightElevation: 0,
                        elevation: 0,
                        onPressed: () {},
                        backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                        child: ButtonWidget(
                          backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                          sizePU: h * w * 0.00017,
                          sizePD: h * w * 0.00018,
                          iconSize: h * w * 0.00006,
                          iconData: FontAwesomeIcons.microphone,
                          function: () async {
                            await Get.find<NoteVoiceRecorderLogic>().startRecorder(context);
                          },
                        ))
                    : _noteVoiceRecorderLogic.state.flutterSoundRecorder.isRecording
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
                                  backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                                  child: ButtonWidget(
                                    backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    sizePU: h * w * 0.00012,
                                    sizePD: h * w * 0.00013,
                                    iconSize: h * w * 0.00006,
                                    iconData: Icons.pause,
                                    function: () async {
                                      await _noteVoiceRecorderLogic.pauseRecorder();
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
                                        '${((_noteVoiceRecorderLogic.state.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                      Text(
                                        ':',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                      Text(
                                        '${((_noteVoiceRecorderLogic.state.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                    ],
                                  ),
                                ),
                                FloatingActionButton(
                                  highlightElevation: 0,
                                  elevation: 0,
                                  onPressed: () {},
                                  backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                                  child: ButtonWidget(
                                    backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    sizePU: h * w * 0.00012,
                                    sizePD: h * w * 0.00013,
                                    iconSize: h * w * 0.00006,
                                    iconData: Icons.stop,
                                    function: () {
                                      _noteVoiceRecorderLogic.stopRecorder();
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
                                  backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                                  child: ButtonWidget(
                                    backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    sizePU: h * 0.05,
                                    sizePD: h * 0.06,
                                    iconSize: h * w * 0.00006,
                                    iconData: FontAwesomeIcons.play,
                                    function: () {
                                      _noteVoiceRecorderLogic.resumeRecorder();
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
                                        '${((_noteVoiceRecorderLogic.state.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                      Text(
                                        ':',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                      Text(
                                        '${((_noteVoiceRecorderLogic.state.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color, fontSize: h * w * 0.0001),
                                      ),
                                    ],
                                  ),
                                ),
                                FloatingActionButton(
                                  highlightElevation: 0,
                                  elevation: 0,
                                  onPressed: () {},
                                  backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                                  child: ButtonWidget(
                                    backgroundColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    sizePU: h * 0.05,
                                    sizePD: h * 0.06,
                                    iconSize: h * w * 0.00006,
                                    iconData: Icons.stop,
                                    function: () {
                                      _noteVoiceRecorderLogic.stopRecorder();
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
      },
    );
  }
}
