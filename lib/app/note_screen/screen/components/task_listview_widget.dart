import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/notetask_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/snackbar.dart';

class TaskListView extends StatelessWidget {
  final Color color;
  const TaskListView({
    Key key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);

    final _noteTaskProvider = Provider.of<NoteTaskProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      height: isLandscape ? w * 0.7 : h * 0.8,
      margin: EdgeInsets.all(h * 0.02),
      child: Column(
        children: [
          Container(
            height: h * 0.06,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate('reset'),
                  style: TextStyle(
                      color: _themeProvider.textColor,
                      fontSize: _themeProvider.isEn ? h * w * 0.00007 : h * w * 0.00005,
                      fontWeight: FontWeight.w400),
                ),
                Switch(
                  activeColor: color,
                  inactiveTrackColor: _themeProvider.textColor,
                  inactiveThumbColor: _themeProvider.mainColor,
                  value: _noteTaskProvider.resetCheckBoxs,
                  onChanged: (value) {
                    _noteTaskProvider.changeResetCheckBoxs(value);
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Container(
            height: h * 0.7,
            child: FutureBuilder(
              future: _noteTaskProvider.getTaskList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: ReorderableListView(
                        scrollController: _noteTaskProvider.scrollController,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        onReorder: (oldIndex, newIndex) {
                          _noteTaskProvider.reorderTaskList(oldIndex, newIndex);
                        },
                        children: List.generate(snapshot.data.length, (index) {
                          return AnimatedContainer(
                            key: snapshot.data[index].key,
                            duration: Duration(seconds: 5),
                            child: Dismissible(
                                key: snapshot.data[index].key,
                                background: Container(
                                  padding: EdgeInsets.only(left: w * 0.1, bottom: h * 0.01, right: w * 0.1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(35)),
                                    color: _themeProvider.mainColor,
                                  ),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Container(
                                    height: h * w * 0.0002,
                                    width: h * w * 0.0002,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Icon(
                                      Icons.delete_sweep,
                                      size: h * w * 0.0001,
                                      color: _themeProvider.mainColor,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                      AppLocalizations.of(context).translate('undoTask'), 'undoTask', true,
                                      context: context, index: index));
                                  _noteTaskProvider.taskDissmissed(index);
                                },
                                child: Container(
                                  height: h * w * 0.00022,
                                  margin: EdgeInsets.only(
                                    top: h * 0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _noteTaskProvider.taskCheckBoxChanged(index);
                                        },
                                        child: Container(
                                            height: h * 0.03,
                                            width: h * 0.03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: color, width: 1.5),
                                                color: snapshot.data[index].isDone ?? false ? color : null),
                                            child: snapshot.data[index].isDone ?? false
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    size: h * 0.028,
                                                    color: Colors.white,
                                                  )
                                                : Container()),
                                      ),
                                      Container(
                                        height: h * w * 0.00022,
                                        width: w * 0.75,
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: snapshot.data[index].textEditingController,
                                          onSubmitted: (value) {
                                            _noteTaskProvider.checkListOnSubmit(index);
                                          },
                                          focusNode: snapshot.data[index].focusNode,
                                          cursorColor: _themeProvider.swashColor,
                                          cursorHeight: h * 0.04,
                                          style: TextStyle(
                                              color: _themeProvider.textColor,
                                              fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00006,
                                              fontWeight: FontWeight.w200),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(_themeProvider.isEn ? h * w * 0.00001 : h * w * 0.000008),
                                              hintText: AppLocalizations.of(context).translate('titleHint'),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: _themeProvider.hintColor.withOpacity(0.12),
                                                  fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00006,
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                      ),
                                      Icon(
                                        Icons.swap_vertical_circle_rounded,
                                        color: color,
                                      ),
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
