import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/reorderable_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:todoapp/widgets/loading_widget.dart';
import '../main.dart';

class MyRorderable extends StatefulWidget {
  MyRorderable({Key key}) : super(key: key);

  @override
  _MyRorderableState createState() => _MyRorderableState();
}

class _MyRorderableState extends State<MyRorderable> {
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController(keepScrollOffset: false);
    super.initState();
  }

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
                      child: ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              uiKit.ReorderableListButtonsWidget(),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (noteBox.isEmpty)
                                    uiKit.noNotes()
                                  else
                                    FutureBuilder(
                                        future: _reorderableProvider
                                            .updateListSize(keys, SizeX, SizeY),
                                        builder: (context, snapShot) {
                                          if (snapShot.hasData) {
                                            return Container(
                                              height: _reorderableProvider
                                                      .listViewSize +
                                                  400.0,
                                              width: SizeY,
                                              child: ScrollConfiguration(
                                                behavior: NoGlowBehaviour(),
                                                child: AnimationLimiter(
                                                  child: ReorderableListView(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollController:
                                                        _scrollController,
                                                    padding: EdgeInsets.only(
                                                        bottom: SizeX * 0.1,
                                                        top: SizeX * 0.01),
                                                    children: [
                                                      for (int index = 0;
                                                          index < keys.length;
                                                          index++)
                                                        FutureBuilder(
                                                            key: UniqueKey(),
                                                            future: notes.get(
                                                                keys[index]),
                                                            builder: (context,
                                                                snapShot) {
                                                              if (snapShot
                                                                  .hasData) {
                                                                return uiKit
                                                                    .ReorderableCardWidget(
                                                                  index: index,
                                                                  notes: notes,
                                                                  snapShot:
                                                                      snapShot,
                                                                );
                                                              } else {
                                                                return uiKit
                                                                    .LoadingCardWidget();
                                                              }
                                                            }),
                                                    ],
                                                    onReorder: (int oldIndex,
                                                        int newIndex) async {
                                                      // TODO try corecting the when there 3 element and
                                                      // you change the bottom and the top elements
                                                      _reorderableProvider
                                                          .reorderNoteList(
                                                              oldIndex,
                                                              newIndex);
                                                      // if oldIndex < newIndex the flutter asumes the
                                                      // newIndex is newIndex+1 for example new index yopu think is
                                                      // 1 and old index is 0 but the realaity is  that new index is
                                                      // 2 !
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  Consumer<ReorderableProvider>(
                                    builder: (ctx, _reorderableProvider, _) {
                                      return Visibility(
                                          visible:
                                              _reorderableProvider.isLoading,
                                          child: MyCustomWidget());
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
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
