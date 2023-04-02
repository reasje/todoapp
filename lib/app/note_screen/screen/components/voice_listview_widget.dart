import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_player_provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';
import '../../../../widgets/snackbar.dart';

class VoiceListView extends StatelessWidget {
  final Color backGroundColor;
  const VoiceListView({
    Key key,
    this.backGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
        height: isLandscape ? w * 0.8 : h * 0.8,
        width: double.maxFinite,
        child: ScrollConfiguration(
          behavior: NoGlowBehavior(),
          child: Consumer4<NoteVoiceRecorderProvider, NoteVoicePlayerProvider, BottomNavProvider, ThemeProvider>(
            builder: (ctx, _noteVoiceRecorderProvider, _noteVoicePlayerProvider, _bottomNavProvider, _themeProvider, _) {
              return ListView.builder(
                  itemCount: _noteVoiceRecorderProvider.voiceList != null ? _noteVoiceRecorderProvider.voiceList.length + 1 : 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index == (_noteVoiceRecorderProvider.voiceList != null ? _noteVoiceRecorderProvider.voiceList.length : 0)) {
                      return Container();
                    } else {
                      return FutureBuilder(
                          future: _noteVoiceRecorderProvider.getVoiceList(),
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
                                      color: _themeProvider.mainColor,
                                    ),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      size: h * w * 0.00022,
                                      color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                      AppLocalizations.of(context).translate('undoVoice'), 'undoVoice', true,
                                      context: context, index: index));
                                  _noteVoiceRecorderProvider.voiceDissmissed(index);
                                },
                                child: Container(
                                    width: w * 0.8,
                                    height: h * 0.12,
                                    margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.03),
                                    decoration: BoxDecoration(
                                        color: backGroundColor.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(h * 0.02))),
                                    child: _noteVoiceRecorderProvider.voiceList != null
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
                                                          inactiveColor: backGroundColor.withOpacity(0.1),
                                                          activeColor: backGroundColor,
                                                          onChangeEnd: (value) {
                                                            _noteVoicePlayerProvider.seekPlayingRecorder(value, index, context);
                                                          },
                                                          value: _noteVoicePlayerProvider.voiceProgress[index].inSeconds.toDouble(),
                                                          max: _noteVoicePlayerProvider.voiceDuration[index].inSeconds.toDouble() + 1,
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
                                                                    "${((_noteVoicePlayerProvider.voiceProgress[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                                Text(":"),
                                                                Text(
                                                                    "${(_noteVoicePlayerProvider.voiceProgress[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                              ],
                                                            ),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: Text(
                                                              _noteVoiceRecorderProvider.voiceList[index].title,
                                                              softWrap: false,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(right: h * 0.015),
                                                            child: Row(
                                                              textDirection: TextDirection.ltr,
                                                              children: [
                                                                Text(
                                                                    "${((_noteVoicePlayerProvider.voiceDuration[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                                Text(":"),
                                                                Text(
                                                                    "${(_noteVoicePlayerProvider.voiceDuration[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
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
                                                    child: _noteVoicePlayerProvider.soundPlayerState[index] == SoundPlayerState.resumed
                                                        ? InkWell(
                                                            key: UniqueKey(),
                                                            onTap: () {
                                                              _noteVoicePlayerProvider.pausePlayingRecorded(index);
                                                            },
                                                            child: Icon(FontAwesome.pause, color: backGroundColor, size: h * w * 0.00012),
                                                          )
                                                        : _noteVoicePlayerProvider.soundPlayerState[index] == SoundPlayerState.paused
                                                            ? InkWell(
                                                                onTap: () {
                                                                  _noteVoicePlayerProvider.resumePlayingRecorded(index);
                                                                },
                                                                child: Icon(FontAwesome.play, color: backGroundColor, size: h * w * 0.00012),
                                                              )
                                                            : _noteVoicePlayerProvider.soundPlayerState[index] == SoundPlayerState.stopped
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      _noteVoicePlayerProvider.startPlayingRecorded(index, context);
                                                                    },
                                                                    child: Icon(FontAwesome.play, color: backGroundColor, size: h * w * 0.00012),
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
                                    color: _themeProvider.mainColor,
                                  ),
                                ),
                                // child: Shimmer.fromColors(
                                //   period: Duration(seconds: 1),
                                //   baseColor:
                                //   _bottomNavProvider
                                //       .tabs[_bottomNavProvider.selectedTab]
                                //       .color
                                //       .withOpacity(0.3),
                                //   highlightColor: _themeProvider.shimmerColor,
                                //   child: Container(

                                //     width: w * 0.82,
                                //     height: h*0.13,
                                //     margin: EdgeInsets.symmetric(
                                //         vertical: h*0.03,
                                //         horizontal: w * 0.03),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10),
                                //       color: _themeProvider.mainColor,
                                //     ),
                                //   ),
                                // ),
                              );
                            }
                          });
                    }
                  });
            },
          ),
        ));
  }
}
