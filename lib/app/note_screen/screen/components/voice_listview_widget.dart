import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_player_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:todoapp/theme/theme_logic.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';
import '../../../../widgets/snackbar.dart';
import '../../logic/notevoice_recorder_provider.dart';
import '../../state/note_voice_player_state.dart';

class VoiceListView extends StatelessWidget {
  final Color? backGroundColor;
  VoiceListView({
    Key? key,
    this.backGroundColor,
  }) : super(key: key);

  final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();
  final _bottomNavLogic = Get.find<BottomNavLogic>();
  final _themeState = Get.find<ThemeLogic>().state;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final _noteVoicePlayerLogic = Get.find<NoteVoicePlayerLogic>();

    return Container(
        height: isLandscape ? w * 0.8 : h * 0.8,
        width: double.maxFinite,
        child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: Obx(() {
              return ListView.builder(
                  itemCount: _noteVoiceRecorderLogic.state.voiceList != null ? _noteVoiceRecorderLogic.state.voiceList.length + 1 : 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index == (_noteVoiceRecorderLogic.state.voiceList != null ? _noteVoiceRecorderLogic.state.voiceList.length : 0)) {
                      return Container();
                    } else {
                      return FutureBuilder(
                          future: _noteVoiceRecorderLogic.getVoiceList(),
                          builder: (context, snapShot) {
                            if (snapShot.hasData) {
                              return Dismissible(
                                direction: DismissDirection.horizontal,
                                key: UniqueKey(),
                                background: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(left: w * 0.1, bottom: h * 0.01, right: w * 0.1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: _themeState.mainColor,
                                    ),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      size: h * w * 0.00022,
                                      color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(MySnackBar(locale.undoVoice.tr, 'undoVoice', true, context: context, index: index) as SnackBar);
                                  _noteVoiceRecorderLogic.voiceDismissed(index);
                                },
                                child: Container(
                                    width: w * 0.8,
                                    height: h * 0.12,
                                    margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.03),
                                    decoration: BoxDecoration(
                                        color: backGroundColor!.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(h * 0.02))),
                                    child: _noteVoiceRecorderLogic.state.voiceList != null
                                        ? Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              textDirection: TextDirection.ltr,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: w * 0.7,
                                                      child: Directionality(
                                                        textDirection: TextDirection.ltr,
                                                        child: Slider(
                                                          key: PageStorageKey<String>('pageKey ${DateTime.now().microsecondsSinceEpoch}'),
                                                          inactiveColor: backGroundColor!.withOpacity(0.1),
                                                          activeColor: backGroundColor,
                                                          onChangeEnd: (value) {
                                                            _noteVoicePlayerLogic.seekPlayingRecorder(value, index, context);
                                                          },
                                                          value: _noteVoicePlayerLogic.state.voiceProgress[index].inSeconds.toDouble(),
                                                          max: _noteVoicePlayerLogic.state.voiceDuration[index]!.inSeconds.toDouble() + 1,
                                                          min: 0,
                                                          onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: w * 0.4,
                                                      child: Row(
                                                        textDirection: TextDirection.ltr,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(left: h * 0.02),
                                                            child: Row(
                                                              textDirection: TextDirection.ltr,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                    "${((_noteVoicePlayerLogic.state.voiceProgress[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                                Text(":"),
                                                                Text(
                                                                    "${(_noteVoicePlayerLogic.state.voiceProgress[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                              ],
                                                            ),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: Text(
                                                              _noteVoiceRecorderLogic.state.voiceList[index].title!,
                                                              softWrap: false,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(right: h * 0.015),
                                                            child: Row(
                                                              textDirection: TextDirection.ltr,
                                                              children: [
                                                                Text(
                                                                    "${((_noteVoicePlayerLogic.state.voiceDuration[index]!.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                                Text(":"),
                                                                Text(
                                                                    "${(_noteVoicePlayerLogic.state.voiceDuration[index]!.inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                    key: PageStorageKey<String>('pageKey ${DateTime.now().microsecondsSinceEpoch}'),
                                                    width: w * 0.1,
                                                    padding: EdgeInsets.only(right: w * 0.02),
                                                    child: _noteVoicePlayerLogic.state.soundPlayerState[index] == SoundPlayerState.resumed
                                                        ? InkWell(
                                                            key: UniqueKey(),
                                                            onTap: () {
                                                              _noteVoicePlayerLogic.pausePlayingRecorded(index);
                                                            },
                                                            child: Icon(Icons.pause, color: backGroundColor, size: h * w * 0.00012),
                                                          )
                                                        : _noteVoicePlayerLogic.state.soundPlayerState[index] == SoundPlayerState.paused
                                                            ? InkWell(
                                                                onTap: () {
                                                                  _noteVoicePlayerLogic.resumePlayingRecorded(index);
                                                                },
                                                                child: Icon(FontAwesomeIcons.play, color: backGroundColor, size: h * w * 0.00012),
                                                              )
                                                            : _noteVoicePlayerLogic.state.soundPlayerState[index] == SoundPlayerState.stopped
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      _noteVoicePlayerLogic.startPlayingRecorded(index, context);
                                                                    },
                                                                    child: Icon(FontAwesomeIcons.play, color: backGroundColor, size: h * w * 0.00012),
                                                                  )
                                                                : Container())
                                              ],
                                            ),
                                          )
                                        : Container()),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: w * 0.82,
                                  height: h * 0.13,
                                  margin: EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.03),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _themeState.mainColor,
                                  ),
                                ),
                                // child: Shimmer.fromColors(
                                //   period: Duration(seconds: 1),
                                //   baseColor:
                                //   _bottomNavLogic
                                //       .tabs[_bottomNavLogic.selectedTab]
                                //       .color
                                //       .withOpacity(0.3),
                                //   highlightColor: _themeState.shimmerColor,
                                //   child: Container(

                                //     width: w * 0.82,
                                //     height: h*0.13,
                                //     margin: EdgeInsets.symmetric(
                                //         vertical: h*0.03,
                                //         horizontal: w * 0.03),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10),
                                //       color: _themeState.mainColor,
                                //     ),
                                //   ),
                                // ),
                              );
                            }
                          });
                    }
                  });
            })));
  }
}
