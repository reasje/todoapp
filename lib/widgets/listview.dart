import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/notes_provider.dart';
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
    return Container(
      margin: EdgeInsets.only(
          top: SizeX * 0.02, right: SizeY * 0.02, left: SizeY * 0.02),
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
                    padding: EdgeInsets.only(bottom: SizeX * 0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          uiKit.AppLocalizations.of(context)
                              .translate('NoNotesyet'),
                          style: TextStyle(
                              color: uiKit.Colors.darkBlue,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeX * SizeY * 0.00009),
                        ),
                        Text(
                          uiKit.AppLocalizations.of(context)
                              .translate('addNewNotePlease'),
                          style: TextStyle(
                              color: uiKit.Colors.darkBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeX * SizeY * 0.00009),
                        ),
                      ],
                    ),
                  ))
                ],
              );
            } else {
              return Theme(
                data: ThemeData(
                  fontFamily: "BalsamiqSans",
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ScrollConfiguration(
                  behavior: NoGlowBehaviour(),
                  child: ReorderableListView(
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
                              color: uiKit.Colors.whiteSmoke,
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                            child: Icon(
                              Icons.delete_sweep,
                              size: SizeX * SizeY * 0.0002,
                              color: uiKit.Colors.darkBlue,
                            ),
                          ),
                          onDismissed: (direction) {
                            Note note = Note(
                                noteBox.get(keys[index]).title,
                                noteBox.get(keys[index]).text,
                                noteBox.get(keys[index]).isChecked,
                                noteBox.get(keys[index]).time);
                            notes.delete(keys[index]);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                          child: Card(
                            elevation: 4,
                            shadowColor: uiKit.Colors.darkBlue,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Theme(
                              data: ThemeData(
                                  fontFamily: "BalsamiqSans",
                                  unselectedWidgetColor: uiKit.Colors.darkBlue,
                                  primarySwatch: uiKit.darkBlueMaterial,
                                  accentColor: uiKit.Colors.lightBlue),
                              child: ExpansionTile(
                                collapsedBackgroundColor:
                                    uiKit.Colors.shadedBlue,
                                initiallyExpanded: false,
                                key: Key('$index'),
                                backgroundColor: uiKit.Colors.shadedBlue,
                                title: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                            checkColor: uiKit.Colors.darkBlue,
                                            value: notes
                                                .get(keys[index])
                                                .isChecked,
                                            activeColor: uiKit.Colors.darkBlue,
                                            onChanged: (bool newValue) {
                                              _myProvider.updateIsChecked(
                                                  newValue, keys, index);
                                            }),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              notes
                                                          .get(keys[index])
                                                          .title
                                                          .length >=
                                                      (SizeY * 0.08).round()
                                                  ? notes
                                                          .get(keys[index])
                                                          .title
                                                          .substring(
                                                              0,
                                                              (SizeY * 0.08)
                                                                  .round()) +
                                                      "..."
                                                  : notes
                                                      .get(keys[index])
                                                      .title,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeX * SizeY * 0.00014,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _myProvider.loadNote(keys, index, context);
                                  },
                                ),
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35))),
                                    child: Text(
                                      notes.get(keys[index]).text,
                                      style: TextStyle(
                                        fontSize: SizeX * SizeY * 0.0001,
                                        color: uiKit.Colors.darkBlue,
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
                      print(
                          "new Index and its value ${newIndex} , ${notes.get(keys[newIndex]).title}");
                      print(
                          "old Index and its value ${oldIndex} , ${notes.get(keys[oldIndex]).title}");
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
