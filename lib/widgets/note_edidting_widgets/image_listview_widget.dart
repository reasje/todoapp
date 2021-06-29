import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class imageLisView extends StatelessWidget {
  const imageLisView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _timerState = Provider.of<TimerState>(context);
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    return Container(
        height: isLandscape ? SizeY * 0.8 : SizeX * 0.8,
        margin: EdgeInsets.only(top: SizeX * 0.02),
        child: ScrollConfiguration(
          behavior: uiKit.NoGlowBehaviour(),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 3,
              ),
              scrollDirection: Axis.vertical,
              itemCount: _myProvider.imageList != null
                  ? _myProvider.imageList.length + 1
                  : 1,
              itemBuilder: (context, index) {
                if (index ==
                    (_myProvider.imageList != null
                        ? _myProvider.imageList.length
                        : 0)) {
                  return Container();
                } else {
                  return FutureBuilder(
                      future: _myProvider.getImageList(),
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: SizeY * 0.1,
                                    bottom: SizeX * 0.01,
                                    right: SizeY * 0.1),
                                // decoration: BoxDecoration(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(35)),
                                //   color: _themeProvider.mainColor,
                                // ),
                                alignment: AlignmentDirectional.centerEnd,
                                child: Icon(
                                  Icons.delete_sweep,
                                  size: SizeX * SizeY * 0.0003,
                                  color: _myProvider
                                      .tabs[_myProvider.selectedTab].color,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  uiKit.MySnackBar(
                                      uiKit.AppLocalizations.of(context)
                                          .translate('undoImage'),
                                      'undoImage',
                                      true,
                                      context: context,
                                      index: index));
                              _myProvider.imageDissmissed(index);
                            },
                            child: GridTile(
                              footer: GridTileBar(
                                  backgroundColor:
                                      _themeProvider.mainColor.withOpacity(0.1),
                                  title: Text(
                                    snapShot.data[index].desc,
                                    style: TextStyle(
                                        fontFamily: _themeProvider.isEn ? "Ubuntu Condensed" : "Dubai",
                                        color: _themeProvider.mainColor,
                                        fontSize: _themeProvider.isEn
                                            ? SizeX * SizeY * 0.00005
                                            : SizeX * SizeY * 0.00003,
                                        fontWeight: _themeProvider.isEn
                                            ? FontWeight.w100
                                            : FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  )),
                              child: Center(
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeY * 0.03),
                                    child: _myProvider.imageList != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            child: InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          uiKit.PicDetail(
                                                              index: index))),
                                              child: Hero(
                                                  tag: 'pic${index}',
                                                  child: Image.memory(
                                                    snapShot.data[index].image,
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),
                                          )
                                        : Container()),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: SizeY * 0.9,
                            height: SizeX * 0.25,
                            child: Shimmer.fromColors(
                              period: Duration(seconds: 3),
                              baseColor: _myProvider
                                  .tabs[_myProvider.selectedTab].color
                                  .withOpacity(0.3),
                              highlightColor: _themeProvider.shimmerColor,
                              child: Container(
                                width: SizeX * 0.16,
                                margin: EdgeInsets.symmetric(
                                    horizontal: SizeY * 0.03),
                                decoration: BoxDecoration(
                                  color: _themeProvider.mainColor,
                                ),
                              ),
                            ),
                          );
                        }
                      });
                }
              }),
        ));
  }
}
