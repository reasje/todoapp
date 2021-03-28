import 'package:flutter/material.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';

import '../applocalizations.dart';


Future<Widget> showAddDialog(
  BuildContext context,
  double SizeX,
  double SizeY,
  Box<Note> noteBox,
) async {
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  bool _validate = false;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Center(child: Text(AppLocalizations.of(context).translate('newNote'))),
              content: Container(
                height: SizeX * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      maxLines: 20,
                      maxLength: 20,
                      controller: _titleFieldController,
                      decoration:
                          InputDecoration(hintText: AppLocalizations.of(context).translate('newNoteTitle')),
                    ),
                    TextField(
                        maxLength: 100,
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate('newNoteText'),
                          errorText:
                              _validate ? AppLocalizations.of(context).translate('emptyValue') : null,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            width: SizeY * 0.2,
                            //margin: EdgeInsets.only(right: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: InkWell(
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context).translate('cancel'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                })),
                        Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                            width: SizeY * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context).translate('ok'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                if (_textFieldController.text.isNotEmpty) {
                                  String title;
                                  _titleFieldController.text.isEmpty
                                      ? title = "Unamed"
                                      : title = _titleFieldController.text;
                                  final String text = _textFieldController.text;
                                  Note note = Note(title, text, false);
                                  noteBox.add(note);
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _validate = true;
                                  });
                                }
                              },
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      });
}

Future<Widget> showUpdateDialog(BuildContext context, double SizeX,
    double SizeY, int index, Box<Note> noteBox, List<int> keys) async {
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  bool _validate = false;
  _titleFieldController.text = noteBox.get(keys[index]).title;
  _textFieldController.text = noteBox.get(keys[index]).text;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Center(child: Text(AppLocalizations.of(context).translate('updateNote'))),
              content: Container(
                height: SizeX * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: _titleFieldController,
                      decoration:
                      InputDecoration(hintText: AppLocalizations.of(context).translate('updateNoteTitle')),
                    ),
                    TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('updateNoteText'),
                        errorText: _validate ? AppLocalizations.of(context).translate('emptyValue') : null,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            width: SizeY * 0.2,
                            //margin: EdgeInsets.only(right: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: InkWell(
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context).translate('cancel'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                })),
                        Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                            width: SizeY * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context).translate('ok'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                if (_textFieldController.text.isNotEmpty) {
                                  Note note = new Note(
                                      _titleFieldController.text,
                                      _textFieldController.text,
                                      noteBox.get(keys[index]).isChecked);
                                  noteBox.put(keys[index], note);
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _validate = true;
                                  });
                                }
                              },
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      });
}
