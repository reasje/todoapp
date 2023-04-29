import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';
import '../../../../widgets/snackbar.dart';
import '../image_screen.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;

class ImageLisView extends StatelessWidget {
  ImageLisView({
    Key? key,
  }) : super(key: key);
  final _themeState = Get.find<ThemeLogic>().state;
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
            child: Obx(() {
              final _noteImageLogic = Get.find<NoteImageLogic>();
              final _bottomNavLogic = Get.find<BottomNavLogic>();
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: h * 0.05, crossAxisSpacing: w * 0.03),
                  scrollDirection: Axis.vertical,
                  itemCount: _noteImageLogic.state.imageList != null ? _noteImageLogic.state.imageList!.length + 1 : 1,
                  itemBuilder: (context, index) {
                    if (index == (_noteImageLogic.state.imageList != null ? _noteImageLogic.state.imageList!.length : 0)) {
                      return Container();
                    } else {
                      return FutureBuilder<List<imageModel.Image?>?>(
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
                                      color: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(MySnackBar(locale.undoImage.tr, 'undoImage', true, context: context, index: index) as SnackBar);
                                  _noteImageLogic.imageDissmissed(index);
                                },
                                child: GridTile(
                                  footer: GridTileBar(
                                      backgroundColor: _themeState.mainColor!.withOpacity(0.1),
                                      title: Text(
                                        snapShot.data![index] == null ? "" : snapShot.data![index]!.desc ?? "",
                                        style: TextStyle(
                                            fontFamily: _themeState.isEn! ? "Ubuntu Condensed" : "Dubai",
                                            color: _themeState.mainColor,
                                            fontSize: _themeState.isEn! ? h * w * 0.00005 : h * w * 0.00003,
                                            fontWeight: _themeState.isEn! ? FontWeight.w100 : FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      )),
                                  child: Center(
                                    child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: _noteImageLogic.state.imageList != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: InkWell(
                                                  onTap: () => Get.to(PicDetail(index: index), transition: Transition.rightToLeft),
                                                  child: Hero(
                                                      tag: 'pic${index}',
                                                      child: Image.memory(
                                                        snapShot.data![index]!.image!,
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
                                  baseColor: _bottomNavLogic.state.tabs[_bottomNavLogic.state.selectedTab].color.withOpacity(0.3),
                                  highlightColor: _themeState.shimmerColor!,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: w * 0.03),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: _themeState.mainColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                    }
                  });
            })));
  }
}
