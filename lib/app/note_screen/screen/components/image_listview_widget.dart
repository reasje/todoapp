import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';
import '../../../../widgets/snackbar.dart';
import '../image_screen.dart';

class ImageLisView extends StatelessWidget {
  const ImageLisView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
        height: isLandscape ? w * 0.8 : h * 0.8,
        margin: EdgeInsets.only(top: h * 0.02),
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: ScrollConfiguration(
          behavior: NoGlowBehavior(),
          child:
              Consumer2<ThemeProvider,  BottomNavProvider>(builder: (ctx, _themeProvider,_bottomNavProvider, _) {
            return Obx(() {
              final _noteImageLogic = Get.find<NoteImageLogic>();
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: h * 0.05, crossAxisSpacing: w * 0.03),
                  scrollDirection: Axis.vertical,
                  itemCount: _noteImageLogic.imageList != null ? _noteImageLogic.imageList.length + 1 : 1,
                  itemBuilder: (context, index) {
                    if (index == (_noteImageLogic.imageList != null ? _noteImageLogic.imageList.length : 0)) {
                      return Container();
                    } else {
                      return FutureBuilder(
                          future: _noteImageLogic.getImageList(),
                          builder: (context, snapShot) {
                            if (snapShot.hasData) {
                              return Dismissible(
                                key: UniqueKey(),
                                background: Center(
                                  child: Container(
                                    alignment: AlignmentDirectional.center,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      size: h * w * 0.0002,
                                      color: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                                      AppLocalizations.of(context).translate('undoImage'), 'undoImage', true,
                                      context: context, index: index));
                                  _noteImageLogic.imageDissmissed(index);
                                },
                                child: GridTile(
                                  footer: GridTileBar(
                                      backgroundColor: _themeProvider.mainColor.withOpacity(0.1),
                                      title: Text(
                                        snapShot.data[index].desc,
                                        style: TextStyle(
                                            fontFamily: _themeProvider.isEn ? "Ubuntu Condensed" : "Dubai",
                                            color: _themeProvider.mainColor,
                                            fontSize: _themeProvider.isEn ? h * w * 0.00005 : h * w * 0.00003,
                                            fontWeight: _themeProvider.isEn ? FontWeight.w100 : FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      )),
                                  child: Center(
                                    child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: _noteImageLogic.imageList != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: InkWell(
                                                  onTap: () => Navigator.push(
                                                      context, MaterialPageRoute(builder: (BuildContext context) => PicDetail(index: index))),
                                                  child: Hero(
                                                      tag: 'pic${index}',
                                                      child: Image.memory(
                                                        snapShot.data[index].image,
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
                                  baseColor: _bottomNavProvider.tabs[_bottomNavProvider.selectedTab].color.withOpacity(0.3),
                                  highlightColor: _themeProvider.shimmerColor,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: w * 0.03),
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
            }
            );
          }),
        ));
  }
}
