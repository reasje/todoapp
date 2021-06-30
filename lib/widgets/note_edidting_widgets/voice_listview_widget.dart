import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class voiceListView extends StatelessWidget {
  final Color backGroundColor;
  const voiceListView({
    Key key,
    this.backGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    return Container(
        height: isLandscape ? SizeY * 0.8 : SizeX * 0.8,
        width: double.maxFinite,
        child: ScrollConfiguration(
          behavior: uiKit.NoGlowBehaviour(),
          child: ListView.builder(
              itemCount: _myProvider.voiceList != null
                  ? _myProvider.voiceList.length + 1
                  : 1,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index ==
                    (_myProvider.voiceList != null
                        ? _myProvider.voiceList.length
                        : 0)) {
                  return Container();
                } else {
                  return FutureBuilder(
                      future: _myProvider.getVoiceList(),
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            key: UniqueKey(),
                            background: Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: SizeY * 0.1,
                                    bottom: SizeX * 0.01,
                                    right: SizeY * 0.1),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35)),
                                  color: _themeProvider.mainColor,
                                ),
                                alignment: AlignmentDirectional.centerEnd,
                                child: Icon(
                                  Icons.delete_sweep,
                                  size: SizeX * SizeY * 0.00022,
                                  color: _bottomNavProvider
                                  .tabs[_bottomNavProvider.selectedTab].color,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  uiKit.MySnackBar(
                                      uiKit.AppLocalizations.of(context)
                                          .translate('undoVoice'),
                                      'undoVoice',
                                      true,
                                      context: context,
                                      index: index));
                              _myProvider.voiceDissmissed(index);
                            },
                            child: Container(
                                width: SizeY * 0.8,
                                height: SizeX * 0.12,
                                
                                margin: EdgeInsets.symmetric(
                                    horizontal: SizeY * 0.08,
                                    vertical: SizeX * 0.03),
                                decoration: BoxDecoration(
                                    color: backGroundColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(SizeX * 0.02))),
                                child: _myProvider.voiceList != null
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width: SizeY * 0.7,
                                                  child: Directionality(
                                                    textDirection: TextDirection.ltr,
                                                    child: Slider(
                                                      
                                                      key: PageStorageKey<String>(
                                                        'pageKey ${DateTime.now().microsecondsSinceEpoch}'),
                                                      inactiveColor: backGroundColor.withOpacity(0.1),
                                                      activeColor: backGroundColor,
                                                      onChangeEnd: (value) {
                                                        _myProvider
                                                            .seekPlayingRecorder(
                                                                value, index);
                                                      },
                                                      value: _myProvider
                                                          .voiceProgress[index]
                                                          .inSeconds
                                                          .toDouble(),
                                                      max: _myProvider
                                                              .voiceDuration[index]
                                                              .inSeconds
                                                              .toDouble() +
                                                          1,
                                                      min: 0,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: SizeY * 0.4,
                                                  child: Row(
                                                    textDirection: TextDirection.ltr,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: SizeX * 0.02),
                                                        child: Row(
                                                          textDirection: TextDirection.ltr,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                "${((_myProvider.voiceProgress[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                            Text(":"),
                                                            Text(
                                                                "${(_myProvider.voiceProgress[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                          ],
                                                        ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Text(
                                                          _myProvider
                                                              .voiceList[index]
                                                              .title,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: SizeX * 0.015),
                                                        child: Row(
                                                          textDirection: TextDirection.ltr,
                                                          children: [
                                                            Text(
                                                                "${((_myProvider.voiceDuration[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                            Text(":"),
                                                            Text(
                                                                "${(_myProvider.voiceDuration[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                             key: PageStorageKey<String>(
                                                      'pageKey ${DateTime.now().microsecondsSinceEpoch}'),
                                                width: SizeY * 0.1,
                                                padding: EdgeInsets.only(right: SizeY*0.02),
                                                child: _myProvider
                                                                .soundPlayerState[
                                                            index] ==
                                                        SoundPlayerState.resumed
                                                    ? InkWell(
                                                        key: UniqueKey(),
                                                        onTap: () {
                                                          _myProvider
                                                              .pausePlayingRecorded(
                                                                  index);
                                                        },
                                                        child: Icon(
                                                            FontAwesome.pause,
                                                            color: backGroundColor,
                                                            size: SizeX *
                                                                SizeY *
                                                                0.00012),
                                                      )
                                                    : _myProvider.soundPlayerState[
                                                                index] ==
                                                            SoundPlayerState
                                                                .paused
                                                        ? InkWell(
                                                            onTap: () {
                                                              _myProvider
                                                                  .resumePlayingRecorded(
                                                                      index);
                                                            },
                                                            child: Icon(
                                                                FontAwesome.play,
                                                                color:
                                                                    backGroundColor,
                                                                size: SizeX *
                                                                    SizeY *
                                                                    0.00012),
                                                          )
                                                        : _myProvider.soundPlayerState[
                                                                    index] ==
                                                                SoundPlayerState
                                                                    .stopped
                                                            ? InkWell(
                                                                onTap: () {
                                                                  _myProvider
                                                                      .startPlayingRecorded(
                                                                          index);
                                                                },
                                                                child: Icon(
                                                                    FontAwesome
                                                                        .play,
                                                                    color: backGroundColor,
                                                                    size: SizeX *
                                                                        SizeY *
                                                                        0.00012),
                                                              )
                                                            : Container())
                                          ],
                                        ),
                                      )
                                    : Container()),
                          );
                        } else {
                          return Container(
                                width: SizeY * 0.8,
                                height: SizeX * 0.12,
                            child: Shimmer.fromColors(
                              period: Duration(seconds: 3),
                              baseColor: _bottomNavProvider
                                  .tabs[_bottomNavProvider.selectedTab].color
                                  .withOpacity(0.3),
                              highlightColor: _themeProvider.shimmerColor,
                              child: Container(
                                width: SizeX * 0.16,
                                margin: EdgeInsets.symmetric(
                                    horizontal: SizeY * 0.03),
                                decoration: BoxDecoration(
                                  color: _themeProvider.mainColor,
                                ),
                              ),
                            ),
                          );
                        }
                      });
                }
              }),
        ));
  }
}
