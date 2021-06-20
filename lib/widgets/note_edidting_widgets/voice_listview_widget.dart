import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class voiceListView extends StatelessWidget {
  const voiceListView({
    Key key,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
        final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
        double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
            double SizeXSizeY = SizeX * SizeY;
    return Container(
        height: isLandscape ? SizeY * 0.2 : SizeX * 0.2,
        child: ListView.builder(
            itemCount: _myProvider.voiceList != null
                ? _myProvider.voiceList.length + 1
                : 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index ==
                  (_myProvider.voiceList != null
                      ? _myProvider.voiceList.length
                      : 0)) {
                return _myProvider
                        .flutterSoundRecorder.isStopped
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeY * 0.1),
                        alignment: Alignment.centerLeft,
                        child: uiKit.MyButton(
                          sizePU: SizeXSizeY * 0.00017,
                          sizePD: SizeXSizeY * 0.00018,
                          iconSize: SizeX * SizeY * 0.00006,
                          iconData: FontAwesome.microphone,
                          id: 'newvoice',
                        ),
                      )
                    : _myProvider
                            .flutterSoundRecorder.isRecording
                        ? Container(
                            width: SizeY * 0.45,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: SizeY * 0.15,
                                  padding: EdgeInsets.only(
                                      left: SizeY * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Text(
                                        '${((_myProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.00009),
                                      ),
                                      Text(
                                        ':',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.00009),
                                      ),
                                      Text(
                                        '${((_myProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.00009),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeY * 0.03),
                                      alignment:
                                          Alignment.centerLeft,
                                      child: uiKit.MyButton(
                                        sizePU: SizeXSizeY *
                                            0.00012,
                                        sizePD: SizeXSizeY *
                                            0.00013,
                                        iconSize: SizeX *
                                            SizeY *
                                            0.00006,
                                        iconData:
                                            FontAwesome.pause,
                                        id: 'pausevoice',
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeY * 0.1),
                                      alignment:
                                          Alignment.centerLeft,
                                      child: uiKit.MyButton(
                                        sizePU: SizeXSizeY *
                                            0.00012,
                                        sizePD: SizeXSizeY *
                                            0.00013,
                                        iconSize: SizeX *
                                            SizeY *
                                            0.00006,
                                        iconData:
                                            FontAwesome.stop,
                                        id: 'stopvoice',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: SizeY * 0.5,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: SizeY * 0.2,
                                  padding: EdgeInsets.only(
                                      left: SizeY * 0.04),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceAround,
                                    children: [
                                      Text(
                                        '${((_myProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.0001),
                                      ),
                                      Text(
                                        ':',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.0001),
                                      ),
                                      Text(
                                        '${((_myProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            color: _themeProvider
                                                .blueMaterial,
                                            fontSize: SizeX *
                                                SizeY *
                                                0.0001),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeY * 0.1),
                                      alignment:
                                          Alignment.centerLeft,
                                      child: uiKit.MyButton(
                                        sizePU: SizeX * 0.05,
                                        sizePD: SizeX * 0.06,
                                        iconSize: SizeX *
                                            SizeY *
                                            0.00006,
                                        iconData:
                                            FontAwesome.play,
                                        id: 'resumevoice',
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeY * 0.1),
                                      alignment:
                                          Alignment.centerLeft,
                                      child: uiKit.MyButton(
                                        sizePU: SizeX * 0.05,
                                        sizePD: SizeX * 0.06,
                                        iconSize: SizeX *
                                            SizeY *
                                            0.00006,
                                        iconData:
                                            FontAwesome.stop,
                                        id: 'stopvoice',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
              } else {
                return FutureBuilder(
                    future: _myProvider.getVoiceList(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        return Dismissible(
                          direction: DismissDirection.up,
                          key: UniqueKey(),
                          background: Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: SizeY * 0.1,
                                  bottom: SizeX * 0.01,
                                  right: SizeY * 0.1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(35)),
                                color: _themeProvider.mainColor,
                              ),
                              alignment: AlignmentDirectional
                                  .centerEnd,
                              child: Icon(
                                Icons.delete_sweep,
                                size: SizeX * SizeY * 0.00025,
                                color: _themeProvider.textColor,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(uiKit.MySnackBar(
                                    uiKit.AppLocalizations.of(
                                            context)
                                        .translate('undoVoice'),
                                    'undoVoice',
                                    true,
                                    context,
                                    index));
                            _myProvider.voiceDissmissed(index);
                          },
                          child: Container(
                              width: SizeY * 0.52,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeY * 0.08,
                                  vertical: SizeX * 0.03),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _themeProvider
                                          .lightShadowColor,
                                      spreadRadius: 1.0,
                                      blurRadius: 1.0,
                                      offset: Offset(-1,
                                          -1), // changes position of shadow
                                    ),
                                    BoxShadow(
                                      color: _themeProvider
                                          .shadowColor
                                          .withOpacity(0.17),
                                      spreadRadius: 1.0,
                                      blurRadius: 2.0,
                                      offset: Offset(3,
                                          4), // changes position of shadow
                                    ),
                                  ],
                                  color:
                                      _themeProvider.mainColor,
                                  borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              SizeX * 0.016))),
                              child:
                                  _myProvider.voiceList != null
                                      ? Container(
                                          alignment: Alignment
                                              .centerLeft,
                                          width: SizeY * 0.35,
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        SizeY *
                                                            0.41,
                                                    child: Slider
                                                        .adaptive(
                                                      key:
                                                          UniqueKey(),
                                                      onChangeEnd:
                                                          (value) {
                                                        _myProvider.seekPlayingRecorder(
                                                            value,
                                                            index);
                                                      },
                                                      value: _myProvider
                                                          .voiceProgress[
                                                              index]
                                                          .inSeconds
                                                          .toDouble(),
                                                      max: _myProvider
                                                              .voiceDuration[index]
                                                              .inSeconds
                                                              .toDouble() +
                                                          1,
                                                      min: 0,
                                                      onChanged:
                                                          (value) {},
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        SizeY *
                                                            0.4,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(left: SizeX * 0.02),
                                                          child:
                                                              Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("${((_myProvider.voiceProgress[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                              Text(":"),
                                                              Text("${(_myProvider.voiceProgress[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                            ],
                                                          ),
                                                        ),
                                                        FittedBox(
                                                          fit: BoxFit
                                                              .cover,
                                                          child:
                                                              Text(
                                                            _myProvider.voiceList[index].title,
                                                            softWrap:
                                                                false,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(right: SizeX * 0.015),
                                                          child:
                                                              Row(
                                                            children: [
                                                              Text("${((_myProvider.voiceDuration[index].inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}"),
                                                              Text(":"),
                                                              Text("${(_myProvider.voiceDuration[index].inSeconds % 60).floor().toString().padLeft(2, '0')}"),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                  width: SizeY *
                                                      0.1,
                                                  child: _myProvider.soundPlayerState[
                                                              index] ==
                                                          SoundPlayerState
                                                              .resumed
                                                      ? InkWell(
                                                          key:
                                                              UniqueKey(),
                                                          onTap:
                                                              () {
                                                            _myProvider.pausePlayingRecorded(index);
                                                          },
                                                          child: Icon(
                                                              FontAwesome.pause,
                                                              color: _themeProvider.textColor,
                                                              size: SizeX * SizeY * 0.00012),
                                                        )
                                                      : _myProvider.soundPlayerState[index] ==
                                                              SoundPlayerState.paused
                                                          ? InkWell(
                                                              onTap: () {
                                                                _myProvider.resumePlayingRecorded(index);
                                                              },
                                                              child: Icon(FontAwesome.play, color: _themeProvider.textColor, size: SizeX * SizeY * 0.00012),
                                                            )
                                                          : _myProvider.soundPlayerState[index] == SoundPlayerState.stopped
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    _myProvider.startPlayingRecorded(index);
                                                                  },
                                                                  child: Icon(FontAwesome.play, color: _themeProvider.textColor, size: SizeX * SizeY * 0.00012),
                                                                )
                                                              : Container())
                                            ],
                                          ),
                                        )
                                      : Container()),
                        );
                      } else {
                        return Container(
                            width: SizeX * 0.16,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeY * 0.03),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: _themeProvider
                                      .lightShadowColor,
                                  spreadRadius: 1.0,
                                  blurRadius: 1.0,
                                  offset: Offset(-1,
                                      -1), // changes position of shadow
                                ),
                                BoxShadow(
                                  color: _themeProvider
                                      .shadowColor
                                      .withOpacity(0.17),
                                  spreadRadius: 1.0,
                                  blurRadius: 2.0,
                                  offset: Offset(3,
                                      4), // changes position of shadow
                                ),
                              ],
                              color: _themeProvider.mainColor,
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(SizeX * 0.3))
                            ),
                            child: Center(
                                child:
                                    CircularProgressIndicator()));
                      }
                    });
              }
            }));
  }
}