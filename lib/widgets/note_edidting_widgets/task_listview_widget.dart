import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class taskListView extends StatelessWidget {
  const taskListView({
    Key key,
    @required this.isLandscape,
    @required this.SizeY,
    @required this.SizeX,
    @required NoteProvider myProvider,
    @required ThemeProvider themeProvider,
    @required this.SizeXSizeY,
  }) : _myProvider = myProvider, _themeProvider = themeProvider, super(key: key);

  final bool isLandscape;
  final double SizeY;
  final double SizeX;
  final NoteProvider _myProvider;
  final ThemeProvider _themeProvider;
  final double SizeXSizeY;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLandscape ? SizeY * 0.7 : SizeX * 0.7,
      margin: EdgeInsets.all(SizeX * 0.02),
      child: FutureBuilder(
        future: _myProvider.getTaskList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    _myProvider.reorder(oldIndex, newIndex);
                  },
                  children: List.generate(snapshot.data.length,
                      (index) {
                    return Dismissible(
                        key: snapshot.data[index].key,
                        background: Container(
                          padding: EdgeInsets.only(
                              left: SizeY * 0.1,
                              bottom: SizeX * 0.01,
                              right: SizeY * 0.1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(35)),
                            color: _themeProvider.mainColor,
                          ),
                          alignment:
                              AlignmentDirectional.centerEnd,
                          child: Container(
                            height: SizeX * SizeY * 0.0002,
                            width: SizeX * SizeY * 0.0002,
                            decoration: BoxDecoration(
                              color: _themeProvider.textColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30)),
                            ),
                            child: Icon(
                              Icons.delete_sweep,
                              size: SizeX * SizeY * 0.0001,
                              color: _themeProvider.mainColor,
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(uiKit.MySnackBar(
                                  uiKit.AppLocalizations.of(
                                          context)
                                      .translate('undoTask'),
                                  'undoTask',
                                  true,
                                  context,
                                  index));
                          _myProvider.taskDissmissed(index);
                        },
                        child: Container(
                          height: SizeXSizeY * 0.00022,
                          child: Row(
                            children: [
                              Checkbox(
                                value:
                                    snapshot.data[index].isDone,
                                onChanged: (value) {
                                  _myProvider
                                      .taskCheckBoxChanged(
                                          value, index);
                                },
                              ),
                              Container(
                                height: SizeXSizeY * 0.00022,
                                width: SizeY * 0.8,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    top: SizeX * 0.01),
                                child: TextField(
                                  controller: snapshot
                                      .data[index]
                                      .textEditingController,
                                  onSubmitted: (value) {
                                    _myProvider
                                        .checkListOnSubmit(
                                            index);
                                  },
                                  focusNode: snapshot
                                      .data[index].focusNode,
                                  cursorColor:
                                      _themeProvider.swachColor,
                                  cursorHeight: SizeX * 0.055,
                                  style: TextStyle(
                                      color: _themeProvider
                                          .textColor,
                                      fontSize:
                                          _themeProvider.isEn
                                              ? SizeX *
                                                  SizeY *
                                                  0.00011
                                              : SizeX *
                                                  SizeY *
                                                  0.00009,
                                      fontWeight:
                                          FontWeight.w200),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(
                                          _themeProvider.isEn
                                              ? SizeX *
                                                  SizeY *
                                                  0.00001
                                              : SizeX *
                                                  SizeY *
                                                  0.000008),
                                      hintText: uiKit.AppLocalizations.of(context).translate(
                                          'titleHint'),
                                      border: InputBorder.none,
                                      focusedBorder:
                                          InputBorder.none,
                                      enabledBorder:
                                          InputBorder.none,
                                      errorBorder:
                                          InputBorder.none,
                                      disabledBorder:
                                          InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: _themeProvider.hintColor
                                              .withOpacity(
                                                  0.12),
                                          fontSize: _themeProvider.isEn
                                              ? SizeX * SizeY * 0.00011
                                              : SizeX * SizeY * 0.0001,
                                          fontWeight: FontWeight.w200)),
                                ),
                              )
                            ],
                          ),
                        ));
                  })),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}