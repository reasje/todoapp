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
  }) :super(key: key);



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
        height: isLandscape ? SizeY * 0.2 : SizeX * 0.2,
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

                );
              } else {
                return FutureBuilder(
                    future: _myProvider.getImageList(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        return Dismissible(
                          direction: DismissDirection.up,
                          key: UniqueKey(),
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
                            child: Icon(
                              Icons.delete_sweep,
                              size: SizeX * SizeY * 0.0001,
                              color: _themeProvider.textColor,
                            ),
                          ),
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(uiKit.MySnackBar(
                                    uiKit.AppLocalizations.of(
                                            context)
                                        .translate('undoImage'),
                                    'undoImage',
                                    true,
                                    context,
                                    index));
                            _myProvider.imageDissmissed(index);
                          },
                          child: Container(
                              width: SizeX * 0.16,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeY * 0.03),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: _themeProvider
                                        .lightShadowColor,
                                    spreadRadius: 1.0,
                                    blurRadius: 1.0,
                                    offset: Offset(-1,
                                        -1), // changes position of shadow
                                  ),
                                  BoxShadow(
                                    color: _themeProvider
                                        .shadowColor
                                        .withOpacity(0.17),
                                    spreadRadius: 1.0,
                                    blurRadius: 2.0,
                                    offset: Offset(3,
                                        4), // changes position of shadow
                                  ),
                                ],
                                color: _themeProvider.mainColor,
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(SizeX * 0.3))
                              ),
                              child: _myProvider.imageList !=
                                      null
                                  ? InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext
                                                      context) =>
                                                  uiKit.PicDetail(
                                                      index:
                                                          index))),
                                      child: Hero(
                                          tag: 'pic${index}',
                                          child: Image.memory(
                                            snapShot
                                                .data[index],
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                  : Container()),
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: _themeProvider.mainColor,
                          highlightColor:
                              _themeProvider.shimmerColor,
                          child: Container(
                            width: SizeX * 0.16,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeY * 0.03),
                            decoration: BoxDecoration(
                              color: _themeProvider.mainColor,
                              boxShadow: [
                                BoxShadow(
                                  color: _themeProvider
                                      .lightShadowColor,
                                  spreadRadius: 1.0,
                                  blurRadius: 1.0,
                                  offset: Offset(-1,
                                      -1), // changes position of shadow
                                ),
                                BoxShadow(
                                  color: _themeProvider
                                      .shadowColor
                                      .withOpacity(0.17),
                                  spreadRadius: 1.0,
                                  blurRadius: 2.0,
                                  offset: Offset(3,
                                      4), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    });
              }
            }));
  }
}