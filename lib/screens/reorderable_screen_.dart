import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/reorderable_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import '../main.dart';

class MyRorderable extends StatefulWidget {
  MyRorderable({Key key}) : super(key: key);

  @override
  _MyRorderableState createState() => _MyRorderableState();
}

class _MyRorderableState extends State<MyRorderable> {
  @override
  Widget build(BuildContext context) {
    final _reorderableProvider =
        Provider.of<ReorderableProvider>(context, listen: false);
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Consumer<ThemeProvider>(
      builder: (ctx, _themeProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: _themeProvider.mainColor,
          body: Container(
              padding: EdgeInsets.only(top: SizeXSizeY * 0.00008),
              width: SizeY,
              child: ValueListenableBuilder(
                  valueListenable: noteBox.listenable(),
                  builder: (context, LazyBox<Note> notes, _) {
                    List<int> keys = notes.keys.cast<int>().toList();
                    return Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        height: SizeX,
                        width: SizeY,
                        child: Column(
                          children: [
                            uiKit.ReorderableListButtonsWidget(),
                            if (noteBox.isEmpty)
                              uiKit.noNotes()
                            else
                              Align(

                                child: Container(
                                    height: SizeX*0.84,
                                    child: ScrollConfiguration(
                                      behavior: NoGlowBehaviour(),
                                      child: AnimationLimiter(
                                        child: ReorderableListView(
                                          // physics:
                                          //     NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              bottom: SizeX * 0.1,
                                              top: SizeX * 0.01),
                                          children: [
                                            for (int index = 0;
                                                index < notes.length;
                                                index++)
                                              FutureBuilder(
                                                  key: UniqueKey(),
                                                  future:
                                                      notes.get(keys[index]),
                                                  builder:
                                                      (context, snapShot) {
                                                    if (snapShot.hasData) {
                                                      return uiKit
                                                          .ReorderableCardWidget(
                                                        index: index,
                                                        notes: notes,
                                                        snapShot: snapShot,
                                                      );
                                                    } else {
                                                      return uiKit
                                                          .LoadingCardWidget();
                                                    }
                                                  }),
                                          ],
                                          onReorder: (int oldIndex,
                                              int newIndex) async {
                                            _reorderableProvider
                                                .reorderNoteList(
                                                    oldIndex, newIndex);
                                            // if oldIndex < newIndex the flutter asumes the
                                            // newIndex is newIndex+1 for example new index yopu think is
                                            // 1 and old index is 0 but the realaity is  that new index is
                                            // 2 !
                                          },
                                        ),
                                      ),
                                    )),
                              ),
                            Consumer<ReorderableProvider>(
                              builder: (ctx, _reorderableProvider, _) {
                                return Visibility(
                                    visible: _reorderableProvider.isLoading,
                                    child: uiKit.LoadingWidget());
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  })),
          floatingActionButton: uiKit.FloatingActionButtonWidget(),
        );
      },
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
