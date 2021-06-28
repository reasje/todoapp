import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/conn_provider.dart';

import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:todoapp/widgets/buttons.dart';

import '../main.dart';

class MyRorderable extends StatefulWidget {
  MyRorderable({Key key}) : super(key: key);

  @override
  _MyRorderableState createState() => _MyRorderableState();
}

class _MyRorderableState extends State<MyRorderable> {
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController(keepScrollOffset: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _themeProvider.mainColor,
      body: Container(
          padding: EdgeInsets.only(top: SizeXSizeY * 0.00008),
          width: SizeY,
          margin: EdgeInsets.only(
              //right: SizeY * 0.02,
              //left: SizeY * 0.02,
              ),
          // padding: EdgeInsets.only(top: SizeX * 0.01),
          child: ValueListenableBuilder(
              valueListenable: noteBox.listenable(),
              builder: (context, LazyBox<Note> notes, _) {
                List<int> keys = notes.keys.cast<int>().toList();

                return Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: ScrollConfiguration(
                    behavior: NoGlowBehaviour(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          uiKit.ReorderableListButtonsWidget(),
                          if (noteBox.isEmpty)
                            uiKit.noNotes()
                          else
                            FutureBuilder(
                                future: _myProvider.updateListSize(
                                    keys, SizeX, SizeY),
                                builder: (context, snapShot) {
                                  if (snapShot.hasData) {
                                    return Container(
                                      height: _myProvider.listview_size + 400.0,
                                      width: SizeY,
                                      child: ScrollConfiguration(
                                        behavior: NoGlowBehaviour(),
                                        child: AnimationLimiter(
                                          child: ReorderableListView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollController: _scrollController,
                                            padding: EdgeInsets.only(
                                                bottom: SizeX * 0.1,
                                                top: SizeX * 0.01),
                                            children: [
                                              for (int index = 0;
                                                  index < keys.length;
                                                  index++)
                                                Dismissible(
                                                  key: UniqueKey(),
                                                  background: Container(
                                                    padding: EdgeInsets.only(
                                                        left: SizeY * 0.1,
                                                        bottom: SizeX * 0.01,
                                                        right: SizeY * 0.1),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  35)),
                                                      color: _themeProvider
                                                          .mainColor,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerEnd,
                                                    child: Icon(
                                                      Icons.delete_sweep,
                                                      size: SizeX *
                                                          SizeY *
                                                          0.0002,
                                                      color: _themeProvider
                                                          .textColor,
                                                    ),
                                                  ),
                                                  onDismissed:
                                                      (direction) async {
                                                    var bnote = await notes
                                                        .get(keys[index]);
                                                    Note note = Note(
                                                        bnote.title,
                                                        bnote.text,
                                                        bnote.isChecked,
                                                        bnote.time,
                                                        bnote.color,
                                                        bnote.leftTime,
                                                        bnote.imageList,
                                                        bnote.voiceList,
                                                        bnote.taskList,
                                                        bnote.resetCheckBoxs);
                                                    notes.delete(keys[index]);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            uiKit.MySnackBar(
                                                      uiKit.AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'undoNote'),
                                                      'undoNote',
                                                      true,
                                                      context,
                                                      index,
                                                      notes,
                                                      note,
                                                      keys,
                                                    ));
                                                  },
                                                  child: AnimationConfiguration
                                                      .staggeredList(
                                                    position: index,
                                                    delay: Duration(
                                                        milliseconds: 100),
                                                    child: SlideAnimation(
                                                      duration: Duration(
                                                          milliseconds: 2500),
                                                      curve: Curves
                                                          .fastLinearToSlowEaseIn,
                                                      horizontalOffset: 30,
                                                      verticalOffset: 300.0,
                                                      child: Center(
                                                        child: FlipAnimation(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          curve: Curves
                                                              .fastLinearToSlowEaseIn,
                                                          flipAxis: FlipAxis.y,
                                                          child: Container(
                                                              width:
                                                                  SizeY * 0.9,
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      SizeY *
                                                                          0.009,
                                                                  vertical:
                                                                      SizeY *
                                                                          0.04),
                                                              margin: EdgeInsets.only(
                                                                  bottom:
                                                                      SizeX *
                                                                          0.04,
                                                                  top: isLandscape
                                                                      ? SizeY *
                                                                          0.1
                                                                      : SizeX *
                                                                          0.01),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(snapShot.data[index].color).withOpacity(
                                                                              0.5) ??
                                                                          Colors
                                                                              .white,
                                                                      //border: Border.all(width: 1, color: uiKit.Colors.whiteSmoke),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                              //clipBehavior: Clip.antiAlias,
                                                              child: Theme(
                                                                  data: Theme.of(context).copyWith(
                                                                    unselectedWidgetColor:
                                                                        _themeProvider
                                                                            .textColor,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      snapShot.data[index].time !=
                                                                              0
                                                                          ? InkWell(
                                                                              key: UniqueKey(),
                                                                              onTap: () {
                                                                                if (!(_timerState.isRunning.any((element) => element == true))) {
                                                                                  _timerState.loadTimer(
                                                                                    keys,
                                                                                    index,
                                                                                    context,
                                                                                  );
                                                                                }

                                                                                _myProvider.loadNote(context, keys, index);
                                                                                Navigator.push(context, SliderTransition(uiKit.MyNotesEditing()));
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(4),
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  ),
                                                                                  child: Directionality(
                                                                                    textDirection: TextDirection.ltr,
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          ((snapShot.data[index].leftTime / 3600) % 60).floor().toString().padLeft(2, '0'),
                                                                                          style: TextStyle(color: _timerState.isRunning[index] ? _themeProvider.swachColor : _themeProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                        ),
                                                                                        Text(
                                                                                          ':',
                                                                                          style: TextStyle(color: _timerState.isRunning[index] ? _themeProvider.swachColor : _themeProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                        ),
                                                                                        Text(
                                                                                          ((snapShot.data[index].leftTime / 60) % 60).floor().toString().padLeft(2, '0'),
                                                                                          style: TextStyle(color: _timerState.isRunning[index] ? _themeProvider.swachColor : _themeProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                        ),
                                                                                        Text(
                                                                                          ':',
                                                                                          style: TextStyle(color: _timerState.isRunning[index] ? _themeProvider.swachColor : _themeProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                        ),
                                                                                        Text(
                                                                                          (snapShot.data[index].leftTime % 60).floor().toString().padLeft(2, '0'),
                                                                                          style: TextStyle(color: _timerState.isRunning[index] ? _themeProvider.swachColor : _themeProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          // In this case the note doesnt have a
                                                                          : Container(),
                                                                      snapShot.data[index].time !=
                                                                              0
                                                                          ? Container(
                                                                              width: double.infinity,
                                                                              height: SizeX * 0.02,
                                                                            )
                                                                          : Container(),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(2),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                          ),
                                                                          child:
                                                                              ExpansionTile(

                                                                            initiallyExpanded:
                                                                                false,
                                                                            // tried too hard to make the expanion color and
                                                                            // collapsed color personalized but threre was  a problem
                                                                            // Every widget when We call the notifier in the provider
                                                                            // as I called one is ExpansionTile the Tile will be
                                                                            // recreated so We have to defin this spesific listTile
                                                                            // a key that the widget won't be changed !
                                                                            key:
                                                                                UniqueKey(),
                                                                            title:
                                                                                InkWell(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Checkbox(
                                                                                        checkColor: _themeProvider.textColor,
                                                                                        value: snapShot.data[index].isChecked,
                                                                                        activeColor: _themeProvider.textColor,
                                                                                        onChanged: (bool newValue) {
                                                                                          _myProvider.updateIsChecked(newValue, keys, index);
                                                                                        }),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 8,
                                                                                    child: Center(
                                                                                      child: FittedBox(
                                                                                        fit: BoxFit.cover,
                                                                                        child: Text(
                                                                                          snapShot.data[index].title.length >= (SizeY * 0.08).round() ? snapShot.data[index].title.substring(0, (SizeY * 0.08).round()) + "..." : snapShot.data[index].title,
                                                                                          softWrap: false,
                                                                                          style: TextStyle(color: _themeProvider.noteTitleColor[index], fontSize: _themeProvider.isEn ? SizeX * SizeY * 0.00011 : SizeX * SizeY * 0.00009, fontWeight: _themeProvider.isEn ? FontWeight.w100 : FontWeight.w600),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onTap: () {
                                                                                if (!(_timerState.isRunning.any((element) => element == true))) {
                                                                                  _timerState.loadTimer(
                                                                                    keys,
                                                                                    index,
                                                                                    context,
                                                                                  );
                                                                                }
                                                                                _myProvider.loadNote(context, keys, index);
                                                                                Navigator.push(context, SliderTransition(uiKit.MyNotesEditing()));
                                                                              },
                                                                            ),
                                                                            children: [
                                                                              Container(
                                                                                padding: EdgeInsets.all(SizeY * 0.05),
                                                                                child: Text(
                                                                                  snapShot.data[index].text,
                                                                                  style: TextStyle(
                                                                                    color: _themeProvider.textColor,
                                                                                    fontSize: SizeX * SizeY * 0.00008,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            // onTap: () {
                                                                            //   _myProvider.loadNote(keys, index, context);
                                                                            // },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )

                                                                  // return Container(
                                                                  //     height: SizeX * 0.1,
                                                                  //     child: Container(
                                                                  //         padding: EdgeInsets.all(4),
                                                                  //         child: Container(
                                                                  //           decoration: BoxDecoration(
                                                                  //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  //           ),
                                                                  //           child: Shimmer.fromColors(
                                                                  //             baseColor: _themeProvider.shimmerColor,
                                                                  //             highlightColor: Colors.white,
                                                                  //             child: Container(
                                                                  //                 margin: EdgeInsets.all(10),
                                                                  //                 decoration: BoxDecoration(
                                                                  //                   color: _themeProvider.shimmerColor,
                                                                  //                   borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  //                 )),
                                                                  //           ),
                                                                  //         )));

                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                            onReorder: (int oldIndex,
                                                int newIndex) async {
                                              // TODO try corecting the when there 3 element and
                                              // you change the bottom and the top elements
                                              print(oldIndex);
                                              print(newIndex);
                                              // if oldIndex < newIndex the flutter asumes the
                                              // newIndex is newIndex+1 for example new index yopu think is
                                              // 1 and old index is 0 but the realaity is  that new index is
                                              // 2 !
                                              setState(() {
                                                if (oldIndex < newIndex) {
                                                  newIndex -= 1;
                                                }
                                              });
                                              var bnote = await notes
                                                  .get(keys[oldIndex]);

                                              Note note = bnote;
                                              if (newIndex < oldIndex) {
                                                for (int i = oldIndex;
                                                    i > newIndex;
                                                    i--) {
                                                  var bnote2 = await notes
                                                      .get(keys[i - 1]);
                                                  notes.put(keys[i], bnote2);
                                                }
                                              } else {
                                                for (int i = oldIndex;
                                                    i < newIndex;
                                                    i++) {
                                                  var bnote = await notes
                                                      .get(keys[i + 1]);
                                                  notes.put(keys[i], bnote);
                                                }
                                              }
                                              notes.put(keys[newIndex], note);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                })
                        ],
                      ),
                    ),
                  ),
                );
              })),
      floatingActionButton: uiKit.FloatingActionButtonWidget(),
    );
  }
}




class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


