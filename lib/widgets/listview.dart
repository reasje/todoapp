import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';

import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class myRorderable extends StatefulWidget {
  myRorderable(
      {Box<Note> this.noteBox, double this.SizeX, double this.SizeY, Key key})
      : super(key: key);
  final SizeX;
  final SizeY;
  final noteBox;
  @override
  _myRorderableState createState() => _myRorderableState();
}

class _myRorderableState extends State<myRorderable> {
  ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    Box<Note> noteBox = widget.noteBox;
    double SizeX = widget.SizeX;
    double SizeY = widget.SizeY;
    return Expanded(
      child: Container(
          width: SizeX,
          margin: EdgeInsets.only(
            right: SizeY * 0.02,
            left: SizeY * 0.02,
          ),
          // padding: EdgeInsets.only(top: SizeX * 0.01),
          child: ValueListenableBuilder(
              valueListenable: noteBox.listenable(),
              builder: (context, Box<Note> notes, _) {
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
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(SizeX * 0.015),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        uiKit.AppLocalizations.of(context)
                                            .translate('notesApp'),
                                        style: TextStyle(
                                            color: _myProvider.titleColor,
                                            fontSize: _myProvider.isEn ?  SizeX * SizeY * 0.00012 : SizeX * SizeY * 0.0001),
                                      )),
                                  Container(
                                    padding: EdgeInsets.all(SizeX * 0.015),
                                    alignment: Alignment.centerLeft,
                                    child: uiKit.MyButton(
                                      sizePU: SizeX * 0.05,
                                      sizePD: SizeX * 0.06,
                                      iconSize: SizeX * SizeY * 0.00006,
                                      iconData: FontAwesome.code,
                                      id: 'coder',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(SizeX * 0.025),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    uiKit.MyButton(
                                      sizePU: SizeX * 0.07,
                                      sizePD: SizeX * 0.08,
                                      iconSize: SizeX * SizeY * 0.0001,
                                      iconData: FontAwesome.language,
                                      id: 'lan',
                                    ),
                                    uiKit.MyButton(
                                      sizePU: SizeX * 0.07,
                                      sizePD: SizeX * 0.08,
                                      iconSize: SizeX * SizeY * 0.0001,
                                      iconData: FontAwesome.plus,
                                      id: 'new',
                                    ),
                                    uiKit.MyButton(
                                      sizePU: SizeX * 0.07,
                                      sizePD: SizeX * 0.08,
                                      iconSize: SizeX * SizeY * 0.0001,
                                      iconData: FontAwesome.lightbulb_o,
                                      id: 'lamp',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          noteBox.isEmpty
                              ? Container(
                                  height: SizeX * 0.7,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: SizeX * 0.45,
                                        width: SizeY * 0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeX * 0.019),
                                          child: Container(
                                            height: SizeX * 0.45,
                                            width: SizeY,
                                            child: Image.asset(
                                              _myProvider.noTaskImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        //padding: EdgeInsets.only(bottom: SizeX * 0.2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              uiKit.AppLocalizations.of(context)
                                                  .translate('NoNotesyet'),
                                              style: TextStyle(
                                                  color: _myProvider.textColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00008),
                                            ),
                                            Text(
                                              uiKit.AppLocalizations.of(context)
                                                  .translate(
                                                      'addNewNotePlease'),
                                              style: TextStyle(
                                                  color: _myProvider.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      _myProvider.isEn ? SizeX * SizeY * 0.00008 : SizeX * SizeY * 0.00006),
                                            ),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              : Container(
                                  height: SizeX,
                                  width: SizeY,
                                  child: ScrollConfiguration(
                                    behavior: NoGlowBehaviour(),
                                    child: ReorderableListView(
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(35)),
                                                color: _myProvider.mainColor,
                                              ),
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: Icon(
                                                Icons.delete_sweep,
                                                size: SizeX * SizeY * 0.0002,
                                                color: _myProvider.textColor,
                                              ),
                                            ),
                                            onDismissed: (direction) {
                                              Note note = Note(
                                                notes.get(keys[index]).title,
                                                notes.get(keys[index]).text,
                                                notes
                                                    .get(keys[index])
                                                    .isChecked,
                                                notes.get(keys[index]).time,
                                                notes.get(keys[index]).color,
                                                notes.get(keys[index]).leftTime,
                                              );
                                              notes.delete(keys[index]);
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      uiKit.MySnackBar(
                                                          uiKit.AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'undoNote'),
                                                          true,
                                                          context,
                                                          notes,
                                                          note,
                                                          keys,
                                                          index));
                                            },
                                            child: Center(
                                              child: Container(
                                                width: SizeY * 0.9,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: SizeY * 0.009,
                                                    vertical: SizeY * 0.04),
                                                margin: EdgeInsets.only(
                                                    bottom: SizeX * 0.04,
                                                    top: SizeX * 0.01),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: _myProvider
                                                            .lightShadowColor,
                                                        //spreadRadius: 1.0,
                                                        blurRadius: 5.0,
                                                        offset: Offset(-6,
                                                            -3), // changes position of shadow
                                                      ),
                                                      BoxShadow(
                                                        color: _myProvider
                                                            .shadowColor
                                                            .withOpacity(0.2),
                                                        //spreadRadius: 1.0,
                                                        blurRadius: 5.0,
                                                        offset: Offset(6,
                                                            12), // changes position of shadow
                                                      ),
                                                    ],
                                                    color:
                                                        _myProvider.mainColor,
                                                    //border: Border.all(width: 1, color: uiKit.Colors.whiteSmoke),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                //clipBehavior: Clip.antiAlias,
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        _myProvider.textColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      notes
                                                                  .get(keys[
                                                                      index])
                                                                  .time !=
                                                              0
                                                          ? InkWell(
                                                              key: new PageStorageKey<
                                                                      String>(
                                                                  notes
                                                                      .get(keys[
                                                                          index])
                                                                      .title),
                                                              onTap: () {
                                                                if (!(_timerState
                                                                    .isRunning
                                                                    .any((element) =>
                                                                        element ==
                                                                        true))) {
                                                                  _myProvider
                                                                      .changeTimerStack();
                                                                  _timerState
                                                                      .loadTimer(
                                                                          keys,
                                                                          index, _myProvider.myContext,);
                                                                } else {
                                                                  if (_timerState
                                                                          .index ==
                                                                      index) {
                                                                    _myProvider
                                                                        .changeTimerStack();
                                                                    _timerState
                                                                        .loadTimer(
                                                                            
                                                                            keys,
                                                                            index,_myProvider.myContext,);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .hideCurrentSnackBar();
                                                                    ScaffoldMessenger.of(context).showSnackBar(uiKit.MySnackBar(
                                                                        uiKit.AppLocalizations.of(context)
                                                                            .translate('timerOn'),
                                                                        false,
                                                                        context));
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: _myProvider
                                                                            .lightShadowColor,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                        blurRadius:
                                                                            0.0,
                                                                        // changes position of shadow
                                                                      ),
                                                                      BoxShadow(
                                                                        color: _myProvider
                                                                            .shadowColor
                                                                            .withOpacity(0.14),
                                                                        offset: Offset(
                                                                            -1,
                                                                            -1),
                                                                      ),
                                                                      BoxShadow(
                                                                        color: _myProvider
                                                                            .mainColor,
                                                                        offset: Offset(
                                                                            5,
                                                                            8),
                                                                        spreadRadius:
                                                                            -0.5,
                                                                        blurRadius:
                                                                            14.0,
                                                                        // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Directionality(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          ((notes.get(keys[index]).leftTime / 3600) % 60)
                                                                              .floor()
                                                                              .toString()
                                                                              .padLeft(2, '0'),
                                                                          style: TextStyle(
                                                                              color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor,
                                                                              fontSize: SizeX * SizeY * 0.00012),
                                                                        ),
                                                                        Text(
                                                                          ':',
                                                                          style: TextStyle(
                                                                              color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor,
                                                                              fontSize: SizeX * SizeY * 0.00012),
                                                                        ),
                                                                        Text(
                                                                          ((notes.get(keys[index]).leftTime / 60) % 60)
                                                                              .floor()
                                                                              .toString()
                                                                              .padLeft(2, '0'),
                                                                          style: TextStyle(
                                                                              color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor,
                                                                              fontSize: SizeX * SizeY * 0.00012),
                                                                        ),
                                                                        Text(
                                                                          ':',
                                                                          style: TextStyle(
                                                                              color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor,
                                                                              fontSize: SizeX * SizeY * 0.00012),
                                                                        ),
                                                                        Text(
                                                                          (notes.get(keys[index]).leftTime % 60)
                                                                              .floor()
                                                                              .toString()
                                                                              .padLeft(2, '0'),
                                                                          style: TextStyle(
                                                                              color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor,
                                                                              fontSize: SizeX * SizeY * 0.00012),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )

                                                          // In this case the note doesnt have a
                                                          : Container(),
                                                      notes
                                                                  .get(keys[
                                                                      index])
                                                                  .time !=
                                                              0
                                                          ? Container(
                                                              width: double
                                                                  .infinity,
                                                              height:
                                                                  SizeX * 0.02,
                                                            )
                                                          : Container(),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: _myProvider
                                                                    .lightShadowColor,
                                                                offset: Offset(
                                                                    2, 2),
                                                                blurRadius: 0.0,
                                                                // changes position of shadow
                                                              ),
                                                              BoxShadow(
                                                                color: _myProvider
                                                                    .shadowColor
                                                                    .withOpacity(
                                                                        0.14),
                                                                offset: Offset(
                                                                    -1, -1),
                                                              ),
                                                              BoxShadow(
                                                                color: _myProvider
                                                                    .mainColor,
                                                                offset: Offset(
                                                                    5, 4),
                                                                spreadRadius:
                                                                    -0.5,
                                                                blurRadius:
                                                                    14.0,
                                                                // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: ExpansionTile(
                                                            onExpansionChanged:
                                                                (value) {
                                                              _myProvider
                                                                  .changeNoteTitleColor(
                                                                      value,
                                                                      index);
                                                              // used to animate
                                                              // if (value) {
                                                              //   _scrollController.animateTo(
                                                              //       _scrollController
                                                              //               .position
                                                              //               .pixels +
                                                              //           SizeX *
                                                              //               0.1,
                                                              //       duration:
                                                              //           Duration(
                                                              //               seconds:
                                                              //                   1),
                                                              //       curve: Curves
                                                              //           .easeIn);
                                                              // }
                                                            },
                                                            initiallyExpanded:
                                                                false,
                                                            // tried too hard to make the expanion color and
                                                            // collapsed color personalized but threre was  a problem
                                                            // Every widget when We call the notifier in the provider
                                                            // as I called one is ExpansionTile the Tile will be
                                                            // recreated so We have to defin this spesific listTile
                                                            // a key that the widget won't be changed !
                                                            key: new PageStorageKey<
                                                                    String>(
                                                                notes
                                                                    .get(keys[
                                                                        index])
                                                                    .title),
                                                            title: InkWell(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Checkbox(
                                                                        checkColor: _myProvider.textColor,
                                                                        value: notes.get(keys[index]).isChecked,
                                                                        activeColor: _myProvider.textColor,
                                                                        onChanged: (bool newValue) {
                                                                          _myProvider.updateIsChecked(
                                                                              newValue,
                                                                              keys,
                                                                              index);
                                                                        }),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 8,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        child:
                                                                            Text(
                                                                          notes.get(keys[index]).title.length >= (SizeY * 0.08).round()
                                                                              ? notes.get(keys[index]).title.substring(0, (SizeY * 0.08).round()) + "..."
                                                                              : notes.get(keys[index]).title,
                                                                          softWrap:
                                                                              false,
                                                                          style: TextStyle(
                                                                              color: _myProvider.noteTitleColor[index],
                                                                              fontSize: SizeX * SizeY * 0.00011,
                                                                              fontWeight: FontWeight.w100),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                _myProvider
                                                                    .loadNote(
                                                                        keys,
                                                                        index,
                                                                        context);
                                                              },
                                                            ),
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .all(SizeY *
                                                                        0.05),
                                                                child: Text(
                                                                  notes
                                                                      .get(keys[
                                                                          index])
                                                                      .text,
                                                                  style:
                                                                      TextStyle(
                                                                    color: _myProvider
                                                                        .textColor,
                                                                    fontSize: SizeX *
                                                                        SizeY *
                                                                        0.00008,
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
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                      onReorder: (int oldIndex, int newIndex) {
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

                                        Note note = notes.get(keys[oldIndex]);
                                        if (newIndex < oldIndex) {
                                          for (int i = oldIndex;
                                              i > newIndex;
                                              i--) {
                                            notes.put(keys[i],
                                                notes.get(keys[i - 1]));
                                          }
                                        } else {
                                          for (int i = oldIndex;
                                              i < newIndex;
                                              i++) {
                                            notes.put(keys[i],
                                                notes.get(keys[i + 1]));
                                          }
                                        }
                                        notes.put(keys[newIndex], note);
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
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

// void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
//   final keyContext = expansionTileKey.currentContext;
//   if (keyContext != null) {
//     Future.delayed(Duration(milliseconds: 200)).then((value) {
//       Scrollable.ensureVisible(keyContext,
//           duration: Duration(milliseconds: 200));
//     });
//   }
// }
