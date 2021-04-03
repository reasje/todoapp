import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'dart:async';

checkMe() {
  final dateBox = Hive.box<String>(dateBoxName);
  String date = dateBox.get('date');
  var now = DateTime.now();
  if (date != null) {
    List<String> dateList = date.split(',');
    int day = now.day;
    int month = now.month;
    int year = now.year;
    Box<Note> noteBox = Hive.box<Note>(noteBoxName);
    if (int.parse(dateList[0]) < year ||
        int.parse(dateList[1]) < month ||
        int.parse(dateList[2]) < day) {
      if (noteBox.length != 0) {
        for (int i = 0; i < noteBox.length; i++) {
          var ntitle = noteBox.getAt(i).title;
          var nttext = noteBox.getAt(i).text;
          Note note = Note(ntitle, nttext, false);
          noteBox.putAt(i, note);
        }
        dateBox.put('date',
            "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
      }
    }
  } else {
    dateBox.put('date',
        "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<Note> noteBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteBox = Hive.box<Note>(noteBoxName);
    super.initState();
    var _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return 
    Scaffold(
      backgroundColor: uiKit.Colors.darkBlue,
      body: SafeArea(
        child: Container(
            height: SizeX * 0.93,
            width: SizeY,
            margin: EdgeInsets.only(top: SizeX * 0.01),
            padding:
                EdgeInsets.only(left: SizeX * 0.0005, right: SizeX * 0.0005),
            decoration: BoxDecoration(
                boxShadow: [
      BoxShadow(
        color: uiKit.Colors.whiteSmoke.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 1), // changes position of shadow
      ),
    ],                
                border: Border.all(width: 1, color: uiKit.Colors.darkBlue),
                color: uiKit.Colors.whiteSmoke,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: IndexedStack(
              index: _myProvider.stack_index,
              children: [
                Container(
                  child: Container(
                      width: SizeY,
                      child: uiKit.myRorderable(
                          SizeX: SizeX, SizeY: SizeY, noteBox: noteBox)),
                ),
                Container(
                  child: uiKit.MyNotesEditing(SizeX: SizeX,SizeY: SizeY,),
                )
              ],
            )),
      ),
      floatingActionButton: IndexedStack(
        alignment: Alignment.center,
        index: _myProvider.floating_index,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              _myProvider.newNoteClicked(context);
            },
            backgroundColor: uiKit.Colors.lightBlue,
            child: Icon(
              Icons.add,
              size: 27,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  _myProvider.doneClicked();
                },
                backgroundColor: uiKit.Colors.lightBlue,
                child: Icon(
                  Icons.done,
                  size: 27,
                ),
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  _myProvider.cancelClicked();
                },
                backgroundColor: uiKit.Colors.lightBlue,
                child: Icon(
                  Icons.clear,
                  size: 27,
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
