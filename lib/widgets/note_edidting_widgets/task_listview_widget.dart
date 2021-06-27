import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class taskListView extends StatelessWidget {
  final Color color;
  const taskListView({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    return Container(
      height: isLandscape ? SizeY * 0.7 : SizeX * 0.8,
      margin: EdgeInsets.all(SizeX * 0.02),
      child: Column(
        children: [
          Container(
            height: SizeX* 0.1,
            
            child: Row( children: [
              Switch(value: false, onChanged: (value) {
                
              },),
              Text('Reset checkboxs on day change !' ,style: TextStyle(
              color: _themeProvider.textColor,
              fontSize: _themeProvider.isEn
                  ? SizeX * SizeY * 0.00006
                  : SizeX * SizeY * 0.00004,
              fontWeight: FontWeight.w400),),
            ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          ),
          Container(
            height: SizeX*0.7,
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
                        children: List.generate(snapshot.data.length, (index) {
                          return AnimatedContainer(
                            key: snapshot.data[index].key,
                            duration: Duration(seconds: 5),
                            child: Dismissible(
                                key: snapshot.data[index].key,
                                background: Container(
                                  padding: EdgeInsets.only(
                                      left: SizeY * 0.1,
                                      bottom: SizeX * 0.01,
                                      right: SizeY * 0.1),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35)),
                                    color: _themeProvider.mainColor,
                                  ),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Container(
                                    height: SizeX * SizeY * 0.0002,
                                    width: SizeX * SizeY * 0.0002,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Icon(
                                      Icons.delete_sweep,
                                      size: SizeX * SizeY * 0.0001,
                                      color: _themeProvider.mainColor,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      uiKit.MySnackBar(
                                          uiKit.AppLocalizations.of(context)
                                              .translate('undoTask'),
                                          'undoTask',
                                          true,
                                          context,
                                          index));
                                  _myProvider.taskDissmissed(index);
                                },
                                child: Container(
                                  height: SizeXSizeY * 0.00022,
                                  margin: EdgeInsets.only(
                                    top: SizeX * 0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _myProvider.taskCheckBoxChanged(index);
                                        },
                                        child: Container(
                                            height: SizeX * 0.03,
                                            width: SizeX * 0.03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: color, width: 1.5),
                                                color: snapshot.data[index].isDone ??
                                                        false
                                                    ? color
                                                    : null),
                                            child:
                                                snapshot.data[index].isDone ?? false
                                                    ? Icon(
                                                        Icons.check_rounded,
                                                        size: SizeX * 0.028,
                                                        color: Colors.white,
                                                      )
                                                    : Container()),
                                      ),
                                      Container(
                                        height: SizeXSizeY * 0.00022,
                                        width: SizeY * 0.75,
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: snapshot
                                              .data[index].textEditingController,
                                          onSubmitted: (value) {
                                            _myProvider.checkListOnSubmit(index);
                                          },
                                          focusNode: snapshot.data[index].focusNode,
                                          cursorColor: _themeProvider.swachColor,
                                          cursorHeight: SizeX * 0.04,
                                          style: TextStyle(
                                              color: _themeProvider.textColor,
                                              fontSize: _themeProvider.isEn
                                                  ? SizeX * SizeY * 0.00008
                                                  : SizeX * SizeY * 0.00006,
                                              fontWeight: FontWeight.w200),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(
                                                  _themeProvider.isEn
                                                      ? SizeX * SizeY * 0.00001
                                                      : SizeX * SizeY * 0.000008),
                                              hintText:
                                                  uiKit.AppLocalizations.of(context)
                                                      .translate('titleHint'),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: _themeProvider.hintColor
                                                      .withOpacity(0.12),
                                                  fontSize: _themeProvider.isEn
                                                      ? SizeX * SizeY * 0.00008
                                                      : SizeX * SizeY * 0.00006,
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        })),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
