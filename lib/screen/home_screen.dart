import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'dart:async';

// checkMe() {
//   final dateBox = Hive.box<String>(dateBoxName);
//   String date = dateBox.get('date');
//   var now = DateTime.now();
//   if (date != null) {
//     List<String> dateList = date.split(',');
//     int day = now.day;
//     int month = now.month;
//     int year = now.year;
//     Box<Note> noteBox = Hive.box<Note>(noteBoxName);
//     if (int.parse(dateList[0]) < year ||
//         int.parse(dateList[1]) < month ||
//         int.parse(dateList[2]) < day) {
//       if (noteBox.length != 0) {
//         for (int i = 0; i < noteBox.length; i++) {
//           var ntitle = noteBox.getAt(i).title;
//           var nttext = noteBox.getAt(i).text;
//           var nttime = noteBox.getAt(i).time;
//           var ntcolor = noteBox.getAt(i).color;
//           Note note = Note(ntitle, nttext, false, nttime, ntcolor);
//           noteBox.putAt(i, note);
//         }
//         dateBox.put('date',
//             "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
//       }
//     }
//   } else {
//     dateBox.put('date',
//         "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
//   }
// }

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<Note> noteBox = Hive.box<Note>(noteBoxName);
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   noteBox = Hive.box<Note>(noteBoxName);
  //   super.initState();
  //   // var _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //   //   checkMe();
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return AnimatedTheme(
      duration: Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: _myProvider.mainColor,
        body: SafeArea(
          child: Container(
              height: SizeX * 0.98,
              width: SizeY,
              padding: EdgeInsets.only(),
              child: IndexedStack(
                index: _myProvider.stack_index,
                children: [
                  Container(
                      width: SizeY,
                      height: SizeX,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    uiKit.AppLocalizations.of(context)
                                        .translate('notesApp'),
                                    style: TextStyle(
                                      color: _myProvider.titleColor,
                                        fontSize: SizeX * SizeY * 0.00014),
                                  )),
                              Container(
                                margin: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    uiKit.MyButton(
                                      SizeX: SizeX,
                                      SizeY: SizeY,
                                      iconData: FontAwesome.language,
                                      id: 'lan',
                                    ),
                                    uiKit.MyButton(
                                      SizeX: SizeX,
                                      SizeY: SizeY,
                                      iconData: FontAwesome.plus,
                                      id: 'new',
                                    ),
                                    uiKit.MyButton(
                                      SizeX: SizeX,
                                      SizeY: SizeY,
                                      iconData: FontAwesome.lightbulb_o,
                                      id: 'lamp',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          uiKit.myRorderable(
                              SizeX: SizeX, SizeY: SizeY, noteBox: noteBox)
                        ],
                      )),
                  Container(
                    child: uiKit.MyNotesEditing(
                      SizeX: SizeX,
                      SizeY: SizeY,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
