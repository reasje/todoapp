import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:todoapp/widgets/image.dart';

// TODO moving and reordering list view effect
class MyNotesEditing extends StatefulWidget {
  double SizeX;
  double SizeY;
  LazyBox<Note> noteBox;
  MyNotesEditing(
      {@required this.SizeX,
      @required this.SizeY,
      @required this.noteBox,
      Key key})
      : super(key: key);

  @override
  _MyNotesEditingState createState() => _MyNotesEditingState();
}

class _MyNotesEditingState extends State<MyNotesEditing> {
  @override
  Widget build(BuildContext context) {
    double SizeX = widget.SizeX;
    double SizeY = widget.SizeY;
    final _myProvider = Provider.of<myProvider>(context);
    LazyBox<Note> noteBox = widget.noteBox;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: SizeX * 0.03),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 22,
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    uiKit.MyButton(
                      sizePU: SizeX * 0.07,
                      sizePD: SizeX * 0.08,
                      iconSize: SizeX * SizeY * 0.0001,
                      iconData: FontAwesome.undo,
                      id: 'undo',
                    ),
                    uiKit.MyButton(
                      sizePU: SizeX * 0.07,
                      sizePD: SizeX * 0.08,
                      iconSize: SizeX * SizeY * 0.0001,
                      iconData: FontAwesome.rotate_right,
                      id: 'redo',
                    ),
                    uiKit.MyButton(
                      sizePU: SizeX * 0.07,
                      sizePD: SizeX * 0.08,
                      iconSize: SizeX * SizeY * 0.0001,
                      iconData: FontAwesome.hourglass,
                      id: 'timer',
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 15,
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    uiKit.MyButton(
                      sizePU: SizeX * 0.07,
                      sizePD: SizeX * 0.08,
                      iconSize: SizeX * SizeY * 0.0001,
                      iconData: FontAwesome.times,
                      id: 'cancel',
                    ),
                    Container(
                      child: uiKit.MyButton(
                        sizePU: SizeX * 0.07,
                        sizePD: SizeX * 0.08,
                        iconSize: SizeX * SizeY * 0.0001,
                        iconData: FontAwesome.check,
                        id: 'save',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(SizeX * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(SizeX * 0.016)),
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
            child: TextField(
              controller: _myProvider.title,
              focusNode: _myProvider.fTitle,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: _myProvider.swachColor,
              cursorHeight: SizeX * 0.055,
              style: TextStyle(
                  color: _myProvider.textColor,
                  fontSize: _myProvider.isEn
                      ? SizeX * SizeY * 0.00012
                      : SizeX * SizeY * 0.0001,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(_myProvider.isEn
                      ? SizeX * SizeY * 0.00004
                      : SizeX * SizeY * 0.00003),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_sharp),
                    onPressed: () {
                      _myProvider.clearTitle();
                    },
                  ),
                  hintText:
                      uiKit.AppLocalizations.of(context).translate('titleHint'),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                      color: _myProvider.hintColor.withOpacity(0.12),
                      fontSize: _myProvider.isEn
                          ? SizeX * SizeY * 0.00012
                          : SizeX * SizeY * 0.0001,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(SizeX * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(SizeX * 0.016)),
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
            child: TextField(
              controller: _myProvider.text,
              focusNode: _myProvider.ftext,
              onChanged: (newVal) {
                _myProvider.listenerActivated(newVal);
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: _myProvider.swachColor,
              cursorHeight: SizeX * 0.045,
              style: TextStyle(
                  color: _myProvider.textColor,
                  fontSize: SizeX * SizeY * 0.00009,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_sharp),
                    onPressed: () {
                      _myProvider.clearText();
                    },
                  ),
                  contentPadding: EdgeInsets.all(SizeX * SizeY * 0.00006),
                  hintText:
                      uiKit.AppLocalizations.of(context).translate('textHint'),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                      color: _myProvider.hintColor.withOpacity(0.12),
                      fontSize: SizeX * SizeY * 0.00009,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _myProvider.imageList != null
                    ? _myProvider.imageList.length + 1
                    : 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index ==
                      (_myProvider.imageList != null
                          ? _myProvider.imageList.length
                          : 0)) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeY * 0.1),
                      alignment: Alignment.centerLeft,
                      child: uiKit.MyButton(
                        sizePU: SizeX * 0.07,
                        sizePD: SizeX * 0.08,
                        iconSize: SizeX * SizeY * 0.00006,
                        iconData: FontAwesome.plus,
                        id: 'newpic',
                      ),
                    );
                  } else {
                    return Dismissible(
                      direction: DismissDirection.up,
                      key: UniqueKey(),
                      background: Container(
                        padding: EdgeInsets.only(
                            left: SizeY * 0.1,
                            bottom: SizeX * 0.01,
                            right: SizeY * 0.1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          color: _myProvider.mainColor,
                        ),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.delete_sweep,
                          size: SizeX * SizeY * 0.0001,
                          color: _myProvider.textColor,
                        ),
                      ),
                      onDismissed: (direction) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            uiKit.MySnackBar(
                                uiKit.AppLocalizations.of(context)
                                    .translate('undoImage'),
                                true,
                                context, index));
                        _myProvider.imageDissmissed(index);
                      },
                      child: Container(
                          width: SizeX * 0.16,
                          margin:
                              EdgeInsets.symmetric(horizontal: SizeY * 0.03),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: _myProvider.lightShadowColor,
                                spreadRadius: 1.0,
                                blurRadius: 1.0,
                                offset: Offset(
                                    -1, -1), // changes position of shadow
                              ),
                              BoxShadow(
                                color:
                                    _myProvider.shadowColor.withOpacity(0.17),
                                spreadRadius: 1.0,
                                blurRadius: 2.0,
                                offset:
                                    Offset(3, 4), // changes position of shadow
                              ),
                            ],
                            color: _myProvider.mainColor,
                            // borderRadius:
                            //     BorderRadius.all(Radius.circular(SizeX * 0.3))
                          ),
                          child: _myProvider.imageList != null
                              ? InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PicDetail(index: index))),
                                  child: Hero(
                                      tag: 'pic${index}',
                                      child: Image.memory(
                                        _myProvider.imageList[index],
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : Container()),
                    );
                  }
                })),
        Expanded(child: Container())
      ],
    );
  }
}
