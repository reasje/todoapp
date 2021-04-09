import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/bloc/timer_bloc.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/ticker.dart';
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
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
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
        padding: EdgeInsets.only(top: SizeX * 0.01),
        child: ValueListenableBuilder(
            valueListenable: noteBox.listenable(),
            builder: (context, Box<Note> notes, _) {
              List<int> keys = notes.keys.cast<int>().toList();
              if (noteBox.isEmpty) {
                return Column(
                  children: [
                    Container(
                      height: SizeX * 0.5,
                      width: SizeY * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(top: SizeX * 0.019),
                        child: Container(
                          height: SizeX * 0.65,
                          width: SizeY,
                          child: Image.asset(
                            "assets/notask.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      //padding: EdgeInsets.only(bottom: SizeX * 0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            uiKit.AppLocalizations.of(context)
                                .translate('NoNotesyet'),
                            style: TextStyle(
                                color: _myProvider.textColor,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeX * SizeY * 0.0001),
                          ),
                          Text(
                            uiKit.AppLocalizations.of(context)
                                .translate('addNewNotePlease'),
                            style: TextStyle(
                                color: _myProvider.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: SizeX * SizeY * 0.0001),
                          ),
                        ],
                      ),
                    ))
                  ],
                );
              } else {
                return Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    textTheme: TextTheme(
                        headline1: TextStyle(color: _myProvider.textColor)),
                  ),
                  child: ScrollConfiguration(
                    behavior: NoGlowBehaviour(),
                    child: ReorderableListView(
                      padding: EdgeInsets.only(
                          bottom: SizeX * 0.1, top: SizeX * 0.01),
                      children: [
                        for (int index = 0; index < keys.length; index++)
                          Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              padding: EdgeInsets.only(
                                  left: SizeY * 0.1,
                                  bottom: SizeX * 0.01,
                                  right: SizeY * 0.1),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: _myProvider.mainColor,
                              ),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete_sweep,
                                size: SizeX * SizeY * 0.0002,
                                color: _myProvider.textColor,
                              ),
                            ),
                            onDismissed: (direction) {
                              Note note = Note(
                                noteBox.get(keys[index]).title,
                                noteBox.get(keys[index]).text,
                                noteBox.get(keys[index]).isChecked,
                                noteBox.get(keys[index]).time,
                                noteBox.get(keys[index]).color,
                                noteBox.get(keys[index]).leftTime,
                              );
                              notes.delete(keys[index]);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  uiKit.MySnackBar(
                                      uiKit.AppLocalizations.of(context)
                                          .translate('undoNote'),
                                      true,
                                      context,
                                      noteBox,
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
                                    bottom: SizeX * 0.04, top: SizeX * 0.01),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: _myProvider.lightShadowColor,
                                        //spreadRadius: 1.0,
                                        blurRadius: 5.0,
                                        offset: Offset(-6,
                                            -3), // changes position of shadow
                                      ),
                                      BoxShadow(
                                        color: _myProvider.shadowColor
                                            .withOpacity(0.2),
                                        //spreadRadius: 1.0,
                                        blurRadius: 5.0,
                                        offset: Offset(6,
                                            12), // changes position of shadow
                                      ),
                                    ],
                                    color: _myProvider.mainColor,
                                    //border: Border.all(width: 1, color: uiKit.Colors.whiteSmoke),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                //clipBehavior: Clip.antiAlias,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        _myProvider.textColor,
                                  ),
                                  child: Column(
                                    children: [
                                      notes.get(keys[index]).time != 0
                                          ? BlocProvider(
                                              create: (context) => TimerBloc(
                                                  ticker: Ticker(),
                                                  duration: notes
                                                      .get(keys[index])
                                                      .time,
                                                  keys: keys,
                                                  index: index),
                                              child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: _myProvider
                                                              .lightShadowColor,
                                                          offset: Offset(2, 2),
                                                          blurRadius: 0.0,
                                                          // changes position of shadow
                                                        ),
                                                        BoxShadow(
                                                          color: _myProvider
                                                              .shadowColor
                                                              .withOpacity(
                                                                  0.14),
                                                          offset:
                                                              Offset(-1, -1),
                                                        ),
                                                        BoxShadow(
                                                          color: _myProvider
                                                              .mainColor,
                                                          offset: Offset(5, 8),
                                                          spreadRadius: -0.5,
                                                          blurRadius: 14.0,
                                                          // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: BlocBuilder<
                                                        TimerBloc, TimerState>(
                                                      builder:
                                                          (context, state) {
                                                        final String
                                                            hourSection =
                                                            ((state.duration /
                                                                        3600) %
                                                                    60)
                                                                .floor()
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                        final String
                                                            minutesSection =
                                                            ((state.duration /
                                                                        60) %
                                                                    60)
                                                                .floor()
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                        final String
                                                            secondsSection =
                                                            (state.duration %
                                                                    60)
                                                                .floor()
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');

                                                        final TimerState
                                                            currentState =
                                                            BlocProvider.of<
                                                                        TimerBloc>(
                                                                    context)
                                                                .state;
                                                        //_myProvider.saveDuration(keys, index, state.duration);
                                                        return InkWell(
                                                          child: Container(
                                                            //padding: EdgeInsets.all(SizeX*SizeY*0.00001),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  hourSection,
                                                                  style: TextStyle(
                                                                      color: currentState
                                                                              is Running
                                                                          ? _myProvider
                                                                              .swachColor
                                                                          : _myProvider
                                                                              .textColor,
                                                                      fontSize: SizeX *
                                                                          SizeY *
                                                                          0.00015),
                                                                ),
                                                                Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      color: currentState
                                                                              is Running
                                                                          ? _myProvider
                                                                              .swachColor
                                                                          : _myProvider
                                                                              .textColor,
                                                                      fontSize: SizeX *
                                                                          SizeY *
                                                                          0.00015),
                                                                ),
                                                                Text(
                                                                  minutesSection,
                                                                  style: TextStyle(
                                                                      color: currentState
                                                                              is Running
                                                                          ? _myProvider
                                                                              .swachColor
                                                                          : _myProvider
                                                                              .textColor,
                                                                      fontSize: SizeX *
                                                                          SizeY *
                                                                          0.00015),
                                                                ),
                                                                Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      color: currentState
                                                                              is Running
                                                                          ? _myProvider
                                                                              .swachColor
                                                                          : _myProvider
                                                                              .textColor,
                                                                      fontSize: SizeX *
                                                                          SizeY *
                                                                          0.00015),
                                                                ),
                                                                Text(
                                                                  secondsSection,
                                                                  style: TextStyle(
                                                                      color: currentState
                                                                              is Running
                                                                          ? _myProvider
                                                                              .swachColor
                                                                          : _myProvider
                                                                              .textColor,
                                                                      fontSize: SizeX *
                                                                          SizeY *
                                                                          0.00015),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (currentState
                                                                is Running) {
                                                              BlocProvider.of<
                                                                          TimerBloc>(
                                                                      context)
                                                                  .add(Pause());
                                                            } else {
                                                              BlocProvider.of<
                                                                          TimerBloc>(
                                                                      context)
                                                                  .add(Start(
                                                                      duration:
                                                                          currentState
                                                                              .duration));
                                                            }
                                                          },
                                                          onDoubleTap: () {
                                                            BlocProvider.of<
                                                                        TimerBloc>(
                                                                    context)
                                                                .add(Reset());
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  )),
                                            )
                                          // In this case the note doesnt have a
                                          : Container(),
                                      notes.get(keys[index]).time != 0
                                          ? Container(
                                              width: double.infinity,
                                              height: SizeX * 0.02,
                                            )
                                          : Container(),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _myProvider
                                                    .lightShadowColor,
                                                offset: Offset(2, 2),
                                                blurRadius: 0.0,
                                                // changes position of shadow
                                              ),
                                              BoxShadow(
                                                color: _myProvider.shadowColor
                                                    .withOpacity(0.14),
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
                                              _myProvider.changeNoteTitleColor(
                                                  value, index);
                                            },
                                            initiallyExpanded: false,
                                            // tried too hard to make the expanion color and
                                            // collapsed color personalized but threre was  a problem
                                            // Every widget when We call the notifier in the provider
                                            // as I called one is ExpansionTile the Tile will be
                                            // recreated so We have to defin this spesific listTile
                                            // a key that the widget won't be changed !
                                            key: new PageStorageKey<String>(
                                                notes.get(keys[index]).title),
                                            title: InkWell(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Checkbox(
                                                      
                                                        checkColor: _myProvider
                                                            .textColor,
                                                        value: notes
                                                            .get(keys[index])
                                                            .isChecked,
                                                        activeColor: _myProvider
                                                            .textColor,
                                                        onChanged:
                                                            (bool newValue) {
                                                          _myProvider
                                                              .updateIsChecked(
                                                                  newValue,
                                                                  keys,
                                                                  index);
                                                        }),
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Center(
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Text(
                                                          notes
                                                                      .get(keys[
                                                                          index])
                                                                      .title
                                                                      .length >=
                                                                  (SizeY * 0.08)
                                                                      .round()
                                                              ? notes
                                                                      .get(keys[
                                                                          index])
                                                                      .title
                                                                      .substring(
                                                                          0,
                                                                          (SizeY * 0.08)
                                                                              .round()) +
                                                                  "..."
                                                              : notes
                                                                  .get(keys[
                                                                      index])
                                                                  .title,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              color: _myProvider
                                                                      .noteTitleColor[
                                                                  index],
                                                              fontSize: SizeX *
                                                                  SizeY *
                                                                  0.00016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                _myProvider.loadNote(
                                                    keys, index, context);
                                              },
                                            ),
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                35))),
                                                child: Text(
                                                  notes.get(keys[index]).text,
                                                  style: TextStyle(
                                                    color:
                                                        _myProvider.textColor,
                                                    fontSize:
                                                        SizeX * SizeY * 0.0001,
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
                          for (int i = oldIndex; i > newIndex; i--) {
                            notes.put(keys[i], notes.get(keys[i - 1]));
                          }
                        } else {
                          for (int i = oldIndex; i < newIndex; i++) {
                            notes.put(keys[i], notes.get(keys[i + 1]));
                          }
                        }
                        notes.put(keys[newIndex], note);
                      },
                    ),
                  ),
                );
              }
            }),
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
