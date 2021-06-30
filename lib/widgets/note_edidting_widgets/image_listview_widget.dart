import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/noteimage_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class ImageLisView extends StatelessWidget {
  const ImageLisView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    return Container(
        height: isLandscape ? SizeY * 0.8 : SizeX * 0.8,
        margin: EdgeInsets.only(top: SizeX * 0.02),
        padding: EdgeInsets.symmetric(horizontal: SizeY * 0.05),
        child: ScrollConfiguration(
          behavior: uiKit.NoGlowBehaviour(),
          child: Consumer3<ThemeProvider , NoteImageProvider , BottomNavProvider>(builder: (ctx, _themeProvider,_noteImageProvider,_bottomNavProvider , _) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: SizeX*0.05,
                    crossAxisSpacing: SizeY * 0.03),
                scrollDirection: Axis.vertical,
                itemCount: _noteImageProvider.imageList != null
                    ? _noteImageProvider.imageList.length + 1
                    : 1,
                itemBuilder: (context, index) {
                  if (index ==
                      (_noteImageProvider.imageList != null
                          ? _noteImageProvider.imageList.length
                          : 0)) {
                    return Container();
                  } else {
                    return FutureBuilder(
                        future: _noteImageProvider.getImageList(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return Dismissible(
                              key: UniqueKey(),
                              background: Center(
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Icon(
                                    Icons.delete_sweep,
                                    size: SizeX * SizeY * 0.0002,
                                    color: _bottomNavProvider
                                        .tabs[_bottomNavProvider.selectedTab]
                                        .color,
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
                                _noteImageProvider.imageDissmissed(index);
                              },
                              child: GridTile(
                                footer: GridTileBar(
                                    backgroundColor: _themeProvider.mainColor
                                        .withOpacity(0.1),
                                    title: Text(
                                      snapShot.data[index].desc,
                                      style: TextStyle(
                                          fontFamily: _themeProvider.isEn
                                              ? "Ubuntu Condensed"
                                              : "Dubai",
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
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: _noteImageProvider.imageList !=
                                              null
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
                                                      snapShot
                                                          .data[index].image,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            )
                                          : Container()),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                baseColor: _bottomNavProvider
                                    .tabs[_bottomNavProvider.selectedTab].color
                                    .withOpacity(0.3),
                                highlightColor: _themeProvider.shimmerColor,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: SizeY * 0.03),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _themeProvider.mainColor,
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                  }
                });
          }),
        ));
  }
}
