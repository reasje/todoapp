import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../main.dart';
import 'components/bottomnav_widget.dart';
import 'components/fab_widget.dart';
import 'components/tabview_widget.dart';

final GlobalKey<ScaffoldState> noteEditingScaffoldKey = new GlobalKey<ScaffoldState>();

// TODO moving and reordering list view effect
class NoteScreen extends StatefulWidget {
  NoteScreen({Key key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    final _noteLogic = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      key: noteEditingScaffoldKey,
      //resizeToAvoidBottomInset: false,
      backgroundColor: _themeProvider.mainColor,
      bottomNavigationBar: BottomNavWidget(),
      body: WillPopScope(
        onWillPop: () {
          _noteLogic.doneClicked(context);
          return;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Container(
              height: h,
              width: isLandscape ? w * 0.8 : w,
              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Consumer<BottomNavProvider>(
                builder: (ctx, _bottomNavProvider, _) {
                  return PageView(
                    onPageChanged: (value) {
                      _bottomNavProvider.newTabSelectedAnimation(value);
                    },
                    controller: _bottomNavProvider.pageController,
                    children: [
                      TabView(
                        index: 0,
                      ),
                      TabView(
                        index: 1,
                      ),
                      TabView(
                        index: 2,
                      ),
                      TabView(
                        index: 3,
                      ),
                      TabView(
                        index: 4,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: NoteEditingFloatingActionButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
