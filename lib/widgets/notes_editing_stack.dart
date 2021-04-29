import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

// TODO moving and reordering list view effect
class MyNotesEditing extends StatefulWidget {
  double SizeX;
  double SizeY;
  MyNotesEditing({@required this.SizeX, @required this.SizeY, Key key})
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: SizeX*0.03),
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
                      sizePU: SizeX*0.07,
                      sizePD: SizeX*0.08,
                      iconSize: SizeX*SizeY*0.0001,
                      iconData: FontAwesome.undo,
                      id: 'undo',
                    ),
                    uiKit.MyButton(
                      sizePU: SizeX*0.07,
                      sizePD: SizeX*0.08,
                      iconSize: SizeX*SizeY*0.0001,
                      iconData: FontAwesome.rotate_right,
                      id: 'redo',
                    ),
                    uiKit.MyButton(
                      sizePU: SizeX*0.07,
                      sizePD: SizeX*0.08,
                      iconSize: SizeX*SizeY*0.0001,
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
                      sizePU: SizeX*0.07,
                      sizePD: SizeX*0.08,
                      iconSize: SizeX*SizeY*0.0001,
                      iconData: FontAwesome.times,
                      id: 'cancel',
                    ),
                    Container(
                      child: uiKit.MyButton(
                        sizePU: SizeX*0.07,
                        sizePD: SizeX*0.08,
                        iconSize: SizeX*SizeY*0.0001,
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
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 1,
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: IconButton(
        //           icon: Icon(Icons.undo),
        //           disabledColor: uiKit.Colors.shadedBlue,
        //           color: uiKit.Colors.darkBlue,
        //           onPressed: !_myProvider.canUndo
        //               ? null
        //               : () {
        //                   if (mounted) {
        //                     _myProvider.changesUndo();
        //                   }
        //                 },
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 1,
        //       child: Align(
        //         alignment: Alignment.centerRight,
        //         child: IconButton(
        //           icon: Icon(Icons.access_alarms_rounded),
        //           color: uiKit.Colors.darkBlue,
        //           onPressed: () {
        //             showCupertinoModalPopup(
        //                 context: context,
        //                 builder: (context) => CupertinoActionSheet(
        //                       actions: [uiKit.MyDatePicker(context)],
        //                       cancelButton: CupertinoActionSheetAction(
        //                         child: Text(uiKit.AppLocalizations.of(context)
        //                             .translate('done')),
        //                         onPressed: () {
        //                           Navigator.pop(context);
        //                         },
        //                       ),
        //                     ));
        //           },
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        Container(
          margin: EdgeInsets.all(SizeX*0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(SizeX*0.016)),
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
            cursorHeight: SizeX * SizeY * 0.00012,
            style: TextStyle(
                color: _myProvider.textColor,
                fontSize:_myProvider.isEn ? SizeX * SizeY * 0.00012 : SizeX * SizeY * 0.0001,
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all( _myProvider.isEn ? SizeX * SizeY * 0.00004 : SizeX * SizeY * 0.00003),
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
                    fontSize: _myProvider.isEn ? SizeX * SizeY * 0.00012 : SizeX * SizeY * 0.0001 ,
                    fontWeight: FontWeight.w400)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(SizeX*0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(SizeX*0.016)),
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
              cursorHeight: SizeX * SizeY * 0.00009,
              style: TextStyle(
                  color: _myProvider.textColor,
                  fontSize: SizeX * SizeY *0.00009,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_sharp),
                    onPressed: () {
                      _myProvider.clearText();
                    },
                  ),
                  contentPadding: EdgeInsets.all(SizeX * SizeY * 0.00006),
                  hintText: uiKit.AppLocalizations.of(context)
                      .translate('textHint'),
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
        )
      ],
    );
  }
}
