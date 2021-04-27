import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return AnimatedTheme(
      duration: Duration(milliseconds: 600),
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: _myProvider.mainColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: AnimatedContainer(
                duration: Duration(microseconds: 500),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(SizeX * 0.025),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          uiKit.AppLocalizations.of(context)
                                              .translate('notesApp'),
                                          style: TextStyle(
                                              color: _myProvider.titleColor,
                                              fontSize:
                                                  SizeX * SizeY * 0.00014),
                                        )),
                                    Container(
                                      padding: EdgeInsets.all(SizeX * 0.025),
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
                            uiKit.myRorderable(
                                SizeX: SizeX, SizeY: SizeY, noteBox: noteBox)
                          ],
                        )),
                    Container(
                      child: uiKit.MyNotesEditing(
                        SizeX: SizeX,
                        SizeY: SizeY,
                      ),
                    ),
                    Container(
                      child: uiKit.MyTimer(
                          SizeX: SizeX, SizeY: SizeY, noteBox: noteBox),
                    ),
                    Container(
                      child: uiKit.MyDoante(SizeX: SizeX, SizeY: SizeY,),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
