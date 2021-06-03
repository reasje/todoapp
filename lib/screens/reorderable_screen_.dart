import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/conn_provider.dart';

import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

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
    // TODO: implement initState
    _scrollController = ScrollController(keepScrollOffset: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _connState = Provider.of<ConnState>(context);
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;

    return Scaffold(
                resizeToAvoidBottomInset: false,
      backgroundColor: _myProvider.mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Expanded(
          child: Container(
              width: SizeX,
              margin: EdgeInsets.only(
                  //right: SizeY * 0.02,
                  //left: SizeY * 0.02,
                  ),
              // padding: EdgeInsets.only(top: SizeX * 0.01),
              child: ValueListenableBuilder(
                  valueListenable: noteBox.listenable(),
                  builder: (context, LazyBox<Note> notes, _) {
                    List<int> keys = notes.keys.cast<int>().toList();
    
                    return FutureBuilder(
                        future: _myProvider.updateListSize(keys, SizeX, SizeY),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
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
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.only(
                                                            top: SizeX * 0.03,
                                                            bottom: SizeX * 0.03,
                                                            left: SizeX * 0.03),
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          uiKit.AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'notesApp'),
                                                          style: TextStyle(
                                                              color: _myProvider
                                                                  .titleColor,
                                                              fontSize:
                                                                  _myProvider.isEn
                                                                      ? SizeX *
                                                                          SizeY *
                                                                          0.00012
                                                                      : SizeX *
                                                                          SizeY *
                                                                          0.0001),
                                                        )),
                                                    Container(
                                                      child: Icon(
                                                        FontAwesome.dot_circle_o,
                                                        size: SizeX *
                                                            SizeY *
                                                            0.00005,
                                                        color: _connState.is_conn
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          SizeX * 0.015),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: uiKit.MyButton(
                                                        sizePU: SizeX * 0.05,
                                                        sizePD: SizeX * 0.06,
                                                        iconSize: SizeX *
                                                            SizeY *
                                                            0.00006,
                                                        iconData:
                                                            FontAwesome.download,
                                                        id: 'download',
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          SizeX * 0.015),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: uiKit.MyButton(
                                                        sizePU: SizeX * 0.05,
                                                        sizePD: SizeX * 0.06,
                                                        iconSize: SizeX *
                                                            SizeY *
                                                            0.00006,
                                                        iconData:
                                                            FontAwesome.upload,
                                                        id: 'upload',
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          SizeX * 0.015),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: uiKit.MyButton(
                                                        sizePU: SizeX * 0.05,
                                                        sizePD: SizeX * 0.06,
                                                        iconSize: SizeX *
                                                            SizeY *
                                                            0.00006,
                                                        iconData:
                                                            FontAwesome.google,
                                                        id: 'google',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      SizeX * 0.015),
                                                  alignment: Alignment.centerLeft,
                                                  child: uiKit.MyButton(
                                                    sizePU: SizeX * 0.05,
                                                    sizePD: SizeX * 0.06,
                                                    iconSize:
                                                        SizeX * SizeY * 0.00006,
                                                    iconData: FontAwesome.code,
                                                    id: 'coder',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(SizeX * 0.025),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  uiKit.MyButton(
                                                    sizePU: SizeX * 0.07,
                                                    sizePD: SizeX * 0.08,
                                                    iconSize:
                                                        SizeX * SizeY * 0.0001,
                                                    iconData:
                                                        FontAwesome.language,
                                                    id: 'lan',
                                                  ),
                                                  uiKit.MyButton(
                                                    sizePU: SizeX * 0.07,
                                                    sizePD: SizeX * 0.08,
                                                    iconSize:
                                                        SizeX * SizeY * 0.0001,
                                                    iconData: FontAwesome.plus,
                                                    id: 'new',
                                                  ),
                                                  uiKit.MyButton(
                                                    sizePU: SizeX * 0.07,
                                                    sizePD: SizeX * 0.08,
                                                    iconSize:
                                                        SizeX * SizeY * 0.0001,
                                                    iconData:
                                                        FontAwesome.lightbulb_o,
                                                    id: 'lamp',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (noteBox.isEmpty)
                                        Container(
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      uiKit.AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'NoNotesyet'),
                                                      style: TextStyle(
                                                          color: _myProvider
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: SizeX *
                                                              SizeY *
                                                              0.00008),
                                                    ),
                                                    Text(
                                                      uiKit.AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'addNewNotePlease'),
                                                      style: TextStyle(
                                                          color: _myProvider
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              _myProvider.isEn
                                                                  ? SizeX *
                                                                      SizeY *
                                                                      0.00008
                                                                  : SizeX *
                                                                      SizeY *
                                                                      0.00006),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        )
                                      else
                                        Container(
                                          height:
                                              _myProvider.listview_size + 400.0,
                                          width: SizeY,
                                          child: ScrollConfiguration(
                                            behavior: NoGlowBehaviour(),
                                            child: AnimationLimiter(
                                              child: ReorderableListView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollController:
                                                    _scrollController,
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
                                                          color: _myProvider
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
                                                          color: _myProvider
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
                                                            bnote.imageList);
                                                        notes.delete(keys[index]);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                uiKit.MySnackBar(
                                                          uiKit.AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'undoNote'),
                                                          true,
                                                          context,
                                                          index,
                                                          notes,
                                                          note,
                                                          keys,
                                                        ));
                                                      },
                                                      child:
                                                          AnimationConfiguration
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
                                                              flipAxis:
                                                                  FlipAxis.y,
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
                                                                    top: SizeX *
                                                                        0.01),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        boxShadow: [
                                                                      BoxShadow(
                                                                        color: _myProvider
                                                                            .lightShadowColor,
                                                                        //spreadRadius: 1.0,
                                                                        blurRadius:
                                                                            5.0,
                                                                        offset: Offset(
                                                                            -6,
                                                                            -3), // changes position of shadow
                                                                      ),
                                                                      BoxShadow(
                                                                        color: _myProvider
                                                                            .shadowColor
                                                                            .withOpacity(
                                                                                0.2),
                                                                        //spreadRadius: 1.0,
                                                                        blurRadius:
                                                                            5.0,
                                                                        offset: Offset(
                                                                            6,
                                                                            12), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                        color: _myProvider
                                                                            .mainColor,
                                                                        //border: Border.all(width: 1, color: uiKit.Colors.whiteSmoke),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                                Radius.circular(10))),
                                                                //clipBehavior: Clip.antiAlias,
                                                                child: Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                      unselectedWidgetColor:
                                                                          _myProvider
                                                                              .textColor,
                                                                    ),
                                                                    child:
                                                                        FutureBuilder(
                                                                            future: _myProvider.getNoteListView(
                                                                                keys,
                                                                                index),
                                                                            builder:
                                                                                (BuildContext context, AsyncSnapshot snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Column(
                                                                                  children: [
                                                                                    snapshot.data.time != 0
                                                                                        ? InkWell(
                                                                                            key: new PageStorageKey<String>(snapshot.data.title),
                                                                                            onTap: () {
                                                                                              if (!(_timerState.isRunning.any((element) => element == true))) {
                                                                                                //_myProvider.changeTimerStack();
                                                                                                _timerState.loadTimer(
                                                                                                  keys,
                                                                                                  index,
                                                                                                  context,
                                                                                                );
                                                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                  return uiKit.MyTimer(SizeX: SizeX, SizeY: SizeY, noteBox: noteBox);
                                                                                                }));
                                                                                              } else {
                                                                                                if (_timerState.index == index) {
                                                                                                  // TODO Delete _myProvider.changeTimerStack();
                                                                                                  _timerState.loadTimer(
                                                                                                    keys,
                                                                                                    index,
                                                                                                    context,
                                                                                                  );
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                    return uiKit.MyTimer(SizeX: SizeX, SizeY: SizeY, noteBox: noteBox);
                                                                                                  }));
                                                                                                } else {
                                                                                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                                                  ScaffoldMessenger.of(context).showSnackBar(uiKit.MySnackBar(uiKit.AppLocalizations.of(context).translate('timerOn'), false, context));
                                                                                                }
                                                                                              }
                                                                                            },
                                                                                            child: Container(
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
                                                                                                child: Directionality(
                                                                                                  textDirection: TextDirection.ltr,
                                                                                                  child: Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        ((snapshot.data.leftTime / 3600) % 60).floor().toString().padLeft(2, '0'),
                                                                                                        style: TextStyle(color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        ':',
                                                                                                        style: TextStyle(color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        ((snapshot.data.leftTime / 60) % 60).floor().toString().padLeft(2, '0'),
                                                                                                        style: TextStyle(color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        ':',
                                                                                                        style: TextStyle(color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        (snapshot.data.leftTime % 60).floor().toString().padLeft(2, '0'),
                                                                                                        style: TextStyle(color: _timerState.isRunning[index] ? _myProvider.swachColor : _myProvider.textColor, fontSize: SizeX * SizeY * 0.00012, fontFamily: "Ubuntu Condensed"),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        // In this case the note doesnt have a
                                                                                        : Container(),
                                                                                    snapshot.data.time != 0
                                                                                        ? Container(
                                                                                            width: double.infinity,
                                                                                            height: SizeX * 0.02,
                                                                                          )
                                                                                        : Container(),
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(2),
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
                                                                                              offset: Offset(5, 4),
                                                                                              spreadRadius: -0.5,
                                                                                              blurRadius: 14.0,
                                                                                              // changes position of shadow
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        child: ExpansionTile(
                                                                                          onExpansionChanged: (value) {
                                                                                            _myProvider.changeNoteTitleColor(value, index);
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
                                                                                          initiallyExpanded: false,
                                                                                          // tried too hard to make the expanion color and
                                                                                          // collapsed color personalized but threre was  a problem
                                                                                          // Every widget when We call the notifier in the provider
                                                                                          // as I called one is ExpansionTile the Tile will be
                                                                                          // recreated so We have to defin this spesific listTile
                                                                                          // a key that the widget won't be changed !
                                                                                          key: new PageStorageKey<String>(snapshot.data.title),
                                                                                          title: InkWell(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  flex: 1,
                                                                                                  child: Checkbox(
                                                                                                      checkColor: _myProvider.textColor,
                                                                                                      value: snapshot.data.isChecked,
                                                                                                      activeColor: _myProvider.textColor,
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
                                                                                                        snapshot.data.title.length >= (SizeY * 0.08).round() ? snapshot.data.title.substring(0, (SizeY * 0.08).round()) + "..." : snapshot.data.title,
                                                                                                        softWrap: false,
                                                                                                        style: TextStyle(color: _myProvider.noteTitleColor[index], fontSize: _myProvider.isEn ? SizeX * SizeY * 0.00011 : SizeX * SizeY * 0.00009, fontWeight: _myProvider.isEn ? FontWeight.w100 : FontWeight.w600),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            onTap: () {
                                                                                              _myProvider.loadNote(context, keys, index);
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                return uiKit.MyNotesEditing(SizeX: SizeX, SizeY: SizeY, noteBox: noteBox);
                                                                                              }));
                                                                                            },
                                                                                          ),
                                                                                          children: [
                                                                                            Container(
                                                                                              padding: EdgeInsets.all(SizeY * 0.05),
                                                                                              child: Text(
                                                                                                snapshot.data.text,
                                                                                                style: TextStyle(
                                                                                                  color: _myProvider.textColor,
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
                                                                                );
                                                                              } else {
                                                                                return Container(child: Center(child: CircularProgressIndicator()));
                                                                              }
                                                                            })),
                                                              ),
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
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        });
                  })),
        ),
      ),
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