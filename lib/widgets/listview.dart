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
      margin: EdgeInsets.only(top: SizeX * 0.02),
      child: ValueListenableBuilder(
          valueListenable: noteBox.listenable(),
          builder: (context, Box<Note> notes, _) {
            List<int> keys = notes.keys.cast<int>().toList();
            return Theme(
              data: ThemeData(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              child: ReorderableListView(
                children: [
                  for (int index = 0; index < keys.length; index++)
                    Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.red,
                        ),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        notes.delete(keys[index]);
                      },
                      child: ListTile(
                        key: Key('$index'),
                        title: InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeX * 0.01),
                            height: SizeX * 0.25,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: uiKit.Colors.shadedBlue),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                uiKit.Colors.darkBlue),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Checkbox(
                                              checkColor: uiKit.Colors.darkBlue,
                                              value: notes
                                                  .get(keys[index])
                                                  .isChecked,
                                              activeColor:
                                                  uiKit.Colors.darkBlue,
                                              onChanged: (bool newValue) {
                                                _myProvider.updateIsChecked(
                                                    newValue, keys, index);
                                              }),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 10),
                                        child: Center(
                                          child: Text(
                                            notes.get(keys[index]).title,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: uiKit.Colors.darkBlue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    notes.get(keys[index]).text,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: uiKit.Colors.darkBlue,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          _myProvider.loadNote(keys, index, context);
                        },
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
            );
          }),
    );
  }
}
