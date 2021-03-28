import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

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
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: uiKit.Colors.darkBlue,
      body: SafeArea(
        child: Container(
            height: SizeX * 0.93,
            width: SizeY,
            margin: EdgeInsets.only(top: SizeX * 0.01),
            padding:
                EdgeInsets.only(left: SizeX * 0.0005, right: SizeX * 0.0005),
            decoration: BoxDecoration(
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
                  child: uiKit.MyNotesEditing(),
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
              _myProvider.loop();
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
