import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

// TODO snack bar showing
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
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.undo),
              disabledColor: uiKit.Colors.shadedBlue,
              color: uiKit.Colors.darkBlue,
              onPressed: !_myProvider.canUndo
                  ? null
                  : () {
                      if (mounted) {
                        _myProvider.changesUndo();
                      }
                    },
            ),
          ],
        ),
        TextField(
          controller: _myProvider.title,
          focusNode: _myProvider.fTitle,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: uiKit.Colors.lightBlue,
          cursorHeight: SizeX * SizeY * 0.00014,
          style: TextStyle(
              color: uiKit.Colors.lightBlue,
              fontSize: SizeX * SizeY * 0.00014,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(SizeX * SizeY * 0.00006),
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
                  color: uiKit.Colors.shadedBlue,
                  fontSize: SizeX * SizeY * 0.00014,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: TextField(
            controller: _myProvider.text,
            focusNode: _myProvider.ftext,
            onChanged: (newVal) {
              _myProvider.listenerActivated(newVal);
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            cursorColor: uiKit.Colors.lightBlue,
            cursorHeight: SizeX * SizeY * 0.00011,
            style: TextStyle(
                color: uiKit.Colors.lightBlue,
                fontSize: SizeX * SizeY * 0.00011,
                fontWeight: FontWeight.w600),
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
                    color: uiKit.Colors.shadedBlue,
                    fontSize: SizeX * SizeY * 0.00011,
                    fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }
}
